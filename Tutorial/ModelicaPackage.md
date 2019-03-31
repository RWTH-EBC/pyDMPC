# Modelica package descritpion

## Overview
The Modelica package currently contains models for the AHU and the test hall
use case. The most important thing to keep in mind is that there are subsystems
and subsystem models. The difference is that the subsystem models are the ones
that are actually used by the DMPC algorithms. The subsystems, however, are
used in Software-in-the-loop experiments to construct the controlled system.
Both Modelica classes extend a common base class. This ensures that, in SiL
experiments, we have exactly the same parameters in the components that appear
both in the subsystem and in its model, thus ensuring a perfect model. 
