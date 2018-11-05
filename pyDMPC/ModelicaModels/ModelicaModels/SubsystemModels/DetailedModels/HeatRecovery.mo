within ModelicaModels.SubsystemModels.DetailedModels;
model HeatRecovery "Detailed model of heat recovery system"

  extends
    ModelicaModels.SubsystemModels.BaseClasses.HeatExchangerCommunicationBaseClass(
     Pressure(k=system.p_ambient),
    IntakeAirSink(nPorts=1),
    volumeFlow(tableOnFile=false, table=[0,0.31,0.29]),
    MeasuredData(columns=2:5),
    IntakeAirSource(nPorts=1));

  extends ModelicaModels.Subsystems.BaseClasses.HRCBaseClass;
  Modelica.Fluid.Sources.MassFlowSource_T extractAirSource(
    m_flow=0.5,
    redeclare package Medium = MediumAir,
    X={0.03,0.97},
    T=30 + 273.15,
    use_X_in=true,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1) "Source of extract air"
    annotation (Placement(transformation(extent={{80,126},{60,146}})));
  Modelica.Blocks.Math.Product VolumeToMassFlowOutgoing
    annotation (Placement(transformation(extent={{40,170},{60,190}})));
  AixLib.Utilities.Psychrometrics.X_pTphi x_pTphi_Etr(                p=
        defaultPressure, use_p_in=true)
                         "Absolute Humidity of extract air"
    annotation (Placement(transformation(extent={{180,120},{160,100}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin_extractTemperature
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={194,168})));
  Modelica.Blocks.Sources.Constant density(k=1.2) "Default density" annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={10,170})));
  Modelica.Blocks.Math.Gain convertPercent1(k=1/100) "Convert from percent"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={160,168})));
  Modelica.Fluid.Sources.Boundary_pT ExhaustAirSink(
    nPorts=1,
    redeclare package Medium = MediumAir,
    use_T_in=false,
    use_X_in=false,
    use_p_in=false,
    p(displayUnit="Pa") = 101300)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-164,140})));
equation
  connect(VolumeToMassFlowOutgoing.y,extractAirSource. m_flow_in) annotation (
      Line(points={{61,180},{94,180},{94,144},{80,144}}, color={0,0,127}));
  connect(x_pTphi_Etr.X,extractAirSource. X_in) annotation (Line(points={{159,110},
          {100,110},{100,132},{82,132}},
                                       color={0,0,127}));
  connect(toKelvin_extractTemperature.Kelvin,extractAirSource. T_in)
    annotation (Line(points={{194,157},{194,140},{82,140}},        color={0,0,127}));
  connect(toKelvin_extractTemperature.Kelvin,x_pTphi_Etr. T)
    annotation (Line(points={{194,157},{194,110},{182,110}},
                                                          color={0,0,127}));
  connect(IntakeHex.port_b2, IntakeAirSink.ports[1]) annotation (Line(points={{8,-90},
          {150,-90},{150,12},{170,12}},         color={0,127,255}));
  connect(IntakeHex.port_b2, supplyAirTemperature.port) annotation (Line(points={{8,-90},
          {106,-90},{106,38},{104,38}},          color={0,127,255}));
  connect(supplyAirHumidity.port, IntakeHex.port_b2)
    annotation (Line(points={{66,38},{66,-90},{8,-90}},  color={0,127,255}));
  connect(volumeFlow.y[2], VolumeToMassFlowOutgoing.u1) annotation (Line(points=
         {{-1.7,96},{-20,96},{-20,186},{38,186}}, color={0,0,127}));
  connect(density.y, VolumeToMassFlowOutgoing.u2) annotation (Line(points={{21,
          170},{28,170},{28,174},{38,174}}, color={0,0,127}));
  connect(MeasuredData.y[3], toKelvin_extractTemperature.Celsius) annotation (
      Line(points={{-204.3,203},{194,203},{194,180}}, color={0,0,127}));
  connect(Pressure.y, x_pTphi_Etr.p_in) annotation (Line(points={{-121,-30},{
          -128,-30},{-128,-140},{200,-140},{200,104},{182,104}}, color={0,0,127}));
  connect(MeasuredData.y[4], convertPercent1.u) annotation (Line(points={{
          -204.3,203},{160,203},{160,175.2}}, color={0,0,127}));
  connect(convertPercent1.y, x_pTphi_Etr.phi) annotation (Line(points={{160,
          161.4},{160,130},{190,130},{190,116},{182,116}}, color={0,0,127}));
  connect(decisionVariables.y[1], convertCommand.u) annotation (Line(points={{
          -65,-110},{-50,-110},{-50,-82},{-116,-82},{-116,-50},{-103.2,-50}},
        color={0,0,127}));
  connect(IntakeAirSource.ports[1], IntakeHex.port_a2) annotation (Line(points=
          {{-100,12},{-40,12},{-40,-90},{-12,-90}}, color={0,127,255}));
  connect(extractAirSource.ports[1], hex.port_b2) annotation (Line(points={{60,
          136},{40,136},{40,70},{8,70}}, color={0,127,255}));
  connect(ExhaustAirSink.ports[1], OutgoingAirOutletTemp.port_b) annotation (
      Line(points={{-154,140},{-74,140},{-74,76},{-44,76}}, color={0,127,255}));
  connect(OutgoingAirOutletTemp.port_a, hex.port_a2)
    annotation (Line(points={{-24,76},{-12,76},{-12,70}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatRecovery;
