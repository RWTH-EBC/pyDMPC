within ModelicaModels.Subsystems;
model Heater
  "Heater subsystem"

  extends ModelicaModels.Subsystems.BaseClasses.HeaterBaseClass;

  extends ModelicaModels.Subsystems.BaseClasses.HeatExchangerPorts;

equation
  connect(portSupplyAirIn, hex.port_a2) annotation (Line(points={{-100,0},{-84,
          0},{-84,70},{-12,70}},
                            color={0,127,255}));
  connect(hex.port_b2, portSupplyAirOut) annotation (Line(points={{8,70},{80,70},
          {80,0},{100,0}},  color={0,127,255}));
  connect(valveOpening, convertCommand.u) annotation (Line(points={{-100,-90},{
          -66,-90},{-66,-68},{-112,-68},{-112,-50},{-103.2,-50}}, color={0,0,
          127}));
  connect(Temperature.y, waterInflowTemperature) annotation (Line(points={{-119,
          -128},{78,-128},{78,-90},{100,-90}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -220},{140,120}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-220},{140,
            120}})));
end Heater;
