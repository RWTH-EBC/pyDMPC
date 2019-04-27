""" Neccessary specifications (user) """

"""System configuration"""
name_system = 'AHU'
amount_consumer = 4
amount_generator = 1

"""Data point IDs in the controlled system"""
measurements_IDs = ['AHUTemperature', 'AHUHumidity']

""" General algorithm settings """
algorithm = 'BExMoC'   #choices: 'NC_DMPC', 'BExMoC'
parallelization = False  #run calculations in parallel if possible
realtime = True         #Choose True for a real-life experiment

""" Settings for BExMoC algorithm """
# So far: For all subsystems the same settings
factors_BCs = [6, 0.03]              # order: BC1, BC2, ...
center_vals_BCs = [30, 0.001]
amount_lower_vals = [1, 0]
amount_upper_vals = [1, 1]
exp_BCs = [1, 1]
amount_vals_BCs = [1, 1]

""" Settings for NC-DMPC algorithm """
init_DVs = [0]
convex_factor = 0
max_num_iteration = 1000
max_relErr = 0.1
cost_gradient = 0

""" Set objective function """
obj_function = 'Monetary'   #choices: 'Exergy', 'Monetary'
set_point = [30.0, 0.005]     #set points of the controlled variables
tolerance = 0.4
cost_factor = 0.5

""" Time and Interval Settings """
sim_time_global = 10000          # -> not used yet
sync_rate = 5*60                 # Synchronisation rate in seconds
optimization_interval = 10*60    # After one interval the optimization is repeated
prediction_horizon = 3600        #Common prediction horizon in seconds

""" Directories and Modelica libraries """
# Path where the main working directory shall be created
path_res = r'C:\Temp\Dymola'
keypath = r'C:\Temp\Dymola\key.txt'

# Name of the main working directory
import time
timestr = time.strftime("%Y%m%d_%H%M%S")
name_wkdir = r'pyDMPC_' + 'wkdir' + timestr
# Path to the Modelica libraries to be loaded
path_lib1 = r'C:\Git\pyDMPC\pyDMPC\ModelicaModels\ModelicaModels'
path_lib2 = r'C:\Git\modelica-buildings\Buildings'
path_lib3 = r'C:\Git\AixLib\AixLib'
path_lib = [path_lib1, path_lib2, path_lib3]

create_FMU = False
# Modelica model to be used as controlled system in a FMU
path_fmu = r'ModelicaModels.ControlledSystems.ControlledSystemBoundaries'

# Name of the FMU file to be created
name_fmu = 'ModelicaModels_ControlledSystems_TestHall'

# Path to the *.egg file containing the Python-Dymola-Interface
path_dymola = r'C:\Program Files\Dymola 2019\Modelica\Library\python_interface\dymola.egg'

""" Simulation settings """
# Start time of simulation in seconds
start_time = 0.0

# Stop time of simulation in seconds
stop_time = prediction_horizon

# Increments of the equidistant output time grid
incr = 10

# Tolerance for the Modelica solver
tol = 0.0001

# Initial conditions for the optimization
init_conds = [50]

""" Setting for the *.mat files to be used in Dymola """
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
bounds_DVs_global = None
names_BCs_global = names_SPs = ['temperature', 'humidity']
output_vars_global = None
amount_subsystems = amount_consumer+amount_generator

name = []
position = []
no_parallel = [] #number of this this system in the holon of parallel subsystems
holon = []  # Number of identical subsystems in this holon
type_subSyst = []
num_DecVars = []
num_VarsOut = []
sim_time = []
init_DecVars = []
num_BCs = [] # up to 4 because of modelicares.exps.doe.fullfact
bounds_DVs = []
model_path = []
names_DVs = []
start_DVs = []
factor_DVs = []
names_BCs = []
output_vars = []
initial_names= [] #for simulation
IDs_initial_values= [] #for simulation
cost_par = [] #for MassFlowRate
variation = []
IDs_inputs = []
cost_factor = []
model_type = []

""" Subsystems """


