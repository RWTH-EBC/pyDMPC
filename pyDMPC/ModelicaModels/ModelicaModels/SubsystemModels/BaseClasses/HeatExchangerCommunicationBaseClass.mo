within ModelicaModels.SubsystemModels.BaseClasses;
model HeatExchangerCommunicationBaseClass
  "Base class containing the communication blocks for the heat exchanger models"

  extends ModelicaModels.BaseClasses.BaseClass;

  parameter String resultFileName="HexResult.txt"
    "File on which data is present";
  parameter String header="Objective function value" "Header for result file";

  Modelica.Fluid.Sources.MassFlowSource_T IntakeAirSource(
    m_flow=0.5,
    redeclare package Medium = MediumAir,
    X={0.03,0.97},
    T=30 + 273.15,
    use_X_in=true,
    use_T_in=true,
    use_m_flow_in=true)
    annotation (Placement(transformation(extent={{-120,2},{-100,22}})));
  Modelica.Fluid.Sources.Boundary_pT IntakeAirSink(
    redeclare package Medium = MediumAir,
    use_T_in=false,
    use_X_in=false,
    use_p_in=false,
    p(displayUnit="Pa") = 101300)
    annotation (Placement(transformation(extent={{190,2},{170,22}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-190,110})));
  Modelica.Blocks.Math.Product VolumeToMassFlowIntake
    annotation (Placement(transformation(extent={{-120,80},{-140,100}})));
  Modelica.Blocks.Sources.Constant Pressure(k=defaultPressure)
    annotation (Placement(transformation(extent={{-100,-20},{-120,-40}})));
  Modelica.Blocks.Sources.Constant Density(k=1.2041)
    annotation (Placement(transformation(extent={{-80,60},{-100,80}})));

  Modelica.Blocks.Sources.CombiTimeTable decisionVariables(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    tableName="tab1",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    columns={2},
    fileName="decisionVariables.mat")
    "Table with decision variables"              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,-108})));
  Modelica.Blocks.Sources.CombiTimeTable MeasuredData(
    tableOnFile=true,
    tableName="InputTable",
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    columns=2:19,
    fileName="../Inputs/CompleteInput.mat")
    annotation (Placement(transformation(extent={{-240,186},{-206,220}})));
  Modelica.Blocks.Sources.CombiTimeTable volumeFlow(
    tableOnFile=true,
    tableName="tab1",
    columns=2:3,
    fileName="../Inputs/volumeFlow.txt") annotation (Placement(transformation(
        extent={{-17,17},{17,-17}},
        rotation=180,
        origin={17,96})));
  Modelica.Blocks.Sources.CombiTimeTable variation(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    tableName="tab1",
    columns=2:3,
    fileName="variation.mat")       "Table with control input"
                                                            annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-230,140})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin3 annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-132,170})));
  AixLib.Utilities.Psychrometrics.X_pTphi x_pTphi1
    annotation (Placement(transformation(extent={{-66,108},{-46,128}})));
  AixLib.Utilities.Psychrometrics.X_pTphi x_pTphi2
    annotation (Placement(transformation(extent={{70,80},{90,100}})));
  AixLib.Utilities.Psychrometrics.ToDryAir toDryAir
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Math.Add add4(k2=-1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-188,162})));
  Modelica.Blocks.Sources.Constant phiset1(k=1)  annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-156,220})));

  AixLib.Fluid.Sensors.RelativeHumidity supplyAirHumidity(redeclare package
      Medium = MediumAir) "Relative humidity of supply air"
    annotation (Placement(transformation(extent={{56,38},{76,58}})));
  AixLib.Fluid.Sensors.Temperature supplyAirTemperature(redeclare package
      Medium = MediumAir) "Temperature of supply air"
    annotation (Placement(transformation(extent={{94,38},{114,58}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin fromKelvin annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={186,48})));


equation



  connect(VolumeToMassFlowIntake.y, IntakeAirSource.m_flow_in) annotation (
      Line(points={{-141,90},{-150,90},{-150,20},{-120,20}}, color={0,0,127}));
  connect(toKelvin.Kelvin, IntakeAirSource.T_in) annotation (Line(points={{-190,99},
          {-190,16},{-122,16}},     color={0,0,127}));
  connect(Density.y, VolumeToMassFlowIntake.u2) annotation (Line(points={{-101,70},
          {-110,70},{-110,84},{-118,84}},     color={0,0,127}));
  connect(volumeFlow.y[1], VolumeToMassFlowIntake.u1) annotation (Line(points={{-1.7,96},
          {-1.7,96},{-118,96}},            color={0,0,127}));
  connect(variation.y[1], toKelvin.Celsius) annotation (Line(points={{-219,140},
          {-190,140},{-190,122}}, color={0,0,127}));
  connect(MeasuredData.y[1], toKelvin3.Celsius) annotation (Line(points={{-204.3,
          203},{-132,203},{-132,182}}, color={0,0,127}));
  connect(toKelvin3.Kelvin, x_pTphi1.T) annotation (Line(points={{-132,159},{-132,
          159},{-132,132},{-132,118},{-68,118}}, color={0,0,127}));
  connect(MeasuredData.y[2], x_pTphi1.phi) annotation (Line(points={{-204.3,203},
          {-100,203},{-100,112},{-68,112}}, color={0,0,127}));
  connect(Pressure.y, x_pTphi1.p_in) annotation (Line(points={{-121,-30},{-128,-30},
          {-128,-12},{-76,-12},{-76,124},{-68,124}},
                                                   color={0,0,127}));
  connect(x_pTphi2.X[1], toDryAir.XiTotalAir)
    annotation (Line(points={{91,90},{99,90}},         color={0,0,127}));
  connect(Pressure.y, x_pTphi2.p_in) annotation (Line(points={{-121,-30},{-128,
          -30},{-128,-12},{-76,-12},{-76,70},{40,70},{40,96},{68,96}},
        color={0,0,127}));
  connect(phiset1.y, add4.u1) annotation (Line(points={{-167,220},{-182,220},{-182,
          174}},      color={0,0,127}));
  connect(add4.y, IntakeAirSource.X_in[2]) annotation (Line(points={{-188,151},{
          -188,151},{-188,146},{-182,146},{-182,8},{-122,8}}, color={0,0,127}));
  connect(variation.y[2], IntakeAirSource.X_in[1]) annotation (Line(points={{-219,
          140},{-206,140},{-206,8},{-122,8}}, color={0,0,127}));
  connect(variation.y[2], add4.u2) annotation (Line(points={{-219,140},{-206,140},
          {-206,182},{-194,182},{-194,174}}, color={0,0,127}));
  connect(supplyAirTemperature.T, x_pTphi2.T) annotation (Line(points={{111,48},
          {160,48},{160,74},{58,74},{58,90},{68,90}}, color={0,0,127}));
  connect(supplyAirHumidity.phi, x_pTphi2.phi) annotation (Line(points={{77,48},
          {82,48},{82,66},{64,66},{64,84},{68,84}},   color={0,0,127}));
  connect(supplyAirTemperature.T, fromKelvin.Kelvin)
    annotation (Line(points={{111,48},{174,48},{174,48}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -200},{500,220}})), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-240,-200},{500,220}}), graphics={Text(
            extent={{-392,208},{-404,156}},
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
end HeatExchangerCommunicationBaseClass;
