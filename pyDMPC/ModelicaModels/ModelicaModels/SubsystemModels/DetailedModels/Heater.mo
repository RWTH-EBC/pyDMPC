within ModelicaModels.SubsystemModels.DetailedModels;
model Heater "Subsystem model of the heater"
  extends
    ModelicaModels.SubsystemModels.BaseClasses.HeatExchangerCommunicationBaseClass(
     Pressure(k=defaultPressure),
    IntakeAirSource(nPorts=1),
    IntakeAirSink(nPorts=1),
    volumeFlow(tableOnFile=false, table=[0,0.31,0.29]));

  extends ModelicaModels.Subsystems.BaseClasses.HeaterBaseClass;



  Modelica.Blocks.Sources.Constant Temperature(k=273 + 50) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-190})));
equation
  connect(hex.port_b2, supplyAirTemperature.port)
    annotation (Line(points={{80,12},{104,12},{104,38}}, color={0,127,255}));
  connect(hex.port_b2, supplyAirHumidity.port) annotation (Line(points={{80,12},
          {86,12},{86,32},{86,34},{66,34},{66,38}}, color={0,127,255}));
  connect(senTemp1.port, hex.port_b1) annotation (Line(points={{82,-122},{82,26},
          {48,26},{48,0},{60,0}},
                              color={0,127,255}));
  connect(IntakeAirSource.ports[1], hex.port_a2)
    annotation (Line(points={{-100,12},{60,12}}, color={0,127,255}));
  connect(hex.port_b2, IntakeAirSink.ports[1])
    annotation (Line(points={{80,12},{170,12}}, color={0,127,255}));
  connect(decisionVariables.y[1], gain3.u)
    annotation (Line(points={{-63,-108},{-27.2,-108}}, color={0,0,127}));
  connect(Temperature.y, warmWaterSource.T_in) annotation (Line(points={{-39,
          -190},{56,-190},{56,-182}}, color={0,0,127}));
  annotation (experiment(StopTime=3600, Interval=10));
end Heater;
