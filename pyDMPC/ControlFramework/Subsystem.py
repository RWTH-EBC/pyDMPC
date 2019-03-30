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
gl_commands_costs = []
gl_measurements_all =[]

class Subsystem():

    def __init__(self, name, position,no_parallel,holon,
                 num_DVs,num_BCs, init_DecVars, sim_time,
                 bounds_DVs,start_DVs,factor_DVs,
                 model_path, names_BCs, variation,
                 num_VarsOut, names_DVs,
                 output_vars, initial_names, IDs_initial_values,
                 IDs_inputs,cost_par,cost_factor,model_type,type_subSyst=None):
        self._name = name
        self._type_subSyst = type_subSyst
        self._num_DVs = num_DVs
        self._num_BCs = num_BCs
        self.init_DecVars = init_DecVars
        self.sim_time = sim_time
        self.position = position
        self.no_parallel = no_parallel
        self.holon = holon
        self.num_VarsOut = num_VarsOut
        self._bounds_DVs = bounds_DVs
        self.start_DVs = start_DVs
        self.factor_DVs = factor_DVs
        self.values_BCs = None
        self.variation = variation
        self.lookUpTables = None
        self._model_path = model_path
        self._names_BCs = names_BCs
        self._cost_par = cost_par
        self._cost_factor = cost_factor
        self._names_DVs = names_DVs
        self._output_vars = output_vars
        self._initial_names = initial_names
        self._IDs_initial_values = IDs_initial_values
        self._IDs_inputs = IDs_inputs
        self._model_type = model_type


    def GetNeighbour(self, neighbour_name):
        """Gets the name of a subsystem's neighbor"""
        self.neighbour_name = neighbour_name

    def GetMeasurements(self, ids_list, model):
        """
        Gets measurements from FMU model
        inputs:
            ids_list: names of the variables in the model
            model: FMU object
        returns:
            values: list of measurement values
        """
        values = []

        for val in ids_list:
            value = model.get(val) #FMU
            values.append(np.asscalar(value))

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
        

    def CalcDVvalues(self, time_step, time_storage, iter, model):
        """
        Caclulate the values of the decision variables
        inputs:
            ids_list: names of the variables in the model
            model: FMU object
        returns:
            values: list of measurement values
        """
        """ Get Measurements """
        self.measurements = self.GetMeasurements(self._IDs_inputs, model)
        
        self.GetWeatherForcast()

        if self._type_subSyst != "generator":
            values = np.concatenate(([0.0], self.measurements[::-1]),axis=0)
        else:
            values = np.concatenate(([0.0], self.measurements[::-1]),axis=0)
        print(values)

        # Save new 'CompleteInput.mat' File
        sio.savemat((Init.path_res +'\\'+Init.name_wkdir + '\\' + self._name + 
                     '\\' + 'CompleteInput.mat'), {'InputTable' :np.array(values)})
        self.measurements[0] = self.CalcXfromRH(self.measurements[0]*100, 
                         self.measurements[1])
        self.measurements = [self.measurements[0], self.measurements[1]]

        # Get a dedicated outdoor measurement
        #outdoor_meas = self.GetMeasurements([r'outdoorTemperatureOutput'], model)

        if self._IDs_initial_values is not None:
            self._initial_values = self.GetMeasurements(
                    self._IDs_initial_values, model)
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
            if (time_step-time_storage < Init.optimization_interval and 
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
                """ Store global commands""" # just for analysis
                global gl_commands_costs
                tz = pytz.timezone('Europe/Berlin')
                ts = datetime.now(tz).strftime("%Y-%m-%d %H:%M:%S")
                
            for j,val in enumerate(commands):
                model.set(self._names_DVs[j], self.start_DVs[j] + 
                              val/100*self.factor_DVs[j])

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
