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
Start by giving your system a name and the right number of subsystems you intend to control. The difference between the generator and the consumers is decribed later. For now, you can simply consider it the very first subsystem in a supply chain.

```bash
"""System configuration"""
name_system = 'AHU'
amount_consumer = 4
amount_generator = 1
```
### Measurements
You need to select all the names of all the measurements in you controlled system (FMU).

```bash
"""Data point IDs in the controlled system"""
measurements_IDs = ['outdoorTemperatureOutput',...]
```

### Algorithm settings
Select on of the two currently available algorithms. Refer to the [Introduction](Tutorial/Introduction.md) for further information on the algorithms. In both cases, you should specify if you intend to run a real-life experiment/experiment in realtime or a simulation
```bash
""" General algorithm settings """
algorithm = 'BExMoC'   #choices: 'NC_DMPC', 'BExMoC'
parallelization = True  #run calculations in parallel if possible
realtime = True         #Choose True for a real-life experiment
```
Insert the folders, where you stored the libraries.

### Directories
If you are using Dymola for simulating the models, you need to specify the path where you would like the simulation results to be stored. pyDMPC will create the required folder structure in the work directory directory automatically.
```bash
path_res = r'C:\TEMP'
name_wkdir = r'pyDMPC_wkdir'
```
Furthermore, select the paths, in which pyDMPC can find the package.mo files of the Modelica libraries.
```bash
path_lib1 = r'C:\Git\pyDMPC\pyDMPC\ModelicaModels\ModelicaModels'
path_lib2 = r'C:\Git\modelica-buildings\Buildings'
path_lib3 = r'C:\Git\SimContrCaseStudies\SimulationMPC\SimulationMPC'
```
Finally, specify, where in the pyDMPC ModelicaModels package the model of the controlled system to be translated into a FMU is stored and the name you would like the FMU to have.
```bash
path_fmu = r'ModelicaModels.ControlledSystems.ControlledSystemBoundaries'
name_fmu = 'pyDMPCFMU'
path_dymola = r'C:\Program Files\Dymola 2018 FD01\Modelica\Library\python_interface\dymola.egg'
```
### Subsystem definitions
There are several parameters that define a pyDMPC subsystem. For each subsystem, the parameter values are appended to lists.

Start by defining the name, position and type of the subsystem. The type of the subsystem can be generator or consumer as explained above.
```bash
name.append('Heat_recovery_system')
position.append(5)
type_subSyst.append('generator')
```
Next, make the necessary specifications regarding the variables, i.e. the number of decision variables in that subsystem, the number of output variables and the bounds of the decision variables
```bash
num_DecVars.append(1)
num_VarsOut.append(2)
bounds_DVs.append([0,100])
```
All the other parameters are either paths or they map the names of variables in the subsystem models to the data points in the controlled system.  
The model path refers to the Modelica package, in which the respective subsystem model is included.
```bash
model_path.append('ModelicaModels.SubsystemModels.DetailedModels.HeatRecovery')
```


## Set up the Modelica models
The Modelica models are translated and simulated automatically using the Python-Dymola interface. They provide the cost forecast in the respective prediction horizon.

## Run the demo
In order to run the demo, simply execute the test_main.py.

## Inspect the output
