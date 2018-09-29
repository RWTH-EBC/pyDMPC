within ;
package ModelicaModels "Modelica models to be used in the pyDMPC tool"
extends Modelica.Icons.VariantsPackage;

annotation (uses(Modelica(version="3.2.2"),
    AixLib(version="0.5.4"),
    SimulationMPC(version="1"),
    Buildings(version="6.0.0")));
end ModelicaModels;
