within ModelicaModels.SubsystemModels.DetailedModels.Geo;
model Building "Simplified building model"

  extends ModelicaModels.SubsystemModels.DetailedModels.Geo.GeoCommunicationBaseClass;

  extends ModelicaModels.Subsystems.Geo.BaseClasses.BuildingBaseClass;

equation
  connect(variation.y[1], boundary.T_in) annotation (Line(points={{-79,90},{-68,
          90},{-68,20},{-94,20},{-94,4},{-82,4}}, color={0,0,127}));
  connect(percent.y, product1.u1)
    annotation (Line(points={{-57.4,-50},{-36,-50}}, color={0,0,127}));
  connect(product1.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-13,
          -56},{0,-56},{0,20},{-34,20},{-34,42},{-18,42}}, color={0,0,127}));
  connect(prescribedHeatFlow.port, vol1.heatPort)
    annotation (Line(points={{6,42},{14,42}}, color={191,0,0}));
end Building;
