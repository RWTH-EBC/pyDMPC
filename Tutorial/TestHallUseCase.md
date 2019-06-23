# Test hall use case

## Overview
This is a demonstration, in which four different model types are used with the
BExMoC algorithm.

The task is to control a building, henceforth called test hall, considering the
different demands and aiming for maximum energy efficiency.

### Offices: Fuzzy controller
In the offices, we assume almost no system knowledge. The only sensor data we
have is the room air temperature measurement and the position of the
thermostat. The offices are equipped with active chilled beams that ventilate
the offices. Moreover, they can reheat or recool an air stram that is supplied
by a central air handling unit. In order to control the offices despite the
very limited system knowledge, we make use of a fuzzy controller and a local
PI controller. The fuzzy controller is paramterized with linguistic terms that
are translated into so-called crisp numerical values. The controller outputs a
temperature set point for the supply air flow from the central AHU. The cost
function penalizes deviations from this set point. The interpretation for this
penalty is that there will either be energy costs due to the necessary
rehaeting or recooling or the comfort will be affected.

### Central air handling unit (AHU)
The central AHU is modeled as a simple linear function.

### Hall
The hall subsystem is divided in to a subsystem with large inertia and a
subsystem with very low intertia. The "hall-long" subsystem uses a Modelica
model, which, in turn, is a simple set up of an air volume, air exchange,
heat exchange with walls, solar gains and heat exchange with the concrete
floor heating. The weather data is collected from the openweathermap API
and stored in a .mat file readable by Modelica models.
The "hall-short" model is a simple linear equation that controls the air
temperature perfectly, so that the air flow into the hall is always equal to
the temperature that was assumed for the long simulation.  
