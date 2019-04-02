##################################################################
# Objective function module that can be used by each of the agents in
# order to determine costs
##################################################################

import Init
import numpy as np
from joblib import load
import random

'''Global variables used for simulation handling'''
# Variable indicating if the subsystem model is compiled
gl_model_compiled = [False]*(Init.amount_consumer+Init.amount_generator)

# Variable indicating if dymola instance is active
dymola = None

# Global output of the subsystems
gl_output = None

# Results of the subsystem
gl_res_grid = np.zeros([2,1])

def TranslateModel(model_path, name, position, no_parallel):
    """
    Function to handle the Compilation of Modelica models
    inputs
        model_path: path of the model
        name: name of the subsystems
        position: position number of the subsystems
    returns:
        None
    """
    global gl_model_compiled
    if  gl_model_compiled[position+no_parallel-1] == False and model_path!="":
        import os
        import sys
        global dymola

        """ Dymola configurations"""
        if dymola is None:
            # Work-around for the environment variable
            sys.path.insert(0, os.path.join(r'C:\Program Files\Dymola 2018 FD01\Modelica\Library\python_interface\dymola.egg'))

            # Import Dymola Package
            from dymola.dymola_interface import DymolaInterface

            # Start the interface
            dymola = DymolaInterface()

        """ Compilation """
        # Open dymola library
        for lib in Init.path_lib:
            check1 = dymola.openModel(os.path.join(lib,'package.mo'))
            print("Opening successful " + str(check1))

        # Force Dymola to use 64 bit compiler
        #dymola.ExecuteCommand("Advanced.CompileWith64=2")
        dymola.cd(Init.path_res +'\\'+Init.name_wkdir+'\\' + name)

        # Translate the model
        check2 =dymola.translateModel(model_path)
        print("Translation successful " + str(check2))
        if check2 is True:
            gl_model_compiled[position+no_parallel-1] = True


