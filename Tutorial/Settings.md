# pyDMPC air handler tutorial

## Case Study
Similar to the previous tutorial, in this case study an air handling unit (AHU) is decomposed into five different modules and controlled in a distributed way. This time, a detailed model of the AHU is used and intgerated into the control framework using the Fnctional Mockup Interface (FMI).

## Modelica libraries
We use two external libraries, namely
- AixLib (https://github.com/RWTH-EBC/AixLib.git)
- Buildings (https://github.com/lbl-srg/modelica-buildings.git)

## Init
All required inputs are inserted into the Init file. The required selection is described in detail in the following. IN order to just run the demo without any changes, you can skip this part.

### Basic system layout
Start by giving your system a name and the right number of subsystems you intend to control. There are three different types of subsystems, namely generator, consumers and distributor. This distinction refers to a typical suppy chain. The generator uses some kind of external input such as gas, electricity or simply outdoor air in case of an air handling unit. The consumer can be a room subsystem but also the last the subsystem in an air handling unti. The important function of the consumer subsystem is that it penalized deviations from the set points. The distributors are subsystems that can be parts of the distributions system of a supply chain or simply the subsystems of an air handling unit that are neither consumers nor generator.

```Python
"""System configuration"""
name_system = 'AHU'
amount_consumer = 4
amount_generator = 1
```
### Measurements
You need to select all the names of all the measurements in you controlled system (FMU).

```Python
"""Data point IDs in the controlled system"""
measurements_IDs = ['outdoorTemperatureOutput',...]
```

### Algorithm settings
Select on of the two currently available algorithms. Refer to the [Introduction](Tutorial/Introduction.md) for further information on the algorithms. In both cases, you should specify if you intend to run a real-life experiment/experiment in realtime or a simulation
```Python
""" General algorithm settings """
algorithm = 'BExMoC'   #choices: 'NC_DMPC', 'BExMoC'
parallelization = True  #run calculations in parallel if possible
realtime = True         #Choose True for a real-life experiment
```
Insert the folders, where you stored the libraries.

### Directories
If you are using Dymola for simulating the models, you need to specify the path where you would like the simulation results to be stored. pyDMPC will create the required folder structure in the work directory directory automatically.
```Python
path_res = r'C:\TEMP'
name_wkdir = r'pyDMPC_wkdir'
```
Furthermore, select the paths, in which pyDMPC can find the package.mo files of the Modelica libraries.
```Python
path_lib1 = r'C:\Git\pyDMPC\pyDMPC\ModelicaModels\ModelicaModels'
path_lib2 = r'C:\Git\modelica-buildings\Buildings'
path_lib3 = r'C:\Git\SimContrCaseStudies\SimulationMPC\SimulationMPC'
```
Finally, specify, where in the pyDMPC ModelicaModels package the model of the controlled system to be translated into a FMU is stored and the name you would like the FMU to have.
```Python
path_fmu = r'ModelicaModels.ControlledSystems.ControlledSystemBoundaries'
name_fmu = 'pyDMPCFMU'
path_dymola = r'C:\Program Files\Dymola 2018 FD01\Modelica\Library\python_interface\dymola.egg'
```
### Subsystem definitions
There are several parameters that define a pyDMPC subsystem. For each subsystem, the parameter values are appended to lists.

Start by defining the name, position and type of the subsystem. The type of the subsystem can be generator, distributor or consumer as explained above.
```Python
name.append('Heat_recovery_system')
position.append(5)
type_subSyst.append('generator')
```
The next two paramters are relevant if the subsystem is part of a holon. A holon is a group of subsystems that are connected in parallel and that are assumed not to influence each other. the
```Python
no_parallel.append(0)
```
indicates the number of this subsystem in the holon. We simply number all the subsystems in a holon. This is important to tell the algorithm how many subsystems have to store their cost in one folder, namely the folder of the first subsystem before the holon. The
```Python
holon.append(0)
```
indicates how many parallel systems there are (beside the considered subsystem) in the holon.


Next, make the necessary specifications regarding the variables, i.e. the number of decision variables in that subsystem, the number of output variables and the bounds of the decision variables
```Python
num_DecVars.append(1)
num_VarsOut.append(2)
bounds_DVs.append([0,100])
```
The
```Python
start_DVs.append(280)
factor_DVs.append(30)
```
are used to convert the descision variable in a linear function ax+b.

All the other parameters are either paths or they map the names of variables in the subsystem models to the data points in the controlled system.  
The model path refers to the Modelica package, in which the respective subsystem model is included.
```Python
model_path.append('ModelicaModels.SubsystemModels.DetailedModels.HeatRecovery')
```


## Set up the Modelica models
The Modelica models are translated and simulated automatically using the Python-Dymola interface. They provide the cost forecast in the respective prediction horizon.

## Run
In order to excute a control experiment, simply execute the test_main.py.
