##################################################################
# Algorithm module using look-up tables
##################################################################

import math
import numpy as np
import modelicares
from scipy.optimize import minimize
import scipy.interpolate as interpolate
from scipy.optimize import differential_evolution
from scipy.optimize import brute


""" Execute only once """
def CalcBCvalues(amount_vals_BCs, exp_BCs, center_vals_BCs, factors_BCs, amount_lower_vals_BCs=None, amount_upper_vals_BCs=None):
    """
    Calculate the boundary conditions around a center value. Typically, this
    is a equidistant grid but it can also be an exponentially increasing
    increment

    inputs:
        amount_vals_BCs: amount of discrete values of boundary conditions
        exp_BCs: exponent for increasing increments
        center_vals_BCs: center value that the other values are arranged around
        factors_BCs: for an exponent of 1, this is the uniform increment
        amount_lower_vals_BCs: amount of values below the center value
        amount_upper_vals_BCs: amount of values above the center value
    returns:
        values: list of boundary conditions
    """

    if amount_lower_vals_BCs is None or amount_upper_vals_BCs is None:
        amount_lower_vals_BCs =[x/2 for x in amount_vals_BCs]
        amount_lower_vals_BCs = [math.floor(x) for x in amount_lower_vals_BCs]
        amount_upper_vals_BCs = [amount_vals_BCs[x]-amount_lower_vals_BCs[x]-1 for x in range(len(amount_vals_BCs))]
    values_BCs = []
    for i in range(len(amount_vals_BCs)):
        temp_list = []
        for j in range(amount_lower_vals_BCs[i]):
            temp_list.append(center_vals_BCs[i] - (amount_lower_vals_BCs[i]-j)**exp_BCs[i]*factors_BCs[i])
        for j in range(amount_upper_vals_BCs[i]+1):
            temp_list.append(center_vals_BCs[i] + j**exp_BCs[i]*factors_BCs[i])
        values_BCs.append(temp_list)
    values_BCs[0].insert(0,0)

    return values_BCs

def CalcLookUpTables(s, time_storage, init_conds):
    """
    Calculate decision variables and costs and put them into look-up tables

    inputs:
        s: subsystem object
        time_storage: the current time step
        init_conds: initialization of optimization algorithm
    returns:
        storage_cost: list of costs depending on boundary conditions
        storage_DV: decision variables depending on boundary conditions
        storage_out: outputs depending on boundary conditions
        exDestArr: two-dimensional list of costs
        storage_grid: result grid as output of optimization algorithm
    """

    import Objective_Function

    # Use the fullfactorial design of experiment: Use predefined BCs
    if  len(s.values_BCs) == 1:
        BCsettings = modelicares.exps.doe.fullfact(s.values_BCs[0])
        counter = len(s.values_BCs)
    elif  len(s.values_BCs) == 2:
        BCsettings = modelicares.exps.doe.fullfact(s.values_BCs[0],s.values_BCs[1])
        counter = len(s.values_BCs[0])*len(s.values_BCs[1])
    elif  len(s.values_BCs) == 3:
        BCsettings = modelicares.exps.doe.fullfact(s.values_BCs[0],s.values_BCs[1],s.values_BCs[2])
        counter = len(s.values_BCs[0])*len(s.values_BCs[1])*len(s.values_BCs[2])
    elif  len(s.values_BCs) == 4:
        BCsettings = modelicares.exps.doe.fullfact(s.values_BCs[0],s.values_BCs[1],s.values_BCs[2],s.values_BCs[3])
        counter = len(s.values_BCs[0])*len(s.values_BCs[1])*len(s.values_BCs[2])*len(s.values_BCs[3])

    # Look-up tables:
    storage_cost = np.zeros([counter,(len(s.values_BCs)+1)])
    storage_DV = np.zeros([counter,len(s.values_BCs)+s._num_DVs])
    storage_out = np.zeros([counter,len(s.values_BCs)+s.num_VarsOut])
    storage_grid = np.zeros([counter+1,2])
    storage_grid[0,0] = storage_grid[0,1] = None
    storage_grid_alt2 = np.zeros([2*counter,2])

    # 2D exDestArr to communicate:
    exDestArr = np.empty([len(s.values_BCs[0])+1,len(s.values_BCs[1])+1])
    for i,val in enumerate(s.values_BCs[0]):
        exDestArr[i+1,0]=val
    for i,val in enumerate(s.values_BCs[1]):
        exDestArr[0,i+1]=val
    exDestArr[0,0] = None

    counter = 0

    for BC in BCsettings:
        j = 0
        while j < len(s.values_BCs):
            storage_cost[counter,j] = storage_DV[counter,j] = storage_out[counter,j] = BC[j]
            j += 1

        """" Perform a minimization using the defined objective function  """
        Objective_Function.ChangeDir(s._name)

        boundaries = s._bounds_DVs #[low, high]

        if boundaries[0] != boundaries[1]:
            ranges = [slice(boundaries[0],boundaries[1]+5, 5)]

            """ First conduct a brute force search """
            obj_fun_val = brute(Objective_Function.Obj,ranges,args = (BC, s), disp=True, full_output=True, finish = None)
            init_conds = obj_fun_val[0]-5
            cons = ({'type':'ineq','fun': lambda x: x-boundaries[0]},
                    {'type':'ineq','fun': lambda x: boundaries[1]-x})

            """ Perform an addtional optimization to refine the previous findings """
            obj_fun_val = minimize(Objective_Function.Obj,init_conds,args = (BC, s),method='COBYLA',constraints=cons, options={'maxiter':100, 'catol':0.0002, 'rhobeg':5})
        else:
            ranges = [slice(boundaries[0],boundaries[1]+1, 1)]
            obj_fun_val = brute(Objective_Function.Obj,ranges,args = (BC, s), disp=True, full_output=True, finish = None)

        """
        Post processing of the different returned results of the
        optimization algorithms
        """
        if isinstance(obj_fun_val, tuple):
            """ fill storage_grid """
            if counter ==0:
                res_grid = np.concatenate((obj_fun_val[2][np.newaxis], obj_fun_val[3][np.newaxis]),axis = 0)
            else:
                res_grid = np.append(res_grid,obj_fun_val[3][np.newaxis],axis = 0)
        else:
            res_grid_new = Objective_Function.GetOptTrack()
            Objective_Function.DelLastTrack()
            if counter ==0:
                res_grid = res_grid_new
            else:
                stor_shape = res_grid.shape
                new_shape = res_grid_new.shape
                if stor_shape[1] != new_shape[1]:
                    to_add = abs(stor_shape[1]-new_shape[1])
                    if stor_shape[1] > new_shape[1]:
                        add_array = np.zeros([new_shape[0],to_add])
                        res_grid_new = np.append(res_grid_new,add_array, axis = 1)
                    else:
                        add_array = np.zeros([stor_shape[0],to_add])
                        res_grid = np.append(res_grid,add_array, axis = 1)
                res_grid = np.append(res_grid,res_grid_new,axis = 0)

        """ fill look-up table DV and Cost """
        j = len(s.values_BCs)

        while j < (s._num_DVs+len(s.values_BCs)):
            if isinstance(obj_fun_val, tuple):
                DV_values = obj_fun_val[0]
            else:
                DV_values = obj_fun_val.get('x')
            storage_DV[counter,j] = DV_values.item(j-len(s.values_BCs))
            j += 1

        ix1 = np.isin(exDestArr, BC[0])
        ix2 = np.isin(exDestArr, BC[1])
        index1 = np.where(ix1)
        index2 = np.where(ix2)
        if isinstance(obj_fun_val, tuple):
             storage_cost[counter,len(s.values_BCs)] = obj_fun_val[1]
             exDestArr[index1[0].tolist(), index2[1].tolist()] = obj_fun_val[1]
        else:
            storage_cost[counter,len(s.values_BCs)] = obj_fun_val.get('fun')
            exDestArr[index1[0].tolist(), index2[1].tolist()] = obj_fun_val.get('fun')

        # Get Output Variables
        output_vals = Objective_Function.GetOutputVars()

        """ Fill look-up table Out """
        k = len(s.values_BCs)
        while k < (s.num_VarsOut+len(s.values_BCs)):
            storage_out[counter,k] = output_vals[k-len(s.values_BCs)]
            k += 1

        counter = counter + 1

    if isinstance(obj_fun_val, tuple):
        storage_grid = np.append(storage_grid,res_grid,axis=1)
    else:
        storage_grid = np.append(storage_grid_alt2,res_grid,axis=1)

    storage_grid = res_grid
    return [storage_cost, storage_DV, storage_out, exDestArr, storage_grid]


