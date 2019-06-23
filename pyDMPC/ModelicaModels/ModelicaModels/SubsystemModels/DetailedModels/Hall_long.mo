within ModelicaModels.SubsystemModels.DetailedModels;
model Hall_long
  extends ModelicaModels.SubsystemModels.DetailedModels.BaseClasses.HallBaseClass;

  Modelica.Blocks.Sources.Constant Tnormal(k=273 + 22)
    "Average Temperature of supply air or forecast"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Modelica.Blocks.Sources.Constant solar(k=0)
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=35 -
        decisionVariables.y[1])
    annotation (Placement(transformation(extent={{-106,-110},{-50,-92}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor FloorConductor(G=10000)
    "Conducts heat from floor to air"
    annotation (Placement(transformation(extent={{98,-160},{118,-140}})));
equation
  connect(Tnormal.y, IntakeAirSource.T_in) annotation (Line(points={{-139,20},{
          -120,20},{-120,24},{-102,24}}, color={0,0,127}));
  connect(solar.y, SolarShare.u)
    annotation (Line(points={{21,-40},{32.8,-40}}, color={0,0,127}));
  connect(realExpression.y, waterTemperature.Celsius) annotation (Line(points={
          {-47.2,-101},{-37.6,-101},{-37.6,-100},{-29.2,-100}}, color={0,0,127}));
  connect(FloorConductor.port_a, concreteFloor.port)
    annotation (Line(points={{98,-150},{70,-150},{70,-144}}, color={191,0,0}));
  connect(volume.heatPort, FloorConductor.port_b) annotation (Line(points={{90,
          -80},{80,-80},{80,-124},{134,-124},{134,-150},{118,-150}}, color={191,
          0,0}));
  annotation (experiment(StopTime=172800, Interval=10));
end Hall_long;
