# Detailed description of the control framework

### Various model types
The key goal of pyDMPC is to allow users to select various types of subsystem
models to allow for almost general applicability in the building energy
domain. All the models have unique reuirements. Therefore, the module
"Objective_Funciton" provides interfaces for four different model types and can
also be extended easily.

### Initial values
In MPC, proper initialization of models is very impotant. The Modelica models
can simply be initialized using the Dymola Interface. In the Init file, you
should specify the names of the variables in the model and the name of the
data point in the controlled system. Currently, pyDMPC only supports variables
that can be observed.

### Functional mockup units (FMU)
Currenty, FMUs are used only for simulating the controlled system. In the Init,
the user can choose if an FMU should be generated automatically (which can
sometimes lead to trouble with the Dymola license) or choose to provide an
existing FMU.

### test_main.py
This module is used to test the functionality. It calls the GenerateSubSys()
from the System module to create the subsystems. It creates all the necessary
directories and generates and FMU or loads an existing FMU as controlled system.
It further triggers each of the subsytem agents to take action.

### System.py
System is a class that generates the various subsystems.

### Subsystem.py
