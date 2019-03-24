within ModelicaModels.SubsystemModels;
model Humidifier "Mockup model of the humidifier "

  extends ModelicaModels.SubsystemModels.BaseClasses.HeatExchangerMockupCommunicationBaseClass(
      gainTemperature(k=0));
equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -160},{140,120}}),
                         graphics={
        Line(points={{-180,140}}, color={0,140,72})}),
                                Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-160,-160},{140,120}})));
end Humidifier;
