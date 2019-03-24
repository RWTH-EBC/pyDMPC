within ModelicaModels.SubsystemModels.BaseClasses;
model AHUMockupCommunicationBaseClass
  "Base class containing the communication blocks for all the mockup models"
  import ModelicaModels;

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
        origin={-70,-50})));
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
        origin={-70,70})));

  TemperatureSensor supplyAirTemperature
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant BaseTemperature(k=0)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation

  connect(variation.y[1], supplyAirTemperature.u1) annotation (Line(points={{
          -59,70},{-28,70},{-28,8},{-12,8}}, color={0,0,127}));
  connect(BaseTemperature.y, supplyAirTemperature.u2)
    annotation (Line(points={{-59,0},{-12,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -200},{240,220}}), graphics={
        Line(points={{-140,80},{-140,-140},{120,-140},{100,-120},{100,-160},{
              120,-140}}, color={28,108,200}),
        Line(points={{-140,100},{-120,80},{-160,80},{-140,100}},   color={28,
              108,200})}),      Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-240,-200},{240,220}})));
end AHUMockupCommunicationBaseClass;
