within ModelicaModels.SubsystemModels.BaseClasses;
model HeatExchangerCommunicationBaseClass
  "Base class containing the communication blocks for the heat exchanger models"

  replaceable package MediumAir = AixLib.Media.Air;
  replaceable package MediumWater = AixLib.Media.Water;

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
        origin={-76,-110})));
  Modelica.Blocks.Sources.CombiTimeTable MeasuredData(
    tableOnFile=true,
    tableName="InputTable",
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    fileName="CompleteInput.mat",
    columns=2:3)
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


  Modelica.Blocks.Math.Gain convertPercent(k=1/100) "Convert from percent"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={-100,168})));
  AixLib.Utilities.Psychrometrics.ToTotalAir toTotAir
    annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));
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
  connect(Pressure.y, x_pTphi1.p_in) annotation (Line(points={{-121,-30},{-128,-30},
          {-128,-12},{-76,-12},{-76,124},{-68,124}},
                                                   color={0,0,127}));
  connect(x_pTphi2.X[1], toDryAir.XiTotalAir)
    annotation (Line(points={{91,90},{99,90}},         color={0,0,127}));
  connect(Pressure.y, x_pTphi2.p_in) annotation (Line(points={{-121,-30},{-128,
          -30},{-128,-12},{-76,-12},{-76,70},{40,70},{40,96},{68,96}},
        color={0,0,127}));
  connect(supplyAirTemperature.T, x_pTphi2.T) annotation (Line(points={{111,48},
          {160,48},{160,74},{58,74},{58,90},{68,90}}, color={0,0,127}));
  connect(supplyAirHumidity.phi, x_pTphi2.phi) annotation (Line(points={{77,48},
          {82,48},{82,66},{64,66},{64,84},{68,84}},   color={0,0,127}));
  connect(supplyAirTemperature.T, fromKelvin.Kelvin)
    annotation (Line(points={{111,48},{174,48},{174,48}}, color={0,0,127}));
  connect(MeasuredData.y[2], convertPercent.u) annotation (Line(points={{-204.3,
          203},{-100,203},{-100,175.2}}, color={0,0,127}));
  connect(convertPercent.y, x_pTphi1.phi) annotation (Line(points={{-100,161.4},
          {-100,112},{-68,112}}, color={0,0,127}));
  connect(toTotAir.XiTotalAir, IntakeAirSource.X_in[1]) annotation (Line(points=
         {{-179,-10},{-150,-10},{-150,8},{-122,8}}, color={0,0,127}));
  connect(toTotAir.XNonVapor, IntakeAirSource.X_in[2]) annotation (Line(points={
          {-179,-14},{-150,-14},{-150,8},{-122,8}}, color={0,0,127}));
  connect(variation.y[2], toTotAir.XiDry) annotation (Line(points={{-219,140},{-208,
          140},{-208,-10},{-201,-10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-240,-200},
            {200,220}})),       Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-240,-200},{200,220}})));
end HeatExchangerCommunicationBaseClass;
