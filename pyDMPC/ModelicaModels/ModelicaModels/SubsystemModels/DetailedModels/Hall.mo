within ModelicaModels.SubsystemModels.DetailedModels;
model Hall
  extends ModelicaModels.SubsystemModels.BaseClasses.HeatExchangerCommunicationBaseClass(
    IntakeAirSource(nPorts=1),
    IntakeAirSink(nPorts=1),
    Pressure(k=10000),
    volumeFlow(fileName="../../Inputs/volumeFlow.txt"));
  extends ModelicaModels.Subsystems.BaseClasses.HallBaseClass(volume(nPorts=2),
    concreteFloor(T(fixed=true)),
    wallMasses(T(fixed=true)));

  Modelica.Blocks.Sources.CombiTimeTable weather(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    columns={2},
    tableName="InputTable",
    fileName="weather.mat",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "Table with weather forecast" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-70})));
equation
  connect(IntakeAirSource.ports[1], volume.ports[2]) annotation (Line(points={{
          -100,12},{-60,12},{-60,-170},{54,-170},{54,-90},{100,-90}}, color={0,
          127,255}));
  connect(decisionVariables.y[1], valveEffect.u) annotation (Line(points={{-65,
          -110},{-50,-110},{-50,-126},{2.8,-126}}, color={0,0,127}));
  connect(res.port_b, IntakeAirSink.ports[1]) annotation (Line(points={{152,
          -110},{168,-110},{168,12},{170,12}}, color={0,127,255}));
  connect(res.port_b, supplyAirHumidity.port) annotation (Line(points={{152,
          -110},{168,-110},{168,0},{66,0},{66,38}}, color={0,127,255}));
  connect(res.port_b, supplyAirTemperature.port) annotation (Line(points={{152,
          -110},{168,-110},{168,0},{104,0},{104,38}}, color={0,127,255}));
  connect(weather.y[1], outdoorAir.T) annotation (Line(points={{-79,-70},{-32,
          -70},{-32,-80},{-2,-80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, Interval=10));
end Hall;
