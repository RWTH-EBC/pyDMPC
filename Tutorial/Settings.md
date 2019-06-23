# pyDMPC settings
All required inputs are inserted into the Init file. The required selection
is described in detail in the following. In order to just run the demo without
any changes, you can skip this part.

### Global paths
There are 3 global library paths, namely
- pyDMPC Modelica Models
- Modelica Buildings
- AixLib.

Moreover, specify the result path, where the working directories will be created
automatically.

Finally, there is the Dymola path, where the .egg file is stored.

```Python
glob_lib_paths = [r'C:\Git\pyDMPC\pyDMPC\ModelicaModels\ModelicaModels',
             r'C:\Git\modelica-buildings\Buildings',
             r'C:\Git\AixLib\AixLib']
glob_res_path = r'C:\TEMP\Dymola'
glob_dym_path = r'C:\Program Files\Dymola 2018 FD01\Modelica\Library\python_interface\dymola.egg'
```

### Working directory
The working directory is automatically created out of the current time stamp.
```Python
import time
timestr = time.strftime("%Y%m%d_%H%M%S")
name_wkdir = r'pyDMPC_' + 'wkdir' + timestr
```

### Identifiers
The unique identifier is an integer. Additionally, a subsystem name can be given
as a string.
```Python
sys_id.append(0)
name.append("Field")
```

### Controlled system
The controlled system type can either be "Modelica" or "PLC". There is only
one controlled system for each main system. In case of the
PLC controlled system, an ADS address and a port have to be specified.
In case of a Modelica model, which is provided as an FMU model, the name of
the FMU file has to be provided. The file should be stored in the global result
path. The time increment is the minimal time step that is used for
communication with the FMU.

```Python
contr_sys_typ = "Modelica"
ads_id = '5.59.199.202.1.1'
ads_port = 851
name_fmu = 'pyDMPCFMU_Geo.fmu'
orig_fmu_path = glob_res_path + '\\' + name_fmu
dest_fmu_path = glob_res_path + '\\' + name_wkdir + '\\' + name_fmu
time_incr = 120
```

### Neighbors
Each subsystem can have upstream and downstram neighbors. To assign a subsystem
to its neighbors, provide the IDs of the neighboring subsystems or None.

```Python
ups_neigh.append(None)
downs_neigh.append(0)
```

### Inputs
The input names are given as a list of strings. These are the names of the
variables in the FMU model or the data point names on the PLC. By contrast,
the inputs_variables are the names in the subsystem model. Be sure to use the
same order in both lists so that the mapping is correct. Finally, a list of
inputs can be provided using the range function. The algorithms will use these
values to vary the inputs to the models and create lookup tables. Alternatively,
use a list with only the entry "external" to use an external input. In that
case, the algorithms do not vary the inputs but, instead, inputs should be
provided in the model. This can be useful, if the model has a much longer
prediction horizon than the other models and relies on some kind of long-term
prediction, e.g. weather or load prediciton.

```Python
input_names.append(["supplyTemperature.T"])
input_variables.append([r"variation.table[1,2]"])
inputs.append(range(280,310,10))
```
### Commands
The commands are speicified just like the inputs, with the names referring to
the controlled system and teh variables to the subsystem models. Again, the
values to be used can be given using the range function. All these commands are
evaluated in a brute-force manner. In future versions, there will be more
sophisticated optimization algorithms.

```Python
command_names.append(["heatShare"])
command_variables.append(["decisionVariables.table[1,2]"])
commands.append(range(0,105,5))
```

### Outputs
The names of the outputs are a list of strings and represent the variable
names as used in the subsystem models.

```Python
output_names.append(["returnTemperature.T"])
```

### Set points
The set points are given as a list of floats. The list should have the same
order as the outputs list as the algorithms compare the set points to the
corresponding output.

```Python
set_points.append([287])
```

### State variables
The state variables are used to initialized the subsystem models. There are
currently no state estimators. Therefore, use the state_var_names to provide
the names of the variables in the controlled system and model_state_var_names
as their counterpart in the subsystem model.

```Python
state_var_names.append(["supplyTemperature.T"])
model_state_var_names.append(["vol.T_start"])
```

### Prediction times
Specify when a prediction should start (usually a relative time 0) and when it
should stop. Also indicate the increment, which will be the sampling time of the
result time series. The opt_time is the interval (referring to the global system
time), in which the subsystem is optimized. The samp_time is the interval, in
which a subsystem communicates with the controlled system.

```Python
start.append(0.)
stop.append(3600.0*24*365.25*3)
incr.append(3600.)
opt_time.append(600)
samp_time.append(10)
```

### Subsystem paths
Most of the paths can remain unchanged as they are formed based on the global
paths. The path that should be specified, yet only in case of a Modelica
subsystem model, is the path to the model in the Modelica-specific package
structure.

```Python
mod_path.append(r'ModelicaModels.SubsystemModels.DetailedModels.Geo.Field')
```

### Trajectories
Some subsystems require their neigbors to follow certain trajectories. To get
an upstream subsystem to provide the trajectory, the subsystem assigns costs to
deviations from the trajectory that is calculated in the model. The name of the
variable is provided in the traj_var. The trajectory points are used to
approximate the costs that are cause if the upstream system does not follow the
trajectory.
```Python
traj_points.append(range(278,310,1))
traj_var.append(["supplyTemperature.T"])
```

### Cost factors
The cost factors are essential to select which types of costs should be
considered and how they should be weighted. The first element in the list is
the cost related to the control effort. The second is the cost that is received
from the dowmstream neighbor and the third is the cost due to deviations form
the set point.

```Python
cost_fac.append([0.0, 0.0, 1.0])
```
