# pyDMPC air handler tutorial

## Case Study
Similar to the previous tutorial, in this case study an air handling unit (AHU) is decomposed into five different modules and controlled in a distributed way. This time, a detailed model of the AHU is used and intgerated into the control framework using the Fnctional Mockup Interface (FMI).

## Modelica libraries
We use two external libraries, namely
- AixLib
- Buildings

## Init
All required inputs are inserted into the Init file. The required selection is

```bash
algorithm = 'BExMoC'   #choices: 'NC_DMPC', 'BExMoC'
```
Inser the folders, where you stored the libraries.

```bash
""" Simulation Settings for Dymola """
# Directory where the simulation results are stored
path_res = r'C:\TEMP\Dymola\LookUps_Backup_01_03'
path_lib1 = r'C:\Git\pyDMPC\pyDMPC\ModelicaModels\ModelicaModels'
path_lib2 = r'C:\Git\modelica-buildings\Buildings'
path_lib3 = r'C:\Git\SimContrCaseStudies\SimulationMPC\SimulationMPC'
```

## Set up the Modelica models
The Modelica models are translated and simulated automatically using the Python-Dymola interface. They provide the cost forecast in the respective prediction horizon.

There is one model representing a pre-heater and a heater. The model is a simple linear function: the higher the value of the manipulated variable (valve opening), the higher the output (the temperature) and the cost. In the cooler model, the temperature is inversely proportional to the valve opening and there is cost required to cool the air. In the heat recovery system, there are no costs, the temperature can be increased without cost.

## Run the demo
In order to run the demo, simply execute the test_main.py.
