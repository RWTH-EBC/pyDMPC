# -*- coding: utf-8 -*-
"""

"""

import numpy as np
import Init
import scipy.io as sio
import client
import math
from datetime import datetime
import pytz

gl_commands_costs = []
gl_measurements_all =[]

class Subsystem():
        
    def __init__(self, name, position,
                 num_DVs,num_BCs, init_DecVars, sim_time, 
                 bounds_DVs,model_path, names_BCs, 
                   num_VarsOut, Id_BC1, Id_BC2, names_DVs, 
                   output_vars, initial_names, IDs_initial_values,
                   type_subSyst=None):
        self._name = name
        self._type_subSyst = type_subSyst
        self._num_DVs = num_DVs
        self._num_BCs = num_BCs
        self.init_DecVars = init_DecVars
        self.sim_time = sim_time
        self.position = position
        self.num_VarsOut = num_VarsOut
        self._bounds_DVs = bounds_DVs
        #self.measurements_SubSys = [[20],[0.005]]  # order: [[BC1,..],[BC2,..]]
        self.values_BCs = None
        self.lookUpTables = None
        self._model_path = model_path
        self._names_BCs = names_BCs
        
        self._Id_BC1 = Id_BC1 #T
        self._Id_BC2 = Id_BC2 #relHum + T_hum
        self._names_DVs = names_DVs
        self._output_vars = output_vars
        self._initial_names = initial_names
        self._IDs_initial_values = IDs_initial_values

        
    def GetNeighbour(self, neighbour_name):
        self.neighbour_name = neighbour_name
        
    def GetMeasurements(self, ids_list):

        #Get ID-list of unique values
        ids_list_orig = ids_list
        if len(ids_list) != len(set(ids_list)):
            ids_list = list(set(ids_list))

        #Get the current local time stamp
        tz = pytz.timezone('Europe/Berlin')           
        ts = datetime.now(tz).strftime("%Y-%m-%d %H:%M:%S")

        #read
        values = []
        
        for val in ids_list:
            value = 30.0
            values.append(float(value))
            
        #Set values in correct order   
        if len(ids_list_orig) != len(ids_list):
            list_values = ids_list_orig[:]
            for i,val1 in enumerate(ids_list_orig):
                for j,val2 in enumerate(ids_list):
                    if val1 == val2:
                      list_values[i] = values[j]
            values = list_values
                                       
    
        #Print the current time stamp and current value
        print(str(ts),':',str(values))  
               
        if len(ids_list_orig) == len(Init.measurements_IDs):
            #Print the current time stamp and current value
            #print(str(ts),':',str(values))
        
            measurementsAll = values
            X_afterHRS = self.CalcXfromRH(values[1],values[0])
            relHum_afterHRS = self.CalcRHfromX(X_afterHRS,values[16])
            measurementsAll.insert(17, relHum_afterHRS)
            measurementsAll.insert(0, 0)
            # All relHum measurements need to be not in Percentage (as measured)
            measurementsAll[2] = measurementsAll[2]/100
            measurementsAll[4] = measurementsAll[4]/100
            measurementsAll[6] = measurementsAll[6]/100
            measurementsAll[8] = measurementsAll[8]/100

            global gl_measurements_all
            gl_measurements_all.append(measurementsAll)
            sio.savemat((Init.path_res +'\\' + 'Inputs' +'\\' + 'MeasAll.mat'), {'MeasAll' :gl_measurements_all})

            #Save new 'CompleteInput.mat' File
            sio.savemat((Init.path_res +'\\' + 'Inputs' +'\\' + 'CompleteInput.mat'), {'InputTable' :np.array(measurementsAll)})
            
            
        else:
            
            if self._IDs_initial_values is not None: 
                len_to_cut = len(values)-len(self._IDs_initial_values)
                self.measurements = np.array(values[0:len_to_cut])
                values[0:len_to_cut] = []
                values_K =[k+273.15 for k in values]
                self._initial_values = values_K
            else:
                self.measurements = np.array(values)
                self._initial_values = None
        
       
        

    """ Continue util Init.stop_time (experiment time) is reached """    
    def CalcDVvalues(self, time_step, time_storage):     
        """ Get Measurements """
        id_list = list()
        id_list.extend(self._Id_BC2) 
        id_list.append(self._Id_BC1) 
        if self._IDs_initial_values is not None and len(self._IDs_initial_values)>1:
            id_list.extend(self._IDs_initial_values) 
        self.GetMeasurements(id_list)
        absHum_measurements = self.CalcXfromRH(self.measurements[0], self.measurements[1])
        self.measurements[0] = absHum_measurements
        self.measurements = np.delete(self.measurements, 1)        
        
        """ Import selected algorithm (and choose objective function) """
        if Init.algorithm == "BExMoC":
            import algorithm.BExMoC
            BExMoC = algorithm.BExMoC
            """ Execute only once """
            if time_step == 0:
                if self.values_BCs is None:
                    self.values_BCs = BExMoC.CalcBCvalues(Init.amount_vals_BCs, Init.exp_BCs,
                                                 Init.center_vals_BCs, Init.factors_BCs, Init.amount_lower_vals, Init.amount_upper_vals)   

            """ Execute if new optimization is requested """ 
 
            """ Get initial_values for simulation """
            # Check if optimization phase is due
            if time_step-time_storage < Init.optimization_interval and time_step != 0:
                """ Interpolation """ 
                try:
                    [commands, costs, outputs] = BExMoC.Interpolation(self.measurements, self.lookUpTables[1],
                                                self._bounds_DVs, self.lookUpTables[0], self.lookUpTables[2])
                except:
                    commands = []
                    costs = []
                    outputs = []
                            
                    for i in range(0,len(self.lookUpTables[1])):
                        commands.append(0)
                        costs.append(0)
                        outputs.append(0)

                print(str(commands))

            else:
                time_storage = time_step # store the time 
                [storage_cost, storage_DV, storage_out, exDestArr, res_grid] = BExMoC.CalcLookUpTables(self, Init.obj_function, time_storage, Init.path_lib, Init.init_conds)
                self.lookUpTables = [storage_cost, storage_DV, storage_out]
                """ Store look-up table for upstream subsystem in directory of upstream subsystem """
                if exDestArr is not None and self.neighbour_name is not None:
                    sio.savemat((Init.path_res +'\\' + self.neighbour_name +'\\' +  Init.fileName_Cost + '.mat'), {Init.tableName_Cost :exDestArr})   
                """Store optimizer results"""
                sio.savemat((Init.path_res + '\\' + self._name + '\\' + 'OptimizerTrack.mat' ), {'OptimizerTrackCounter11': res_grid})   
                
                try:
                    [commands, costs, outputs] = BExMoC.Interpolation(self.measurements, self.lookUpTables[1],
                                                self._bounds_DVs, self.lookUpTables[0], self.lookUpTables[2])
                except:
                    commands = []
                    costs = []
                    outputs = []
                            
                    for i in range(0,len(self.lookUpTables[1])):
                        commands.append(0)
                        costs.append(0)
                        outputs.append(0)
                        
            if time_storage != time_step:
                """ Store global commands""" # just for analysis
                global gl_commands_costs
                tz = pytz.timezone('Europe/Berlin')
                ts = datetime.now(tz).strftime("%Y-%m-%d %H:%M:%S")
                gl_commands_costs.append([np.array([[self.measurements[0]]]), np.array([[self.measurements[1]]]), commands, costs, np.array([[outputs[0][0]-273.15]]), np.array([[outputs[0][1]]]), self._name, ts])
                #gl_commands_costs.append([commands, costs, self._name, ts])
                sio.savemat((Init.path_res + '\\' + self._name + '\\' + 'CommandsCosts.mat' ), {'CommandsCosts': gl_commands_costs})     
                if self._name != 'Steam_humidifier':
                    self.SendCommands(commands[0,0])
            else: 
                commands = -1
                
            return commands
        elif Init.algorithm == "NC_DMPC":
            import algorithm.NC_DMPC
            NC_DMPC = algorithm.NC_DMPC
            values_BCs = []
            if time_step == 0 or self.neighbour_name is None:
            #if time_storage == 0 or self.neighbour_name is None:
                BC_1 = self.measurements[::-1]
                #if len(BC_1) ==1:
                BC_2 = [BC_1[0]*1.5, BC_1[1]+0.000005]
            else:
                BC_dict = sio.loadmat(Init.path_res +'\\' + self.neighbour_name +'\\' +  Init.fileName_Output + '.mat')
                arrayBC = BC_dict['output']
                #Sort Input Conditions because "exDestArr" must be strictly increaing  """
                if len(arrayBC[1]) ==4:
                    absHum_measurements1 = self.CalcXfromRH(arrayBC[1][3]*100, arrayBC[1][2]-273.15)
                    absHum_measurements2 = self.CalcXfromRH(arrayBC[2][3]*100, arrayBC[2][2]-273.15)
                    BC_1 = [arrayBC[1][2]-273.15, absHum_measurements1]
                    BC_2 = [arrayBC[2][2]-273.15, absHum_measurements2]
                    if arrayBC[1][2] == arrayBC[2][2] or arrayBC[1][3] == arrayBC[2][3]:
                        BC_2 = [val*1.1 for val in BC_1]      
                else:
                    if arrayBC[0][1] < arrayBC[1][1]:
                        values_BCs.append([arrayBC[0][1], arrayBC[1][1]])
                    elif arrayBC[0][1] > arrayBC[1][1]:
                        values_BCs.append([arrayBC[1][1], arrayBC[0][1]]) 
                    else: 
                        values_BCs.append([arrayBC[1][1], arrayBC[0][1]*1.5])     

            for i in range(len(BC_1)):
                if BC_1[i]<BC_2[i]:
                    values_BCs.append([BC_1[i], BC_2[i]])  #[[BC_1[0], BC_2[0]]] 
                else:
                    values_BCs.append([BC_2[i], BC_1[i]])  #[[BC_1[0], BC_2[0]]] 
            self.values_BCs = values_BCs
            if time_step == 0:
                last_DV = Init.init_DVs[0]
                """ Store last_DV in own directory """
                sio.savemat((Init.path_res + '\\' + self._name + '\\' + 'last_DV.mat'), {'last_DV': last_DV})
                
                self.values_BCs = values_BCs  
            """ Load "last_DV" """
            last_DV_dict = sio.loadmat(Init.path_res + '\\' + self._name + '\\' + 'last_DV.mat')
            last_DV = last_DV_dict['last_DV']
            [storage_cost, storage_DV, storage_out, exDestArr, storage_grid]  = NC_DMPC.Iteration(self, time_step)
            """Store optimizer results"""
            sio.savemat((Init.path_res + '\\' + self._name + '\\' + 'OptimizerTrack.mat' ), {'OptimizerTrack': storage_grid})    
            """ Load, determine and store new "last_DV" """
            new_last_DV = last_DV*Init.convex_factor+(1-Init.convex_factor)*storage_DV[0][2]
            sio.savemat((Init.path_res + '\\' + self._name + '\\' + 'last_DV.mat'), {'last_DV': new_last_DV})
            print(new_last_DV)
            """ Store costs in neighbour's folder """
            if exDestArr is not None and self.neighbour_name is not None:
                sio.savemat((Init.path_res +'\\' + self.neighbour_name +'\\' +  Init.fileName_Cost + '.mat'), {Init.tableName_Cost :exDestArr})  
            """ Store output values in own directory """     
            sio.savemat((Init.path_res + '\\' + self._name + '\\' + Init.fileName_Output + '.mat'), {Init.tableName_Output: storage_out})
            """ Store costs in own directory for evaluation only"""  
            sio.savemat((Init.path_res + '\\' + self._name + '\\' + 'Costs.mat'), {Init.tableName_Output: storage_cost})
            commands = float(new_last_DV)
            tz = pytz.timezone('Europe/Berlin')
            ts = datetime.now(tz).strftime("%Y-%m-%d %H:%M:%S")
            gl_commands_costs.append([np.array([[self.measurements[0]]]), np.array([[self.measurements[1]]]),np.array([[commands]]), np.array([[storage_cost[0][1]]]),  np.array([[storage_out[0][2]]]),np.array([[storage_out[0][3]]]), self._name, ts])
            """ For evaluation only"""  
            sio.savemat((Init.path_res + '\\' + self._name + '\\' + 'CommandsCosts.mat' ), {'CommandsCosts': gl_commands_costs})   
            """ Send commands """
            if self._name != 'Steam_humidifier' and  time_step-time_storage == Init.optimization_interval-Init.sync_rate:
                self.SendCommands(commands)
            return commands
     
    def SendCommands(self, commands):
        """ Send commands   """
        
    def CalcXfromRH(self, relHum, T_hum, pressure=None):
        if pressure is None:
            pressure = 101325            
        """Enhancement factors Water / Ice"""
        aw = 6.1121
        bw = 18.678
        cw = 257.14
        dw = 234.5
    
        ai = 6.1115
        bi = 23.036
        ci = 279.82
        di = 333.7
    
        pressure = pressure/100     # calculations require hekto pascal (equal mbar)
        
        if T_hum > 0:
             EFw = 1 + 10**-4 *(7.2 + pressure * (0.0320 + 5.9*10**-6 * T_hum**2));
             f1wT = EFw * aw * math.exp((bw - T_hum/dw) * T_hum/(T_hum + cw));                       # saturation pressure from temperature
             f1wDP = (relHum/100) * f1wT;                            # vaporPressure
             absHum_measurements = (18.015/28.963) * f1wDP /(pressure - f1wDP);
        else:
             EFi = 1 + 10**-4 *(2.2 + pressure * (0.0383 + 6.4*10**-6 * T_hum**2));
             f1iT = EFi * ai * math.exp((bi - T_hum/di) * T_hum/(T_hum + ci));                       # saturation pressure from temperature
             f1iDP = (relHum/100) * f1iT;                            # vaporPressure
             absHum_measurements = ((18.015/28.963) * f1iDP /(pressure - f1iDP));
        return absHum_measurements

        
    def CalcRHfromX(self, absHum, T_hum, pressure=None):
        if pressure is None:
            pressure = 101325            
        """Enhancement factors Water / Ice"""
        aw = 6.1121
        bw = 18.678
        cw = 257.14
        dw = 234.5
    
        ai = 6.1115
        bi = 23.036
        ci = 279.82
        di = 333.7
    
        pressure = pressure/100     # calculations require hekto pascal (equal mbar)
        
        if T_hum > 0:
             EFw = 1 + 10**-4 *(7.2 + pressure * (0.0320 + 5.9*10**-6 * T_hum**2));
             f1wT = EFw * aw * math.exp((bw - T_hum/dw) * T_hum/(T_hum + cw));                       # saturation pressure from temperature
             relHum = (pressure*absHum*100/(absHum+(18.015/28.963)))/f1wT;
        else:
             EFi = 1 + 10**-4 *(2.2 + pressure * (0.0383 + 6.4*10**-6 * T_hum**2));
             f1iT = EFi * ai * math.exp((bi - T_hum/di) * T_hum/(T_hum + ci));                       # saturation pressure from temperature
             relHum = (pressure*absHum*100/(absHum+(18.015/28.963)))/f1iT;
        return relHum
    
            
        
        