within ModelicaModels.SubsystemModels.BaseClasses;
model HeatExchangerMockupCommunicationBaseClass
  "Base class containing the communication blocks for the heat exchanger mockup models"

  extends ModelicaModels.SubsystemModels.BaseClasses.AHUMockupCommunicationBaseClass;



  Modelica.Blocks.Math.Gain gainTemperature(k=0.1)
    "Temperature gain to transform the decision variable into temperature difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-28,-28})));
  HumiditySensor humiditySensor
    annotation (Placement(transformation(extent={{-10,-140},{10,-120}})));
  Modelica.Blocks.Math.Gain gainHumidity(k=0.01)
    "Humidity gain to transform the decision variable into humidity difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-28,-72})));
equation
  connect(decisionVariables.y[1], gainTemperature.u)
    annotation (Line(points={{-59,-50},{-28,-50},{-28,-40}}, color={0,0,127}));
  connect(gainTemperature.y, supplyAirTemperature.u3)
    annotation (Line(points={{-28,-17},{-28,-8},{-12,-8}}, color={0,0,127}));
  connect(decisionVariables.y[1], gainHumidity.u)
    annotation (Line(points={{-59,-50},{-28,-50},{-28,-60}}, color={0,0,127}));
  connect(gainHumidity.y, humiditySensor.u1) annotation (Line(points={{-28,-83},
          {-28,-124},{-12,-124}}, color={0,0,127}));
  connect(variation.y[2], humiditySensor.u2) annotation (Line(points={{-59,70},
          {-28,70},{-28,100},{-120,100},{-120,-136},{-12,-136}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -160},{140,120}}),
                         graphics={
        Rectangle(extent={{-160,120},{140,-160}}, lineColor={28,108,200}),
        Line(points={{-180,200},{-160,180},{-200,180},{-180,200}}, color={28,108,
              200})}),          Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-160,-160},{140,120}})));
end HeatExchangerMockupCommunicationBaseClass;
