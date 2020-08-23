within ModelicaModels.Export.AHU;
model HumidifierML "Detailed model of the humidifier for machine learning"

  replaceable package MediumAir =
      AixLib.Media.Air;
  replaceable package MediumWater = AixLib.Media.Water;

  Modelica.Fluid.Sources.MassFlowSource_T IntakeAirSource(
    m_flow=0.5,
    redeclare package Medium = MediumAir,
    X={0.03,0.97},
    T=30 + 273.15,
    use_X_in=true,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Fluid.Sources.Boundary_pT IntakeAirSink(
    redeclare package Medium = MediumAir,
    use_T_in=false,
    use_X_in=false,
    use_p_in=false,
    p(displayUnit="Pa") = 101300,
    nPorts=1)
    annotation (Placement(transformation(extent={{120,60},{100,80}})));
  AixLib.Utilities.Psychrometrics.ToTotalAir toTotAir
    annotation (Placement(transformation(extent={{-110,56},{-90,76}})));
  AixLib.Fluid.Sensors.Temperature supplyAirTemperature(redeclare package
      Medium = MediumAir) "Temperature of supply air"
    annotation (Placement(transformation(extent={{32,88},{52,108}})));
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
  AixLib.Fluid.MixingVolumes.MixingVolume    vol(
    redeclare package Medium = MediumAir,
    m_flow_nominal=0.5,
    V=0.1,
    nPorts=4)
    annotation (Placement(transformation(extent={{-10,74},{10,94}})));
  Modelica.Fluid.Sources.MassFlowSource_T  SteamSource(
    m_flow=0.5,
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    use_X_in=false,
    T=100 + 273.15,
    X={0.99,0.01},
    use_T_in=true,
    nPorts=1)
             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={12,-24})));
  Modelica.Blocks.Tables.CombiTable1D HumidifierCharacteristics(
    tableOnFile=false, table=[0,0; 1,0.012])            annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={92,-14})));
  Modelica.Blocks.Sources.Constant SteamFlowNominal(k=0.2) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={92,-50})));
  Modelica.Blocks.Math.Product product3
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={52,-44})));
  Modelica.Blocks.Sources.Constant steamTemperature(k=100 + 273.15)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={52,-4})));
  Modelica.Blocks.Sources.RealExpression realExpression3[4](each y=vol.heatPort.T)
    annotation (Placement(transformation(extent={{62,-114},{82,-94}})));
  Modelica.Blocks.Interfaces.RealOutput hexele1masT "Value of Real output"
    annotation (Placement(transformation(extent={{102,-98},{122,-78}})));
  Modelica.Blocks.Interfaces.RealOutput hexele2masT "Value of Real output"
    annotation (Placement(transformation(extent={{102,-108},{122,-88}})));
  Modelica.Blocks.Interfaces.RealOutput hexele3masT "Value of Real output"
    annotation (Placement(transformation(extent={{102,-118},{122,-98}})));
  Modelica.Blocks.Interfaces.RealOutput hexele4masT "Value of Real output"
    annotation (Placement(transformation(extent={{102,-128},{122,-108}})));
equation
  connect(toTotAir.XiTotalAir, IntakeAirSource.X_in[1])
    annotation (Line(points={{-89,66},{-62,66}}, color={0,0,127}));
  connect(toTotAir.XNonVapor, IntakeAirSource.X_in[2]) annotation (Line(points=
          {{-89,62},{-82,62},{-82,66},{-62,66}}, color={0,0,127}));
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
  connect(HumidifierCharacteristics.y[1],product3. u2) annotation (Line(
      points={{81,-14},{72,-14},{72,-38},{64,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SteamFlowNominal.y,product3. u1) annotation (Line(
      points={{81,-50},{64,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product3.y,SteamSource. m_flow_in) annotation (Line(
      points={{41,-44},{32,-44},{32,-32},{22,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(steamTemperature.y,SteamSource. T_in)
    annotation (Line(points={{41,-4},{32,-4},{32,-28},{24,-28}},
                                                          color={0,0,127}));
  connect(vol.ports[1], IntakeAirSink.ports[1]) annotation (Line(points={{-3,74},
          {-3,74},{60,74},{60,70},{100,70}}, color={0,127,255}));
  connect(SteamSource.ports[1], vol.ports[2])
    annotation (Line(points={{2,-24},{2,74},{-1,74}}, color={0,127,255}));
  connect(IntakeAirSource.ports[1], vol.ports[3]) annotation (Line(points={{-40,
          70},{-22,70},{-22,74},{1,74}}, color={0,127,255}));
  connect(supplyAirTemperature.port, vol.ports[4])
    annotation (Line(points={{42,88},{42,74},{3,74}}, color={0,127,255}));
  connect(valveOpening, HumidifierCharacteristics.u[1]) annotation (Line(points=
         {{-140,-50},{-86,-50},{24,-50},{24,-74},{118,-74},{118,-14},{104,-14}},
        color={0,0,127}));
  connect(realExpression3[1].y,hexele1masT)  annotation (Line(points={{83,-104},
          {94,-104},{94,-88},{112,-88}}, color={0,0,127}));
  connect(realExpression3[2].y,hexele2masT)  annotation (Line(points={{83,-104},
          {94,-104},{94,-98},{112,-98}},   color={0,0,127}));
  connect(realExpression3[3].y,hexele3masT)  annotation (Line(points={{83,-104},
          {92,-104},{92,-108},{112,-108}}, color={0,0,127}));
  connect(realExpression3[4].y,hexele4masT)  annotation (Line(points={{83,-104},
          {94,-104},{94,-118},{112,-118}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3600, Interval=10));
end HumidifierML;
