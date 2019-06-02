within ModelicaModels.SubsystemModels.DetailedModels.Geo;
model Building "Simplified building model"

  replaceable package Water = AixLib.Media.Water;
  AixLib.Fluid.MixingVolumes.MixingVolume vol1(redeclare package Medium =
        Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    m_flow_small=50,
    p_start=100000,
    m_flow_nominal=16,
    V=2,
    nPorts=2)                    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-6,42})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-12,-12},{12,12}},
        rotation=0,
        origin={-42,42})));
  Modelica.Blocks.Math.Gain maxHeatFlowRate(k=0.01) "Convert from percent"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-48,-90})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-28,-80},{-8,-60}})));
  Modelica.Blocks.Sources.Constant const(k=-10000)
    annotation (Placement(transformation(extent={{-92,-60},{-72,-40}})));
  Modelica.Blocks.Sources.CombiTimeTable decisionVariables(
    table=[0.0,0.0],
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.CombiTimeTable variation(
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    table=[0.0,303.15])
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  AixLib.Fluid.FixedResistances.PressureDrop res(
    m_flow_nominal=16,
    dp_nominal(displayUnit="bar") = 100000,
    redeclare package Medium = Water)
        "total resistance" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={24,32})));
  AixLib.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Water,
    m_flow=16,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{-60,-14},{-40,6}})));
  AixLib.Fluid.Sources.Boundary_pT bou(
  redeclare package Medium = Water,
  nPorts=1) annotation (Placement(
        transformation(
        extent={{-10,-11},{10,11}},
        rotation=180,
        origin={90,-1})));
  AixLib.Fluid.Sensors.TemperatureTwoPort senTem(
  redeclare package Medium = Water, m_flow_nominal=16)
    annotation (Placement(transformation(extent={{42,22},{62,42}})));
  Modelica.Blocks.Interfaces.RealOutput returnTemperature
    "Temperature of the passing fluid"
    annotation (Placement(transformation(extent={{82,50},{102,70}})));
equation
  connect(prescribedHeatFlow.port, vol1.heatPort) annotation (Line(points={{-30,42},
          {-16,42}},                         color={191,0,0}));
  connect(maxHeatFlowRate.y, product1.u2)
    annotation (Line(points={{-41.4,-90},{-36,-90},{-36,-76},{-30,-76}},
                                                       color={0,0,127}));
  connect(product1.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-7,-70},
          {22,-70},{22,20},{-60,20},{-60,42},{-54,42}},              color={0,0,
          127}));
  connect(const.y, product1.u1) annotation (Line(points={{-71,-50},{-60,-50},{
          -60,-64},{-30,-64}}, color={0,0,127}));
  connect(decisionVariables.y[1], maxHeatFlowRate.u) annotation (Line(points={{-79,-90},
          {-55.2,-90}},                          color={0,0,127}));
  connect(variation.y[1], boundary.T_in)
    annotation (Line(points={{-79,0},{-62,0}}, color={0,0,127}));
  connect(boundary.ports[1], vol1.ports[1]) annotation (Line(points={{-40,-4},{-24,
          -4},{-24,32},{-8,32}}, color={0,127,255}));
  connect(vol1.ports[2], res.port_a)
    annotation (Line(points={{-4,32},{14,32}}, color={0,127,255}));
  connect(res.port_b, senTem.port_a)
    annotation (Line(points={{34,32},{42,32}}, color={0,127,255}));
  connect(senTem.port_b, bou.ports[1]) annotation (Line(points={{62,32},{68,32},
          {68,-1},{80,-1}}, color={0,127,255}));
  connect(senTem.T, returnTemperature)
    annotation (Line(points={{52,43},{52,60},{92,60}}, color={0,0,127}));
end Building;
