within ModelicaModels.Tests.TestHall;
model HallCalibrationNominal
  "Calibration of the hall model in conditions for nominal heating power"
  extends ModelicaModels.Subsystems.TestHall.BaseClasses.HallCalibrationBaseClass;
  Modelica.Blocks.Sources.Constant supplyAirTemperature(k=20)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Blocks.Sources.Constant outdoorAirTemperature(k=-12)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.Constant TABSTemperature(k=40)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.Constant supplyAirVolumeFlow(k=8000)
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
equation
  connect(TABSTemperature.y, hall.CCA_SEN_T__WS_SUP__AI_U_C) annotation (Line(
        points={{-79,-90},{-20.5,-90},{-20.5,-9.8},{-12,-9.8}}, color={0,0,127}));
  connect(supplyAirTemperature.y, toKelvin.Celsius) annotation (Line(points={{
          -79,-50},{-48,-50},{-48,-31.2}}, color={0,0,127}));
  connect(outdoorAirTemperature.y, hall.AIR_AHU_SEN_T_AIR_ODA__AI_U__C)
    annotation (Line(points={{-79,50},{-20,50},{-20,7},{-12,7}}, color={0,0,127}));
  connect(supplyAirVolumeFlow.y, gain.u) annotation (Line(points={{-79,10},{-66,
          10},{-66,12},{-54.8,12}}, color={0,0,127}));
  connect(supplyAirTemperature.y, feedback1.u1)
    annotation (Line(points={{-79,-50},{18,-50}}, color={0,0,127}));
  annotation (experiment(StopTime=300000, Interval=10));
end HallCalibrationNominal;
