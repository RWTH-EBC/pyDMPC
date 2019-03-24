within ModelicaModels.BaseClasses;
model HRCController "Controls the heat recovery unit"

  Modelica.Blocks.Interfaces.RealInput T_fresh(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0) "Fresh air temperature"
    annotation (Placement(transformation(extent={{-118,-18},{-82,18}})));
  Modelica.Blocks.Interfaces.RealInput T_set(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0) "Set supply air temperature"
    annotation (Placement(transformation(extent={{-118,52},{-82,88}})));
  Modelica.Blocks.Interfaces.RealInput T_extract(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0) "Extract air temperature"
    annotation (Placement(transformation(extent={{-118,-88},{-82,-52}})));
  Modelica.Blocks.Logical.Hysteresis detectCoolingDemand(uHigh=0.5, uLow=0.1)
    "true=cooling"
    annotation (Placement(transformation(extent={{-30,60},{-10,80}})));
  Modelica.Blocks.Math.Add add(k2=-1)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Logical.Hysteresis detectColdReciveryPossibility(uLow=1,
      uHigh=2) "true=cold recovery possible"
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
  Modelica.Blocks.Math.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Math.Add add2(k2=-1)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Logical.Hysteresis detectHeatingDemand(uHigh=0.5, uLow=0.1)
    "true=heating"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  Modelica.Blocks.Logical.Hysteresis detectHeatRecoveryPossibility(uLow=1,
      uHigh=2) "true=heat recovery possible"
    annotation (Placement(transformation(extent={{-30,-80},{-10,-60}})));
  Modelica.Blocks.Math.Add add3(k2=-1)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Modelica.Blocks.Logical.Or or1
    annotation (Placement(transformation(extent={{68,-10},{88,10}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{104,-78},{124,-58}})));
  Modelica.Blocks.Sources.Constant fullyClosed(k=0) "Close damper fully"
    annotation (Placement(transformation(extent={{64,-96},{78,-82}})));
  Modelica.Blocks.Interfaces.RealOutput opening
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput T_HRC(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0) "Air temperature behind heat recovery" annotation (Placement(
        transformation(
        extent={{-18,-18},{18,18}},
        rotation=270,
        origin={50,100})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{30,-60},{50,-40}})));
  Modelica.Blocks.Logical.Switch switch3
    annotation (Placement(transformation(extent={{30,-92},{50,-72}})));
  AixLib.Controls.Continuous.LimPID controller(
    yMax=100,
    yMin=0,
    reverseAction=true,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=10,
    Ti=100) annotation (Placement(transformation(extent={{66,-68},{86,-48}})));
