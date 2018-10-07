within ModelicaModels.SubsystemModels.DetailedModels;
model Humidifier "Detailed model of the humidifier"

    extends
    ModelicaModels.SubsystemModels.BaseClasses.HeatExchangerCommunicationBaseClass(
     Pressure(k=system.p_ambient),
    IntakeAirSource(nPorts=1),
    IntakeAirSink(nPorts=1),
    volumeFlow(tableOnFile=false, table=[0,0.31,0.29]));

  extends
    ModelicaModels.Subsystems.BaseClasses.HumidifierBaseClass(vol(nPorts=5),
      SteamSource(nPorts=1));
equation
  connect(vol.ports[1], IntakeAirSource.ports[1]) annotation (Line(points={{-40,
          -40},{-42,-40},{-42,-50},{-66,-50},{-66,12},{-100,12}}, color={0,127,
          255}));
  connect(vol.ports[2], IntakeAirSink.ports[1]) annotation (Line(points={{-40,
          -40},{-40,-50},{80,-50},{80,12},{170,12}}, color={0,127,255}));
  connect(vol.ports[3], SteamSource.ports[1]) annotation (Line(points={{-40,-40},
          {-28,-40},{-28,-140},{40,-140}}, color={0,127,255}));
  connect(supplyAirHumidity.port, vol.ports[4]) annotation (Line(points={{66,38},
          {66,-54},{-40,-54},{-40,-40}}, color={0,127,255}));
  connect(supplyAirTemperature.port, vol.ports[5]) annotation (Line(points={{
          104,38},{104,-54},{-40,-54},{-40,-40}}, color={0,127,255}));
  connect(decisionVariables.y[1], gain.u) annotation (Line(points={{-63,-108},{
          236,-108},{236,-130},{176,-130}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment,
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=false,
      OutputFlatModelica=false));
end Humidifier;
