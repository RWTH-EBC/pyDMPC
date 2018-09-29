within ModelicaModels.BaseClasses;
model ControlledSystemBaseClass "Base class of the controlled system"

  replaceable package MediumAir = AixLib.Media.Air;
  replaceable package MediumWater = AixLib.Media.Water;

  parameter Modelica.SIunits.Pressure defaultPressure=101300 "Default pressure";

  ModelicaModels.Subsystems.InOutlets inOutlets(
      defaultPressure=defaultPressure)
    annotation (Placement(transformation(extent={{-206,-20},{-126,30}})));
  ModelicaModels.Subsystems.Heater heater(
    defaultPressure=defaultPressure,
    specificCost=5,
    fileName="../HeaterCost.txt")
    annotation (Placement(transformation(extent={{78,20},{122,-22}})));
  ModelicaModels.Subsystems.PreHeater preHeater(
    defaultPressure=defaultPressure,
    fileName="../PreHeaterCost.txt",
    specificCost=5)
    annotation (Placement(transformation(extent={{-82,20},{-38,-22}})));
  ModelicaModels.Subsystems.Cooler cooler(defaultPressure=
       defaultPressure)
    annotation (Placement(transformation(extent={{-2,-19},{42,23}})));
  ModelicaModels.Subsystems.Humidifier humidifier
    annotation (Placement(transformation(extent={{158,20},{212,-24}})));
  Modelica.Fluid.Sources.MassFlowSource_T
                                      freshAirSource(
    redeclare package Medium = MediumAir,
    use_T_in=true,
    use_X_in=true,
    nPorts=1,
    use_m_flow_in=true) "Source of fresh air"
    annotation (Placement(transformation(extent={{-302,-50},{-282,-30}})));
  AixLib.Fluid.Sensors.Temperature supplyAirTemperature(redeclare package
      Medium = MediumAir) "Temperature of supply air"
    annotation (Placement(transformation(extent={{278,20},{298,40}})));
  AixLib.Fluid.Sensors.RelativeHumidity supplyHumidity(redeclare package Medium =
               MediumAir) "Relative humidity of supply air"
    annotation (Placement(transformation(extent={{250,20},{270,40}})));
  Modelica.Fluid.Sources.Boundary_pT  exhaustAirSink(
    redeclare package Medium = MediumAir,
    use_T_in=false,
    use_X_in=false,
    use_p_in=false,
    nPorts=1,
    p(displayUnit="Pa") = defaultPressure) "Sink of exhaust air"
    annotation (Placement(transformation(extent={{-300,30},{-280,50}})));
  Modelica.Fluid.Sources.MassFlowSource_T extractAirSource(
    m_flow=0.5,
    redeclare package Medium = MediumAir,
    X={0.03,0.97},
    T=30 + 273.15,
    use_X_in=true,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1) "Source of extract air"
    annotation (Placement(transformation(extent={{-80,168},{-100,188}})));
  AixLib.Fluid.FixedResistances.PressureDrop exhaustPressureDrop(m_flow_nominal=
       0.3, dp_nominal=350,redeclare package Medium =
               MediumAir) "Pressure drop in exhaust duct" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-236,20})));
  AixLib.Fluid.FixedResistances.PressureDrop supplyPressureDrop(
    m_flow_nominal=0.3,
    dp_nominal=350,
    redeclare package Medium = MediumAir) "Pressure drop in supply duct"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={236,0})));
  Modelica.Fluid.Sources.Boundary_pT supplyAirSink(
    redeclare package Medium = MediumAir,
    use_T_in=false,
    use_X_in=false,
    use_p_in=false,
    nPorts=1,
    p(displayUnit="Pa") = defaultPressure) "Sink of supply air" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={308,0})));
  Modelica.Blocks.Sources.CombiTimeTable volumeFlow(
    tableOnFile=true,
    tableName="tab1",
    columns=2:3,
    fileName="../../Inputs/volumeFlow.txt")
                                         annotation (Placement(transformation(
        extent={{-17,17},{17,-17}},
        rotation=180,
        origin={-83,-58})));
  Modelica.Blocks.Math.Product VolumeToMassFlowIntake
    annotation (Placement(transformation(extent={{-132,-94},{-152,-74}})));
  Modelica.Blocks.Sources.Constant Density(k=1.2041)
    annotation (Placement(transformation(extent={{-72,-100},{-92,-80}})));
  Modelica.Blocks.Math.Product VolumeToMassFlowIntake1
    annotation (Placement(transformation(extent={{-132,-52},{-152,-32}})));
  AixLib.Utilities.Psychrometrics.X_pTphi x_outdoor(use_p_in=false, p=
        defaultPressure) "Mass fractions of outdoor air" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-350,-50})));
  AixLib.Utilities.Psychrometrics.X_pTphi x_indoor(use_p_in=false, p=
        defaultPressure) "Mass fractions of extract air" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={28,176})));
  Modelica.Blocks.Sources.Constant Tset(k=23) annotation (Placement(
        transformation(
        extent={{13,-13},{-13,13}},
        rotation=180,
        origin={-387,-127})));
  Modelica.Blocks.Sources.Constant phiset1(
                                          k=0.5) annotation (Placement(
        transformation(
        extent={{13,-13},{-13,13}},
        rotation=180,
        origin={-323,-127})));
  AixLib.Utilities.Psychrometrics.X_pTphi x_set(use_p_in=false, p=
        defaultPressure) "Mass fractions of outdoor air" annotation (Placement(
        transformation(
        extent={{-13,13},{13,-13}},
        rotation=0,
        origin={-247,-127})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvinSet
    "Convert temperature set point to Kelvin" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-350,-96})));
  AixLib.Fluid.Sensors.Temperature heaterTemperature(redeclare package Medium =
               MediumAir) "Temperature after heater"
    annotation (Placement(transformation(extent={{144,22},{164,42}})));
  AixLib.Fluid.Sensors.RelativeHumidity heaterHumidity(redeclare package Medium =
               MediumAir) "Relative humidity after heater"
    annotation (Placement(transformation(extent={{118,24},{138,44}})));
  AixLib.Fluid.Sensors.RelativeHumidity coolerHumidity(redeclare package Medium =
               MediumAir) "Relative humidity after cooler"
    annotation (Placement(transformation(extent={{38,24},{58,44}})));
  AixLib.Fluid.Sensors.Temperature coolerTemperature(redeclare package Medium =
               MediumAir) "Temperature after cooler"
    annotation (Placement(transformation(extent={{62,22},{82,42}})));
  AixLib.Fluid.Sensors.RelativeHumidity preHeaterHumidity(redeclare package
      Medium = MediumAir) "Relative humidity after pre-heater"
    annotation (Placement(transformation(extent={{-38,20},{-18,40}})));
  AixLib.Fluid.Sensors.Temperature preHeaterTemperature(redeclare package
      Medium = MediumAir) "Temperature after pre-heater"
    annotation (Placement(transformation(extent={{-16,20},{4,40}})));
  AixLib.Fluid.Sensors.Temperature hRCTemperature(redeclare package Medium =
        MediumAir) "Temperature after HRC"
    annotation (Placement(transformation(extent={{-98,20},{-78,40}})));
  AixLib.Fluid.Sensors.RelativeHumidity hRCHumidity(redeclare package Medium =
        MediumAir) "Relative humidity after HRC"
    annotation (Placement(transformation(extent={{-126,24},{-106,44}})));
