within ModelicaModels.Export.AHU;
model HRCML "Detailed model of the heat recovery for machine learning"

  extends ModelicaModels.Subsystems.BaseClasses.HRCBaseClass;
  Modelica.Fluid.Sources.MassFlowSource_T IntakeAirSource(
    m_flow=0.5,
    redeclare package Medium = MediumAir,
    X={0.03,0.97},
    T=30 + 273.15,
    use_X_in=true,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,38},{-40,58}})));
  Modelica.Fluid.Sources.Boundary_pT IntakeAirSink(
    redeclare package Medium = MediumAir,
    use_T_in=false,
    use_X_in=false,
    use_p_in=false,
    p(displayUnit="Pa") = 101300,
    nPorts=1)
    annotation (Placement(transformation(extent={{122,22},{102,42}})));
  AixLib.Utilities.Psychrometrics.ToTotalAir toTotAir
    annotation (Placement(transformation(extent={{-110,56},{-90,76}})));
  AixLib.Fluid.Sensors.TemperatureTwoPort
                                   supplyAirTemperature(redeclare package
      Medium = MediumAir, m_flow_nominal=0.35)
                          "Temperature of supply air"
    annotation (Placement(transformation(extent={{62,20},{82,40}})));
  Modelica.Blocks.Sources.RealExpression realExpression3[4](y=hex.ele[:].mas.T)
    annotation (Placement(transformation(extent={{52,-124},{72,-104}})));
  Modelica.Blocks.Interfaces.RealOutput hexele1masT "Value of Real output"
    annotation (Placement(transformation(extent={{92,-108},{112,-88}})));
  Modelica.Blocks.Interfaces.RealOutput hexele2masT "Value of Real output"
    annotation (Placement(transformation(extent={{92,-118},{112,-98}})));
  Modelica.Blocks.Interfaces.RealOutput hexele3masT "Value of Real output"
    annotation (Placement(transformation(extent={{92,-128},{112,-108}})));
  Modelica.Blocks.Interfaces.RealOutput hexele4masT "Value of Real output"
    annotation (Placement(transformation(extent={{92,-138},{112,-118}})));
  Modelica.Blocks.Interfaces.RealOutput supplyTemp "Temperature in port medium"
    annotation (Placement(transformation(extent={{126,88},{146,108}})));
  Modelica.Blocks.Interfaces.RealInput valveOpening "Input signal connector"
    annotation (Placement(transformation(extent={{-160,-70},{-120,-30}})));
  Modelica.Blocks.Sources.Constant x(k=0.007) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-130,66})));
  Modelica.Blocks.Sources.Constant mflow(k=0.35) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-100,100})));
  Modelica.Blocks.Interfaces.RealInput inflowTemp
    "Prescribed fluid temperature"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-84,20})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin
                                                 fromKelvin
                                                          annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={82,98})));
  Modelica.Fluid.Sources.MassFlowSource_T extractAirSource(
    m_flow=0.5,
    redeclare package Medium = MediumAir,
    X={0.03,0.97},
    T=30 + 273.15,
    use_X_in=true,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={138,70})));
  Modelica.Blocks.Sources.Constant extractTemp(k=273.15 + 25) annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={206,66})));
  Modelica.Blocks.Sources.Constant mflowExtract(k=0.32) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={206,22})));
  Modelica.Fluid.Sources.Boundary_pT ExhaustAirSink(
    redeclare package Medium = MediumAir,
    use_T_in=false,
    use_X_in=false,
    use_p_in=false,
    p(displayUnit="Pa") = 101300,
    nPorts=1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-108,132})));
