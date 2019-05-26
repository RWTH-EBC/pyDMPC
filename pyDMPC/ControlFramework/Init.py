# Global paths
glob_lib_paths = [r'C:\Git\pyDMPC\pyDMPC\ModelicaModels\ModelicaModels',
             r'C:\Git\modelica-buildings\Buildings',
             r'C:\Git\AixLib\AixLib']
glob_res_path = r'C:\TEMP\Dymola'
glob_dym_path = r'C:\Program Files\Dymola 2018 FD01\Modelica\Library\python_interface\dymola.egg'

# Working directory
import time
timestr = time.strftime("%Y%m%d_%H%M%S")
wkdir = r'pyDMPC_' + 'wkdir' + timestr

# Controlled system
contr_sys_typ = "Modelica"
ads_id = '5.59.199.202.1.1'
ads_port = 851
name_fmu = 'ModelicaModels_ControlledSystems_TestHall.fmu'
orig_fmu_path = glob_res_path + '\\' + name_fmu
dest_fmu_path = glob_res_path + '\\' + wkdir + '\\' + name_fmu

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

model_type = []
sys_id = []

# Subsystems
sys_id.append(0)
model_type.append("Modelica")
inputs.append(None)
input_names.append(None)
output_names.append(["heatCapacitor.port.T"])
set_points.append(None)
set_point_names.append(None)
#state_var_names.append([r"heatCapacitor.T.start"])
state_var_names.append(None)
start.append(0.)
stop.append(7200.)
incr.append(10.)
opt_time.append(600)
samp_time.append(60)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path)
dym_path.append(glob_dym_path)
mod_path.append(r'ModelicaModels.SubsystemModels.DetailedModels.test_model')
command_names.append(None)
factors.append(None)

sys_id.append(1)
model_type.append("Scikit")
inputs.append(None)
input_names.append(None)
output_names.append(None)
set_points.append(None)
set_point_names.append(None)
state_var_names.append(None)
start.append(0.)
stop.append(7200.)
incr.append(10.)
opt_time.append(600)
samp_time.append(60)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path)
dym_path.append(glob_dym_path)
mod_path.append(r'C:\TEMP\Dymola\heater')
command_names.append(None)
factors.append(None)

sys_id.append(2)
model_type.append("Linear")
inputs.append(None)
input_names.append(None)
output_names.append(None)
set_points.append(None)
set_point_names.append(None)
state_var_names.append(None)
start.append(0.)
stop.append(7200.)
incr.append(10.)
opt_time.append(600)
samp_time.append(60)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path)
dym_path.append(glob_dym_path)
mod_path.append(None)
command_names.append(None)
factors.append([1,0.1])

sys_id.append(3)
model_type.append("Fuzzy")
inputs.append(None)
input_names.append(None)
output_names.append(None)
set_points.append(None)
set_point_names.append(None)
state_var_names.append(None)
start.append(0.)
stop.append(7200.)
incr.append(10.)
opt_time.append(600)
samp_time.append(60)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path)
dym_path.append(glob_dym_path)
mod_path.append(None)
command_names.append(None)
factors.append([1,0.1])