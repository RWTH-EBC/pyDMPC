within ModelicaModels.SubsystemModels.DetailedModels;
model Cooler "Detailed model of the cooler"

  extends
    ModelicaModels.SubsystemModels.BaseClasses.HeatExchangerCommunicationBaseClass(
     Pressure(k=defaultPressure),
    IntakeAirSource(nPorts=1),
    IntakeAirSink(nPorts=1));

  extends
    ModelicaModels.Subsystems.BaseClasses.CoolerBaseClass;
equation
  connect(IntakeAirSource.ports[1], hex.port_a2)
    annotation (Line(points={{-100,12},{60,12}}, color={0,127,255}));
  connect(hex.port_b2, IntakeAirSink.ports[1])
    annotation (Line(points={{80,12},{170,12}}, color={0,127,255}));
  connect(decisionVariables.y[1], gain3.u)
    annotation (Line(points={{-63,-108},{-27.2,-108}}, color={0,0,127}));
  connect(hex.port_b2, supplyAirHumidity.port) annotation (Line(points={{80,12},
          {84,12},{84,38},{66,38}}, color={0,127,255}));
  connect(hex.port_b2, supplyAirTemperature.port) annotation (Line(points={{80,
          12},{92,12},{92,38},{104,38}}, color={0,127,255}));
  connect(senTemp1.port, hex.port_a1) annotation (Line(points={{82,-122},{84,
          -122},{84,-130},{68,-130},{68,-24},{80,-24},{80,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Cooler;