def Interpolation(measurements_SubSys, storage_DV, bounds_DVs, storage_cost, storage_out):
    """
    Interpolate the values of the decision variables, costs and outputs

    inputs:
        measurements_SubSys: the inflow measurements of a subsystem
        storage_DV: the decision variables depending on boundary conditions
        bounds_DVs: upper and lower bounds of the decision variables
        storage_cost: the costs depending on boundary conditions
        storage_out: the outputs depending on boundary conditions
    returns:
        commands: interpolated command for current measurement
        costs: interpolated costs for current measurement
        out: interpolated outputs for current measurement
    """

    """
    Reformat the boundary conditions, decision variables, outputs and
    costs
    """
    cond_BC = [True if L<len(measurements_SubSys) else False for L in range(len(storage_DV[0]))]
    cond_DV = [False if L<len(measurements_SubSys) else True for L in range(len(storage_DV[0]))]
    cond_Out = [False if L<len(measurements_SubSys) else True for L in range(len(storage_out[0]))]
    cond_Costs = cond_DV

    grid_points = np.compress(cond_BC,storage_DV, axis = 1)
    grid_point_values = np.compress(cond_DV,storage_DV, axis = 1)
    grid_measurements = measurements_SubSys[::-1]
    grid_point_values_costs = np.compress(cond_Costs,storage_cost, axis = 1)
    grid_point_values_out = np.compress(cond_Out,storage_out, axis = 1)

    print("Grid points:")
    print(grid_points)
    print("values:")
    print(grid_point_values)
    print("measurements:")
    print(grid_measurements)

    """ Interpolation of reformatted data """
    try:
        commands = interpolate.griddata(grid_points, grid_point_values,grid_measurements ,method='linear')
        costs = interpolate.griddata(grid_points, grid_point_values_costs,grid_measurements ,method='linear')
        out = interpolate.griddata(grid_points, grid_point_values_out, grid_measurements ,method='linear')

        print("commands: " + str(commands))
        print("costs: " + str(costs))
        print("outputs: " + str(out))

        # Check if commands are in range, else set to boundary values
        for i, val in enumerate(commands):
            if val < bounds_DVs[i]:
                commands[i] = bounds_DVs[i]
                print('Val < lower Bound')
            elif val > bounds_DVs[i+1]:
                commands[i] = bounds_DVs[i+1]
                print('Val > higher Bound')
            elif val >= bounds_DVs[i] and val <= bounds_DVs[i+1]:
                commands[i] = val
                # last case: invalid interpolation
            else:
                commands[i] = bounds_DVs[i]
                print('interpolation failed!')
        return [commands, costs, out]

    except:
        commands = []
        costs = []
        out = []

        for i in range(0,len(storage_DV)):
            commands.append(storage_DV[0,0])
            costs.append(0)
            out.append(0)
        print('interpolation failed!')
