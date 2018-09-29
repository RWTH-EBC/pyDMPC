within ModelicaModels.Subsystems.BaseClasses;
model PreHeaterBaseClass "Base class of the pre-heater"
  extends
    ModelicaModels.Subsystems.BaseClasses.HeatExchangerBaseClass(hex(
        UA_nominal=756), Pressure1(k=375),
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
        origin={58,-100})));
  AixLib.Fluid.Movers.FlowControlled_dp    CurculationPump(redeclare package
      Medium = MediumWater, m_flow_nominal=0.5) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={58,-70})));
equation
  connect(val.port_2,CurculationPump. port_a) annotation (Line(points={{58,-90},
          {58,-80}},          color={0,127,255}));
  connect(CurculationPump.port_b, hex.port_a1) annotation (Line(points={{58,-60},
          {88,-60},{88,-20},{88,0},{80,0}},   color={0,127,255}));
  connect(hex.port_b1,val. port_3) annotation (Line(points={{60,0},{58,0},{58,
          -30},{98,-30},{98,-100},{68,-100}},
                                           color={0,127,255}));
  connect(ValveCharacteristicCurve.y[1],val. y) annotation (Line(points={{15,-110},
          {24,-110},{24,-100},{46,-100}}, color={0,0,127}));
  connect(Pressure1.y,CurculationPump. dp_in)
    annotation (Line(points={{21,-70},{46,-70},{46,-70}},   color={0,0,127}));
  connect(warmWaterSource.ports[1], val.port_1) annotation (Line(points={{60,
          -160},{60,-120},{58,-120},{58,-110}}, color={0,127,255}));
  connect(waterSink.ports[1], val.port_3) annotation (Line(points={{80,-160},{
          80,-136},{74,-136},{74,-100},{68,-100}}, color={0,127,255}));
end PreHeaterBaseClass;
