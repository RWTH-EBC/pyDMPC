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
name_fmu = 'pyDMPCFMU.fmu'
orig_fmu_path = glob_res_path + '\\' + name_fmu
dest_fmu_path = glob_res_path + '\\' + name_wkdir + '\\' + name_fmu
time_incr = 120

# States
inputs = []
input_names = []
output_names = []
set_points = []
set_point_names = []
state_var_names = []

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
sys_id = []
ups_neigh = []
downs_neigh = []

# Subsystems
sys_id.append(0)
model_type.append("Modelica")
ups_neigh.append(1)
downs_neigh.append(None)
input_names.append(["preHeaterReturnTemperatureOutput"])
output_names.append(["heatCapacitor.port.T"])
set_points.append(None)
set_point_names.append(None)
state_var_names.append(None)
start.append(0.)
stop.append(7200.)
incr.append(10.)
opt_time.append(600)
samp_time.append(10)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path)
dym_path.append(glob_dym_path)
mod_path.append(r'ModelicaModels.SubsystemModels.DetailedModels.test_model')
command_names.append(None)
factors.append(None)
min_var.append(10)
max_var.append(12)
inc_var.append(1)
cost_fac.append([0.5, 0.5, 0.5])

sys_id.append(1)
model_type.append("Modelica")
ups_neigh.append(None)
downs_neigh.append(0)
input_names.append((["preHeaterReturnTemperatureOutput"]))
output_names.append(["heatCapacitor.port.T"])
set_points.append(None)
set_point_names.append(None)
state_var_names.append(None)
start.append(0.)
stop.append(7200.)
incr.append(10.)
opt_time.append(600)
samp_time.append(10)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path)
dym_path.append(glob_dym_path)
mod_path.append(r'ModelicaModels.SubsystemModels.DetailedModels.test_model')
command_names.append(None)
factors.append(None)
min_var.append(10)
max_var.append(12)
inc_var.append(1)
cost_fac.append([0.5, 0.5, 0.5])