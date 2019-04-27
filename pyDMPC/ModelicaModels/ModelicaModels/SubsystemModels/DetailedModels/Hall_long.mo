within ModelicaModels.SubsystemModels.DetailedModels;
model Hall_long
  extends ModelicaModels.SubsystemModels.DetailedModels.BaseClasses.HallBaseClass;

  Modelica.Blocks.Sources.Constant Tnormal(k=273 + 22)
    "Average Temperature of supply air or forecast"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=35 -
        decisionVariables.y[1])
    annotation (Placement(transformation(extent={{-110,-110},{-44,-90}})));
equation
  connect(Tnormal.y, IntakeAirSource.T_in) annotation (Line(points={{-139,20},{
          -120,20},{-120,24},{-102,24}}, color={0,0,127}));
  connect(realExpression.y, waterTemperature.Celsius)
    annotation (Line(points={{-40.7,-100},{-29.2,-100}}, color={0,0,127}));
  annotation (experiment(StopTime=172800, Interval=10));
end Hall_long;
