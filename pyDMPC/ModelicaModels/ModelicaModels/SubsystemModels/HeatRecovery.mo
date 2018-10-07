within ModelicaModels.SubsystemModels;
model HeatRecovery "Mockup model of the heat recovery"
  extends BaseClasses.HeatExchangerMockupCommunicationBaseClass(gainHumidity(k=
          0));
  Modelica.Blocks.Sources.Constant BaseTemperature1(k=0)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  annotation (Icon(graphics={Line(points={{-140,-140},{-100,-40},{-22,60},{100,
              60},{100,60},{118,60}},   color={255,0,0})}));
end HeatRecovery;
