within ModelicaModels.Subsystems.BaseClasses;
model HeatExchangerPorts
  "Base class for the heat exchanger subsystems"

  replaceable package MediumAir = AixLib.Media.Air;
  replaceable package MediumWater = AixLib.Media.Water;


  Modelica.Fluid.Interfaces.FluidPort_a portSupplyAirIn(redeclare package
      Medium =
        MediumAir) "Inlet port of supply air"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-114,-16},{-84,16}})));
  Modelica.Fluid.Interfaces.FluidPort_b portSupplyAirOut(redeclare package
      Medium =                                                                      MediumAir)
                                                                                               "Outlet port of supply air"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}),
        iconTransformation(extent={{114,-16},{82,16}})));
  Modelica.Blocks.Interfaces.RealInput valveOpening
    "Opening of the HRC valve (0..100 %)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,-90})));
  Modelica.Blocks.Interfaces.RealOutput waterInflowTemperature
    "Temperature of supply water"
    annotation (Placement(transformation(extent={{90,-100},{110,-80}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatExchangerPorts;
