within ModelicaModels.Subsystems;
model PreHeater "Model of the pre-heater"

  extends ModelicaModels.Subsystems.BaseClasses.PreHeaterBaseClass;

  extends ModelicaModels.Subsystems.BaseClasses.HeatExchangerBaseClass(senTemp1(
       redeclare package Medium = MediumWater));

  extends ModelicaModels.Subsystems.BaseClasses.HeatExchangerPorts(
  portSupplyAirIn(redeclare package Medium = MediumAir),
  portSupplyAirOut(redeclare package Medium = MediumAir));

equation
  connect(T_in, warmWaterSource.T_in) annotation (Line(points={{56,-220},{56,-220},
          {56,-182},{56,-182}}, color={0,0,127}));
  connect(valveOpening, gain3.u) annotation (Line(points={{-54,-220},{-54,-220},
          {-54,-120},{-54,-108},{-27.2,-108}}, color={0,0,127}));
  connect(portSupplyAirIn, hex.port_a2) annotation (Line(points={{-240,0},{-90,0},
          {-90,12},{60,12}}, color={0,127,255}));
  connect(hex.port_b2, portSupplyAirOut) annotation (Line(points={{80,12},{140,12},
          {140,0},{200,0}}, color={0,127,255}));
  connect(senTemp1.port, hex.port_b1) annotation (Line(points={{82,-122},{82,-126},
          {98,-126},{98,-30},{58,-30},{58,0},{60,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PreHeater;
