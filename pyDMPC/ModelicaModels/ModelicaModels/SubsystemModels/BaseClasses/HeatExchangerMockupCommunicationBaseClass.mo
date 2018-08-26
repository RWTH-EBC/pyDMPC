within ModelicaModels.SubsystemModels.BaseClasses;
model HeatExchangerMockupCommunicationBaseClass
  "Base class containing the communication blocks for the heat exchanger mockup models"

  extends ModelicaModels.SubsystemModels.BaseClasses.AHUMockupCommunicationBaseClass;



  Modelica.Blocks.Tables.CombiTable2D exDestArr(
    tableOnFile=true,
    tableName="tab1",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName="exDestArr.mat")
    "Outputs the mean exergetic or monetary cost of the downstream subsystems"
                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={44,-15})));
  Modelica.Blocks.Math.Sum sum(nin=2)
                               "Sum all costs"
    annotation (Placement(transformation(extent={{90,-24},{110,-4}})));
  Modelica.Blocks.Math.Gain gain(k=0.1)
    annotation (Placement(transformation(extent={{-44,-118},{-24,-98}})));
  Modelica.Blocks.Sources.Constant xRefWater(k=0.005)
    annotation (Placement(transformation(extent={{-50,-32},{-30,-12}})));
equation
  connect(exDestArr.y,sum. u[1]) annotation (Line(points={{55,-15},{58,-15},{88,
          -15}},                    color={0,0,127}));
  connect(decisionVariables.y[1],gain. u) annotation (Line(points={{-63,-108},{
          -54,-108},{-46,-108}}, color={0,0,127}));
  connect(sum.y, objectiveFunction)
    annotation (Line(points={{111,-14},{230,-14},{230,0}},   color={0,0,127}));
  connect(xRefWater.y, exDestArr.u2) annotation (Line(points={{-29,-22},{2,-22},
          {2,-21},{32,-21}}, color={0,0,127}));
  connect(add.y, exDestArr.u1) annotation (Line(points={{-59,90},{2,90},{2,-9},
          {32,-9}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-240,-200},
            {240,220}}), graphics={
        Rectangle(extent={{-240,220},{240,-200}}, lineColor={28,108,200}),
        Line(points={{-180,200},{-180,-140},{160,-140},{140,-120},{140,-160},{160,
              -140}}, color={28,108,200}),
        Line(points={{-180,200},{-160,180},{-200,180},{-180,200}}, color={28,108,
              200})}),          Diagram(coordinateSystem(preserveAspectRatio=
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
end HeatExchangerMockupCommunicationBaseClass;
