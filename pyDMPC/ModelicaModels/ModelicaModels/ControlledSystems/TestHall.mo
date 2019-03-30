within ModelicaModels.ControlledSystems;
model TestHall "Model of the test hall"
  replaceable package MediumAir = AixLib.Media.Air;
  replaceable package MediumWater = AixLib.Media.Water;
  Subsystems.Hall hall
    annotation (Placement(transformation(extent={{20,-10},{44,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T IntakeAirSource(
    nPorts=3,
    redeclare package Medium = MediumAir,
    T=30 + 273.15,
    use_T_in=true,
    use_X_in=false,
    use_m_flow_in=false,
    m_flow=8000/3600*1.2,
    X={0.003,0.997})
    annotation (Placement(transformation(extent={{-62,-10},{-42,10}})));
  AixLib.Fluid.Sensors.RelativeHumidity supplyAirHumidity(redeclare package
      Medium = MediumAir) "Relative humidity of supply air"
    annotation (Placement(transformation(extent={{-42,20},{-22,40}})));
  AixLib.Fluid.Sensors.Temperature supplyAirTemperature(redeclare package
      Medium = MediumAir) "Temperature of supply air"
    annotation (Placement(transformation(extent={{-12,20},{8,40}})));
  Modelica.Blocks.Interfaces.RealInput CCAValve "Input signal connector"
    annotation (Placement(transformation(extent={{-120,-60},{-80,-20}})));
  Modelica.Blocks.Interfaces.RealInput suppyAirTemperature
    "Prescribed fluid temperature"
    annotation (Placement(transformation(extent={{-120,-16},{-80,24}})));
  Modelica.Fluid.Sources.Boundary_pT IntakeAirSink(
    nPorts=1,
    redeclare package Medium = MediumAir,
    use_T_in=false,
    use_X_in=false,
    use_p_in=false,
    p(displayUnit="Pa") = 101300)
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Modelica.Blocks.Interfaces.RealOutput AHUTemperature
    "Temperature in port medium"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
  Modelica.Blocks.Interfaces.RealOutput AHUHumidity
    "Relative humidity in port medium"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Blocks.Interfaces.RealInput Room1Set "Input signal connector"
    annotation (Placement(transformation(extent={{-120,-90},{-80,-50}})));
  Modelica.Blocks.Interfaces.RealInput Room2Set "Input signal connector"
    annotation (Placement(transformation(extent={{-120,-110},{-80,-70}})));
  Modelica.Blocks.Sources.Constant temperature(k=293)
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Modelica.Blocks.Sources.Constant delta(k=1)
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Modelica.Blocks.Interfaces.RealOutput Room1T
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{90,-30},{110,-10}})));
  Modelica.Blocks.Interfaces.RealOutput Room1del
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Modelica.Blocks.Interfaces.RealOutput Room2T
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Interfaces.RealOutput Room2del
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin conversionAHUTemperature
    annotation (Placement(transformation(extent={{38,70},{58,90}})));
  Modelica.Blocks.Interfaces.RealInput HallSet "Input signal connector"
    annotation (Placement(transformation(extent={{-80,-110},{-40,-70}})));
  Modelica.Blocks.Sources.RealExpression wallMasses(y=hall.wallMasses.port.T)
    annotation (Placement(transformation(extent={{-10,-106},{10,-86}})));
  Modelica.Blocks.Sources.RealExpression concreteFloor(y=hall.concreteFloor.port.T)
    annotation (Placement(transformation(extent={{-10,-120},{10,-100}})));
  Modelica.Blocks.Sources.RealExpression volume(y=hall.volume.heatPort.T)
    annotation (Placement(transformation(extent={{-10,-134},{10,-114}})));
  Modelica.Blocks.Interfaces.RealOutput wallMassesT "Value of Real output"
    annotation (Placement(transformation(extent={{28,-106},{48,-86}})));
  Modelica.Blocks.Interfaces.RealOutput concreteFloorT "Value of Real output"
    annotation (Placement(transformation(extent={{28,-120},{48,-100}})));
  Modelica.Blocks.Interfaces.RealOutput volumeT "Value of Real output"
    annotation (Placement(transformation(extent={{28,-134},{48,-114}})));
equation
  connect(IntakeAirSource.ports[1], hall.port_a) annotation (Line(points={{-42,0.666667},
          {-12,0.666667},{-12,0},{20,0}}, color={0,127,255}));
  connect(hall.u1, CCAValve) annotation (Line(points={{20,-8},{0,-8},{0,-40},{-100,
          -40}}, color={0,0,127}));
  connect(IntakeAirSource.T_in, suppyAirTemperature)
    annotation (Line(points={{-64,4},{-100,4}}, color={0,0,127}));
  connect(supplyAirHumidity.port, IntakeAirSource.ports[2]) annotation (Line(
        points={{-32,20},{-32,-5.55112e-17},{-42,-5.55112e-17}}, color={0,127,255}));
  connect(supplyAirTemperature.port, IntakeAirSource.ports[3]) annotation (Line(
        points={{-2,20},{-2,-0.666667},{-42,-0.666667}}, color={0,127,255}));
  connect(hall.port_b, IntakeAirSink.ports[1])
    annotation (Line(points={{44,0},{80,0}}, color={0,127,255}));
  connect(supplyAirHumidity.phi, AHUHumidity) annotation (Line(points={{-21,30},
          {-16,30},{-16,60},{100,60}}, color={0,0,127}));
  connect(temperature.y, Room1T) annotation (Line(points={{61,-40},{76,-40},{76,
          -20},{100,-20}}, color={0,0,127}));
  connect(temperature.y, Room1del)
    annotation (Line(points={{61,-40},{100,-40}}, color={0,0,127}));
  connect(delta.y, Room2T) annotation (Line(points={{61,-70},{80,-70},{80,-60},
          {100,-60}}, color={0,0,127}));
  connect(delta.y, Room2del) annotation (Line(points={{61,-70},{80,-70},{80,-80},
          {100,-80}}, color={0,0,127}));
  connect(supplyAirTemperature.T, conversionAHUTemperature.Kelvin) annotation (
      Line(points={{5,30},{20,30},{20,80},{36,80}}, color={0,0,127}));
  connect(conversionAHUTemperature.Celsius, AHUTemperature)
    annotation (Line(points={{59,80},{100,80}}, color={0,0,127}));
  connect(wallMasses.y, wallMassesT)
    annotation (Line(points={{11,-96},{38,-96}}, color={0,0,127}));
  connect(concreteFloor.y, concreteFloorT)
    annotation (Line(points={{11,-110},{38,-110}}, color={0,0,127}));
  connect(volume.y, volumeT)
    annotation (Line(points={{11,-124},{38,-124}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestHall;
