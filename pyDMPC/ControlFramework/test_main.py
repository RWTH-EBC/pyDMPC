# -*- coding: utf-8 -*-
"""
This is a test module for new implementations. 

"""

import System 
import time
import Init
import numpy as np
import scipy.io as sio
import multiprocessing as mp
from pathos.multiprocessing import ProcessingPool as Pool

def main():
    """ System and Subsystem Creation """ 
    AHU = System.System()
    subsystems = AHU.GenerateSubSys()
    #subsystems.reverse()  #only for BExMoC

    counter = 0
    time_step = 0    
    time_storage = 0
    storage_commands = np.zeros([5,1])
    stor = []
    """
    # Non-parallel NC-DMPC
    while counter < Init.max_num_iteration:   
        #Begin non-parallel NC-DMPC
        subsystems[0].GetMeasurements(AHU._measurements_IDs)
        start = time.time()
        #for s in subsystems
        s = subsystems[0]
        print(s._name)
        commands = s.CalcDVvalues(time_step, time_storage)
        stor.append(commands)
        end = time.time()
        print(commands, 'time elapsed:', end-start)
        counter += 1
        if time_step-time_storage >= Init.optimization_interval:
            time_storage = time_step
        time_step += Init.sync_rate  
        storage_commands = np.append(storage_commands, np.expand_dims(np.array(stor), axis = 1), axis = 1)
        stor = []
        sio.savemat((Init.path_res  + '\\' + 'Commands_NC_DMPC' + str(counter) + '.mat' ), {'Commands_NC_DMPC': storage_commands})
        # End non-parallel NC-DMPC

    #Parallel NC-DMPC
    p = Pool(4)
    while counter < Init.max_num_iteration:
        start = time.time()
        subsystems[0].GetMeasurements(AHU._measurements_IDs) #GetMeasurements as abstract method
        # Begin Parallel Computing
        def f(s):
            commands = s.CalcDVvalues(time_step, time_storage)
            return commands        

        commands = p.map(f, [subsystems[0], subsystems[1], subsystems[2], subsystems[3], subsystems[4]])
        storage_commands = np.append(storage_commands, np.expand_dims(commands, axis = 1), axis = 1)
        sio.savemat((Init.path_res  + '\\' + 'Commands_NC_DMPC' + str(counter) + '.mat' ), {'Commands_NC_DMPC': storage_commands})
        print(commands)
        end = time.time()
        print('counter:', counter, 'time elapsed:', end-start)
        counter += 1
        if time_step-time_storage >= Init.optimization_interval:
            time_storage = time_step
        time_step += Init.sync_rate
        end = time.time()
        # End NC-DMPC Parallel 
"""     
    # Begin BExMoC  
    start = time.time()
    while time_step <= Init.sync_rate*Init.stop_time: 
        subsystems[0].GetMeasurements(AHU._measurements_IDs) #GetMeasurements as abstract method
        for s in subsystems:      
            print(s._name)
            start = time.time()            
            commands = s.CalcDVvalues(time_step, time_storage)              
            end = time.time()
            print(s._name, commands, 'time elapsed:', end-start)
            sio.savemat((Init.path_res + '\\' + s._name + '\\' + 'DV_lookUpTable' + str(counter) + '.mat' ), {'DV_lookUpTable': s.lookUpTables[1]})
            sio.savemat((Init.path_res + '\\' + s._name + '\\' + 'Costs_lookUpTable' + str(counter) + '.mat' ), {'Cost_lookUpTable': s.lookUpTables[0]})
            sio.savemat((Init.path_res + '\\' + s._name + '\\' + 'Output_Table' + str(counter) + '.mat' ), {'Output_Table': s.lookUpTables[2]})
        if time_step > 0:
            time.sleep(600)
        if time_step-time_storage >= Init.optimization_interval:
            time_storage = time_step
        time_step += Init.sync_rate
    import Objective_Function
    Objective_Function.CloseDymola()
    
    # End BExMoC

    print("Program successfully executed")   

if __name__=="__main__": main()