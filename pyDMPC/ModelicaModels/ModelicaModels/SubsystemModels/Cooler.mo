within ModelicaModels.SubsystemModels;
model Cooler "Mockup model of the cooler"
  extends BaseClasses.HeatExchangerMockupCommunicationBaseClass;
  Modelica.Blocks.Math.Gain gain1(k=-1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-38,-66})));
equation
  connect(gain.y, sum.u[2]) annotation (Line(points={{-23,-108},{68,-108},{68,
          -13},{88,-13}}, color={0,0,127}));
  connect(gain.y, gain1.u) annotation (Line(points={{-23,-108},{0,-108},{0,-66},
          {-26,-66}}, color={0,0,127}));
  connect(gain1.y, add.u2) annotation (Line(points={{-49,-66},{-100,-66},{-100,
          90},{-82,90}}, color={0,0,127}));
  annotation (Icon(graphics={Line(points={{-180,140},{-140,60},{-80,0},{-22,-20},
              {62,-40},{122,-40}}, color={0,140,72})}));
end Cooler;