def Obj(values_DVs, BC, s):
    """
    Function to compute the objective function value
    inputs:
        values_DVs: values of the decision variables
        BC: current boundary conditions
        s: subsystem object
    returns:
        None
    """
    import Init
    import os
    from modelicares import SimRes
    import numpy as np
    import scipy.interpolate as interpolate
    import scipy.io as sio

    # Open dymola library
    TranslateModel(s._model_path, s._name, s.position, s.no_parallel)

    global dymola
    obj_fnc_val = 'objectiveFunction'

    """ Store two .mat-files that can be read by Dymola """
    #This file contains the input setting BC1/ BC2/..
    BC_array = np.empty([1,len(BC)+1])
    BC_array[0,0] = 0
    for i,val in enumerate(BC):
        BC_array[0][i+1] = val

    """This file contains the decision variable setting DV1/ DV2/.. """
    if isinstance (values_DVs, np.ndarray):
        DV_array = np.empty([1,2])
        DV_array[0,0] = 0
        DV_array[0,1] = float(values_DVs)
    else:
        DV_array = np.empty([1,len(values_DVs)+1])
        DV_array[0,0] = 0
        for i2,val2 in enumerate(values_DVs):
            DV_array[0][i2+1] = val2

    """Store the decision variables and boundary conditions as .mat files"""
    subsys_path = Init.path_res +'\\'+Init.name_wkdir+'\\' + s._name
    sio.savemat((subsys_path +'\\'+ Init.fileName_DVsInputTable + '.mat'), {Init.tableName_DVsInputTable :DV_array})
    sio.savemat((subsys_path +'\\'+ Init.fileName_BCsInputTable + '.mat'), {Init.tableName_BCsInputTable :BC_array})

    final_names = [obj_fnc_val]

    ### Modelica model ###
    # Max. 3 attempts to simulate
    # Different function call if no initialization is intended
    if s._model_type == "Modelica":
        for k in range(3):
            try:
                if s._initial_names is None:
                    simStat = dymola.simulateExtendedModel(
                    problem=s._model_path,
                    startTime=Init.start_time,
                    stopTime=Init.stop_time,
                    outputInterval=Init.incr,
                    method="Dassl",
                    tolerance=Init.tol,
                    resultFile= subsys_path  +'\dsres',
                    finalNames = final_names,
                    )
                else:
                    simStat = dymola.simulateExtendedModel(
                        problem=s._model_path,
                        startTime=Init.start_time,
                        stopTime=Init.stop_time,
                        outputInterval=Init.incr,
                        method="Dassl",
                        tolerance=Init.tol,
                        resultFile= subsys_path  +'\dsres',
                        finalNames = final_names,
                        initialNames = s._initial_names,
                        initialValues = s._initial_values,
                    )

                k = 4

            except:
                if k < 3:
                    print('Repeating simulation attempt')
                else:
                    print('Final simulation error')

                k += 1

        # Get the simulation result
        sim = SimRes(os.path.join(subsys_path, 'dsres.mat'))

        #store output
        output_traj = []
        output_list = []
        if s._output_vars is not None:
            for val in s._output_vars:
                output_vals = sim[val].values()
                output_list.append(output_vals[-1])
                output_traj.append(sim[val].values())

    ### Fuzzy model ###
    elif s._model_type == "fuzzy":
        import functions.fuzzy as fuz

        traj = BC[0] + 273.15
        Tset = fuz.control(s._initial_values[0],s._initial_values[1])
        output_list = []

        if s._output_vars is not None:
            output_traj = [traj, (0.3+random.uniform(0.0,0.01))]

            output_list = output_traj
        
        print(values_DVs)
        print(BC[0])
        print(traj)
        print(output_traj[0])
        print(Tset)
        
    ### Linear model ###
    elif s._model_type == "lin":
        traj = values_DVs/100*40 + 273.15
        Tset = 303

        if s._output_vars is not None:
            output_traj = [traj, (0.3+random.uniform(0.0,0.01))]
            output_list = output_traj


    ### Scikit model ###
    elif s._model_type == "Scikit":
        command = []
        T_cur = []
        T_prev = []
        T_met_prev_1 = []
        T_met_prev_2 = []
        T_met_prev_3 = []
        T_met_prev_4 = []
        output_traj = []
        output_list = []
        MLPModel = load("C:\\TEMP\Dymola\\" + s._name + ".joblib")
        scaler = load("C:\\TEMP\\Dymola\\" + s._name + "_scaler.joblib")

        for t in range(60):
            T_met_prev_1.append(s._initial_values[0])
            T_met_prev_2.append(s._initial_values[1])
            T_met_prev_3.append(s._initial_values[2])
            T_met_prev_4.append(s._initial_values[3])
            command.append(values_DVs[0])
            T_cur.append(BC[0])
            T_prev.append(BC[0])


        x_test = np.stack((command,T_cur,T_prev,T_met_prev_1,T_met_prev_2,T_met_prev_3,T_met_prev_4),axis=1)

        scaled_instances = scaler.transform(x_test)
        traj = MLPModel.predict(scaled_instances)
        traj += 273*np.ones(len(traj))
        if s._output_vars is not None:
            output_traj = [traj, (0.3+random.uniform(0.0,0.01))*np.ones(60)]

            output_list.append(traj[-1])
            output_list.append(0.3+random.uniform(0.0,0.01))
        
        print(values_DVs[0])
        print(BC[0])
        print(traj)
        

    else:
        traj = values_DVs
        output_list = []

        if s._output_vars is not None:
            output_traj = [traj, (0.3+random.uniform(0.0,0.01))]

            output_list.append(traj)
            output_list.append(0.3+random.uniform(0.0,0.01))


    if s._output_vars is not None:
        global gl_output
        gl_output = output_list

    cost_total = 0

    """all other subsystems + costs of downstream system"""
    if s._type_subSyst != "consumer":
        x = sio.loadmat(Init.path_res + '\\'+Init.name_wkdir+'\\' + s._name
        + '\\' + Init.fileName_Cost + '.mat')

        storage_cost = x[Init.tableName_Cost]

        for m in range(1,1000):
            try:
                x = sio.loadmat(Init.path_res + '\\'+Init.name_wkdir+'\\' + s._name
                + '\\' + Init.fileName_Cost + str(m) + '.mat')

                storage_cost_temp = x[Init.tableName_Cost]

                for a in range(1,4):
                    for b in range(1,2):
                        storage_cost[a,b] += storage_cost_temp[a,b]
            except:
                #print(storage_cost)
                break


        """Interpolation"""
        # Currently, the local cost depends on the relative decision variable
        costs_neighbor = interpolate.interp2d(storage_cost[0,1:],
        storage_cost[1:,0], storage_cost[1:,1:], kind = 'linear',
        fill_value = 10000)

        if s._model_type != "fuzzy" and s._model_type != "lin":
            for l,tout in enumerate(output_traj[0]):
                if l > 100 or s._model_type == "MLP" or s._model_type == "lin":
                    # Avoid nan by suppressing operations with small numbers
                    if values_DVs > 0.0001:
                        cost_total += values_DVs*s._cost_factor + costs_neighbor(0.008,tout-273)
                    else:
                        cost_total += costs_neighbor(0.008,tout-273)
            if s._model_type == "Modelica":
                cost_total = cost_total/len(output_traj[0])
            else:
                cost_total = cost_total/len(output_traj[0])
            print("output: " + str(tout))
        else:
            if values_DVs > 0.0001:
                cost_total += values_DVs*s._cost_factor + costs_neighbor(0.008,output_traj[0]-273)
                print("cost_neighbor: " + str(costs_neighbor(0.008,output_traj[0]-273)))
            else:
                cost_total += costs_neighbor(0.008,output_traj[0]-273)

        print(s._name + " actuators : " + str(values_DVs))
        print("cost_total: " + str(cost_total))

    else:
        if s._model_type != "fuzzy" and s._model_type != "lin":
            for l,tout in enumerate(output_traj[0]):
                if l > 100 or s._model_type == "MLP":
                    cost_total += 10*(max(abs(tout-273-Init.set_point[0])-Init.tolerance,0))**2
            cost_total = cost_total/len(output_traj[0])
            print("output: " + str(tout))
        else:
            cost_total = 10*(abs(output_traj[0]-Tset)**2)
            


        print(s._name + " actuators : " + str(values_DVs))
        print("cost_total: " + str(cost_total))

    '''Temporary objective function value'''
    obj_fnc_vals = [1]

    """ Track Optimizer """
    global gl_res_grid
    step = np.array([[float(values_DVs)], [obj_fnc_vals[-1]]])
    gl_res_grid = np.append(gl_res_grid,step,axis = 1)

    return cost_total


def CloseDymola():
    global dymola
    if dymola is not None:
        dymola.close()
        dymola = None
        global gl_model_compiled
        gl_model_compiled = False

def ChangeDir(name):
    global dymola
    if dymola is not None:
        dymola.cd(Init.path_res +'\\'+ Init.name_wkdir +'\\' + name)


def GetOutputVars():
    global gl_output
    return gl_output

def GetOptTrack():
    global gl_res_grid
    gl_res_grid = np.delete(gl_res_grid,0,1)
    return gl_res_grid

def DelLastTrack():
    global gl_res_grid
    gl_res_grid =np.zeros([2,1])
