within ModelicaModels.SubsystemModels;
model Humidifier "Mockup model of the humidifier "

  extends
    ModelicaModels.SubsystemModels.BaseClasses.AHUMockupCommunicationBaseClass;

  Modelica.Blocks.Sources.Constant Tset(k=38)
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Sources.Constant BaseTemperature2(k=0)
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Modelica.Blocks.Math.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
equation

  connect(product.y, objectiveFunction)
    annotation (Line(points={{1,0},{230,0}}, color={0,0,127}));
  connect(add1.y, product.u1) annotation (Line(points={{-45,0},{-34.5,0},{-34.5,
          6},{-22,6}}, color={0,0,127}));
  connect(add1.y, product.u2) annotation (Line(points={{-45,0},{-34,0},{-34,-6},
          {-22,-6}}, color={0,0,127}));
  connect(Tset.y, add1.u2) annotation (Line(points={{-119,-70},{-98,-70},{-98,
          -6},{-68,-6}}, color={0,0,127}));
  connect(variation.y[1], add1.u1) annotation (Line(points={{-111,96},{-100,96},
          {-100,6},{-68,6}}, color={0,0,127}));
  connect(BaseTemperature2.y, add.u2) annotation (Line(points={{-139,60},{-90,
          60},{-90,90},{-82,90}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-240,-200},
            {240,220}}), graphics={
        Rectangle(extent={{-240,220},{240,-200}}, lineColor={28,108,200}),
        Line(points={{-180,200},{-180,-140},{160,-140},{140,-120},{140,-160},{160,
              -140}}, color={28,108,200}),
        Line(points={{-180,200},{-160,180},{-200,180},{-180,200}}, color={28,108,
              200}),
        Line(points={{-180,140}}, color={0,140,72}),
        Line(points={{-180,140},{-162,80},{-120,18},{-62,-40},{2,-62},{60,-40},{
              120,20},{140,80},{152,140}}, color={28,108,200})}),
                                Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-240,-200},{240,220}})));
end Humidifier;
