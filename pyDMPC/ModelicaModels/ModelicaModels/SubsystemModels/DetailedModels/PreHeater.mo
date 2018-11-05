within ModelicaModels.SubsystemModels.DetailedModels;
model PreHeater "Detailed model of the pre heater"

  extends
    ModelicaModels.SubsystemModels.BaseClasses.HeatExchangerCommunicationBaseClass(
     Pressure(k=defaultPressure),
    IntakeAirSource(nPorts=1),
    IntakeAirSink(nPorts=1),
    volumeFlow(tableOnFile=false, table=[0,0.31,0.29]));

  extends
    ModelicaModels.Subsystems.BaseClasses.PreHeaterBaseClass;

  Modelica.Blocks.Sources.Constant Temperature(k=273 + 50) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-190})));
equation
  connect(IntakeAirSource.ports[1], hex.port_a2)
    annotation (Line(points={{-100,12},{-56,12},{-56,70},{-12,70}},
                                                 color={0,127,255}));
  connect(hex.port_b2, IntakeAirSink.ports[1])
    annotation (Line(points={{8,70},{90,70},{90,12},{170,12}},
                                                color={0,127,255}));
  connect(senTemp1.port, hex.port_a1) annotation (Line(points={{10,-64},{10,
          -128},{130,-128},{130,58},{8,58}},color={0,127,255}));
  connect(supplyAirHumidity.port, hex.port_b2) annotation (Line(points={{66,38},
          {66,28},{8,28},{8,70}},   color={0,127,255}));
  connect(supplyAirTemperature.port, hex.port_b2) annotation (Line(points={{104,38},
          {104,30},{8,30},{8,70}},       color={0,127,255}));
  connect(Temperature.y, warmWaterSource.T_in) annotation (Line(points={{-39,
          -190},{-16,-190},{-16,-124}},
                                      color={0,0,127}));
  connect(decisionVariables.y[1], convertCommand.u) annotation (Line(points={{
          -65,-110},{-46,-110},{-46,-78},{-114,-78},{-114,-50},{-103.2,-50}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PreHeater;
