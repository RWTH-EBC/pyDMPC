within ModelicaModels.SubsystemModels.DetailedModels;
model Cooler "Detailed model of the cooler"

  extends
    ModelicaModels.SubsystemModels.BaseClasses.HeatExchangerCommunicationBaseClass(
     Pressure(k=defaultPressure),
    IntakeAirSource(nPorts=1),
    IntakeAirSink(nPorts=1),
    volumeFlow(tableOnFile=false, table=[0,0.31,0.29]));

  extends
    ModelicaModels.Subsystems.BaseClasses.CoolerBaseClass;
equation
  connect(IntakeAirSource.ports[1], hex.port_a2)
    annotation (Line(points={{-100,12},{-56,12},{-56,70},{-12,70}},
                                                 color={0,127,255}));
  connect(hex.port_b2, IntakeAirSink.ports[1])
    annotation (Line(points={{8,70},{90,70},{90,12},{170,12}},
                                                color={0,127,255}));
  connect(hex.port_b2, supplyAirHumidity.port) annotation (Line(points={{8,70},{
          84,70},{84,38},{66,38}},  color={0,127,255}));
  connect(hex.port_b2, supplyAirTemperature.port) annotation (Line(points={{8,70},{
          92,70},{92,38},{104,38}},      color={0,127,255}));
  connect(decisionVariables.y[1], convertCommand.u) annotation (Line(points={{
          -65,-110},{-48,-110},{-48,-78},{-114,-78},{-114,-50},{-103.2,-50}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Cooler;