# AHU
name.append('AHU')
position.append(3)
type_subSyst.append('generator')
no_parallel.append(0)
holon.append(0)
num_DecVars.append(1)
num_VarsOut.append(2)
bounds_DVs.append([0,100])
start_DVs.append([10])
factor_DVs.append([30])
model_path.append('')
names_DVs.append(['TempSensors.TempAHUReheaterTSetAir'])
output_vars.append(["AHU_Bacnet.HumSUP","AHU_Bacnet.TempSUP"])
initial_names.append(None)
IDs_initial_values.append(None)
IDs_inputs.append(["AHU_Bacnet.HumODA","AHU_Bacnet.TempODA"])
cost_par.append(None)
variation.append(False)
cost_factor.append(0.5)
model_type.append("lin")

# Hall
name.append('Hall-short')
position.append(2)
no_parallel.append(2)
holon.append(2)
type_subSyst.append('consumer')
num_DecVars.append(1)
num_VarsOut.append(2)
bounds_DVs.append([0,0])
start_DVs.append([-10])
factor_DVs.append([0.3])
model_path.append('ModelicaModels.SubsystemModels.DetailedModels.Hall_short')
names_DVs.append(None)
output_vars.append(["supplyAirTemperature.T","supplyAirHumidity.phi"])
initial_names.append(["concreteFloor.T","AirVolumeFlow.k","volume.T_start","currentWaterTemperature.k"])
IDs_initial_values.append(["GVL_Bacnet.CCA_SenT_Ret","AHU_Bacnet.AirflowSUP","AHU_Bacnet.TempETA","GVL_Bacnet.CCA_SenT_Sup"])
IDs_initial_values.append(None)
IDs_inputs.append(None)
cost_par.append(None)
variation.append(True)
cost_factor.append(0.5)
model_type.append("Modelica")

# Steam_humidifier
name.append('Room_1')
position.append(2)
no_parallel.append(0)
holon.append(2)
type_subSyst.append('consumer')
num_DecVars.append(1)
num_VarsOut.append(2)
bounds_DVs.append([0,0])
start_DVs.append([0])
factor_DVs.append([100])
model_path.append('')
#names_DVs.append(['Room2Set'])
names_DVs.append(None)
#output_vars.append(["supplyAirTemperature.T","supplyAirHumidity.phi"])
output_vars.append(None)
initial_names.append(None)
#IDs_initial_values.append(["Room2T","Room2del"])
IDs_initial_values.append(["AHU_Bacnet.HumSUP","AHU_Bacnet.TempSUP"])
IDs_inputs.append(None)
cost_par.append('None')
variation.append(True)
cost_factor.append(0.5)
model_type.append("fuzzy")

# Steam_humidifier
name.append('Room_2')
position.append(2)
no_parallel.append(1)
holon.append(2)
type_subSyst.append('consumer')
num_DecVars.append(1)
num_VarsOut.append(2)
bounds_DVs.append([0,0])
start_DVs.append([0])
factor_DVs.append([100])
model_path.append('')
#names_DVs.append(['Room2Set'])
names_DVs.append(None)
#output_vars.append(["supplyAirTemperature.T","supplyAirHumidity.phi"])
output_vars.append(None)
initial_names.append(None)
#IDs_initial_values.append(["Room2T","Room2del"])
IDs_initial_values.append(["AHU_Bacnet.HumSUP","AHU_Bacnet.TempSUP"])
IDs_inputs.append(None)
cost_par.append(None)
variation.append(True)
cost_factor.append(0.5)
model_type.append("fuzzy")

# Hall
name.append('Hall-long')
position.append(1)
no_parallel.append(0)
holon.append(0)
type_subSyst.append('consumer')
num_DecVars.append(1)
num_VarsOut.append(2)
bounds_DVs.append([0,100])
start_DVs.append([-10])
factor_DVs.append([0.3])
model_path.append('ModelicaModels.SubsystemModels.DetailedModels.Hall_long')
names_DVs.append(['TempSensors.TempCCAT_amb_mean'])
output_vars.append(["supplyAirTemperature.T","supplyAirHumidity.phi"])
initial_names.append(["concreteFloor.T","AirVolumeFlow.k","volume.T_start"])
IDs_initial_values.append(["GVL_Bacnet.CCA_SenT_Ret","AHU_Bacnet.AirflowSUP","AHU_Bacnet.TempETA"])
IDs_initial_values.append(None)
IDs_inputs.append(None)
cost_par.append(None)
variation.append(False)
cost_factor.append(0.5)
model_type.append("Modelica")
