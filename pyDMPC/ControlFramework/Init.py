# Global paths
glob_lib_paths = [r'C:\Git\pyDMPC\pyDMPC\ModelicaModels\ModelicaModels',
             r'C:\Git\modelica-buildings\Buildings',
             r'C:\Git\AixLib\AixLib']
glob_res_path = r'C:\TEMP\Dymola'
glob_dym_path = r'C:\Program Files\Dymola 2018 FD01\Modelica\Library\python_interface\dymola.egg'

# Working directory
import time
timestr = time.strftime("%Y%m%d_%H%M%S")
name_wkdir = r'pyDMPC_' + 'wkdir' + timestr

# Algorithm
alg_typ = "BExMoC"

# Controlled system
contr_sys_typ = "Modelica"
ads_id = '5.59.199.202.1.1'
ads_port = 851
name_fmu = 'pyDMPCFMU_Geo.fmu'
orig_fmu_path = glob_res_path + '\\' + name_fmu
dest_fmu_path = glob_res_path + '\\' + name_wkdir + '\\' + name_fmu
time_incr = 120

# States
inputs = []
input_names = []
input_variables = []
commands = []
command_variables = []
output_names = []
set_points = []
set_point_names = []
state_var_names = []
model_state_var_names = []

# Times
start = []
stop = []
incr = []
opt_time = []
samp_time = []

# Paths
lib_paths = []
res_path = []
dym_path = []
mod_path = []
command_names = []

# Modifiers
factors = []
cost_fac = []

# Variation
min_var = []
max_var = []
inc_var = []

# Subsystem Config
model_type = []
name = []
sys_id = []
ups_neigh = []
downs_neigh = []

# Subsystems
sys_id.append(0)
name.append("Field")
model_type.append("Modelica")
ups_neigh.append(1)
downs_neigh.append(None)
input_names.append((["returnTemperature.T"]))
output_names.append(["returnTemperature.T"])
set_points.append([287])
set_point_names.append(None)
state_var_names.append([])
model_state_var_names.append([])
start.append(0.)
stop.append(3600.0*24*365.25*3)
incr.append(3600.)
opt_time.append(600)
samp_time.append(10)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path + "\\" + name_wkdir)
dym_path.append(glob_dym_path)
mod_path.append(r'ModelicaModels.SubsystemModels.DetailedModels.Geo.Field')
command_names.append(["heatShare"])
command_variables.append(["decisionVariables.table[1,2]"])
factors.append(None)
commands.append(range(0,105,5))
input_variables.append(["external"])
inputs.append([])
cost_fac.append([0.0, 0.0, 1.0])

sys_id.append(1)
name.append("Building")
model_type.append("Modelica")
ups_neigh.append(None)
downs_neigh.append(0)
input_names.append(["supplyTemperature.T"])
output_names.append(["returnTemperature"])
set_points.append([289])
set_point_names.append(None)
state_var_names.append(["sine.y"])
model_state_var_names.append(["const.k"])
start.append(0.)
stop.append(7200.)
incr.append(10.)
opt_time.append(600)
samp_time.append(10)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path + "\\" + name_wkdir)
dym_path.append(glob_dym_path)
mod_path.append(r'ModelicaModels.SubsystemModels.DetailedModels.Geo.Building')
command_names.append([])
command_variables.append(["decisionVariables.table[1,2]"])
commands.append(range(0,105,5))
factors.append(None)
input_variables.append([r"variation.table[1,2]"])   # ["variation.table[1,2]"]
inputs.append(range(280,310,10))
cost_fac.append([-0.01, 1.0, 1.0])

