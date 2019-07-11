within ModelicaModels.SubsystemModels.DetailedModels.Geo;
model Field "Simplified model of geothermal field"

  extends
    ModelicaModels.SubsystemModels.DetailedModels.Geo.GeoCommunicationBaseClass(variation(
        extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,
          10000; 2635200,12000; 5270400,9000; 7905600,3000; 10540800,-5000;
          13176000,-12000; 15811200,-12000; 18446400,-13000; 21081600,-5000;
          23716800,4000; 26352000,8000; 28987200,12000]), decisionVariables(
        table=[0.0,50]),
    percent(k=0.01));

  extends ModelicaModels.Subsystems.Geo.BaseClasses.FieldBaseClass;

  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-78,0},{-58,20}})));
  Modelica.Blocks.Logical.LessEqualThreshold    lessEqualThreshold
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-80,32},{-60,52}})));
  Modelica.Blocks.Math.Gain negate(k=-1) "negate" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-48,42})));
equation
  connect(variation.y[1], lessEqualThreshold.u) annotation (Line(points={{-79,
          90},{-70,90},{-70,80},{-62,80}}, color={0,0,127}));
  connect(variation.y[1], switch1.u3) annotation (Line(points={{-79,90},{-70,90},
          {-70,72},{-98,72},{-98,34},{-82,34}}, color={0,0,127}));
  connect(variation.y[1], product1.u1) annotation (Line(points={{-79,90},{-70,
          90},{-70,72},{-98,72},{-98,16},{-80,16}}, color={0,0,127}));
  connect(negate.y, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{-41.4,42},{-18,42}}, color={0,0,127}));
  connect(prescribedHeatFlow.port, vol1.heatPort)
    annotation (Line(points={{6,42},{20,42}}, color={191,0,0}));
  connect(product1.y,switch1. u1) annotation (Line(points={{-57,10},{-52,10},{-52,
          26},{-90,26},{-90,50},{-82,50}},     color={0,0,127}));
  connect(lessEqualThreshold.y,switch1. u2) annotation (Line(points={{-39,80},{-14,
          80},{-14,60},{-92,60},{-92,42},{-82,42}},     color={255,0,255}));
  connect(negate.u,switch1. y)
    annotation (Line(points={{-55.2,42},{-59,42}}, color={0,0,127}));
  connect(percent.y, product1.u2) annotation (Line(points={{-57.4,-50},{-52,-50},
          {-52,-8},{-96,-8},{-96,4},{-80,4}}, color={0,0,127}));
  annotation (
    experiment(StopTime=94672800, Interval=3600),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=false,
      OutputFlatModelica=false));
end Field;
