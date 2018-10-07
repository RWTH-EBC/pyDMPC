within ModelicaModels.Subsystems.BaseClasses;
model CoolerBaseClass "Base class of the cooler"
  extends
    ModelicaModels.Subsystems.BaseClasses.HeatExchangerBaseClass(
    hex(UA_nominal=1250),
    Pressure1(k=80000),
    warmWaterSource(p=waterSink.p + Pressure1.k, nPorts=1),
    ValveCharacteristicCurve(tableOnFile=false,
    table=[0,0; 0.25,0.0625; 0.5,0.55; 0.7,1; 0.9,1; 1,1]),
    waterSink(nPorts=1));
  AixLib.Fluid.Actuators.Valves.TwoWayLinear    CoolerValve(
    redeclare package Medium = MediumWater,
    m_flow_nominal=0.5,
    dpValve_nominal=2000)
                        annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={104,-78})));
equation
  connect(ValveCharacteristicCurve.y[1],CoolerValve. y) annotation (Line(points={{15,-110},
          {52,-110},{52,-78},{92,-78}},           color={0,0,127}));
  connect(hex.port_b1, CoolerValve.port_a) annotation (Line(points={{60,0},{50,
          0},{50,-38},{104,-38},{104,-68}}, color={0,127,255}));
  connect(warmWaterSource.ports[1], CoolerValve.port_b) annotation (Line(points=
         {{60,-160},{60,-94},{104,-94},{104,-88}}, color={0,127,255}));
  connect(hex.port_a1, waterSink.ports[1]) annotation (Line(points={{80,0},{138,
          0},{138,-144},{80,-144},{80,-160}}, color={0,127,255}));
end CoolerBaseClass;
