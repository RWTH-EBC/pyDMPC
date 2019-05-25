"""
This is a test module for new implementations.
"""

import System
import Init
import time
import numpy as np
import scipy.io as sio
from pathos.multiprocessing import ProcessingPool as Pool
import Objective_Function
from pyfmi import load_fmu
import os
import sys
import shutil
import pyads
import pandas as pd

class Logger:
    
    def __init__(self, model, data_points):
        self.model = model
        self.data_points = data_points
        self.df = pd.DataFrame([[0] * len(data_points)],index=[time.time()],
                               columns=data_points)
    
    def get_meas(self):
        cur_vals = [self.model.read_by_name(point, pyads.PLCTYPE_REAL)
                        for point in self.data_points]
        return pd.DataFrame([cur_vals],index=[time.time()],
                               columns=self.data_points)
        
    def save_df(self):
        self.df.append(self.get_meas())
        self.df.to_csv(path_or_buf = Init.path_res + "\logs.csv")
            

def main():
    """Create a system and multiple subsystems"""
    AHU = System.System()
    subsystems = AHU.GenerateSubSys()

    """Prepare the working directory"""
    os.chdir(Init.path_res)
    os.mkdir(str(Init.name_wkdir))
    os.chdir(str(Init.name_wkdir))

    """Create one directory for each of the subsystems and one for the inputs"""
    for s in subsystems:
        os.mkdir(s._name)

    os.mkdir("Inputs")

    if Init.realtime == False:
        # FMU is loaded if the controlled system is a simulation model
        
        """Load the FMU model, set the experiment and initialize the inputs"""
        global dymola
        dymola = None
        # Work-around for the environment variable
        sys.path.insert(0, os.path.join(str(Init.path_dymola)))
    
        # Import Dymola Package
        from dymola.dymola_interface import DymolaInterface
    
        # Start the interface
        dymola = DymolaInterface()
    
        """ Simulation """
        # Open dymola library
    
        for lib in Init.path_lib:
            check1 = dymola.openModel(os.path.join(lib,'package.mo'))
            print('Opening successful ' + str(check1))
    
        dymola.cd(Init.path_res + '\\' + Init.name_wkdir)
    
        # Translate the model to FMU
        if Init.create_FMU:
            dymola.ExecuteCommand('translateModelFMU("'+Init.path_fmu+'", true, "'+
                                Init.name_fmu+'", "1", "cs", false, 0)')
        else:
            shutil.copyfile(Init.path_res + "\\" + Init.name_fmu + 
                            ".fmu", Init.path_res+'\\'+Init.name_wkdir +'\\'+
                            Init.name_fmu+'.fmu')
    
    
        model = load_fmu(Init.path_res+'\\'+Init.name_wkdir +'\\'+Init.name_fmu+
                         '.fmu')
    
        model.set('suppyAirTemperature',300)
        model.set('Room1Set',0)
        model.set('Room2Set',0)
        model.set('CCAValve',0)
    
        model.initialize()
        model.do_step(0, Init.sync_rate)
        
    else:
        model = 1
        model = pyads.Connection('5.59.199.202.1.1', 851)
        model.open()
        
    try:
        try:
        
            """Variables storing (time) steps"""
            time_step = Init.sync_rate
            time_storage = 0
            start = time.time()
            counter = 0
        
            """Variables storing commands"""
            storage_commands = np.zeros([5,1])
            supplyTemps = []
            
            logger = Logger(data_points = 
                            ['AHU_Bacnet.TempODA','AHU_Bacnet.TempETA',
                            'TempSensors.TempAHUReheaterTSetAir',
                            'TempSensors.TempCCAT_amb_mean'], model = model)
            
        
            """There are currently three different options:
            1. NC-OPT algorithm
            2. NC-OPT algorithm using parallel computing
            3. BExMoC algorithm
            """
        
            """The algorithms work with a discrete *time_step*. In each step, the 
            current measurements are taken using the :func:`GetMeasurements' method."""
            while time_step <= Init.sync_rate*Init.stop_time:
        
                # Variable for the final commands of all subsystems
                command_all = []
        
                if Init.algorithm == 'NC_DMPC':
        
                    if (time_step-time_storage >= Init.optimization_interval or 
                        time_step == Init.sync_rate):
        
                        """ Consider the subsystems in multiple iterations, either in 
                        parallel or in sequential order """
                        for k in range(4):
                            command_all = []
                            if Init.parallelization:
                                def f(s):
                                    commands = s.CalcDVvalues(time_step, time_storage,
                                                              k,model)
                                    return commands
        
                                p = Pool(4)
                                commands = p.map(f, [subsystems[0], subsystems[1], 
                                                     subsystems[2], subsystems[3], 
                                                     subsystems[4]])
                                command_all = commands
        
                            else:
                                for s in subsystems:
                                    commands = s.CalcDVvalues(time_step, time_storage,
                                                              k,model)
                                    print(k, s._name, commands)
                                    command_all.append(commands)
        
                elif Init.algorithm == 'BExMoC':
        
                    #Consider each subsystem sequentially
                    for s in subsystems:
                        print(s._name)
        
                        """The main calculations are carried out by invoking the :func:
                            'CalcDVvalues' method. The BExMoC algorithm exchanges 
                            tables between the subsystems in a .mat format"""
                        commands = (s.CalcDVvalues(time_step, time_storage,0, model))
        
                        command_all.append(commands)
        
                        #Save the look-up tables in .mat files
                        (sio.savemat((Init.path_res + '\\' + Init.name_wkdir + '\\' + 
                                      s._name + '\\' +
                        'DV_lookUpTable' + str(counter) + '.mat' ),
                        {'DV_lookUpTable': s.lookUpTables[1]}))
        
                        (sio.savemat((Init.path_res + '\\' + Init.name_wkdir + '\\' + 
                                      s._name + '\\' +
                        'Costs_lookUpTable' + str(counter) + '.mat' ),
                        {'Cost_lookUpTable': s.lookUpTables[0]}))
        
                        (sio.savemat((Init.path_res + '\\' + Init.name_wkdir + '\\' +
                                      s._name + '\\' +
                        'Output_Table' + str(counter) + '.mat' ),
                        {'Output_Table': s.lookUpTables[2]}))
        
                        (sio.savemat((Init.path_res + '\\' + Init.name_wkdir + '\\' + 
                                      s._name + '\\' +
                        'command' + str(counter) + '.mat' ),
                        {'Output_Table': commands}))
        
                #For real time experiments, the excecution needs to be paused
                if Init.realtime:
                    if time_step > 0:
                        logger.df()
                        logger.save_df()
                        
                        start = time.time()
                else:
                    model.do_step(time_step, Init.sync_rate)
                    print('Proceding')
        
                if time_step-time_storage >= Init.optimization_interval:
                    time_storage = time_step
                time_step += Init.sync_rate
                counter += 1
        
            Objective_Function.CloseDymola()
        
        except Exception as e:
            model.close()
            logger.save_df()
            print(getattr(e, 'message', repr(e)))
    
    except KeyboardInterrupt:
        logger.save_df()
        print('Interrupted')
            

if __name__=="__main__": main()
