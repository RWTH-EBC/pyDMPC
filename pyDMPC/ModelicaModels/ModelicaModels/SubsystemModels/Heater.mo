within ModelicaModels.SubsystemModels;
model Heater "Mockup model of the heater"
  extends BaseClasses.HeatExchangerMockupCommunicationBaseClass;
equation
  connect(gain.y, sum.u[2]) annotation (Line(points={{-23,-108},{68,-108},{68,
          -13},{88,-13}}, color={0,0,127}));
  connect(gain.y, supplyAirTemperature.u2) annotation (Line(points={{-28,-17},{
          0,-17},{0,-58},{-100,-58},{-100,0},{-12,0}}, color={0,0,127}));
  annotation (Icon(graphics={Line(points={{-140,-140},{-120,-60},{-42,40},{14,
              80},{68,100},{100,100}},  color={255,0,0})}));
end Heater;
