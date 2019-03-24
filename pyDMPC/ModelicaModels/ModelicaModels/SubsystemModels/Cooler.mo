within ModelicaModels.SubsystemModels;
model Cooler "Mockup model of the cooler"
  extends BaseClasses.HeatExchangerMockupCommunicationBaseClass(gainTemperature(
        k=-0.1), gainHumidity(k=-0.01));
  annotation (Icon(graphics={Line(points={{-140,60},{-100,-20},{-40,-80},{18,
              -100},{98,-100},{98,-100}},
                                   color={0,140,72})}));
end Cooler;
