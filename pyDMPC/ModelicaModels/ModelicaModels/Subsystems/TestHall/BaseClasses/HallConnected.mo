within ModelicaModels.Subsystems.TestHall.BaseClasses;
model HallConnected "A model of the hall with fluid source and sink"

  parameter AixLib.FastHVAC.Media.BaseClasses.MediumSimple medium=ModelicaModels.Subsystems.TestHall.BaseClasses.SimpleAir();

  HallBaseClass hallBaseClass(medium=medium)
    annotation (Placement(transformation(extent={{20,-20},{60,20}})));
  AixLib.FastHVAC.Components.Pumps.FluidSource
                                        fluidSource(medium=medium)
    annotation (Placement(transformation(extent={{-20,10},{-2,-8}})));
  AixLib.FastHVAC.Components.Sinks.Vessel vessel
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
equation
  connect(fluidSource.enthalpyPort_b, hallBaseClass.enthalpyPort_a) annotation (
     Line(points={{-2,0.1},{14,0.1},{14,0},{20,0}}, color={176,0,0}));
  connect(hallBaseClass.enthalpyPort_b, vessel.enthalpyPort_a)
    annotation (Line(points={{60,0},{83,0}}, color={176,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HallConnected;