equation
  connect(inOutlets.portSupplyAirOut, preHeater.portSupplyAirIn) annotation (
      Line(points={{-126.358,0.25},{-105.179,0.25},{-105.179,-0.16},{-117.64,
          -0.16}},
        color={0,127,255}));
  connect(preHeater.portSupplyAirOut, cooler.portSupplyAirIn) annotation (Line(
        points={{-7.2,-0.16},{-37.64,-0.16},{-37.64,1.16}},color={0,127,255}));
  connect(cooler.portSupplyAirOut, heater.portSupplyAirIn) annotation (Line(
        points={{72.8,1.16},{62,-0.16},{42.36,-0.16}},  color={0,127,255}));
  connect(heater.portSupplyAirOut, humidifier.portSupplyAirIn) annotation (Line(
        points={{152.8,-0.16},{142,0.4},{157.8,0.4}},       color={0,127,255}));
  connect(inOutlets.portExhaustAirOut, exhaustPressureDrop.port_a) annotation (
      Line(points={{-205.701,20.5625},{-214.851,20.5625},{-214.851,20},{-226,20}},
        color={0,127,255}));
  connect(exhaustPressureDrop.port_b, exhaustAirSink.ports[1]) annotation (Line(
        points={{-246,20},{-264,20},{-264,40},{-280,40}}, color={0,127,255}));
  connect(humidifier.portSupplyAirOut, supplyPressureDrop.port_a) annotation (
      Line(points={{208,0.4},{217,0.4},{217,0},{226,0}}, color={0,127,255}));
  connect(extractAirSource.ports[1], inOutlets.portExtractAirIn) annotation (
      Line(points={{-100,178},{-112,178},{-112,19.8125},{-126.06,19.8125}},
        color={0,127,255}));
  connect(freshAirSource.ports[1], inOutlets.portSupplyAirIn) annotation (Line(
        points={{-282,-40},{-246,-40},{-246,0.375},{-205.761,0.375}}, color={0,
          127,255}));
  connect(supplyPressureDrop.port_b, supplyAirSink.ports[1])
    annotation (Line(points={{246,0},{298,0}}, color={0,127,255}));
  connect(supplyHumidity.port, supplyPressureDrop.port_b)
    annotation (Line(points={{260,20},{260,0},{246,0}}, color={0,127,255}));
  connect(supplyAirTemperature.port, supplyPressureDrop.port_b)
    annotation (Line(points={{288,20},{288,0},{246,0}}, color={0,127,255}));
  connect(volumeFlow.y[1], VolumeToMassFlowIntake.u1) annotation (Line(points={
          {-101.7,-58},{-114,-58},{-114,-78},{-128,-78},{-128,-78},{-130,-78},{
          -130,-78}}, color={0,0,127}));
  connect(VolumeToMassFlowIntake.y, freshAirSource.m_flow_in) annotation (Line(
        points={{-153,-84},{-324,-84},{-324,-32},{-302,-32}}, color={0,0,127}));
  connect(Density.y, VolumeToMassFlowIntake.u2) annotation (Line(points={{-93,
          -90},{-110,-90},{-130,-90}}, color={0,0,127}));
  connect(volumeFlow.y[2], VolumeToMassFlowIntake1.u1) annotation (Line(points=
          {{-101.7,-58},{-114,-58},{-114,-36},{-130,-36}}, color={0,0,127}));
  connect(Density.y, VolumeToMassFlowIntake1.u2) annotation (Line(points={{-93,
          -90},{-122,-90},{-122,-48},{-130,-48}}, color={0,0,127}));
  connect(VolumeToMassFlowIntake1.y, extractAirSource.m_flow_in) annotation (
      Line(points={{-153,-42},{-182,-42},{-182,-24},{-22,-24},{-22,186},{-80,
          186}}, color={0,0,127}));
  connect(x_outdoor.X, freshAirSource.X_in) annotation (Line(points={{-339,-50},
          {-312,-50},{-312,-44},{-304,-44}}, color={0,0,127}));
  connect(x_indoor.X, extractAirSource.X_in) annotation (Line(points={{17,176},
          {-30,176},{-30,174},{-78,174}}, color={0,0,127}));
  connect(phiset1.y, x_set.phi) annotation (Line(points={{-308.7,-127},{-290,
          -127},{-290,-119.2},{-262.6,-119.2}}, color={0,0,127}));
  connect(Tset.y, toKelvinSet.Celsius) annotation (Line(points={{-372.7,-127},{
          -366,-127},{-366,-96},{-362,-96}}, color={0,0,127}));
  connect(toKelvinSet.Kelvin, x_set.T) annotation (Line(points={{-339,-96},{
          -280,-96},{-280,-127},{-262.6,-127}}, color={0,0,127}));
  connect(heaterTemperature.port, heater.portSupplyAirOut) annotation (Line(
        points={{154,22},{154,-0.16},{152.8,-0.16}},
                                               color={0,127,255}));
  connect(heaterHumidity.port, heater.portSupplyAirOut) annotation (Line(points={{128,24},
          {128,24},{128,-0.16},{152.8,-0.16}},    color={0,127,255}));
  connect(coolerHumidity.port, cooler.portSupplyAirOut) annotation (Line(points={{48,24},
          {52,24},{52,6},{52,1.16},{72.8,1.16}},     color={0,127,255}));
  connect(coolerTemperature.port, cooler.portSupplyAirOut)
    annotation (Line(points={{72,22},{72,1.16},{72.8,1.16}},
                                                         color={0,127,255}));
  connect(preHeaterHumidity.port, preHeater.portSupplyAirOut) annotation (Line(
        points={{-28,20},{-28,-0.16},{-7.2,-0.16}},
                                               color={0,127,255}));
  connect(preHeaterTemperature.port, preHeater.portSupplyAirOut)
    annotation (Line(points={{-6,20},{-6,-0.16},{-7.2,-0.16}},
                                                          color={0,127,255}));
  connect(hRCTemperature.port, inOutlets.portSupplyAirOut) annotation (Line(
        points={{-88,20},{-88,0.25},{-126.358,0.25}}, color={0,127,255}));
  connect(hRCHumidity.port, inOutlets.portSupplyAirOut) annotation (Line(points={{-116,24},
          {-116,24},{-116,10},{-116,0.25},{-126.358,0.25}},           color={0,
          127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-400,
            -140},{380,220}})),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-400,-140},{380,220}}), graphics={         Text(
            extent={{-560,146},{-572,94}},
            lineColor={238,46,47},
            horizontalAlignment=TextAlignment.Left,
          textString="Measurement Data

1: outside air temperature
2: outside air rel.humidity
3: exhaust air temperature
4: exhaust air rel.humidity
5: outgoing air temperature
6: outgoing air rel.humidity
7: supply air temperature
8: supply rel.humidity
9: temperature after pre-heater
10: temperature after cooler
11: temperature after heater
12: temperature water pre-heater
13: temperature water cooler
14: temperature water heater
15: water return pre-heater
16: water return heater
17: Temperature after recuperator
18: Humidity after recuperator")}));
end ControlledSystemBaseClass;
