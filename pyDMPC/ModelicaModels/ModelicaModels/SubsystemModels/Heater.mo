within ModelicaModels.SubsystemModels;
model Heater "Mockup model of the heater"
  extends BaseClasses.HeatExchangerMockupCommunicationBaseClass;
equation
  connect(gain.y, sum.u[2]) annotation (Line(points={{-23,-108},{68,-108},{68,
          -13},{88,-13}}, color={0,0,127}));
  connect(gain.y, add.u2) annotation (Line(points={{-23,-108},{0,-108},{0,-58},
          {-100,-58},{-100,90},{-82,90}}, color={0,0,127}));
  annotation (Icon(graphics={Line(points={{-180,-140},{-140,-40},{-62,60},{-6,
              100},{48,120},{142,120}}, color={255,0,0})}));
end Heater;
