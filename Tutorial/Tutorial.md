# pyDMPC Tutorial

## Case Study
In this simple case study an air handling unit is decomposed into five different modules and controlled in a distributed way.

## Init
All required inputs are inserted into the Init file. The only required selection is

```bash
algorithm = 'BExMoC'   #choices: 'NC_DMPC', 'BExMoC'
```

## Set up the Modelica models
The Modelica models are translated and simulated automatically using the Python-Dymola interface. They provide the cost forecast in the respective prediction horizon.

There is one model representing a pre-heater and a heater. The model is a simple linear function: the higher the value of the manipulated variable (valve opening), the higher the output (the temperature) and the cost. In the cooler model, the temperature is inversely proportional to the valve opening and there is cost required to cool the air. In the heat recovery system, there are no costs, the temperature can be increased without cost.

## Run the demo
In order to run the demo, simply execute the test_main.py.
