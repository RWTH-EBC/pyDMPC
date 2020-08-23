within ModelicaModels.Subsystems.TestHall.BaseClasses;
model HallCalibrationBaseClass

  parameter AixLib.FastHVAC.Media.BaseClasses.MediumSimple medium=AixLib.FastHVAC.Media.WaterSimple();

  Modelica.Blocks.Math.Feedback feedback1
    annotation (Placement(transformation(extent={{16,-40},{36,-60}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=1/(5.184e6))
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-48,-24})));
  AixLib.FastHVAC.Components.Pumps.FluidSource
                                        fluidSource(medium = medium)
    annotation (Placement(transformation(extent={{-42,10},{-24,-8}})));
  Modelica.Blocks.Math.Gain gain(k=1.2/3600)
    annotation (Placement(transformation(extent={{-54,8},{-46,16}})));
  HallBaseClass hall
    annotation (Placement(transformation(extent={{-12,-14},{16,14}})));
  AixLib.FastHVAC.Components.Sinks.Vessel vessel
    annotation (Placement(transformation(extent={{48,-10},{68,10}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{46,-60},{66,-40}})));
equation
  connect(fluidSource.enthalpyPort_b, hall.enthalpyPort_a)
    annotation (Line(points={{-24,0.1},{-24,0},{-12,0}}, color={176,0,0}));
  connect(hall.enthalpyPort_b, vessel.enthalpyPort_a)
    annotation (Line(points={{16,0},{51,0}}, color={176,0,0}));
  connect(hall.hallTemperature, feedback1.u2)
    annotation (Line(points={{16,9.8},{26,9.8},{26,-42}}, color={0,0,127}));
  connect(integrator.u, product.y)
    annotation (Line(points={{78,-50},{67,-50}}, color={0,0,127}));
  connect(feedback1.y, product.u1) annotation (Line(points={{35,-50},{38,-50},{
          38,-44},{44,-44}}, color={0,0,127}));
  connect(feedback1.y, product.u2) annotation (Line(points={{35,-50},{38,-50},{
          38,-56},{44,-56}}, color={0,0,127}));
  connect(toKelvin.Kelvin, fluidSource.T_fluid) annotation (Line(points={{-48,
          -17.4},{-48,-2.78},{-40.2,-2.78}}, color={0,0,127}));
  connect(gain.y, fluidSource.dotm) annotation (Line(points={{-45.6,12},{-44,12},
          {-44,3.34},{-40.2,3.34}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=5184000, Interval=3600));
end HallCalibrationBaseClass;
