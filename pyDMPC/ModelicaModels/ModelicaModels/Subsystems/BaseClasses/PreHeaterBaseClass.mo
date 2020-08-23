within ModelicaModels.Subsystems.BaseClasses;
model PreHeaterBaseClass "Base class of the pre-heater"
  extends ModelicaModels.Subsystems.BaseClasses.HeatExchangerBaseClass(
    warmWaterSource(nPorts=1),
    ValveCharacteristicCurve(tableOnFile=false, table=[0,0; 1.0,1.0]),
    waterSink(nPorts=1));
  AixLib.Fluid.Actuators.Valves.ThreeWayLinear    val(
    redeclare package Medium = MediumWater,
    l={0.01,0.01},
    dpValve_nominal=2000,
    m_flow_nominal=0.1)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-14})));
  AixLib.Fluid.Movers.FlowControlled_dp    CurculationPump(redeclare package
      Medium = MediumWater,
    m_flow_nominal=0.1,
    dp_nominal=10000)                           annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={20,32})));
equation
  connect(val.port_2,CurculationPump. port_a) annotation (Line(points={{20,-4},
          {20,22}},           color={0,127,255}));
  connect(warmWaterSource.ports[1], val.port_1) annotation (Line(points={{-12,
          -102},{-12,-24},{20,-24}},            color={0,127,255}));
  connect(hex.port_b1, val.port_3) annotation (Line(points={{-12,58},{-20,58},{
          -20,12},{40,12},{40,-14},{30,-14}}, color={0,127,255}));
  connect(hex.port_b1, waterSink.ports[1]) annotation (Line(points={{-12,58},{
          -20,58},{-20,12},{40,12},{40,-88},{8,-88},{8,-102}}, color={0,127,255}));
  connect(hex.port_b1, senTemp1.port) annotation (Line(points={{-12,58},{-20,58},
          {-20,12},{40,12},{40,-72},{10,-72},{10,-64}}, color={0,127,255}));
  connect(ValveCharacteristicCurve.y[1], val.y) annotation (Line(points={{-59,
          -50},{-42,-50},{-42,-14},{8,-14}}, color={0,0,127}));
  connect(Pressure1.y, CurculationPump.dp_in) annotation (Line(points={{-59,-10},
          {-38,-10},{-38,32},{8,32}}, color={0,0,127}));
  connect(CurculationPump.port_b, hex.port_a1)
    annotation (Line(points={{20,42},{20,58},{8,58}}, color={0,127,255}));
end PreHeaterBaseClass;
