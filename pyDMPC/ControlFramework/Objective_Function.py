# -*- coding: utf-8 -*-
"""

"""
import Init
import numpy as np
gl_model_compiled = [False]*(Init.amount_consumer+Init.amount_generator)

dymola = None

gl_output = None

gl_res_grid = np.zeros([2,1])


def TranslateModel(model_path, name, position):
    global gl_model_compiled    
    if  gl_model_compiled[position-1] == False:
        import os
        import sys
        global dymola
        
        if dymola is None:
            # Work-around for the environment variable
            sys.path.insert(0, os.path.join('C:\\',
                                            'Program Files',
                                            'Dymola 2018 FD01',
                                            'Modelica',
                                            'Library',
                                            'python_interface',
                                            'dymola.egg'))
            
            
            # Import Dymola Package
            from dymola.dymola_interface import DymolaInterface
            
            # Start the interface
            dymola = DymolaInterface()
        
        """ Simulation """
        # Open dymola library 
        for lib in Init.path_lib:
            check1 = dymola.openModel(os.path.join(lib,'package.mo'))
            print("Opening successful" + str(check1))
    
        dymola.ExecuteCommand("Advanced.CompileWith64=2")
        dymola.cd(Init.path_res +'\\' + name)
        # Translate the model
        check2 =dymola.translateModel(model_path)
        print("Translation successful" + str(check2))
        if check2 is True:
            gl_model_compiled[position-1] = True
            

def Obj(values_DVs, BC, name, model_path, position, output_vars, initial_names, initial_values):  
    
    import Init
    import os
    from modelicares import SimRes
    import numpy as np
    
    import scipy.io as sio
    
    
    """ Simulation """
    # Open dymola library 
    TranslateModel(model_path, name, position)

    global dymola
    obj_fnc_val = 'objectiveFunction'
    
    """ Store two .mat-files that can be read by Dymola """
    #This file contains the input setting BC1/ BC2/..
    BC_array = np.empty([1,len(BC)+1])
    BC_array[0,0] = 0
    for i,val in enumerate(BC):
        BC_array[0][i+1] = val  
    """This file contains the decision variable setting DV1/ DV2/..   """
    if isinstance (values_DVs, np.ndarray):
        DV_array = np.empty([1,2])   
        DV_array[0,0] = 0 
        DV_array[0,1] = float(values_DVs) 
    else:
        DV_array = np.empty([1,len(values_DVs)+1])   
        DV_array[0,0] = 0    
        for i2,val2 in enumerate(values_DVs):    
            DV_array[0][i2+1] = val2 

    
    subsys_path = Init.path_res +'\\' + name 
    sio.savemat((subsys_path +'\\'+ Init.fileName_DVsInputTable + '.mat'), {Init.tableName_DVsInputTable :DV_array})  
    sio.savemat((subsys_path +'\\'+ Init.fileName_BCsInputTable + '.mat'), {Init.tableName_BCsInputTable :BC_array})  
    
    final_names = [obj_fnc_val]   


    try:
        """Simulation"""
        if initial_names is None:
            simStat = dymola.simulateExtendedModel(
            problem=model_path,
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
                problem=model_path,
                startTime=Init.start_time,
                stopTime=Init.stop_time,
                outputInterval=Init.incr,
                method="Dassl",
                tolerance=Init.tol,
                resultFile= subsys_path  +'\dsres',
                finalNames = final_names,
                #initialNames = initial_names,
                #initialValues = initial_values,
            )
        print('simulated' + simStat)  
        
        # Get the simulation result
        sim = SimRes(os.path.join(subsys_path, 'dsres.mat'))
    except:
        """Simulation"""
        if initial_names is None:
            simStat = dymola.simulateExtendedModel(
            problem=model_path,
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
                problem=model_path,
                startTime=Init.start_time,
                stopTime=Init.stop_time,
                outputInterval=Init.incr,
                method="Dassl",
                tolerance=Init.tol,
                resultFile= subsys_path  +'\dsres',
                finalNames = final_names,
                #initialNames = initial_names,
                #initialValues = initial_values,
            )
        print(simStat)  
        
        # Get the simulation result
        sim = SimRes(os.path.join(subsys_path, 'dsres.mat'))
        
    # Penalty in case optimization algorithm does not support boundaries
    new_values_DVs = sim['decisionVariables.y[1]'].values()
    bounds = [0, 100]
    penalty_val = 0
    if new_values_DVs[-1] > bounds[1]:
        penalty_val = 10
    elif new_values_DVs[-1] < bounds[0]:
        penalty_val = 10
        
    obj_fnc_vals = sim[obj_fnc_val].values()
    obj_fnc_vals = obj_fnc_vals + penalty_val
    
    #store output 
    output_list = []
    if output_vars is not None:
        for val in output_vars:
            output_vals =sim[val].values()
            output_list.append(output_vals[-1])
        global gl_output
        gl_output = output_list
        
    """ Track Optimizer """
    global gl_res_grid
    step = np.array([[float(values_DVs)], [obj_fnc_vals[-1]]])
    gl_res_grid = np.append(gl_res_grid,step,axis = 1)
       
    return obj_fnc_vals[-1]


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
        dymola.cd(Init.path_res +'\\' + name)
    

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
        
    
