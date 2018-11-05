within ModelicaModels.Subsystems;
model Humidifier "Subsystem of the humdifier"
  extends ModelicaModels.Subsystems.BaseClasses.HumidifierBaseClass(
      vol(nPorts=3), SteamSource(nPorts=1));
  Modelica.Fluid.Interfaces.FluidPort_a portSupplyAirIn(redeclare package
      Medium =         MediumAir) "Inlet port of supply air"
    annotation (Placement(transformation(extent={{-110,12},{-90,32}}),
        iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b portSupplyAirOut(redeclare package
      Medium =         MediumAir) "Outlet port of supply air"
    annotation (Placement(transformation(extent={{110,10},{90,30}}),
        iconTransformation(extent={{132,48},{110,70}})));
  Modelica.Blocks.Interfaces.RealInput humidifierWSP
    "Working set point of the humidifiert (0..100%)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={122,-24})));
equation
  connect(vol.ports[1], portSupplyAirIn) annotation (Line(points={{-50,22},{
          -100,22}},      color={0,127,255}));
  connect(vol.ports[2], SteamSource.ports[1]) annotation (Line(points={{-50,22},
          {-50,-34},{-8,-34}},   color={0,127,255}));
  connect(vol.ports[3], portSupplyAirOut) annotation (Line(points={{-50,22},{26,
          22},{26,20},{100,20}}, color={0,127,255}));
  connect(HumidifierCharacteristics.u[1], humidifierWSP)
    annotation (Line(points={{94,-24},{122,-24}}, color={0,0,127}));
end Humidifier;
