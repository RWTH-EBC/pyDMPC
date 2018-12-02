# -*- coding: utf-8 -*-
"""

"""
import numpy as np
import modelicares
from scipy.optimize import minimize
from scipy.optimize import brute
import Init
import scipy.io as sio

def Iteration(s, time_step):

    import Objective_Function

    # Use the fullfactorial design of experiment: Use predefined BCs
    if  len(s.values_BCs) == 1:
        BCsettings = modelicares.exps.doe.fullfact(s.values_BCs[0])
        counter = len(s.values_BCs[0])
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
    if len(s.values_BCs) == 1:
        exDestArr = np.zeros([len(s.values_BCs[0])+3,2])
        for i,val in enumerate(s.values_BCs[0]):
               exDestArr[i+2,0]=val
        exDestArr[0,0] = None
        exDestArr[1,0] = s.values_BCs[0][0]-0.001
        exDestArr[-1,0] = s.values_BCs[0][1]+0.001
    else:
        exDestArr = np.zeros([len(s.values_BCs[0])+3,len(s.values_BCs[1])+3])
        for i,val in enumerate(s.values_BCs[0]):
            exDestArr[i+2,0]=val
        for i,val in enumerate(s.values_BCs[1]):
            exDestArr[0,i+2]=val
        exDestArr[0,0] = None
        exDestArr[1,0] = 0
        exDestArr[4,0] = 60
        exDestArr[0,1] = 0
        exDestArr[0,4] = 1

    if time_step == 0 and s._name != 'Steam_humidifier':
        sio.savemat((Init.path_res +'\\' + Init.name_wkdir + '\\' + s._name +'\\' +  Init.fileName_Cost + '.mat'), {Init.tableName_Cost :exDestArr})

    counter = 0


    for BC in BCsettings:
        j = 0

        while j < len(s.values_BCs):
            storage_cost[counter,j] = storage_DV[counter,j] = storage_out[counter,j] = storage_grid[counter+1,j] = storage_grid_alt2[counter*2,j] = storage_grid_alt2[counter*2+1,j] = BC[j]
            j += 1

        """ Perform a minimization using the defined objective function """
        # Could be set in Init and passed as an attribute
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
            #obj_fun_val = minimize(Objective_Function.Obj,init_conds,args = (BC, s),method='COBYLA',constraints=cons, options={'maxiter':100, 'catol':0.0002, 'rhobeg':5})
        else:
            ranges = [slice(boundaries[0],boundaries[1]+1, 1)]
            obj_fun_val = brute(Objective_Function.Obj,ranges,args = (BC, s), disp=True, full_output=True, finish = None)

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

        if len(BC)==2:
            ix1 = np.isin(exDestArr, BC[0])
            ix2 = np.isin(exDestArr, BC[1])
            index1 = np.where(ix1)
            index2 = np.where(ix2)
            if isinstance(obj_fun_val, tuple):
                 storage_cost[counter,len(s.values_BCs)] = obj_fun_val[1]
                 exDestArr[index1[0].tolist(), index2[1].tolist()] = obj_fun_val[1]
                 if obj_fun_val[1]+1 < 0:
                     objVal = -obj_fun_val[1]
                 else:
                     objVal = obj_fun_val[1]
            else:
                storage_cost[counter,len(s.values_BCs)] = obj_fun_val.get('fun')
                exDestArr[index1[0].tolist(), index2[1].tolist()] = obj_fun_val.get('fun')
                if obj_fun_val.get('fun')+1 < 0:
                    objVal = -obj_fun_val.get('fun')
                else:
                    objVal = obj_fun_val.get('fun')
            if index1[0].tolist() == [2]:
                exDestArr[1, index2[1].tolist()] = (objVal+1)*50
            elif index1[0].tolist() == [3]:
                exDestArr[4, index2[1].tolist()] = (objVal+1)*50
            if index2[1].tolist() == [2]:
                exDestArr[index1[0].tolist(), 1] = (objVal+1)*50
            elif index2[1].tolist() == [3]:
                exDestArr[index1[0].tolist(), 4] = (objVal+1)*50
        elif len(BC)==1:
            ix1 = np.isin(exDestArr, BC[0])
            index1 = np.where(ix1)
            if isinstance(obj_fun_val, tuple):
                 storage_cost[counter,len(s.values_BCs)] = obj_fun_val[1]
                 exDestArr[index1[0].tolist(), 1] = obj_fun_val[1]
            else:
                storage_cost[counter,len(s.values_BCs)] = obj_fun_val.get('fun')
                exDestArr[index1[0].tolist(), 1] = obj_fun_val.get('fun')
                if index1[0].tolist() == [2]:
                    exDestArr[1, 1] = (obj_fun_val.get('fun')+1)*50
                elif index1[0].tolist() == [3]:
                    exDestArr[4, 1] = (obj_fun_val.get('fun')+1)*50

        """ Get Output Variables """
        output_vals = Objective_Function.GetOutputVars()
        output_vals[0] = output_vals[0] - 273.15

        """ fill look-up table Out """
        k = len(s.values_BCs)
        while k < (s.num_VarsOut+len(s.values_BCs)):
            storage_out[counter,k] = output_vals[k-len(s.values_BCs)]
            k += 1

        counter = counter + 1

    if isinstance(obj_fun_val, tuple):
        storage_grid = np.append(storage_grid,res_grid,axis=1)
    else:
        storage_grid = np.append(storage_grid_alt2,res_grid,axis=1)


    return [storage_cost, storage_DV, storage_out, exDestArr, storage_grid]
