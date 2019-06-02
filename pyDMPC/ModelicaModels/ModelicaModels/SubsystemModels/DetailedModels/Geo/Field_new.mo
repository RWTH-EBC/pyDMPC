within ModelicaModels.SubsystemModels.DetailedModels.Geo;
model Field_new "Simplified model of geothermal field"

  replaceable package Water = AixLib.Media.Water;

  Modelica.Blocks.Sources.CombiTimeTable variation(
    fileName="../../Geo_long/variation.mat",
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    tableName="tab1",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableOnFile=false,
    table=[0,10000; 2635200,12000; 5270400,9000; 7905600,3000; 10540800,-5000;
        13176000,-12000; 15811200,-12000; 18446400,-13000; 21081600,-5000;
        23716800,4000; 26352000,8000; 28987200,12000; 31622400,10000; 34257600,
        12000; 36892800,9000; 39528000,3000; 42163200,-5000; 44798400,-12000;
        47433600,-12000; 50068800,-13000; 52704000,-5000; 55339200,4000;
        57974400,8000; 60609600,12000; 63244800,10000; 65880000,12000; 68515200,
        9000; 71150400,3000; 73785600,-5000; 76420800,-12000; 79056000,-12000;
        81691200,-13000; 84326400,-5000; 86961600,4000; 89596800,8000; 92232000,
        12000],
    columns={2}) "Table with control input" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,90})));
  AixLib.Fluid.MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    m_flow_small=50,
    nPorts=3,
    p_start=100000,
    m_flow_nominal=16,
    V=2)                         annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={2,40})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-12,-12},{12,12}},
        rotation=0,
        origin={-24,40})));
  Modelica.Blocks.Math.Gain percent(k=0.01) "Convert from percent" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-64,-50})));
  AixLib.Fluid.Movers.FlowControlled_m_flow pump(m_flow_nominal=16,
      nominalValuesDefineDefaultPressureCurve=true,
      redeclare package Medium = Water) "Main geothermal pump"
    annotation (Placement(transformation(extent={{48,-10},{68,10}})));
  AixLib.Fluid.FixedResistances.PressureDrop res(m_flow_nominal=16, dp_nominal(
        displayUnit="bar") = 100000, redeclare package Medium = Water)
        "total resistance" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={48,30})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Constant massFlowSet(k=16) "Mass flow set point"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Fluid.Sources.Boundary_pT pressurePoint(
    redeclare package Medium = Water,
    use_T_in=false,
    use_X_in=false,
    use_p_in=false,
    p(displayUnit="Pa") = 101300,
    nPorts=1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={42,-34})));
  AixLib.Fluid.Sensors.Temperature supplyTemperature(T(start=285), redeclare
      package Medium = Water) "Temperature of supply water"
    annotation (Placement(transformation(extent={{82,34},{102,54}})));
  AixLib.Fluid.Sensors.MassFlowRate massFlow(redeclare package Medium =
        Water)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=270,
        origin={80,12})));
  Modelica.Blocks.Logical.LessEqualThreshold    lessEqualThreshold
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  AixLib.Fluid.Sensors.Temperature returnTemperature(redeclare package Medium =
        Water, T(start=285.15)) "Temperature of supply water"
    annotation (Placement(transformation(extent={{74,-78},{94,-58}})));
  AixLib.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Water,
    m_flow_small=50,
    nPorts=2,
    V=9000,
    p_start=150000,
    T_start=285.15,
    m_flow_nominal=16)              annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-8,-2})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=285.15)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-24,-62})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=50)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-24,-34})));
  Modelica.Blocks.Math.Gain negate(k=-1) "negate" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-48,40})));
  Modelica.Blocks.Sources.CombiTimeTable decisionVariables(
    table=[0.0,0.0],
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
equation
  connect(prescribedHeatFlow.port, vol1.heatPort)
    annotation (Line(points={{-12,40},{-8,40}}, color={191,0,0}));
  connect(res.port_b, vol1.ports[1])
    annotation (Line(points={{38,30},{-0.666667,30}},
                                              color={0,127,255}));
  connect(percent.y, product1.u2) annotation (Line(points={{-57.4,-50},{-48,-50},
          {-48,-8},{-94,-8},{-94,4},{-82,4}},   color={0,0,127}));
  connect(massFlowSet.y, pump.m_flow_in) annotation (Line(points={{41,70},{72,70},
          {72,20},{58,20},{58,12}}, color={0,0,127}));
  connect(pressurePoint.ports[1], pump.port_a)
    annotation (Line(points={{42,-24},{42,0},{48,0}}, color={0,127,255}));
  connect(variation.y[1], product1.u1) annotation (Line(points={{-79,90},{-72,
          90},{-72,70},{-96,70},{-96,16},{-82,16}}, color={0,0,127}));
  connect(pump.port_b, massFlow.port_a)
    annotation (Line(points={{68,0},{80,0},{80,6}}, color={0,127,255}));
  connect(massFlow.port_b, res.port_a)
    annotation (Line(points={{80,18},{80,30},{58,30}}, color={0,127,255}));
  connect(supplyTemperature.port, pump.port_b)
    annotation (Line(points={{92,34},{92,0},{68,0}}, color={0,127,255}));
  connect(variation.y[1], lessEqualThreshold.u) annotation (Line(points={{-79,
          90},{-66,90},{-66,80},{-62,80}}, color={0,0,127}));
  connect(variation.y[1], switch1.u3) annotation (Line(points={{-79,90},{-72,90},
          {-72,70},{-96,70},{-96,32},{-82,32}}, color={0,0,127}));
  connect(product1.y, switch1.u1) annotation (Line(points={{-59,10},{-52,10},{
          -52,26},{-90,26},{-90,48},{-82,48}}, color={0,0,127}));
  connect(lessEqualThreshold.y, switch1.u2) annotation (Line(points={{-39,80},{
          -14,80},{-14,60},{-92,60},{-92,40},{-82,40}}, color={255,0,255}));
  connect(thermalConductor.port_b, vol.heatPort)
    annotation (Line(points={{-24,-28},{-24,-2},{-18,-2}}, color={191,0,0}));
  connect(fixedTemperature.port, thermalConductor.port_a)
    annotation (Line(points={{-24,-56},{-24,-40}}, color={191,0,0}));
  connect(vol.ports[1], pump.port_a) annotation (Line(points={{-10,-12},{20,-12},
          {20,0},{48,0}}, color={0,127,255}));
  connect(vol1.ports[2], vol.ports[2]) annotation (Line(points={{2,30},{-40,30},
          {-40,-12},{-6,-12}}, color={0,127,255}));
  connect(vol1.ports[3], returnTemperature.port) annotation (Line(points={{
          4.66667,30},{-40,30},{-40,-80},{84,-80},{84,-78}}, color={0,127,255}));
  connect(prescribedHeatFlow.Q_flow, negate.y)
    annotation (Line(points={{-36,40},{-41.4,40}}, color={0,0,127}));
  connect(negate.u, switch1.y)
    annotation (Line(points={{-55.2,40},{-59,40}}, color={0,0,127}));
  connect(decisionVariables.y[1], percent.u)
    annotation (Line(points={{-79,-50},{-71.2,-50}}, color={0,0,127}));
  annotation (experiment(StopTime=94608000, Interval=86400),
      __Dymola_experimentSetupOutput);
end Field_new;
