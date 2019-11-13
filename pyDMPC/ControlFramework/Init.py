# Global paths
glob_lib_paths = [r'C:\Git\pyDMPC\pyDMPC\ModelicaModels\ModelicaModels',
             r'C:\Git\modelica-buildings\Buildings',
             r'C:\Git\AixLib-master\AixLib']
glob_res_path = r'C:\TEMP\dymola'
glob_dym_path = r'C:\Program Files\Dymola 2020\Modelica\Library\python_interface\dymola.egg'

# Working directory
import time
timestr = time.strftime("%Y%m%d_%H%M%S")
name_wkdir = r'pyDMPC_' + 'wkdir' + timestr

# Controlled system
contr_sys_typ = "Modelica"
ads_id = '5.59.199.202.1.1'
ads_port = 851
name_fmu = 'pyDMPCFMU_AHU.fmu'
orig_fmu_path = glob_res_path + '\\' + name_fmu
dest_fmu_path = glob_res_path + '\\' + name_wkdir + '\\' + name_fmu
time_incr = 120

# Number of subsystems
n = 2

# States
inputs = [None for _ in range(n)]
input_names = [None for _ in range(n)]
traj_points = [None for _ in range(n)]
input_variables = [None for _ in range(n)]
commands = [None for _ in range(n)]
command_variables = [None for _ in range(n)]
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
cost_fac = [None for _ in range(n)]
factors = [None for _ in range(n)]

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
name[0] = "Heater"
model_type[0] = "Scikit"
ups_neigh[0] = 1
input_names[0] = ["coolerTemperature.T"]
input_variables[0] = [r"variation.table[1,2]"]
inputs[0] = [i for i in range(280,325,1)]
output_names[0] = ["supplyAirTemperature.T"]
set_points[0] = [303]
state_var_names[0] = ["heaterInitials[1].y"]
model_state_var_names[0] = ["mas1.k"]
start[0] = 0.
stop[0] = 3600
incr[0] = 10.
opt_time[0] = 600
samp_time[0] = time_incr
lib_paths[0] = glob_lib_paths
res_path[0] = glob_res_path + "\\" + name_wkdir
dym_path[0] = glob_dym_path
mod_path[0] = f'{glob_res_path}\\heater'
command_names[0] = ["valveHeater"]
command_variables[0] = ["decisionVariables.table[1,2]"]
commands[0] = [[i,i]  for i in range(0,100,5)]
traj_points[0] = []
traj_var[0] = []
cost_fac[0] = [0.1, 0.0, 1.0]

sys_id[1] = 1
name[1] = "Cooler"
model_type[1] = "Scikit"
downs_neigh[1] = [0]
input_names[1] = ["preHeaterTemperature.T"]
input_variables[1] = [r"variation.table[1,2]"]
inputs[1] = [i for i in range(280,325,1)]
output_names[1] = ["supplyAirTemperature.T"]
set_points[1] = [303]
state_var_names[1] = ["coolerInitials[1].y"]
model_state_var_names[1] = ["hex.ele[1].mas.T"]
start[1] = 0.
stop[1] = 3600.
incr[1] = 10.
opt_time[1] = 600
samp_time[1] = time_incr
lib_paths[1] = glob_lib_paths
res_path[1] = glob_res_path + "\\" + name_wkdir
dym_path[1] = glob_dym_path
mod_path[1] = f'{glob_res_path}\\cooler'
command_names[1] = ["valveCooler"]
command_variables[1] = ["decisionVariables.table[1,2]"]
commands[1] = [[i,i]  for i in range(0,100,5)]
traj_points[1] = []
traj_var[1] = []
cost_fac[1] = [0.0, 1.0, 0]
