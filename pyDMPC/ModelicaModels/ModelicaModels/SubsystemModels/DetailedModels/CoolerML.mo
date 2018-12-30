within ModelicaModels.SubsystemModels.DetailedModels;
model CoolerML "Detailed model of the cooler for machine learning"

  extends ModelicaModels.Subsystems.BaseClasses.CoolerBaseClass;
  Modelica.Fluid.Sources.MassFlowSource_T IntakeAirSource(
    nPorts=1,
    m_flow=0.5,
    redeclare package Medium = MediumAir,
    X={0.03,0.97},
    T=30 + 273.15,
    use_X_in=true,
    use_T_in=true,
    use_m_flow_in=true)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Fluid.Sources.Boundary_pT IntakeAirSink(
    nPorts=1,
    redeclare package Medium = MediumAir,
    use_T_in=false,
    use_X_in=false,
    use_p_in=false,
    p(displayUnit="Pa") = 101300)
    annotation (Placement(transformation(extent={{120,60},{100,80}})));
  AixLib.Utilities.Psychrometrics.ToTotalAir toTotAir
    annotation (Placement(transformation(extent={{-110,56},{-90,76}})));
  AixLib.Fluid.Sensors.Temperature supplyAirTemperature(redeclare package
      Medium = MediumAir) "Temperature of supply air"
    annotation (Placement(transformation(extent={{32,88},{52,108}})));
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
equation
  connect(toTotAir.XiTotalAir, IntakeAirSource.X_in[1])
    annotation (Line(points={{-89,66},{-62,66}}, color={0,0,127}));
  connect(toTotAir.XNonVapor, IntakeAirSource.X_in[2]) annotation (Line(points=
          {{-89,62},{-82,62},{-82,66},{-62,66}}, color={0,0,127}));
  connect(IntakeAirSource.ports[1], hex.port_a2)
    annotation (Line(points={{-40,70},{-12,70}}, color={0,127,255}));
  connect(hex.port_b2, IntakeAirSink.ports[1])
    annotation (Line(points={{8,70},{100,70}}, color={0,127,255}));
  connect(realExpression3[1].y, hexele1masT) annotation (Line(points={{73,-114},
          {84,-114},{84,-98},{102,-98}}, color={0,0,127}));
  connect(realExpression3[2].y, hexele2masT) annotation (Line(points={{73,-114},
          {84,-114},{84,-108},{102,-108}}, color={0,0,127}));
  connect(realExpression3[3].y, hexele3masT) annotation (Line(points={{73,-114},
          {82,-114},{82,-118},{102,-118}}, color={0,0,127}));
  connect(realExpression3[4].y, hexele4masT) annotation (Line(points={{73,-114},
          {84,-114},{84,-128},{102,-128}}, color={0,0,127}));
  connect(hex.port_b2, supplyAirTemperature.port) annotation (Line(points={{8,
          70},{26,70},{26,88},{42,88}}, color={0,127,255}));
  connect(convertCommand.u, valveOpening)
    annotation (Line(points={{-103.2,-50},{-140,-50}}, color={0,0,127}));
  connect(toTotAir.XiDry, x.y)
    annotation (Line(points={{-111,66},{-119,66}}, color={0,0,127}));
  connect(mflow.y, IntakeAirSource.m_flow_in) annotation (Line(points={{-89,100},
          {-74,100},{-74,78},{-60,78}}, color={0,0,127}));
  connect(inflowTemp, toKelvin.Celsius)
    annotation (Line(points={{-140,20},{-96,20}}, color={0,0,127}));
  connect(toKelvin.Kelvin, IntakeAirSource.T_in) annotation (Line(points={{-73,
          20},{-70,20},{-70,74},{-62,74}}, color={0,0,127}));
  connect(supplyAirTemperature.T, fromKelvin.Kelvin)
    annotation (Line(points={{49,98},{70,98}}, color={0,0,127}));
  connect(fromKelvin.Celsius, supplyTemp)
    annotation (Line(points={{93,98},{136,98}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100000, Interval=10));
end CoolerML;
