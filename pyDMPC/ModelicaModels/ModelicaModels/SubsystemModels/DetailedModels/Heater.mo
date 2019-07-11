within ModelicaModels.SubsystemModels.DetailedModels;
model Heater "Subsystem model of the heater"
  extends
    ModelicaModels.SubsystemModels.BaseClasses.HeatExchangerCommunicationBaseClass(
     Pressure(k=defaultPressure),
    IntakeAirSource(nPorts=1),
    IntakeAirSink(nPorts=1),
    volumeFlow(tableOnFile=false, table=[0,0.31,0.29]));

  extends ModelicaModels.Subsystems.BaseClasses.HeaterBaseClass;



  Modelica.Blocks.Sources.Constant mas1(k=0.4) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-230,-50})));
  Modelica.Blocks.Sources.Constant mas2(k=0.4) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-230,-90})));
  Modelica.Blocks.Sources.Constant mas3(k=0.4) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-230,-130})));
  Modelica.Blocks.Sources.Constant mas4(k=0.4) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-230,-170})));
equation
  connect(hex.port_b2, supplyAirTemperature.port)
    annotation (Line(points={{8,70},{104,70},{104,38}},  color={0,127,255}));
  connect(hex.port_b2, supplyAirHumidity.port) annotation (Line(points={{8,70},{
          86,70},{86,32},{86,34},{66,34},{66,38}},  color={0,127,255}));
  connect(IntakeAirSource.ports[1], hex.port_a2)
    annotation (Line(points={{-100,12},{-56,12},{-56,70},{-12,70}},
                                                 color={0,127,255}));
  connect(hex.port_b2, IntakeAirSink.ports[1])
    annotation (Line(points={{8,70},{90,70},{90,12},{170,12}},
                                                color={0,127,255}));
  connect(decisionVariables.y[1], convertCommand.u) annotation (Line(points={{
          -65,-110},{-54,-110},{-54,-68},{-114,-68},{-114,-50},{-103.2,-50}},
        color={0,0,127}));
  annotation (experiment(StopTime=3600, Interval=10));
end Heater;
