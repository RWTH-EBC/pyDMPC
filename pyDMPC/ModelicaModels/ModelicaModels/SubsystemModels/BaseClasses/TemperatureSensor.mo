within ModelicaModels.SubsystemModels.BaseClasses;
model TemperatureSensor "Mockup of a temperature sensor"
  extends Modelica.Blocks.Math.Add3;
  Modelica.Blocks.Interfaces.RealOutput T "Connector of Real output signals"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));

equation
  T = y;

end TemperatureSensor;
