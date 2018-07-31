# -*- coding: utf-8 -*-
"""

"""
# System name
name_system = 'AHU'


# MEASURMENTS IDs

measurements_less = []
measurements_IDs_alt = []
""" Neccessary specifications (user) """
measurements_IDs = []

""" Amount Subsystems """
amount_consumer = 4
amount_generator = 1

""" Set algorithm """
algorithm = 'BExMoC' # opportunities: 'NC_DMPC', 'BExMoC'

""" Set objective function """
obj_function = 'Monetary' # other opportunity: 'Exergy' -> not used yet, defined in model

""" Set set-point (number or function) """
set_point = 20 # -> not used yet, defined in model

""" Time and Interval Settings """
sim_time_global = 10000          # -> not used yet
sync_rate = 2*60                 # Synchronisation rate in seconds
optimization_interval = 20*60    # After one interval the optimization is repeated
prediction_horizon = 3600        # Stop time of Dymola simulation in seconds 

""" Simulation Settings for Dymola """
# Directory where the simulation results are stored 
path_res = r''
path_lib1 = '' 
path_lib2 = ''
path_lib3 = ''
path_lib = [path_lib1, path_lib2, path_lib3]
start_time = 0.0
stop_time = prediction_horizon   # Stop time of simulation in seconds
incr = 10
tol = 0.0001
# Initial conditions for the optimization
init_conds = [50]
fileName_BCsInputTable = 'variation'
tableName_BCsInputTable = 'tab1'
fileName_DVsInputTable = 'decisionVariables'
tableName_DVsInputTable = 'tab1'
fileName_Cost = 'exDestArr'
tableName_Cost = 'tab1'
fileName_Output = 'outputs'
tableName_Output = 'output'


""" Same values for all subsystems !priority if not 'None'! """
init_DecVars_global = 0
num_BCs_global = 2
num_VarsOut_global = 2
bounds_DVs_global = None # min, 
names_BCs_global = names_SPs = ['temperature', 'humidity']
output_vars_global = None #if no, set None, else set names as string-list

name = []
position = []
type_subSyst = []
num_DecVars = []
num_VarsOut = []
sim_time = []
init_DecVars = []
num_BCs = [] # up to 4 because of modelicares.exps.doe.fullfact 
bounds_DVs = []
model_path = []
names_DVs = []
names_BCs = []
Id_BC1 = [] #T
Id_BC2 = [] #relHum, T_relHum
output_vars = []
initial_names= [] #for simulation
IDs_initial_values= [] #for simulation

""" Subsystems """
# Heat recovery system
name.append('Heat_recovery_system')
position.append(5)
type_subSyst.append('generator')
num_DecVars.append(1)
num_VarsOut.append(2)
bounds_DVs.append([0,100])
model_path.append('SimulationMPC.CaseStudies.AirHandler.SubsystemModelsFramework.InOutlets')

Id_BC1.append('')
Id_BC2.append([''])
names_DVs.append('') #fileName "decisionVariables", tab1
output_vars.append([""]) #NC_DMPC
initial_names.append(["OutgoingHex.ele[1].mas.T","OutgoingHex.ele[2].mas.T","OutgoingHex.ele[3].mas.T","OutgoingHex.ele[4].mas.T",
                      "IntakeHex.ele[1].mas.T","IntakeHex.ele[1].mas.T","IntakeHex.ele[1].mas.T","IntakeHex.ele[1].mas.T"])
IDs_initial_values.append([''])

# Pre-heater
name.append('Pre_heater')
position.append(4)                  #last Subsystem, downstream for every other, has biggest number
type_subSyst.append('consumer')
num_DecVars.append(1)
num_VarsOut.append(2)
bounds_DVs.append([0,100])
model_path.append('SimulationMPC.CaseStudies.AirHandler.SubsystemModelsFramework.PreHeater')
Id_BC1.append('')
Id_BC2.append([''])
names_DVs.append('')
output_vars.append(["supplyAirTemperature.T","supplyAirHumidity.phi"]) #NC_DMPC
initial_names.append(["hex.ele[1].mas.T","hex.ele[2].mas.T","hex.ele[3].mas.T","hex.ele[4].mas.T"])
IDs_initial_values.append([''])

# Cooler
name.append('Cooler')
position.append(3)
type_subSyst.append('consumer')
num_DecVars.append(1)
num_VarsOut.append(2)
bounds_DVs.append([0,100])
model_path.append('SimulationMPC.CaseStudies.AirHandler.SubsystemModelsFramework.Cooler')

Id_BC1.append('')
Id_BC2.append([''])
names_DVs.append('')
output_vars.append(["supplyAirTemperature.T","supplyAirHumidity.phi"]) #NC_DMPC 
initial_names.append(["hex.ele[1].mas.T","hex.ele[2].mas.T","hex.ele[3].mas.T","hex.ele[4].mas.T"])
IDs_initial_values.append([''])

# Heater
name.append('Heater')
position.append(2)
type_subSyst.append('consumer')
num_DecVars.append(1)
num_VarsOut.append(2)
bounds_DVs.append([0,80])
model_path.append('SimulationMPC.CaseStudies.AirHandler.SubsystemModelsFramework.Heater')
Id_BC1.append('')
Id_BC2.append([''])
names_DVs.append('') 
output_vars.append(["supplyAirTemperature.T","supplyAirHumidity.phi"]) #NC_DMPC
initial_names.append(["hex.ele[1].mas.T","hex.ele[2].mas.T","hex.ele[3].mas.T","hex.ele[4].mas.T"])
IDs_initial_values.append([''])

# Steam_humidifier
name.append('Steam_humidifier')
position.append(1)
type_subSyst.append('consumer')
num_DecVars.append(1)
num_VarsOut.append(2)
bounds_DVs.append([0,0])
model_path.append('SimulationMPC.CaseStudies.AirHandler.SubsystemModelsFramework.Humidifier')
Id_BC1.append('')
Id_BC2.append([''])
Id_BC2.append([''])
names_DVs.append('Humidifier_DV') 
output_vars.append(["IntakeAirOutletTemp.T","IntakeAirRelHumid.phi"]) #NC_DMPC Humdidifier
initial_names.append(None)
IDs_initial_values.append(None)

""" Settings for BExMoC """
# So far: For all subsystems the same settings
factors_BCs = [1, 0.002]              # order: BC1, BC2, ... 
center_vals_BCs = [30, 0.007]
amount_lower_vals = [3, 0]
amount_upper_vals = [3, 1] 
exp_BCs = [1.4, 1]
amount_vals_BCs = [1, 1]

""" Settings for NC-DMPC """
init_DVs = [0]
convex_factor = 0.5
max_num_iteration = 1000
max_relErr = 0.1
cost_gradient = 0
BC1_init = 1
BC2_init = 0.001

