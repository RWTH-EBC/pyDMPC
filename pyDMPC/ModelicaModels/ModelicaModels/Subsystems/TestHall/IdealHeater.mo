within ModelicaModels.Subsystems.TestHall;
model IdealHeater "Ideal heater or cooler for the hall"

  parameter Real setPoint_heating = 23 "The temperature set point of the controlled zone in heating mode";
  parameter Real setPoint_cooling = 25 "The temperature set point of the controlled zone in cooling mode";

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1
    annotation (Placement(transformation(extent={{24,-10},{44,10}})));
  Modelica.Blocks.Logical.OnOffController onOffController(bandwidth=1)
    annotation (Placement(transformation(extent={{-46,24},{-34,36}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-28,24},{-16,36}})));
  Modelica.Blocks.Sources.Constant minHeatMaxCool(k=0)
    annotation (Placement(transformation(extent={{-48,4},{-38,14}})));
  Modelica.Blocks.Sources.Constant maxHeat(k=10000)
    annotation (Placement(transformation(extent={{-48,48},{-38,58}})));
  Modelica.Blocks.Sources.Constant setPointHeating(k=setPoint_heating)
    annotation (Placement(transformation(extent={{-76,42},{-66,52}})));
  Modelica.Blocks.Interfaces.RealInput T
    "Connector of Real input signal used as measurement signal"
    annotation (Placement(transformation(extent={{-120,6},{-80,46}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port1
    annotation (Placement(transformation(extent={{84,-10},{104,10}})));
  Modelica.Blocks.Logical.OnOffController onOffController1(bandwidth=0.5,
      pre_y_start=true)
    annotation (Placement(transformation(extent={{-44,-36},{-32,-24}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{-26,-36},{-14,-24}})));
  Modelica.Blocks.Sources.Constant setPointHeating1(k=setPoint_cooling)
    annotation (Placement(transformation(extent={{-70,-24},{-60,-14}})));
  Modelica.Blocks.Sources.Constant maxHeat1(k=-10000)
    annotation (Placement(transformation(extent={{-48,-56},{-38,-46}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-4,-10},{16,10}})));
  Modelica.Blocks.Math.Abs abs1
    annotation (Placement(transformation(extent={{24,-60},{44,-40}})));
  Modelica.Blocks.Interfaces.RealOutput energy
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{90,-60},{110,-40}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=1/3600000)
    annotation (Placement(transformation(extent={{62,-56},{74,-44}})));
  Modelica.Blocks.Interfaces.RealOutput power "Connector of Real output signal"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
equation
  connect(minHeatMaxCool.y, switch1.u3) annotation (Line(points={{-37.5,9},{-32,
          9},{-32,25.2},{-29.2,25.2}}, color={0,0,127}));
  connect(maxHeat.y, switch1.u1) annotation (Line(points={{-37.5,53},{-32,53},{
          -32,34.8},{-29.2,34.8}}, color={0,0,127}));
  connect(setPointHeating.y, onOffController.reference) annotation (Line(points=
         {{-65.5,47},{-58,47},{-58,33.6},{-47.2,33.6}}, color={0,0,127}));
  connect(onOffController.u, T) annotation (Line(points={{-47.2,26.4},{-69.6,
          26.4},{-69.6,26},{-100,26}}, color={0,0,127}));
  connect(onOffController.y, switch1.u2)
    annotation (Line(points={{-33.4,30},{-29.2,30}}, color={255,0,255}));
  connect(prescribedHeatFlow1.port, port1)
    annotation (Line(points={{44,0},{94,0}}, color={191,0,0}));
  connect(onOffController1.y, switch2.u2)
    annotation (Line(points={{-31.4,-30},{-27.2,-30}}, color={255,0,255}));
  connect(minHeatMaxCool.y, switch2.u1) annotation (Line(points={{-37.5,9},{-32,
          9},{-32,-25.2},{-27.2,-25.2}}, color={0,0,127}));
  connect(setPointHeating1.y, onOffController1.reference) annotation (Line(
        points={{-59.5,-19},{-52.75,-19},{-52.75,-26.4},{-45.2,-26.4}}, color={
          0,0,127}));
  connect(T, onOffController1.u) annotation (Line(points={{-100,26},{-76,26},{
          -76,-33.6},{-45.2,-33.6}}, color={0,0,127}));
  connect(maxHeat1.y, switch2.u3) annotation (Line(points={{-37.5,-51},{-30,-51},
          {-30,-34.8},{-27.2,-34.8}}, color={0,0,127}));
  connect(prescribedHeatFlow1.Q_flow, add.y)
    annotation (Line(points={{24,0},{17,0}}, color={0,0,127}));
  connect(switch1.y, add.u1) annotation (Line(points={{-15.4,30},{-10,30},{-10,
          6},{-6,6}}, color={0,0,127}));
  connect(switch2.y, add.u2) annotation (Line(points={{-13.4,-30},{-10,-30},{
          -10,-6},{-6,-6}}, color={0,0,127}));
  connect(add.y, abs1.u)
    annotation (Line(points={{17,0},{17,-50},{22,-50}}, color={0,0,127}));
  connect(abs1.y, integrator.u)
    annotation (Line(points={{45,-50},{60.8,-50}}, color={0,0,127}));
  connect(integrator.y, energy)
    annotation (Line(points={{74.6,-50},{100,-50}}, color={0,0,127}));
  connect(abs1.y, power) annotation (Line(points={{45,-50},{52,-50},{52,-80},{
          100,-80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IdealHeater;
