within ModelicaModels.Subsystems.TestHall;
model Office "Office within the test hall"

  parameter Real startTime = 0;
  parameter Real offset_1 = -3;
  parameter Real offset_2 = -1;
  Modelica.Blocks.Interfaces.RealOutput thermostat
    annotation (Placement(transformation(extent={{90,10},{110,30}})));
  Modelica.Blocks.Interfaces.RealOutput T_room
    annotation (Placement(transformation(extent={{90,-30},{110,-10}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=6,
    period=2*3600,
    offset=offset_1,
    startTime=startTime)
               annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Pulse pulse1(
    amplitude=2,
    period=4*3600,
    offset=offset_1,
    startTime=startTime)
               annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=3,
    freqHz=1/(6*3600),
    offset=22,
    startTime=startTime)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Sources.RealExpression calc(y=abs(T_in - T_set)*1.2*4000/3600
        *1000)
    annotation (Placement(transformation(extent={{-14,-70},{42,-52}})));
  Modelica.Blocks.Interfaces.RealInput T_in "Prescribed fluid temperature"
    annotation (Placement(transformation(extent={{-120,50},{-80,90}})));
  Modelica.Blocks.Interfaces.RealInput T_set
                                            "Prescribed fluid temperature"
    annotation (Placement(transformation(extent={{-120,-10},{-80,30}})));
  Modelica.Blocks.Interfaces.RealOutput energy "Value of Real output"
    annotation (Placement(transformation(extent={{90,-72},{110,-52}})));
  Modelica.Blocks.Sources.RealExpression calc_ref(y=abs(T_in_ref - T_set)*1.2*
        4000/3600*1000)
    annotation (Placement(transformation(extent={{-14,-94},{42,-76}})));
  Modelica.Blocks.Interfaces.RealInput T_in_ref "Prescribed fluid temperature"
    annotation (Placement(transformation(extent={{-120,-70},{-80,-30}})));
  Modelica.Blocks.Interfaces.RealOutput energy_ref "Value of Real output"
    annotation (Placement(transformation(extent={{90,-104},{110,-84}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=1/3600000)
    annotation (Placement(transformation(extent={{64,-68},{78,-54}})));
  Modelica.Blocks.Interfaces.RealOutput power "Value of Real output"
    annotation (Placement(transformation(extent={{90,-52},{110,-32}})));
  Modelica.Blocks.Continuous.Integrator integrator1(k=1/3600000)
    annotation (Placement(transformation(extent={{68,-100},{82,-86}})));
  Modelica.Blocks.Interfaces.RealOutput power_ref "Value of Real output"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
equation
  connect(pulse.y, add.u1)
    annotation (Line(points={{1,50},{8,50},{8,36},{18,36}}, color={0,0,127}));
  connect(pulse1.y, add.u2)
    annotation (Line(points={{1,10},{8,10},{8,24},{18,24}}, color={0,0,127}));
  connect(add.y, thermostat) annotation (Line(points={{41,30},{62,30},{62,20},{100,
          20}}, color={0,0,127}));
  connect(sine.y, T_room) annotation (Line(points={{1,-30},{40,-30},{40,-20},{100,
          -20}}, color={0,0,127}));
  connect(calc.y, integrator.u)
    annotation (Line(points={{44.8,-61},{62.6,-61}}, color={0,0,127}));
  connect(energy, integrator.y) annotation (Line(points={{100,-62},{90,-62},{90,
          -61},{78.7,-61}}, color={0,0,127}));
  connect(calc.y, power) annotation (Line(points={{44.8,-61},{54,-61},{54,-42},{
          100,-42}}, color={0,0,127}));
  connect(calc_ref.y, integrator1.u) annotation (Line(points={{44.8,-85},{58,-85},
          {58,-93},{66.6,-93}}, color={0,0,127}));
  connect(energy_ref, integrator1.y) annotation (Line(points={{100,-94},{94,-94},
          {94,-93},{82.7,-93}}, color={0,0,127}));
  connect(calc_ref.y, power_ref) annotation (Line(points={{44.8,-85},{56,-85},{56,
          -80},{100,-80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Office;
