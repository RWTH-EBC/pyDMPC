within ModelicaModels.Subsystems;
model PreHeater "Model of the pre-heater"

  extends ModelicaModels.Subsystems.BaseClasses.PreHeaterBaseClass;

  extends ModelicaModels.Subsystems.BaseClasses.HeatExchangerPorts(
  portSupplyAirIn(redeclare package Medium = MediumAir),
  portSupplyAirOut(redeclare package Medium = MediumAir));

equation
  connect(portSupplyAirIn, hex.port_a2) annotation (Line(points={{-100,0},{-90,0},
          {-90,70},{-12,70}},color={0,127,255}));
  connect(hex.port_b2, portSupplyAirOut) annotation (Line(points={{8,70},{140,70},
          {140,0},{100,0}}, color={0,127,255}));
  connect(valveOpening, convertCommand.u) annotation (Line(points={{-100,-90},{-70,
          -90},{-70,-64},{-114,-64},{-114,-50},{-103.2,-50}}, color={0,0,127}));
  connect(Temperature.y, waterInflowTemperature) annotation (Line(points={{-119,
          -128},{80,-128},{80,-90},{100,-90}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PreHeater;
