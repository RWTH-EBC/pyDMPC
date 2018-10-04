within ModelicaModels.SubsystemModels.DetailedModels;
model PreHeater "Detailed model of the pre heater"

  extends
    ModelicaModels.SubsystemModels.BaseClasses.HeatExchangerCommunicationBaseClass(
     Pressure(k=defaultPressure),
    IntakeAirSource(nPorts=1),
    IntakeAirSink(nPorts=1));

  extends
    ModelicaModels.Subsystems.BaseClasses.PreHeaterBaseClass(
      ValveCharacteristicCurve(fileName="PreHeaterValve.txt"));

  Modelica.Blocks.Sources.Constant Temperature(k=273 + 50) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-190})));
equation
  connect(decisionVariables.y[1], gain3.u)
    annotation (Line(points={{-63,-108},{-27.2,-108}}, color={0,0,127}));
  connect(IntakeAirSource.ports[1], hex.port_a2)
    annotation (Line(points={{-100,12},{60,12}}, color={0,127,255}));
  connect(hex.port_b2, IntakeAirSink.ports[1])
    annotation (Line(points={{80,12},{170,12}}, color={0,127,255}));
  connect(senTemp1.port, hex.port_a1) annotation (Line(points={{82,-122},{82,
          -128},{130,-128},{130,0},{80,0}}, color={0,127,255}));
  connect(supplyAirHumidity.port, hex.port_b2) annotation (Line(points={{66,38},
          {66,28},{80,28},{80,12}}, color={0,127,255}));
  connect(supplyAirTemperature.port, hex.port_b2) annotation (Line(points={{104,
          38},{104,30},{80,30},{80,12}}, color={0,127,255}));
  connect(Temperature.y, warmWaterSource.T_in) annotation (Line(points={{-39,
          -190},{56,-190},{56,-182}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PreHeater;
