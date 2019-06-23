within ModelicaModels.SubsystemModels.DetailedModels;
model test_model
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C=500000)
    annotation (Placement(transformation(extent={{2,0},{22,20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        303.15)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(fixedTemperature.port, heatCapacitor.port)
    annotation (Line(points={{-20,0},{12,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end test_model;
