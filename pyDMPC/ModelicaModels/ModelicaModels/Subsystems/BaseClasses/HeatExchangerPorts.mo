within ModelicaModels.Subsystems.BaseClasses;
model HeatExchangerPorts
  "Base class for the heat exchanger subsystems"

  replaceable package MediumAir = AixLib.Media.Air;
  replaceable package MediumWater = AixLib.Media.Water;


  Modelica.Fluid.Interfaces.FluidPort_a portSupplyAirIn(redeclare package
      Medium =
        MediumAir)                                                                          "Inlet port of supply air"
    annotation (Placement(transformation(extent={{-250,-10},{-230,10}}),
        iconTransformation(extent={{-288,-30},{-236,22}})));
  Modelica.Fluid.Interfaces.FluidPort_b portSupplyAirOut(redeclare package
      Medium =                                                                      MediumAir)
                                                                                               "Outlet port of supply air"
    annotation (Placement(transformation(extent={{210,-10},{190,10}}),
        iconTransformation(extent={{272,-36},{208,28}})));
  Modelica.Blocks.Interfaces.RealInput valveOpening
    "Opening of the HRC valve (0..100 %)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-54,-220})));
  Modelica.Blocks.Interfaces.RealInput T_in "Prescribed boundary temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={56,-220})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatExchangerPorts;
