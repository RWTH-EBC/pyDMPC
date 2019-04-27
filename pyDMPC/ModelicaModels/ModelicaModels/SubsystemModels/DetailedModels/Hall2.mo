within ModelicaModels.SubsystemModels.DetailedModels;
model Hall2
  extends ModelicaModels.Subsystems.BaseClasses.HallBaseClass(
    concreteFloor(T(fixed=true)),
    wallMasses(T(fixed=true)),
    volume(nPorts=2),
    wallConductor(G=30000),
    FloorConductor(G=4000),
    CCAConductor(G=5000),
    SolarShare(k=50));

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
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin waterTemperature1
    annotation (Placement(transformation(extent={{-28,-86},{-16,-74}})));
  Modelica.Fluid.Sources.MassFlowSource_T IntakeAirSource(
    nPorts=1,
    m_flow=0.5,
    redeclare package Medium = MediumAir,
    X={0.03,0.97},
    T=30 + 273.15,
    use_T_in=true,
    use_m_flow_in=true,
    use_X_in=false)
    annotation (Placement(transformation(extent={{-120,2},{-100,22}})));
  Modelica.Fluid.Sources.Boundary_pT IntakeAirSink(
    nPorts=1,
    redeclare package Medium = MediumAir,
    use_T_in=false,
    use_X_in=false,
    use_p_in=false,
    p(displayUnit="Pa") = 101300)
    annotation (Placement(transformation(extent={{190,2},{170,22}})));
  Modelica.Blocks.Sources.Constant Pressure(k=23)
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-80,-110})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin hallTemperature1
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-42,40})));
  Modelica.Blocks.Math.Gain gain(k=1.2/3600) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-46,86})));
equation
  connect(outdoorAir.T, waterTemperature1.Kelvin)
    annotation (Line(points={{-2,-80},{-15.4,-80}}, color={0,0,127}));
  connect(combiTimeTable.y[5], waterTemperature1.Celsius) annotation (Line(
        points={{-19,10},{-14,10},{-14,-32},{-46,-32},{-46,-80},{-29.2,-80}},
        color={0,0,127}));
  connect(IntakeAirSource.ports[1], volume.ports[2]) annotation (Line(points={{
          -100,12},{-86,12},{-86,16},{-58,16},{-58,-66},{74,-66},{74,-90},{100,
          -90}}, color={0,127,255}));
  connect(res.port_b, IntakeAirSink.ports[1]) annotation (Line(points={{152,
          -110},{166,-110},{166,12},{170,12}}, color={0,127,255}));
  connect(Pressure.y, waterTemperature.Celsius) annotation (Line(points={{-69,
          -110},{-50,-110},{-50,-100},{-29.2,-100}}, color={0,0,127}));
  connect(hallTemperature1.Kelvin, IntakeAirSource.T_in) annotation (Line(
        points={{-48.6,40},{-136,40},{-136,16},{-122,16}}, color={0,0,127}));
  connect(combiTimeTable.y[3], hallTemperature1.Celsius) annotation (Line(
        points={{-19,10},{-14,10},{-14,40},{-34.8,40}}, color={0,0,127}));
  connect(combiTimeTable.y[2], gain.u) annotation (Line(points={{-19,10},{0,10},
          {0,86},{-34,86}}, color={0,0,127}));
  connect(gain.y, IntakeAirSource.m_flow_in) annotation (Line(points={{-57,86},
          {-132,86},{-132,20},{-120,20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, Interval=10));
end Hall2;
