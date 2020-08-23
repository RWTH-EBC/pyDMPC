within ModelicaModels.ControlledSystems;
model GenericControlledSystem
  "Model of a generic system with three subsystems"

  replaceable package MediumAir = AixLib.Media.Air;
  replaceable package MediumWater = AixLib.Media.Water;
  Subsystems.Heater heater
    annotation (Placement(transformation(extent={{-36,-12},{-8,22}})));
  Modelica.Fluid.Sources.MassFlowSource_T
                                      freshAirSource(
    nPorts=1,
    redeclare package Medium = MediumAir,
    use_T_in=true,
    use_X_in=true,
    use_m_flow_in=true) "Source of fresh air"
    annotation (Placement(transformation(extent={{-66,-4},{-46,16}})));
  Modelica.Blocks.Sources.Constant m_flow(k=0.5)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.Constant T(k=273 + 30)
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  AixLib.Utilities.Psychrometrics.ToTotalAir toTotAir
    annotation (Placement(transformation(extent={{-100,-32},{-80,-12}})));
  Modelica.Blocks.Sources.Constant X(k=0.005)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Fluid.Sources.Boundary_pT IntakeAirSink(
    nPorts=2,
    redeclare package Medium = MediumAir,
    use_T_in=false,
    use_X_in=false,
    use_p_in=false,
    p(displayUnit="Pa") = 101300)
    annotation (Placement(transformation(extent={{100,0},{80,20}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    table=[0.0,0.0; 3600,20; 6000,20])
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
initial equation
    //heater.hex.ele[1].mas.T = 293;

equation
  connect(freshAirSource.ports[1], heater.portSupplyAirIn) annotation (Line(
        points={{-46,6},{-40,6},{-40,10},{-31.9,10}}, color={0,127,255}));
  connect(m_flow.y, freshAirSource.m_flow_in) annotation (Line(points={{-79,50},
          {-72,50},{-72,16},{-66,16},{-66,14}}, color={0,0,127}));
  connect(T.y, freshAirSource.T_in)
    annotation (Line(points={{-79,10},{-68,10}}, color={0,0,127}));
  connect(toTotAir.XiTotalAir, freshAirSource.X_in[1]) annotation (Line(points=
          {{-79,-22},{-74,-22},{-74,2},{-68,2}}, color={0,0,127}));
  connect(toTotAir.XNonVapor, freshAirSource.X_in[2]) annotation (Line(points={
          {-79,-26},{-74,-26},{-74,2},{-68,2}}, color={0,0,127}));
  connect(X.y, toTotAir.XiDry) annotation (Line(points={{-79,-50},{-72,-50},{
          -72,-70},{-116,-70},{-116,-22},{-101,-22}}, color={0,0,127}));
  connect(heater.portSupplyAirOut, genericHeater.portSupplyAirIn) annotation (
      Line(points={{-12.2,10},{2,10},{2,56},{20,56}}, color={0,127,255}));
  connect(heater.portSupplyAirOut, genericCooler.portSupplyAirIn) annotation (
      Line(points={{-12.2,10},{2,10},{2,-4},{20,-4}}, color={0,127,255}));
  connect(genericHeater.portSupplyAirOut, IntakeAirSink.ports[1]) annotation (
      Line(points={{42.1,55.9},{56,55.9},{56,12},{80,12}}, color={0,127,255}));
  connect(genericCooler.portSupplyAirOut, IntakeAirSink.ports[2]) annotation (
      Line(points={{42.1,-4.1},{50,-4.1},{50,-4},{56,-4},{56,8},{80,8}}, color=
          {0,127,255}));
  connect(combiTimeTable.y[1], heater.valveOpening) annotation (Line(points={{
          -79,-90},{-56,-90},{-56,1},{-32,1}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=12000, Interval=10));
end GenericControlledSystem;
