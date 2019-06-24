within ModelicaModels.SubsystemModels;
model GenericHeaterModel
  extends ModelicaModels.Subsystems.BaseClasses.GenericModelBaseClass(vol(
        nPorts=2));

  Modelica.Blocks.Interfaces.RealInput valveOpening
    annotation (Placement(transformation(extent={{-120,22},{-80,62}})));
  Modelica.Fluid.Sources.MassFlowSource_T
                                      freshAirSource(
    nPorts=1,
    redeclare package Medium = MediumAir,
    use_T_in=true,
    use_X_in=true,
    use_m_flow_in=true) "Source of fresh air"
    annotation (Placement(transformation(extent={{-40,-16},{-20,4}})));
  Modelica.Blocks.Sources.Constant m_flow(k=0.25)
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  AixLib.Utilities.Psychrometrics.ToTotalAir toTotAir
    annotation (Placement(transformation(extent={{-100,-32},{-80,-12}})));
  Modelica.Blocks.Sources.Constant X(k=0.005)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Interfaces.RealInput inflowTemp
    "Prescribed fluid temperature"
    annotation (Placement(transformation(extent={{-120,-12},{-80,28}})));
  Modelica.Blocks.Sources.Constant Kelvin(k=273)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-72,-54},{-52,-34}})));
  Modelica.Blocks.Math.Gain convertCommand(k=100)   "Convert from percent"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-62,30})));
  Modelica.Fluid.Sources.Boundary_pT supplyAirSink(
    redeclare package Medium = MediumAir,
    use_T_in=false,
    use_X_in=false,
    use_p_in=false,
    nPorts=1,
    p(displayUnit="Pa")) "Sink of supply air" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,0})));
equation
  connect(m_flow.y, freshAirSource.m_flow_in) annotation (Line(points={{-79,80},
          {-72,80},{-72,16},{-40,16},{-40,2}}, color={0,0,127}));
  connect(toTotAir.XiTotalAir, freshAirSource.X_in[1]) annotation (Line(points=
          {{-79,-22},{-74,-22},{-74,-10},{-42,-10}}, color={0,0,127}));
  connect(toTotAir.XNonVapor, freshAirSource.X_in[2]) annotation (Line(points={
          {-79,-26},{-74,-26},{-74,-10},{-42,-10}}, color={0,0,127}));
  connect(X.y, toTotAir.XiDry) annotation (Line(points={{-79,-90},{-78,-90},{
          -78,-70},{-116,-70},{-116,-22},{-101,-22}}, color={0,0,127}));
  connect(freshAirSource.ports[1], vol.ports[2])
    annotation (Line(points={{-20,-6},{0,-6},{0,0}}, color={0,127,255}));
  connect(freshAirSource.T_in, add.y) annotation (Line(points={{-42,-2},{-46,-2},
          {-46,-44},{-51,-44}}, color={0,0,127}));
  connect(Kelvin.y, add.u2)
    annotation (Line(points={{-79,-50},{-74,-50}}, color={0,0,127}));
  connect(inflowTemp, add.u1) annotation (Line(points={{-100,8},{-64,8},{-64,
          -28},{-78,-28},{-78,-38},{-74,-38}}, color={0,0,127}));
  connect(prescribedHeatFlow.Q_flow, convertCommand.y)
    annotation (Line(points={{-46,30},{-55.4,30}}, color={0,0,127}));
  connect(convertCommand.u, valveOpening) annotation (Line(points={{-69.2,30},{
          -74,30},{-74,42},{-100,42}}, color={0,0,127}));
  connect(supplyPressureDrop.port_b, supplyAirSink.ports[1])
    annotation (Line(points={{44,0},{60,0}}, color={0,127,255}));
end GenericHeaterModel;
