within ModelicaModels.Subsystems.BaseClasses;
model HeaterBaseClass "Base class of the heater"
  extends
    ModelicaModels.Subsystems.BaseClasses.HeatExchangerBaseClass(
    ValveCharacteristicCurve(
    tableOnFile=false,
    table=[0,0; 0.1,0.1; 0.9,0.9; 1,1]),
    warmWaterSource(nPorts=1),
    waterSink(nPorts=1));


  AixLib.Fluid.Actuators.Valves.ThreeWayLinear    val(
    redeclare package Medium = MediumWater,
    l={0.01,0.01},
    dpValve_nominal=2000,
    m_flow_nominal=0.1)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={14,-30})));
  AixLib.Fluid.Movers.FlowControlled_dp    CurculationPump(redeclare package
      Medium = MediumWater,
    dp_nominal=10000,
    m_flow_nominal=0.1)                         annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={14,2})));
equation
  connect(val.port_2,CurculationPump. port_a) annotation (Line(points={{14,-20},
          {14,-8}},           color={0,127,255}));
  connect(CurculationPump.port_b, hex.port_a1) annotation (Line(points={{14,12},
          {14,58},{8,58}},                    color={0,127,255}));
  connect(hex.port_b1,val. port_3) annotation (Line(points={{-12,58},{-20,58},{
          -20,20},{40,20},{40,-30},{24,-30}},
                                           color={0,127,255}));
  connect(ValveCharacteristicCurve.y[1],val. y) annotation (Line(points={{-59,-50},
          {-20,-50},{-20,-30},{2,-30}},   color={0,0,127}));
  connect(val.port_1, warmWaterSource.ports[1]) annotation (Line(points={{14,
          -40},{14,-72},{-12,-72},{-12,-102}}, color={0,127,255}));
  connect(hex.port_b1, waterSink.ports[1]) annotation (Line(points={{-12,58},{
          -20,58},{-20,20},{40,20},{40,-86},{8,-86},{8,-102}}, color={0,127,255}));
  connect(hex.port_b1, senTemp1.port) annotation (Line(points={{-12,58},{-20,58},
          {-20,20},{40,20},{40,-68},{10,-68},{10,-64}}, color={0,127,255}));
  connect(Pressure1.y, CurculationPump.dp_in) annotation (Line(points={{-59,-10},
          {-44,-10},{-44,2},{2,2}}, color={0,0,127}));
end HeaterBaseClass;