equation
  connect(detectCoolingDemand.u, add.y)
    annotation (Line(points={{-32,70},{-36,70},{-39,70}}, color={0,0,127}));
  connect(add2.y, detectHeatingDemand.u)
    annotation (Line(points={{-39,30},{-32,30}}, color={0,0,127}));
  connect(add1.y, detectColdReciveryPossibility.u) annotation (Line(points={{
          -39,-30},{-35.5,-30},{-32,-30}}, color={0,0,127}));
  connect(T_fresh, add1.u1) annotation (Line(points={{-100,0},{-82,0},{-82,
          -24},{-62,-24}}, color={0,0,127}));
  connect(T_extract, add1.u2) annotation (Line(points={{-100,-70},{-82,-70},{
          -82,-36},{-62,-36}}, color={0,0,127}));
  connect(T_fresh, add3.u2) annotation (Line(points={{-100,0},{-72,0},{-72,
          -76},{-62,-76}}, color={0,0,127}));
  connect(T_extract, add3.u1) annotation (Line(points={{-100,-70},{-82,-70},{
          -82,-64},{-62,-64}}, color={0,0,127}));
  connect(T_set, add2.u1) annotation (Line(points={{-100,70},{-88,70},{-72,70},
          {-72,36},{-62,36}}, color={0,0,127}));
  connect(T_fresh, add2.u2) annotation (Line(points={{-100,0},{-72,0},{-72,24},
          {-62,24}}, color={0,0,127}));
  connect(T_fresh, add.u1) annotation (Line(points={{-100,0},{-82,0},{-82,76},
          {-62,76}}, color={0,0,127}));
  connect(T_set, add.u2) annotation (Line(points={{-100,70},{-72,70},{-72,64},
          {-62,64}}, color={0,0,127}));
  connect(detectCoolingDemand.y, and2.u1) annotation (Line(points={{-9,70},{0,
          70},{0,-20},{18,-20}}, color={255,0,255}));
  connect(detectColdReciveryPossibility.y, and2.u2) annotation (Line(points={
          {-9,-30},{0,-30},{0,-28},{18,-28}}, color={255,0,255}));
  connect(detectHeatingDemand.y, and1.u1) annotation (Line(points={{-9,30},{8,
          30},{8,20},{18,20}}, color={255,0,255}));
  connect(detectHeatRecoveryPossibility.y, and1.u2) annotation (Line(points={
          {-9,-70},{8,-70},{8,12},{18,12}}, color={255,0,255}));
  connect(or1.y, switch1.u2) annotation (Line(points={{89,0},{94,0},{94,-40},
          {94,-68},{102,-68}}, color={255,0,255}));
  connect(switch1.y, opening) annotation (Line(points={{125,-68},{152,-68},{
          152,0},{110,0}}, color={0,0,127}));
  connect(add3.y, detectHeatRecoveryPossibility.u)
    annotation (Line(points={{-39,-70},{-32,-70}}, color={0,0,127}));
  connect(fullyClosed.y, switch1.u3) annotation (Line(points={{78.7,-89},{88,
          -89},{94,-89},{94,-76},{102,-76}}, color={0,0,127}));
  connect(T_HRC, switch2.u1) annotation (Line(points={{50,100},{50,56},{6,56},
          {6,-42},{28,-42}}, color={0,0,127}));
  connect(T_set, switch3.u1) annotation (Line(points={{-100,70},{-72,70},{-72,
          50},{4,50},{4,-74},{28,-74}}, color={0,0,127}));
  connect(T_HRC, switch3.u3) annotation (Line(points={{50,100},{50,56},{6,56},
          {6,-90},{28,-90}}, color={0,0,127}));
  connect(T_set, switch2.u3) annotation (Line(points={{-100,70},{-72,70},{-72,
          50},{4,50},{4,-58},{28,-58}}, color={0,0,127}));
  connect(and1.y, or1.u1) annotation (Line(points={{41,20},{54,20},{54,0},{66,
          0}}, color={255,0,255}));
  connect(and2.y, or1.u2) annotation (Line(points={{41,-20},{58,-20},{58,-8},
          {66,-8}}, color={255,0,255}));
  connect(and2.y, switch2.u2) annotation (Line(points={{41,-20},{54,-20},{54,
          -34},{20,-34},{20,-50},{28,-50}}, color={255,0,255}));
  connect(and2.y, switch3.u2) annotation (Line(points={{41,-20},{54,-20},{54,
          -34},{20,-34},{20,-82},{28,-82}}, color={255,0,255}));
  connect(switch3.y, controller.u_s) annotation (Line(points={{51,-82},{56,-82},
          {56,-58},{64,-58}}, color={0,0,127}));
  connect(switch2.y, controller.u_m) annotation (Line(points={{51,-50},{58,-50},
          {58,-76},{76,-76},{76,-70}}, color={0,0,127}));
  connect(controller.y, switch1.u1) annotation (Line(points={{87,-58},{94,-58},{
          94,-60},{102,-60}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>THE HRC controller checks if</p>
<p>Tset &GT; Tfresh &GT; Textract --&GT; 100</p>
<p>Tset &LT; Tfresh &LT; Textract --&GT; 100</p>
<p>Tset &GT; Tfresh &LT; Textract --&GT; 0</p>
<p>Tset &LT; Tfresh &GT; Textract --&GT; 0</p>
</html>"));
end HRCController;
