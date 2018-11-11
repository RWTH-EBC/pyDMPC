within ModelicaModels.Subsystems.BaseClasses;
model CoolerBaseClass "Base class of the cooler"
  extends
    ModelicaModels.Subsystems.BaseClasses.HeatExchangerBaseClass(
    hex(UA_nominal=1250),
    Pressure1(k=80000),
    warmWaterSource(p=waterSink.p + Pressure1.k, nPorts=1),
    ValveCharacteristicCurve(tableOnFile=false, table=[0,0; 1.0,1.0]),
    waterSink(nPorts=1),
    Temperature(k=273.15 + 12));
  AixLib.Fluid.Actuators.Valves.TwoWayLinear    CoolerValve(
    redeclare package Medium = MediumWater,
    m_flow_nominal=0.5,
    dpValve_nominal=2000)
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={12,0})));
equation
  connect(ValveCharacteristicCurve.y[1],CoolerValve. y) annotation (Line(points={{-59,-50},
          {-30,-50},{-30,8.88178e-16},{0,8.88178e-16}},
                                                  color={0,0,127}));
  connect(hex.port_b1, waterSink.ports[1]) annotation (Line(points={{-12,58},{
          -20,58},{-20,-72},{8,-72},{8,-102}}, color={0,127,255}));
  connect(CoolerValve.port_a, warmWaterSource.ports[1]) annotation (Line(points=
         {{12,-10},{12,-24},{-12,-24},{-12,-102}}, color={0,127,255}));
  connect(CoolerValve.port_b, hex.port_a1)
    annotation (Line(points={{12,10},{12,58},{8,58}}, color={0,127,255}));
  connect(hex.port_b1, senTemp1.port) annotation (Line(points={{-12,58},{-20,58},
          {-20,-72},{10,-72},{10,-64}}, color={0,127,255}));
end CoolerBaseClass;
