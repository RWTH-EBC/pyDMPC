within ModelicaModels.Subsystems;
model GenericMainHeater
  extends ModelicaModels.Subsystems.BaseClasses.HeatExchangerBaseClass(
    waterSink(nPorts=1),
    warmWaterSource(nPorts=1),
    Pressure1(k=0.1),
    ValveCharacteristicCurve(table=[0.0,0.0; 1,1]),
    hex(tau_m=1000));
  Modelica.Fluid.Interfaces.FluidPort_a portSupplyAirIn(redeclare package
      Medium = MediumAir)
                   "Inlet port of supply air"
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}}),
        iconTransformation(extent={{-114,-16},{-84,16}})));
  Modelica.Fluid.Interfaces.FluidPort_b portSupplyAirOut(redeclare package
      Medium = MediumAir)                                                                      "Outlet port of supply air"
    annotation (Placement(transformation(extent={{150,-10},{130,10}}),
        iconTransformation(extent={{114,-16},{82,16}})));
  Modelica.Blocks.Interfaces.RealInput u1
                         "Input signal connector"
    annotation (Placement(transformation(extent={{-160,-70},{-120,-30}})));
  AixLib.Fluid.Movers.FlowControlled_m_flow CurculationPump(
    redeclare package Medium = MediumWater,
    dp_nominal=10000,
    m_flow_nominal=0.1)                         annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={14,2})));
  AixLib.Fluid.Actuators.Valves.ThreeWayLinear    val(
    redeclare package Medium = MediumWater,
    l={0.01,0.01},
    dpValve_nominal=2000,
    m_flow_nominal=0.1,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={14,-24})));
equation
  connect(portSupplyAirIn, hex.port_a2) annotation (Line(points={{-140,0},{-76,0},
          {-76,70},{-12,70}}, color={0,127,255}));
  connect(portSupplyAirOut, hex.port_b2) annotation (Line(points={{140,0},{74,0},
          {74,70},{8,70}}, color={0,127,255}));
  connect(convertCommand.u, u1)
    annotation (Line(points={{-103.2,-50},{-140,-50}}, color={0,0,127}));
  connect(CurculationPump.port_b, hex.port_a1)
    annotation (Line(points={{14,12},{14,58},{8,58}}, color={0,127,255}));
  connect(CurculationPump.port_a, val.port_2)
    annotation (Line(points={{14,-8},{14,-14}}, color={0,127,255}));
  connect(hex.port_b1, waterSink.ports[1]) annotation (Line(points={{-12,58},{
          -32,58},{-32,26},{60,26},{60,-84},{8,-84},{8,-102}}, color={0,127,255}));
  connect(hex.port_b1, val.port_3) annotation (Line(points={{-12,58},{-32,58},{
          -32,26},{60,26},{60,-24},{24,-24}}, color={0,127,255}));
  connect(val.port_1, warmWaterSource.ports[1]) annotation (Line(points={{14,
          -34},{14,-40},{-12,-40},{-12,-102}}, color={0,127,255}));
  connect(val.y, ValveCharacteristicCurve.y[1]) annotation (Line(points={{2,-24},
          {-34,-24},{-34,-50},{-59,-50}}, color={0,0,127}));
  connect(Pressure1.y, CurculationPump.m_flow_in) annotation (Line(points={{-59,
          -10},{-28,-10},{-28,2},{2,2}}, color={0,0,127}));
  connect(senTemp1.port, hex.port_b1) annotation (Line(points={{10,-64},{10,-74},
          {60,-74},{60,26},{-32,26},{-32,58},{-12,58}}, color={0,127,255}));
end GenericMainHeater;
