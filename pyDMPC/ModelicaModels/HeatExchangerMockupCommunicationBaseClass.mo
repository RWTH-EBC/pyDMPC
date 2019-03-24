within ;
model HeatExchangerMockupCommunicationBaseClass
  "Base class containing the communication blocks for the heat exchanger mockup models"


  Modelica.Blocks.Sources.CombiTimeTable decisionVariables(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    tableName="tab1",
    fileName="decisionVariables.txt",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    columns={2})
    "Table with decision variables"              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,-108})));
  Modelica.Blocks.Sources.CombiTimeTable MeasuredData(
    tableOnFile=true,
    tableName="InputTable",
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    fileName="../../Inputs/CompleteInput.mat",
    columns=2:19)
    annotation (Placement(transformation(extent={{-240,186},{-206,220}})));
  Modelica.Blocks.Sources.CombiTimeTable variation(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    tableName="tab1",
    columns=2:3,
    fileName="../../variation.txt") "Table with control input"
                                                            annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-230,140})));
  Modelica.Blocks.Sources.Constant xRefWater(k=0.005)
    annotation (Placement(transformation(extent={{-50,-32},{-30,-12}})));

  Modelica.Blocks.Tables.CombiTable2D exDestArr(
    tableOnFile=true,
    tableName="tab1",
    fileName="../exDestArr.txt",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "Outputs the mean exergetic or monetary cost of the downstream subsystems"
                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={44,-15})));
  Modelica.Blocks.Math.Sum sum(nin=2)
                               "Sum all costs"
    annotation (Placement(transformation(extent={{90,-24},{110,-4}})));
  Modelica.Blocks.Interfaces.RealOutput objectiveFunction
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{138,-24},{158,-4}})));
  Modelica.Blocks.Math.Gain gain(k=0.3)
    annotation (Placement(transformation(extent={{-44,-118},{-24,-98}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));


equation

  connect(exDestArr.y,sum. u[1]) annotation (Line(points={{55,-15},{58,-15},{88,
          -15}},                    color={0,0,127}));
  connect(xRefWater.y, exDestArr.u2)
    annotation (Line(points={{-29,-22},{32,-22},{32,-21}}, color={0,0,127}));
  connect(decisionVariables.y[1], gain.u) annotation (Line(points={{-63,-108},{
          -54,-108},{-46,-108}}, color={0,0,127}));
  connect(variation.y[1], add.u1) annotation (Line(points={{-219,140},{-156,140},
          {-156,96},{-82,96}}, color={0,0,127}));
  connect(gain.y, add.u2) annotation (Line(points={{-23,-108},{0,-108},{0,-40},
          {-100,-40},{-100,84},{-82,84}}, color={0,0,127}));
  connect(add.y, exDestArr.u1) annotation (Line(points={{-59,90},{-20,90},{-20,
          -9},{32,-9}}, color={0,0,127}));
  connect(sum.y, objectiveFunction)
    annotation (Line(points={{111,-14},{126,-14},{148,-14}}, color={0,0,127}));
  connect(gain.y, sum.u[2]) annotation (Line(points={{-23,-108},{8,-108},{70,
          -108},{70,-13},{88,-13}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -200},{500,220}})), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-240,-200},{500,220}}), graphics={Text(
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
18: Humidity after recuperator")}),
    uses(Modelica(version="3.2.2")));
end HeatExchangerMockupCommunicationBaseClass;
