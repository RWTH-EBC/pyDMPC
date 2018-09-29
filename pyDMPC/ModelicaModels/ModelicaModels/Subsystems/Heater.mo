within ModelicaModels.Subsystems;
model Heater
  "Heater subsystem"

  extends ModelicaModels.Subsystems.BaseClasses.HeaterBaseClass;

  extends ModelicaModels.Subsystems.BaseClasses.HeatExchangerBaseClass(senTemp1(
       redeclare package Medium = MediumWater));

  extends ModelicaModels.Subsystems.BaseClasses.HeatExchangerPorts(
  portSupplyAirIn(redeclare package Medium = MediumAir),
  portSupplyAirOut(redeclare package Medium = MediumAir));

equation
  connect(T_in, warmWaterSource.T_in)
    annotation (Line(points={{56,-220},{56,-182},{56,-182}}, color={0,0,127}));
  connect(valveOpening, gain3.u) annotation (Line(points={{-54,-220},{-54,-220},
          {-54,-114},{-54,-108},{-27.2,-108}}, color={0,0,127}));
  connect(portSupplyAirIn, hex.port_a2) annotation (Line(points={{-240,0},{-2,0},
          {-2,12},{60,12}}, color={0,127,255}));
  connect(hex.port_b2, portSupplyAirOut) annotation (Line(points={{80,12},{142,12},
          {142,0},{200,0}}, color={0,127,255}));
  connect(senTemp1.port, val.port_3) annotation (Line(points={{82,-122},{82,
          -130},{76,-130},{76,-100},{70,-100}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Heater;
