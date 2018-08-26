within ModelicaModels.SubsystemModels;
model Cooler "Mockup model of the cooler"
  extends BaseClasses.HeatExchangerMockupCommunicationBaseClass;
  Modelica.Blocks.Math.Gain gain1(k=-0.3)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-36,-68})));
equation
  connect(gain.y, sum.u[2]) annotation (Line(points={{-23,-108},{68,-108},{68,
          -13},{88,-13}}, color={0,0,127}));
  connect(gain.y, gain1.u) annotation (Line(points={{-23,-108},{0,-108},{0,-68},
          {-24,-68}}, color={0,0,127}));
  connect(gain1.y, add.u2) annotation (Line(points={{-47,-68},{-100,-68},{-100,
          90},{-82,90}}, color={0,0,127}));
  annotation (Icon(graphics={Line(points={{-180,140},{-140,60},{-80,0},{-22,-20},
              {62,-40},{122,-40}}, color={0,140,72})}));
end Cooler;
