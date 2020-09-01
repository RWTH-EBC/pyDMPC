import time
import numpy as np
import scipy.io as sio

# Global paths
glob_lib_paths = [r'C:\Git\GitHub\pyDMPC\pyDMPC\ModelicaModels\ModelicaModels',
    r'C:\Git\modelica-buildings\Buildings',
    r'C:\Git\AixLib\AixLib']
glob_res_path = r'C:\TEMP\Dymola'
glob_dym_path = r'C:\Program Files\Dymola 2020\Modelica\Library\python_interface\dymola.egg'

# Working directory
timestr = time.strftime("%Y%m%d_%H%M%S")
name_wkdir = r'pyDMPC_' + 'wkdir' + timestr

# Controlled system
contr_sys_typ = "Modelica"
name_fmu = 'ModelicaModels_ControlledSystems_TestHall.fmu'
orig_fmu_path = glob_res_path + '\\' + name_fmu
dest_fmu_path = glob_res_path + '\\' + name_wkdir + '\\' + name_fmu
time_incr = 100
end_time = 10 ** 7 
ads_id = None
ads_port = None

# Number of subsystems
n = 5

# States
inputs = [None for _ in range(n)]
input_names = [None for _ in range(n)]
traj_points = [None for _ in range(n)]
input_variables = [None for _ in range(n)]
commands = [None for _ in range(n)]
command_variables = [None for _ in range(n)]
output_names = [None for _ in range(n)]
model_output_names = [None for _ in range(n)]
output_names = [None for _ in range(n)]
set_points = [None for _ in range(n)]
state_var_names = [None for _ in range(n)]
model_state_var_names = [None for _ in range(n)]
traj_var = [None for _ in range(n)]

# Times
start = [None for _ in range(n)]
stop = [None for _ in range(n)]
incr = [None for _ in range(n)]
opt_time = [None for _ in range(n)]
samp_time = [None for _ in range(n)]

# Paths
lib_paths = [None for _ in range(n)]
res_path = [None for _ in range(n)]
dym_path = [None for _ in range(n)]
mod_path = [None for _ in range(n)]
command_names = [None for _ in range(n)]

# Modifiers
cost_fac = [[1] for _ in range(n)]
state_factors = [[1] for _ in range(n)]
state_offsets = [[0] for _ in range(n)]
input_factors = [[1] for _ in range(n)]
input_offsets = [[0] for _ in range(n)]
output_factors = [[1] for _ in range(n)]
output_offsets = [[0] for _ in range(n)]
linear_model_factors = [[1] for _ in range(n)]
linear_model_offsets = [[0] for _ in range(n)]

# Variation
min_var = [None for _ in range(n)]
max_var = [None for _ in range(n)]
inc_var = [None for _ in range(n)]

# Subsystem Config
model_type = [None for _ in range(n)]
name = [None for _ in range(n)]
sys_id = [None for _ in range(n)]
ups_neigh = [None for _ in range(n)]
downs_neigh = [None for _ in range(n)]
par_neigh = [None for _ in range(n)]

# Subsystems
sys_id[0] = 0
name[0] = "Hall-long"
model_type[0] = "Modelica"
ups_neigh[0] = 1
input_names[0] = ["T_AHU_act"]
input_variables[0] = [r"variation.table[1, 2]"]
inputs[0] = [1]
output_names[0] = ["T_hall"]
mod_path[0] = "ModelicaModels.SubsystemModels.TestHall.HallLong"
set_points[0] = [22] 
state_var_names[0] = ["hall.AirVolumeFlow.k", "T_hall", "hall.hallBaseClass.floor.thermCapExt[1].port.T", "simTime"]
state_offsets[0] = [0, 273, 0, 0]
state_factors[0] = [1, 1, 1, -1]
model_state_var_names[0] = ["AirVolumeFlow.k", "hallBaseClass.workingFluid.T0", "hallBaseClass.floor.T_start", "weather.startTime"]
start[0] = 0.
stop[0] = 2*24*3600
incr[0] = 100.
opt_time[0] = 5*3600
samp_time[0] = time_incr
lib_paths[0] = glob_lib_paths
res_path[0] = glob_res_path + "\\" + name_wkdir
dym_path[0] = glob_dym_path
command_names[0] = ["T_CCA1"]
command_variables[0] = [r"decisionVariables.table[1, 2]"]
commands[0] = [[i] for i in range(-15, 12, 2)]
traj_points[0] = []
traj_var[0] = []
cost_fac[0] = [0.0, 0.0, 1.0]
model_output_names[0] = ["hallTemperature"]

