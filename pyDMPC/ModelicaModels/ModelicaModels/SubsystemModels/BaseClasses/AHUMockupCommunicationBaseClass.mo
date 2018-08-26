within ModelicaModels.SubsystemModels.BaseClasses;
model AHUMockupCommunicationBaseClass
  "Base class containing the communication blocks for all the mockup models"

  Modelica.Blocks.Sources.CombiTimeTable decisionVariables(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    tableName="tab1",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    columns={2},
    fileName="decisionVariables.mat")
    "Table with decision variables"              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,-108})));
  Modelica.Blocks.Sources.CombiTimeTable MeasuredData(
    tableOnFile=true,
    tableName="InputTable",
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    columns=2:19,
    fileName="../Inputs/CompleteInput.mat")
    annotation (Placement(transformation(extent={{-240,186},{-206,220}})));
  Modelica.Blocks.Sources.CombiTimeTable variation(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    tableName="tab1",
    columns=2:3,
    fileName="variation.mat")       "Table with control input"
                                                            annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-122,96})));

  Modelica.Blocks.Interfaces.RealOutput objectiveFunction
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{220,-10},{240,10}}),
        iconTransformation(extent={{220,-10},{240,10}})));

  Modelica.Blocks.Math.Add3 add
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Constant BaseTemperature(k=0)
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
equation

  connect(BaseTemperature.y, add.u3) annotation (Line(points={{-139,20},{-120,
          20},{-120,82},{-82,82}}, color={0,0,127}));
  connect(variation.y[1], add.u1) annotation (Line(points={{-111,96},{-98,96},{
          -98,98},{-82,98}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -200},{240,220}}), graphics={
        Rectangle(extent={{-240,220},{240,-200}}, lineColor={28,108,200}),
        Line(points={{-180,200},{-180,-140},{160,-140},{140,-120},{140,-160},{
              160,-140}}, color={28,108,200}),
        Line(points={{-180,200},{-160,180},{-200,180},{-180,200}}, color={28,
              108,200})}),      Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-240,-200},{240,220}}), graphics={Text(
            extent={{-392,208},{-404,156}},
            lineColor={238,46,47},
            horizontalAlignment=TextAlignment.Left,
          textString="Measurement Data

1: outside air temperature
2: outside air rel.humidity
3: exhaust air temperature
4: exhaust air rel.humidity
5: outgoing air temperature
6: outgoing air rel.humidity
7: supply air temperature
8: supply rel.humidity
9: temperature after pre-heater
10: temperature after cooler
11: temperature after heater
12: temperature water pre-heater
13: temperature water cooler
14: temperature water heater
15: water return pre-heater
16: water return heater
17: Temperature after recuperator
18: Humidity after recuperator")}));
end AHUMockupCommunicationBaseClass;
