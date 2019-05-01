within ModelicaModels.SubsystemModels.DetailedModels;
model Hall_short
  extends ModelicaModels.SubsystemModels.DetailedModels.BaseClasses.HallBaseClass;

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
        origin={-150,18})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin hallTemperature1
    annotation (Placement(transformation(extent={{-128,12},{-116,24}})));
  Modelica.Blocks.Sources.Constant currentWaterTemperature(k=22)
    "Can be an iniitial value"
    annotation (Placement(transformation(extent={{-88,-110},{-68,-90}})));
  Modelica.Blocks.Sources.Constant solar(k=0)
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
equation
  connect(variation.y[1], hallTemperature1.Celsius)
    annotation (Line(points={{-139,18},{-129.2,18}}, color={0,0,127}));
  connect(IntakeAirSource.T_in, hallTemperature1.Kelvin) annotation (Line(
        points={{-102,24},{-108,24},{-108,18},{-115.4,18}}, color={0,0,127}));
  connect(waterTemperature.Celsius, currentWaterTemperature.y)
    annotation (Line(points={{-29.2,-100},{-67,-100}}, color={0,0,127}));
  connect(solar.y, SolarShare.u)
    annotation (Line(points={{21,-40},{32.8,-40}}, color={0,0,127}));
end Hall_short;