sys_id[1] = 1
name[1] = "Office"
model_type[1] = "Fuzzy"
input_names[1] = ["T_AHU_act"]
input_variables[1] = [r"variation.table[1, 2]"]
inputs[1] = [i for i in range(10, 30, 1)]
output_names[1] = ["T_room1"]
set_points[1] = [295]
state_var_names[1] = ["T_room1", "thermostat1"]
model_state_var_names[1] = ["volume.T_start"]
state_offsets[1] = [0, 0]
state_factors[1] = [1, 1]
start[1] = 0.
stop[1] = 2*3600
incr[1] = 100.
opt_time[1] = 1/4*3600
samp_time[1] = time_incr
res_path[1] = glob_res_path + "\\" + name_wkdir
commands[1] = [[0]]
command_names[1] = [r"Tset"]
cost_fac[1] = [0.0, 0.0, 1.0]
traj_var[1] = []
model_output_names[1] = ["supplyAirTemperature.T"]

sys_id[2] = 2
name[2] = "Office2"
model_type[2] = "Fuzzy"
input_names[2] = ["T_AHU_act"]
input_variables[2] = [r"variation.table[1, 2]"]
inputs[2] = [i for i in range(10, 30, 1)]
output_names[2] = ["T_room2"]
set_points[2] = [295]
state_var_names[2] = ["T_room2", "thermostat2"]
model_state_var_names[2] = ["volume.T_start"]
state_offsets[2] = [0, 0]
state_factors[2] = [1, 1]
start[2] = 0.
stop[2] = 2*3600
incr[2] = 100.
opt_time[2] = 1/4*3600
samp_time[2] = time_incr
res_path[2] = glob_res_path + "\\" + name_wkdir
commands[2] = [[0]]
command_names[2] = [r"Tset2"]
cost_fac[2] = [0.0, 0.0, 1.0]
traj_var[2] = []
model_output_names[2] = ["supplyAirTemperature.T"]

sys_id[3] = 3
name[3] = "Hall-short"
model_type[3] = "Modelica"
ups_neigh[3] = 4
par_neigh[3] = [1, 2]
input_names[3] = ["T_AHU_act"]
input_variables[3] = [r"variation.table[1, 2]"]
inputs[3] = [i for i in range(10, 33, 3)]
output_names[3] = ["T_hall"]
mod_path[3] = "ModelicaModels.SubsystemModels.TestHall.HallShort"
set_points[3] = [23]  
state_var_names[3] = ["hall.AirVolumeFlow.k", "T_hall", "hall.hallBaseClass.floor.thermCapExt[1].port.T", "T_CCA_act", "simTime"]
state_offsets[3] = [0, 273, 0, 0, 0]
state_factors[3] = [1, 1, 1, 1, -1]
model_state_var_names[3] = ["AirVolumeFlow.k", "hallBaseClass.workingFluid.T0", "hallBaseClass.floor.T_start", "currentWaterTemperature.k", "weather.startTime"]
start[3] = 0.
stop[3] = 2*3600
incr[3] = 100.
opt_time[3] = 2*3600
samp_time[3] = time_incr
lib_paths[3] = glob_lib_paths
res_path[3] = glob_res_path + "\\" + name_wkdir
dym_path[3] = glob_dym_path
command_variables[3] = [r"decisionVariables.table[1, 2]"]
commands[3] = [[0]]
traj_points[3] = []
traj_var[3] = []
cost_fac[3] = [0.0, 0.0, 1.0]
traj_var[3] = []
model_output_names[3] = ["hallTemperature"]

sys_id[4] = 4
name[4] = "AHU"
model_type[4] = "Linear"
set_points[4] = [298]
state_offsets[4] = [273]
state_factors[4] = [1]
linear_model_offsets[4] = [0.]
input_names[4] = ["weather.y[1]"]
input_variables[4] = [r"variation.table[1, 2]"]
inputs[4] = [i for i in range(-253, 323, 10)]
opt_time[4] = 1/4*3600
samp_time[4] = time_incr
res_path[4] = glob_res_path + "\\" + name_wkdir
command_names[4] = ["T_in1"]
commands[4] = [[i] for i in range(15, 32, 1)]
cost_fac[4] = [0.0, 1., 0., 0., 0.0]
linear_model_factors[4] = [0, 1]
traj_var[4] = []
model_output_names[4] = []