equation
  connect(toTotAir.XiTotalAir, IntakeAirSource.X_in[1])
    annotation (Line(points={{-89,66},{-76,66},{-76,44},{-62,44}},
                                                 color={0,0,127}));
  connect(toTotAir.XNonVapor, IntakeAirSource.X_in[2]) annotation (Line(points={{-89,62},
          {-82,62},{-82,44},{-62,44}},           color={0,0,127}));
  connect(realExpression3[1].y, hexele1masT) annotation (Line(points={{73,-114},
          {84,-114},{84,-98},{102,-98}}, color={0,0,127}));
  connect(realExpression3[2].y, hexele2masT) annotation (Line(points={{73,-114},
          {84,-114},{84,-108},{102,-108}}, color={0,0,127}));
  connect(realExpression3[3].y, hexele3masT) annotation (Line(points={{73,-114},
          {82,-114},{82,-118},{102,-118}}, color={0,0,127}));
  connect(realExpression3[4].y, hexele4masT) annotation (Line(points={{73,-114},
          {84,-114},{84,-128},{102,-128}}, color={0,0,127}));
  connect(convertCommand.u, valveOpening)
    annotation (Line(points={{-65.2,-56},{-102,-56},{-102,-50},{-140,-50}},
                                                       color={0,0,127}));
  connect(toTotAir.XiDry, x.y)
    annotation (Line(points={{-111,66},{-119,66}}, color={0,0,127}));
  connect(mflow.y, IntakeAirSource.m_flow_in) annotation (Line(points={{-89,100},
          {-74,100},{-74,56},{-60,56}}, color={0,0,127}));
  connect(inflowTemp, toKelvin.Celsius)
    annotation (Line(points={{-140,20},{-96,20}}, color={0,0,127}));
  connect(toKelvin.Kelvin, IntakeAirSource.T_in) annotation (Line(points={{-73,20},
          {-70,20},{-70,52},{-62,52}},     color={0,0,127}));
  connect(fromKelvin.Celsius, supplyTemp)
    annotation (Line(points={{93,98},{136,98}}, color={0,0,127}));
  connect(IntakeAirSource.ports[1], exhaustPressureDrop.port_a) annotation (
      Line(points={{-40,48},{-34,48},{-26,48},{-26,28},{-58,28},{-58,10},{-80,
          10},{-80,4},{-70,4}}, color={0,127,255}));
  connect(supplyAirTemperature.port_b, IntakeAirSink.ports[1])
    annotation (Line(points={{82,30},{102,30},{102,32}}, color={0,127,255}));
  connect(hex.port_b1, supplyAirTemperature.port_a)
    annotation (Line(points={{46,52},{62,52},{62,30}}, color={0,127,255}));
  connect(dam1.port_b, supplyAirTemperature.port_a)
    annotation (Line(points={{54,-10},{62,-10},{62,30}}, color={0,127,255}));
  connect(supplyAirTemperature.T, fromKelvin.Kelvin) annotation (Line(points={{
          72,41},{72,41},{72,64},{58,64},{58,98},{70,98}}, color={0,0,127}));
  connect(hex.port_b2, OutgoingAirOutletTemp.port_a) annotation (Line(points={{
          26,64},{2,64},{2,76},{-24,76}}, color={0,127,255}));
  connect(extractAirSource.ports[1], hex.port_a2) annotation (Line(points={{128,
          70},{88,70},{88,64},{46,64}}, color={0,127,255}));
  connect(toTotAir.XiTotalAir, extractAirSource.X_in[1]) annotation (Line(
        points={{-89,66},{-76,66},{-76,126},{168,126},{168,74},{150,74}}, color=
         {0,0,127}));
  connect(toTotAir.XNonVapor, extractAirSource.X_in[2]) annotation (Line(points=
         {{-89,62},{-82,62},{-82,130},{176,130},{176,74},{150,74}}, color={0,0,
          127}));
  connect(mflowExtract.y, extractAirSource.m_flow_in) annotation (Line(points={
          {195,22},{172,22},{172,62},{148,62}}, color={0,0,127}));
  connect(extractTemp.y, extractAirSource.T_in)
    annotation (Line(points={{195,66},{150,66}}, color={0,0,127}));
  connect(ExhaustAirSink.ports[1], OutgoingAirOutletTemp.port_b) annotation (
      Line(points={{-98,132},{-88,132},{-68,132},{-68,76},{-44,76}}, color={0,
          127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3600, Interval=10));
end HRCML;
