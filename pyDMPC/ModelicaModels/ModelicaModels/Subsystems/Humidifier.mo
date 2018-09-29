within ModelicaModels.Subsystems;
model Humidifier "Subsystem of the humdifier"
  extends ModelicaModels.Subsystems.BaseClasses.HumidifierBaseClass(
      vol(nPorts=3), SteamSource(nPorts=1));
  Modelica.Fluid.Interfaces.FluidPort_a portSupplyAirIn(redeclare package
      Medium =         MediumAir) "Inlet port of supply air"
    annotation (Placement(transformation(extent={{-270,-10},{-250,10}}),
        iconTransformation(extent={{-288,-30},{-236,22}})));
  Modelica.Fluid.Interfaces.FluidPort_b portSupplyAirOut(redeclare package
      Medium =         MediumAir) "Outlet port of supply air"
    annotation (Placement(transformation(extent={{290,-10},{270,10}}),
        iconTransformation(extent={{272,-36},{208,28}})));
  Modelica.Blocks.Interfaces.RealInput humidifierWSP
    "Working set point of the humidifiert (0..100%)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={280,-130})));
equation
  connect(vol.ports[1], portSupplyAirOut)
    annotation (Line(points={{-40,-40},{280,-40},{280,0}}, color={0,127,255}));
  connect(vol.ports[2], portSupplyAirIn) annotation (Line(points={{-40,-40},{-260,
          -40},{-260,0}}, color={0,127,255}));
  connect(vol.ports[3], SteamSource.ports[1]) annotation (Line(points={{-40,-40},
          {-40,-140},{40,-140}}, color={0,127,255}));
  connect(gain.u, humidifierWSP)
    annotation (Line(points={{176,-130},{280,-130}}, color={0,0,127}));
end Humidifier;
