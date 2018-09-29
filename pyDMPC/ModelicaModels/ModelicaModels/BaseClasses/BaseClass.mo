within ModelicaModels.BaseClasses;
model BaseClass "Base class for all component models"

replaceable package MediumAir = AixLib.Media.Air;
replaceable package MediumWater = AixLib.Media.Water;

  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-86},{-80,-66}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseClass;
