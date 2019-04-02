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

### Objective_Funciton.py
This module is a central interface for implementing new cost functions and,
consequently, model calculations. Let's take a look at the currently
simplest objective function - the linear model:

``` Python
### Linear model ###
elif s._model_type == "lin":
    traj = values_DVs/100*40 + 273.15
    Tset = 303

    if s._output_vars is not None:
        output_traj = [traj, (0.3+random.uniform(0.0,0.01))]
        output_list = output_traj
```

First, we check the model type that was set in the Init. We then calculate a
temperature rajectory based on the current value of the decision varaible.
The second value is a relative humidity but, currently, only a dummy value.
We also require a set temperature Tset that is later used to calculate the
cost.
