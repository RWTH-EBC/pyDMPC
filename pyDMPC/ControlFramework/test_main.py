"""
This is a test module for new implementations.
"""

import System
import time
import Init
import numpy as np
import scipy.io as sio
from pathos.multiprocessing import ProcessingPool as Pool
import Objective_Function

def main():
    """Create a system and multiple subsystems"""
    AHU = System.System()
    subsystems = AHU.GenerateSubSys()
    #subsystems.reverse()  #only for BExMoC

    """Variables storing (time) steps"""
    time_step = 0
    time_storage = 0
    start = time.time()
    counter = 0

    """Variables storing commands"""
    storage_commands = np.zeros([5,1])

    """There are currently three different options:
    1. NC-OPT algorithm
    2. NC-OPT algorithm using parallel computing
    3. BExMoC algorithm
    """

    """The algorithms work with a discrete *time_step*. In each step, the current measurements are taken using the :func:`GetMeasurements' method. """
    while time_step <= Init.sync_rate*Init.stop_time:
        subsystems[0].GetMeasurements(AHU._measurements_IDs) #GetMeasurements

        if Init.algorithm == 'NC_DMPC':

            for k in range(5):
                if Init.parallelization == False:
                    for s in subsystems:
                        print(s._name)
                        commands = s.CalcDVvalues(time_step, time_storage,k)
                else:
                    def f(s):
                        commands = s.CalcDVvalues(time_step, time_storage,k)
                        return commands

                    p = Pool(4)
                    commands = p.map(f, [subsystems[0], subsystems[1], subsystems[2], subsystems[3], subsystems[4]])

            print(commands)


        elif Init.algorithm == 'BExMoC':

            for s in subsystems:
                print(s._name)

                """The main calculations are carried out by invoking the :func:'CalcDVvalues' method. The BExMoC algorithm exchanges tables between the subsystems in a .mat format"""
                commands = s.CalcDVvalues(time_step, time_storage,0)

                print(s._name, commands)

                (sio.savemat((Init.path_res + '\\' + s._name + '\\' +
                'DV_lookUpTable' + str(counter) + '.mat' ),
                {'DV_lookUpTable': s.lookUpTables[1]}))

                (sio.savemat((Init.path_res + '\\' + s._name + '\\' +
                'Costs_lookUpTable' + str(counter) + '.mat' ),
                {'Cost_lookUpTable': s.lookUpTables[0]}))

                (sio.savemat((Init.path_res + '\\' + s._name + '\\' +
                'Output_Table' + str(counter) + '.mat' ),
                {'Output_Table': s.lookUpTables[2]}))

        if Init.realtime:
            if time_step > 0:
                time.sleep(max(Init.sync_rate-time.time()+start,0))
                start = time.time()
        if time_step-time_storage >= Init.optimization_interval:
            time_storage = time_step
        print(time_step)
        time_step += Init.sync_rate
        counter += 1
        print(time_step)

    Objective_Function.CloseDymola()

    print("Program successfully executed")

if __name__=="__main__": main()
