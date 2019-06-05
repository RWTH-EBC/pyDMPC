within ModelicaModels.ControlledSystems;
model GeothermalField

  extends ModelicaModels.Subsystems.Geo.BaseClasses.FieldBaseClass;
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-12,-12},{12,12}},
        rotation=0,
        origin={-6,42})));
  Modelica.Blocks.Sources.Sine sine(amplitude=10000, freqHz=1/86400)
    annotation (Placement(transformation(extent={{-80,38},{-60,60}})));
equation
  connect(prescribedHeatFlow.port, vol1.heatPort)
    annotation (Line(points={{6,42},{20,42}}, color={191,0,0}));
  connect(sine.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-59,49},
          {-39.5,49},{-39.5,42},{-18,42}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GeothermalField;
