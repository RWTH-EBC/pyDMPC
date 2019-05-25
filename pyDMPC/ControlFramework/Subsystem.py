##################################################################
# Subsystem class that includes all the control agents' abilities
##################################################################

import numpy as np
import Init
import scipy.io as sio
import math
from datetime import datetime
import pytz
import requests
import pyads
gl_commands_costs = []
gl_measurements_all =[]

class Subsystem():
    
    def __init__(self, i):
        self._name = Init.name[i]
        self._type_subSyst = Init.type_subSyst[i]
        self._num_BCs = Init.num_BCs[i]
        self.init_DecVars = Init.init_DecVars[i]
        self.sim_time = Init.sim_time[i]
        self.position = Init.position[i]
        self.no_parallel = Init.no_parallel[i]
        self.holon = Init.holon[i]
        self.num_VarsOut = Init.num_VarsOut[i]
        self._bounds_DVs = Init.bounds_DVs[i]
        self.start_DVs = Init.start_DVs[i]
        self.factor_DVs = Init.factor_DVs[i]
        self.values_BCs = None
        self.variation = Init.variation[i]
        self.lookUpTables = None
        self._model_path = Init.model_path[i]
        self._names_BCs = Init.names_BCs[i]
        self._cost_par = Init.cost_par[i]
        self._cost_factor = Init.cost_factor[i]
        self._names_DVs = Init.names_DVs[i]
        self._num_DVs = len(self._names_DVs) if self._names_DVs is not None else 0
        self._output_vars = Init.output_vars[i]
        self._initial_names = Init.initial_names[i]
        self._IDs_initial_values = Init.IDs_initial_values[i]
        self._IDs_initial_offsets = Init.IDs_initial_offsets[i]
        self._IDs_inputs = Init.IDs_inputs[i]
        self._model_type = Init.model_type[i]
        self._pred_hor = Init.pred_hor[i]
        self._ind_opt_inter = Init.ind_opt_inter[i]


    def GetNeighbour(self, neighbour_name):
        """Gets the name of a subsystem's neighbor"""
        self.neighbour_name = neighbour_name

    def GetMeasurements(self, ids_list, model, offsets=None):
        """
        Gets measurements from FMU model
        inputs:
            ids_list: names of the variables in the model
            model: FMU object
        returns:
            values: list of measurement values
        """
        values = []

        for j,val in enumerate(ids_list):
            if Init.realtime:
                value = model.read_by_name(val, pyads.PLCTYPE_REAL) 
                print(val + str(value))
            else:
                value = np.asscalar(model.get(val))
                
            if offsets is not None:
                value = value + offsets[j]
                
            values.append(value)
                
        return values
    
    def GetWeatherForcast(self):

        key = np.loadtxt(Init.keypath, str)
        url = (r"http://api.openweathermap.org/data/2.5/forecast?id=6553047&APPID=" +
                  str(key))  
    
        r = requests.get(url).json()
    
        r = r['list']
        
        for k in range(0,1000):
        
            try:
                dic = r[k]
                tim = dic['dt']
                    
                mai = dic['main']
                temp = float(mai['temp'])
                
                if k == 0:
                    start_tim = tim
                    values = [[0.0,temp]]
                else:
                    values += [[tim-start_tim,temp]]
                    
            except:
                break
                    
        sio.savemat((Init.path_res +'\\'+Init.name_wkdir + '\\' + self._name + 
                     '\\' + 'weather.mat'),{'InputTable' : np.array(values)})
        

    def CalcDVvalues(self, time_step, time_storage, iter, model=None):
        """
        Caclulate the values of the decision variables
        inputs:
            ids_list: names of the variables in the model
            model: FMU object
        returns:
            values: list of measurement values
        """
        """ Get Measurements """
        if self._name == "Hall-long" or self._name == "Hall-short":
            self.GetWeatherForcast()
            print('Getting forecast')
        
        if self._IDs_inputs is not None:
            self.measurements = self.GetMeasurements(self._IDs_inputs, model)
            

            self.measurements[0] = self.CalcXfromRH(self.measurements[0], 
                             self.measurements[1])
            self.measurements = [self.measurements[0], self.measurements[1]]
    
            values = np.concatenate(([0.0], self.measurements[::-1]),axis=0)
    
            print(values)
            
            # Save new 'CompleteInput.mat' File
            sio.savemat((Init.path_res +'\\'+Init.name_wkdir + '\\' + self._name + 
                         '\\' + 'CompleteInput.mat'), {'InputTable' :np.array(values)})
            
        else:
            self.measurements = []

        if self._IDs_initial_values is not None:
            self._initial_values = self.GetMeasurements(
                    self._IDs_initial_values, model, self._IDs_initial_offsets)
        else:
            self._initial_values = []

        """ Import selected algorithm (and choose objective function) """
        if Init.algorithm == "BExMoC":
            """
            If optimization is due, create a new look-up table based on
            one optimization per boundary condition. In the steps in between,
            interpolate the look-up table
            """
            import algorithm.BExMoC
            BExMoC = algorithm.BExMoC

            if time_step == Init.sync_rate:
                if self.values_BCs is None:
                    if self.variation:
                        self.values_BCs = BExMoC.CalcBCvalues(
                                Init.amount_vals_BCs, Init.exp_BCs, 
                                Init.center_vals_BCs, Init.factors_BCs, 
                                Init.amount_lower_vals, Init.amount_upper_vals)
                    else:
                        self.values_BCs = BExMoC.CalcBCvalues(
                                Init.amount_vals_BCs, Init.exp_BCs, 
                                Init.center_vals_BCs, Init.factors_BCs, 0, 0)

            # Check if optimization phase is due
            if (time_step-time_storage < self._ind_opt_inter and 
                time_step != Init.sync_rate):
                # Interpolation
                try:
                    [commands, costs, outputs] = BExMoC.Interpolation(
                            self.measurements, self.lookUpTables[1], 
                            self._bounds_DVs, self.lookUpTables[0], 
                            self.lookUpTables[2],self.variation)

                except:
                    commands = []
                    costs = []
                    outputs = []

                    for i in range(0,len(self.lookUpTables[1])):
                        commands.append(0)
                        costs.append(0)
                        outputs.append([0,0])

            else:
                # Optimization
                time_storage = time_step # store the time
                [storage_cost, storage_DV, storage_out, exDestArr, res_grid] = (
                        BExMoC.CalcLookUpTables(self, time_storage, 
                                                Init.init_conds))
                self.lookUpTables = [storage_cost, storage_DV, storage_out]

                """ Store look-up table for upstream subsystem in directory of upstream subsystem """
                if self.no_parallel == 0:
                    if exDestArr is not None and self.neighbour_name is not None:
                        sio.savemat((Init.path_res +'\\'+Init.name_wkdir +'\\' +
                                     self.neighbour_name +'\\' +  
                                     Init.fileName_Cost + '.mat'), 
                                    {Init.tableName_Cost :exDestArr})
                else:
                    if exDestArr is not None and self.neighbour_name is not None:
                        sio.savemat((Init.path_res +'\\'+Init.name_wkdir +'\\' +
                                     self.neighbour_name +'\\' +  
                                     Init.fileName_Cost + str(self.no_parallel) + '.mat'), 
                                    {Init.tableName_Cost :exDestArr})
                        print(exDestArr)
                """Store optimizer results"""
                sio.savemat((Init.path_res +'\\'+Init.name_wkdir + '\\' +
                             self._name + '\\' + 'OptimizerTrack.mat' ), 
                            {'OptimizerTrackCounter11': res_grid})

                try:
                    [commands, costs, outputs] = BExMoC.Interpolation(
                            self.measurements, self.lookUpTables[1], 
                            self._bounds_DVs, self.lookUpTables[0], 
                            self.lookUpTables[2],self.variation)

                    print('measurements: ' + str(self.measurements))
                    print('commands: ' +str(commands))
                    print('outputs: ' +str(outputs))

                except:
                    commands = []
                    costs = []
                    outputs = []

                    for i in range(0,len(self.lookUpTables[1])):
                        commands.append(0)
                        costs.append(0)
                        outputs.append(0)
                    print("Interpolation failed")

            if time_storage != time_step:
                """ Store global commands""" 
                global gl_commands_costs
                tz = pytz.timezone('Europe/Berlin')
                ts = datetime.now(tz).strftime("%Y-%m-%d %H:%M:%S")
                
            if self._names_DVs is not None:
                                   
                for j,val in enumerate(commands):
                    command2send = float((self.start_DVs[j] + 
                                  val/100*self.factor_DVs[j]))
                    if Init.realtime:
                        print(self._names_DVs[j] + ": " + str(command2send))
                        model.write_by_name(self._names_DVs[j], command2send, 
                                      pyads.PLCTYPE_REAL) 
                    else:
                        model.set(self._names_DVs[j], command2send)
                    

            return commands

        elif Init.algorithm == "NC_DMPC":
            """
            The algorithm initializes each subsystem's boundary conditions with
            a value between the current measurement and the set point,
            depending on the current outdoor conditions.
            """
            import algorithm.NC_DMPC
            NC_DMPC = algorithm.NC_DMPC
            values_BCs = []
            incr = 0

            # Initialize in the first iteration
            if iter == 0 and self._type_subSyst != 'generator':
                if outdoor_meas[0] < Init.set_point[0]:
                    BC_1 = [min(outdoor_meas[0], Init.set_point[0]-2),
                            self.measurements[0]+0.0005]
                else:
                    BC_1 = [max(outdoor_meas[0], Init.set_point[0]+1),
                            self.measurements[0]+0.0005]
                BC_2 = [Init.set_point[0], self.measurements[0]-0.0005]

                print('BC_1: ', BC_1)
                print('BC_2: ', BC_2)

            # Generator always has measurements as boundary conditions
            elif self._type_subSyst == 'generator':
                BC_1 = [self.measurements[1],self.measurements[0]+0.0005]
                BC_2 = [self.measurements[1], self.measurements[0]-0.0005]
                print('BC_1: ', BC_1)
                print('BC_2: ', BC_2)

            else:
                # Use the neighbor's outputs as boundary conditions
                BC_dict = sio.loadmat(Init.path_res +'\\'+Init.name_wkdir +'\\' +
                                      self.neighbour_name +'\\' +  
                                      Init.fileName_Output + '.mat')
                arrayBC = BC_dict['output']

                # Sort boundary conditions
                if len(arrayBC[1]) == 4:
                    absHum_measurements1 = self.CalcXfromRH(arrayBC[1][3]*100, 
                                                            arrayBC[1][2])
                    absHum_measurements2 = self.CalcXfromRH(arrayBC[2][3]*100, 
                                                            arrayBC[2][2])

                    BC_2 = [Init.set_point[0], absHum_measurements2]
                    if outdoor_meas[0] < Init.set_point[0]:
                        BC_1 = [min(arrayBC[1][2], Init.set_point[0]-2), 
                                absHum_measurements1]
                    else:
                        BC_1 = [max(arrayBC[3][2], Init.set_point[0]+1), 
                                absHum_measurements1]

                else:
                    if arrayBC[0][1] < arrayBC[1][1]:
                        values_BCs.append([arrayBC[0][1]-incr, arrayBC[1][1]+incr])
                    elif arrayBC[0][1] > arrayBC[1][1]:
                        values_BCs.append([arrayBC[1][1]-incr, arrayBC[0][1]+incr])
                    else:
                        values_BCs.append([arrayBC[1][1]-incr, arrayBC[0][1]+incr])

            for i in range(len(BC_1)):
                if BC_1[i]<BC_2[i]:
                    values_BCs.append([BC_1[i], BC_2[i]])
                else:
                    values_BCs.append([BC_2[i], BC_1[i]])

            last_DV = Init.init_DVs[0]

            """ Store last_DV in own directory """
            sio.savemat((Init.path_res +'\\'+Init.name_wkdir + '\\' + 
                         self._name + '\\' + 'last_DV.mat'), {'last_DV': last_DV})

            self.values_BCs = values_BCs
            """ Load "last_DV" """
            last_DV_dict = sio.loadmat(Init.path_res +'\\'+Init.name_wkdir + 
                                       '\\' + self._name + '\\' + 'last_DV.mat')
            last_DV = last_DV_dict['last_DV']

            [storage_cost, storage_DV, storage_out, exDestArr, storage_grid]  = (
                    NC_DMPC.Iteration(self, time_step))

            """Store optimizer results"""
            sio.savemat((Init.path_res +'\\'+ Init.name_wkdir + '\\' + 
                         self._name + '\\' + 'OptimizerTrack.mat' ), 
                        {'OptimizerTrack': storage_grid})

            """ Load, determine and store new "last_DV" """
            new_last_DV = last_DV*Init.convex_factor+(
                    (1-Init.convex_factor)*storage_DV[0][2])
            sio.savemat((Init.path_res +'\\'+Init.name_wkdir + '\\' + 
                         self._name + '\\' + 'last_DV.mat'), 
                        {'last_DV': new_last_DV})

            """ Store costs in neighbour's folder """
            if exDestArr is not None and self.neighbour_name is not None:
                sio.savemat((Init.path_res +'\\'+Init.name_wkdir +'\\' + 
                             self.neighbour_name +'\\' +  
                             Init.fileName_Cost + '.mat'), 
                            {Init.tableName_Cost :exDestArr})

            """ Store output values in own directory """
            sio.savemat((Init.path_res +'\\'+Init.name_wkdir + '\\' + 
                         self._name + '\\' + Init.fileName_Output + '.mat'), 
                        {Init.tableName_Output: storage_out})

            """ Store costs in own directory for evaluation only"""
            sio.savemat((Init.path_res +'\\'+Init.name_wkdir + '\\' + 
                         self._name + '\\' + 'Costs.mat'), 
                        {Init.tableName_Output: storage_cost})
            if outdoor_meas[0] > Init.set_point[0]:
                commands = float(storage_DV[3][2])
            else:
                commands = float(storage_DV[1][2])
            print(storage_DV)

            tz = pytz.timezone('Europe/Berlin')
            ts = datetime.now(tz).strftime("%Y-%m-%d %H:%M:%S")

            print(str(self._name) + " command: " + str(commands))
            print(str(self._name) + " costs: " + str(storage_cost[0][1]))
            print(str(self._name) + " output: " + str(storage_out[0][2]))

            return commands

    def CalcXfromRH(self, relHum, T_hum, pressure=None):
        """
        Caclulate the absolute humidity
        inputs:
            relHum: relative humidity in %
            T_hum: temperature of moist air in °C
            pressure: pressure in Pa
        returns:
            absHum_measurements: absolute humidity in g/kg
        """
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

        pressure = pressure/100     # calculations require hekto pascal

        if T_hum > 0:
             EFw = 1 + 10**-4 *(7.2 + pressure * (0.0320 + 5.9*10**-6 * T_hum**2))
             f1wT = EFw * aw * math.exp((bw - T_hum/dw) * T_hum/(T_hum + cw)) 
             f1wDP = (relHum/100) * f1wT
             absHum_measurements = (18.015/28.963) * f1wDP /(pressure - f1wDP)
        else:
             EFi = 1 + 10**-4 *(2.2 + pressure * (0.0383 + 6.4*10**-6 * T_hum**2))
             f1iT = EFi * ai * math.exp((bi - T_hum/di) * T_hum/(T_hum + ci))    
             f1iDP = (relHum/100) * f1iT                 
             absHum_measurements = ((18.015/28.963) * f1iDP /(pressure - f1iDP))

        return absHum_measurements


    def CalcRHfromX(self, absHum, T_hum, pressure=None):
        """
        Caclulate the relative humidity
        inputs:
            absHum: absolute humidity in g/kg
            T_hum: temperature of moist air in °C
            pressure: pressure in Pa
        returns:
            relHum: relative humidity in %
        """
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
             EFw = 1 + 10**-4 *(7.2 + pressure * (0.0320 + 5.9*10**-6 * T_hum**2))
             f1wT = EFw * aw * math.exp((bw - T_hum/dw) * T_hum/(T_hum + cw))                      
             relHum = (pressure*absHum*100/(absHum+(18.015/28.963)))/f1wT
        else:
             EFi = 1 + 10**-4 *(2.2 + pressure * (0.0383 + 6.4*10**-6 * T_hum**2))
             f1iT = EFi * ai * math.exp((bi - T_hum/di) * T_hum/(T_hum + ci))                      
             relHum = (pressure*absHum*100/(absHum+(18.015/28.963)))/f1iT

        return relHum
