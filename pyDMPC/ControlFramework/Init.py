""" Neccessary specifications (user) """

"""System configuration"""
name_system = 'AHU'
amount_consumer = 4
amount_generator = 1

"""Data point IDs in the controlled system"""
measurements_IDs = ['4120.L04_.AEMWB04_Temp Aussenluft', '4120.L04_.AEMWB03_Feuchte Aussen', '4120.L04_.AEMWB24_Temp Fortluft',
                    '4120.L04_.AEMWB25_Feuchte FO-Luft',  '4120.L04_.AEMWB20_Temp ABL Gesamt', '4120.L04_.AEMWB21_Feuchte Abluft',
                    '4120.L04_.AEMWB08_Temp nach NE',  '4120.L04_.VEGYMW__Feuchte Zuluft','4120.L04_.AEMWB06_Temp nach VE',
                    '4120.L04_.AEMWB07_Temp n Kuehler','4120.L04_.AEMWB08_Temp nach NE', '4120.MONI.AEMW105 Dist Lab h T in',
                    '4120.K08_.AEMWB02_Temp VL ULK', '4120.MONI.AEMW105 Dist Lab h T in', '4120.L04_.AEMWB16_Temp RL VE',
                    '4120.L04_.AEMWB17_Temp RL NE', '4120.L04_.AEMWB05_Temp nach WRG']

""" General algorithm settings """
algorithm = 'BExMoC'   #choices: 'NC_DMPC', 'BExMoC'
parallelization = False  #run calculations in parallel if possible
realtime = True         #Choose True for a real-life experiment

""" Settings for BExMoC algorithm """
# So far: For all subsystems the same settings
factors_BCs = [3, 0.3]              # order: BC1, BC2, ...
center_vals_BCs = [30, 0.001]
amount_lower_vals = [2, 0]
amount_upper_vals = [2, 1]
exp_BCs = [1.4, 1]
amount_vals_BCs = [1, 1]

""" Settings for NC-DMPC algorithm """
init_DVs = [0]
convex_factor = 0.5
max_num_iteration = 1000
max_relErr = 0.1
cost_gradient = 0

""" Set objective function """
obj_function = 'Monetary'   #choices: 'Exergy', 'Monetary'
set_point = [20, 0.005]     #set points of the controlled variables

""" Time and Interval Settings """
sim_time_global = 10000          # -> not used yet
sync_rate = 10*60                 # Synchronisation rate in seconds
optimization_interval = 2*60    # After one interval the optimization is repeated
prediction_horizon = 3600        #Common prediction horizon in seconds

""" Simulation Settings for Dymola """
# Directory where the simulation results are stored
path_res = r'C:\TEMP\Dymola\LookUps_Backup_01_03'
path_lib1 = r'C:\Git\pyDMPC\pyDMPC\ModelicaModels\ModelicaModels'
path_lib2 = r'C:\Git\modelica-buildings\Buildings'
path_lib3 = r'C:\Git\SimContrCaseStudies\SimulationMPC\SimulationMPC'
path_fmu = r'C:\TEMP\Dymola\LookUps_Backup_01_03\ModelicaModels_ControlledSystems_ControlledSystemBoundaries.fmu'
#path_lib = [path_lib1, path_lib2, path_lib3]
path_lib = [path_lib1]
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
model_path.append('ModelicaModels.SubsystemModels.HeatRecovery')
Id_BC1.append('4120.L04_.AEMWB07_Temp n Kuehler')
Id_BC2.append(['4120.L04_.AEMWB03_Feuchte Aussen','4120.L04_.AEMWB04_Temp Aussenluft'])
names_DVs.append('4120.L04_.AASYY17_NE-Ventil')
output_vars.append(["add.y","variation.y[2]"]) #NC_DMPC
initial_names.append(None)
IDs_initial_values.append([''])

# Pre-heater
name.append('Pre_heater')
position.append(4)                  #last Subsystem, downstream for every other, has biggest number
type_subSyst.append('consumer')
num_DecVars.append(1)
num_VarsOut.append(2)
bounds_DVs.append([0,100])
model_path.append('ModelicaModels.SubsystemModels.Heater')
Id_BC1.append('4120.L04_.AEMWB07_Temp n Kuehler')
Id_BC2.append(['4120.L04_.AEMWB03_Feuchte Aussen','4120.L04_.AEMWB04_Temp Aussenluft'])
names_DVs.append('4120.L04_.AASYY17_NE-Ventil')
output_vars.append(["add.y","variation.y[2]"]) #NC_DMPC
initial_names.append(None)
IDs_initial_values.append([''])

# Cooler
name.append('Cooler')
position.append(3)
type_subSyst.append('consumer')
num_DecVars.append(1)
num_VarsOut.append(2)
bounds_DVs.append([0,100])
model_path.append('ModelicaModels.SubsystemModels.Cooler')
Id_BC1.append('4120.L04_.AEMWB07_Temp n Kuehler')
Id_BC2.append(['4120.L04_.AEMWB03_Feuchte Aussen','4120.L04_.AEMWB04_Temp Aussenluft'])
names_DVs.append('4120.L04_.AASYY17_NE-Ventil')
output_vars.append(["add.y","variation.y[2]"]) #NC_DMPC
initial_names.append(None)
IDs_initial_values.append([''])

# Heater
name.append('Heater')
position.append(2)
type_subSyst.append('consumer')
num_DecVars.append(1)
num_VarsOut.append(2)
bounds_DVs.append([0,80])
model_path.append('ModelicaModels.SubsystemModels.Heater')
Id_BC1.append('4120.L04_.AEMWB07_Temp n Kuehler')
Id_BC2.append(['4120.L04_.AEMWB03_Feuchte Aussen','4120.L04_.AEMWB04_Temp Aussenluft'])
names_DVs.append('4120.L04_.AASYY17_NE-Ventil')
output_vars.append(["add.y","variation.y[2]"]) #NC_DMPC
initial_names.append(None)
IDs_initial_values.append([''])

# Steam_humidifier
name.append('Steam_humidifier')
position.append(1)
type_subSyst.append('consumer')
num_DecVars.append(1)
num_VarsOut.append(2)
bounds_DVs.append([0,0])
model_path.append('ModelicaModels.SubsystemModels.Humidifier')
Id_BC1.append('4120.L04_.AEMWB07_Temp n Kuehler')
Id_BC2.append(['4120.L04_.AEMWB03_Feuchte Aussen','4120.L04_.AEMWB04_Temp Aussenluft'])
names_DVs.append('Humidifier_DV')
output_vars.append(["variation.y[1]","variation.y[2]"]) #NC_DMPC Humdidifier
initial_names.append(None)
IDs_initial_values.append(None)
