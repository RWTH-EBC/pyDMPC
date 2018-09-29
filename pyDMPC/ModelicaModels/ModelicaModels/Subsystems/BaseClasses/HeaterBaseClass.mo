within ModelicaModels.Subsystems.BaseClasses;
model HeaterBaseClass "Base class of the heater"
  extends
    ModelicaModels.Subsystems.BaseClasses.HeatExchangerBaseClass(
    hex(UA_nominal=1521),
    Pressure1(k=300),
    ValveCharacteristicCurve(fileName="Heater/MainHeaterValve.txt"),
    warmWaterSource(nPorts=1),
    waterSink(nPorts=1));


  AixLib.Fluid.Actuators.Valves.ThreeWayLinear    val(
    redeclare package Medium = MediumWater,
    m_flow_nominal=0.5,
    l={0.01,0.01},
    dpValve_nominal=2000)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,-100})));
  AixLib.Fluid.Movers.FlowControlled_dp    CurculationPump(redeclare package
      Medium = MediumWater, m_flow_nominal=0.5) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={60,-70})));
equation
  connect(val.port_2,CurculationPump. port_a) annotation (Line(points={{60,-90},
          {60,-86},{60,-80}}, color={0,127,255}));
  connect(CurculationPump.port_b, hex.port_a1) annotation (Line(points={{60,-60},
          {92,-60},{92,-24},{92,0},{80,0}},   color={0,127,255}));
  connect(hex.port_b1,val. port_3) annotation (Line(points={{60,0},{54,0},{54,
          -28},{100,-28},{100,-100},{70,-100}},
                                           color={0,127,255}));
  connect(ValveCharacteristicCurve.y[1],val. y) annotation (Line(points={{15,-110},
          {26,-110},{38,-110},{38,-100},{48,-100}},
                                          color={0,0,127}));
  connect(Pressure1.y,CurculationPump. dp_in)
    annotation (Line(points={{21,-70},{48,-70},{48,-70}},   color={0,0,127}));
  connect(warmWaterSource.ports[1], val.port_1)
    annotation (Line(points={{60,-160},{60,-110}}, color={0,127,255}));
  connect(waterSink.ports[1], val.port_3) annotation (Line(points={{80,-160},{
          80,-100},{70,-100}}, color={0,127,255}));
end HeaterBaseClass;
