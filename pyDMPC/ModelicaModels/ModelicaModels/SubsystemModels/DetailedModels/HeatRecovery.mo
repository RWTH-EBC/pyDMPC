within ModelicaModels.SubsystemModels.DetailedModels;
model HeatRecovery "Detailed model of heat recovery system"

  extends
    ModelicaModels.SubsystemModels.BaseClasses.HeatExchangerCommunicationBaseClass(
     Pressure(k=system.p_ambient),
    IntakeAirSource(nPorts=1),
    IntakeAirSink(nPorts=2));

  extends ModelicaModels.Subsystems.BaseClasses.HRCBaseClass(
      ValveCharacteristicCurve(fileName="HrcValve.txt"));
  Modelica.Fluid.Sources.MassFlowSource_T extractAirSource(
    m_flow=0.5,
    redeclare package Medium = MediumAir,
    X={0.03,0.97},
    T=30 + 273.15,
    use_X_in=true,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1) "Source of extract air"
    annotation (Placement(transformation(extent={{304,50},{284,70}})));
  Modelica.Blocks.Math.Product VolumeToMassFlowOutgoing
    annotation (Placement(transformation(extent={{324,78},{344,98}})));
  AixLib.Utilities.Psychrometrics.X_pTphi x_pTphi_Etr(use_p_in=false, p=
        defaultPressure) "Absolute Humidity of extract air"
    annotation (Placement(transformation(extent={{344,38},{324,18}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin_extractTemperature
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={384,88})));
  Modelica.Blocks.Sources.Constant Pressure1(k=defaultPressure)
    "Default pressure"
    annotation (Placement(transformation(extent={{384,0},{364,20}})));
  Modelica.Blocks.Sources.Constant density(k=1.2) "Default density" annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={234,100})));
equation
  connect(decisionVariables.y[1], gain2.u) annotation (Line(points={{-63,-108},
          {-42,-108},{-42,-126},{-144,-126},{-144,-2},{-102,-2},{-102,0}},
        color={0,0,127}));
  connect(IntakeAirSource.ports[1], outsideAirInletValve.port_a) annotation (
      Line(points={{-100,12},{-88,12},{-88,36},{-334,36},{-334,-60},{-320,-60}},
        color={0,127,255}));
  connect(outletValve.port_b, IntakeAirSink.ports[1]) annotation (Line(points={
          {-320,60},{-350,60},{-350,62},{-388,62},{-388,270},{148,270},{148,12},
          {170,12}}, color={0,127,255}));
  connect(MeasuredData.y[5],toKelvin_extractTemperature. Celsius) annotation (
      Line(points={{-204.3,203},{-558,203},{-558,328},{384,328},{384,100}},
        color={0,0,127}));
  connect(VolumeToMassFlowOutgoing.y,extractAirSource. m_flow_in) annotation (
      Line(points={{345,88},{354,88},{354,68},{304,68}}, color={0,0,127}));
  connect(x_pTphi_Etr.X,extractAirSource. X_in) annotation (Line(points={{323,28},
          {314,28},{314,56},{306,56}}, color={0,0,127}));
  connect(toKelvin_extractTemperature.Kelvin,extractAirSource. T_in)
    annotation (Line(points={{384,77},{384,77},{384,64},{306,64}}, color={0,0,127}));
  connect(toKelvin_extractTemperature.Kelvin,x_pTphi_Etr. T)
    annotation (Line(points={{384,77},{384,28},{346,28}}, color={0,0,127}));
  connect(density.y, VolumeToMassFlowOutgoing.u2) annotation (Line(points={{245,
          100},{270,100},{270,82},{322,82}}, color={0,0,127}));
  connect(x_pTphi_Etr.phi, MeasuredData.y[6]) annotation (Line(points={{346,34},
          {366,34},{366,242},{-192,242},{-192,203},{-204.3,203}}, color={0,0,
          127}));
  connect(OutgoingHex.port_a2, extractAirSource.ports[1]) annotation (Line(
        points={{20,60},{50,60},{50,136},{200,136},{200,60},{284,60}}, color={0,
          127,255}));
  connect(IntakeHex.port_b2, IntakeAirSink.ports[2]) annotation (Line(points={{
          20,-60},{150,-60},{150,12},{170,12}}, color={0,127,255}));
  connect(IntakeHex.port_b2, supplyAirTemperature.port) annotation (Line(points=
         {{20,-60},{106,-60},{106,38},{104,38}}, color={0,127,255}));
  connect(supplyAirHumidity.port, IntakeHex.port_b2)
    annotation (Line(points={{66,38},{66,-60},{20,-60}}, color={0,127,255}));
  connect(volumeFlow.y[2], VolumeToMassFlowOutgoing.u1) annotation (Line(points=
         {{-1.7,96},{-36,96},{-36,148},{292,148},{292,94},{322,94}}, color={0,0,
          127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{252,204},{264,186}},
          lineColor={28,108,200},
          textString="1: Supply
2: Exhaust",
          horizontalAlignment=TextAlignment.Left)}));
end HeatRecovery;
