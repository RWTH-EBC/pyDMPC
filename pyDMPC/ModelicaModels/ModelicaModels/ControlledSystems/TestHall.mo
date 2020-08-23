within ModelicaModels.ControlledSystems;
model TestHall
  Subsystems.TestHall.Office office(offset_1=-5, offset_2=-2)
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));
  Modelica.Blocks.Interfaces.RealInput T_in1 "Prescribed fluid temperature"
    annotation (Placement(transformation(extent={{-120,-10},{-80,30}})));
  Modelica.Blocks.Interfaces.RealInput T_CCA1 "Input signal connector"
    annotation (Placement(transformation(extent={{-120,-40},{-80,0}})));
  Modelica.Blocks.Interfaces.RealOutput thermostat1
    annotation (Placement(transformation(extent={{90,82},{110,102}})));
  Modelica.Blocks.Interfaces.RealOutput T_room1
    annotation (Placement(transformation(extent={{90,64},{110,84}})));
  Modelica.Blocks.Interfaces.RealOutput T_hall
    annotation (Placement(transformation(extent={{90,6},{110,26}})));
  Modelica.Blocks.Interfaces.RealOutput simTime "Value of Real output"
    annotation (Placement(transformation(extent={{90,-62},{110,-42}})));
  Modelica.Blocks.Interfaces.RealInput Tset "Prescribed fluid temperature"
    annotation (Placement(transformation(extent={{-120,30},{-80,70}})));
  Subsystems.TestHall.IdealHeater idealHeater
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Interfaces.RealOutput energy "Value of Real output"
    annotation (Placement(transformation(extent={{90,-82},{110,-62}})));
  Modelica.Blocks.Sources.RealExpression energyMeter(y=AHU_power.y + office.power
         + office2.power + idealHeater.power + hall.hallPower)
    annotation (Placement(transformation(extent={{-44,-88},{-22,-70}})));
  Modelica.Blocks.Sources.RealExpression AHU_power(y=1.2*16000/3600*1000*((hall.hallTemperature
         - weather.y[1] + 273.15)*0.3 + T_in1 - hall.hallTemperature))
    annotation (Placement(transformation(extent={{-100,-88},{-78,-70}})));
  Modelica.Blocks.Sources.Constant T_AHU_ref(k=23)
    "Air volume flow rate, could be an initial value"
    annotation (Placement(transformation(extent={{-100,-46},{-90,-36}})));
  Subsystems.TestHall.IdealHeater idealHeater_ref
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Sources.RealExpression AHU_power_ref(y=1.2*16000/3600*1000*((
        hall_ref.hallTemperature - weather.y[1] + 273.15)*0.3 + T_AHU_ref.k -
        hall_ref.hallTemperature))
    annotation (Placement(transformation(extent={{-100,-106},{-78,-88}})));
  Modelica.Blocks.Sources.RealExpression energyMeter_ref(y=AHU_power_ref.y +
        office.power_ref + office2.power_ref + idealHeater_ref.power + hall_ref.hallPower)
    annotation (Placement(transformation(extent={{-44,-106},{-22,-88}})));
  Modelica.Blocks.Interfaces.RealOutput energy_ref "Value of Real output"
    annotation (Placement(transformation(extent={{90,-106},{110,-86}})));
  Subsystems.TestHall.Office office2(startTime=-3600)
    annotation (Placement(transformation(extent={{-10,52},{10,72}})));
  Modelica.Blocks.Interfaces.RealOutput thermostat2
    annotation (Placement(transformation(extent={{90,46},{110,66}})));
  Modelica.Blocks.Interfaces.RealOutput T_room2
    annotation (Placement(transformation(extent={{90,28},{110,48}})));
  Modelica.Blocks.Interfaces.RealInput Tset2
                                            "Prescribed fluid temperature"
    annotation (Placement(transformation(extent={{-120,62},{-80,102}})));
  Modelica.Blocks.Sources.CombiTimeTable weather(
    table=[0.0,293],
    tableOnFile=true,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName="../weather.mat",
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    startTime=0,
    columns={2},
    tableName="InputTable")
  "Table with weather forecast" annotation (Placement(transformation(
      extent={{-6,-6},{6,6}},
      rotation=0,
      origin={-54,-6})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin weatherCelsius
    annotation (Placement(transformation(extent={{-38,-14},{-26,-2}})));
  Modelica.Blocks.Continuous.Integrator integrator1(k=1/3600000)
    annotation (Placement(transformation(extent={{-68,-76},{-54,-62}})));
  Modelica.Blocks.Continuous.Integrator integrator2(k=1/3600000)
    annotation (Placement(transformation(extent={{-68,-100},{-54,-86}})));
  Subsystems.TestHall.Hall hall
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Subsystems.TestHall.Hall hall_ref
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Modelica.Blocks.Interfaces.RealOutput T_hall_ref
    annotation (Placement(transformation(extent={{90,-40},{110,-20}})));
  Modelica.Blocks.Sources.RealExpression timer(y=time)
    annotation (Placement(transformation(extent={{60,-60},{82,-42}})));
  Modelica.Blocks.Continuous.Integrator integrator3(k=1/3600000)
    annotation (Placement(transformation(extent={{-8,-78},{6,-64}})));
  Modelica.Blocks.Continuous.Integrator integrator4(k=1/3600000)
    annotation (Placement(transformation(extent={{-8,-100},{6,-86}})));
equation
  connect(office.thermostat, thermostat1)
    annotation (Line(points={{10,92},{100,92}}, color={0,0,127}));
  connect(office.T_room, T_room1) annotation (Line(points={{10,88},{54,88},{54,
          74},{100,74}}, color={0,0,127}));
  connect(Tset, office.T_set) annotation (Line(points={{-100,50},{-66,50},{-66,
          91},{-10,91}}, color={0,0,127}));
  connect(T_in1, office.T_in) annotation (Line(points={{-100,10},{-56,10},{-56,
          97},{-10,97}}, color={0,0,127}));
  connect(T_AHU_ref.y, office.T_in_ref) annotation (Line(points={{-89.5,-41},{
          -68,-41},{-68,46},{-40,46},{-40,85},{-10,85}}, color={0,0,127}));
  connect(office2.thermostat, thermostat2) annotation (Line(points={{10,64},{52,
          64},{52,56},{100,56}}, color={0,0,127}));
  connect(office2.T_room, T_room2) annotation (Line(points={{10,60},{46,60},{46,
          38},{100,38}}, color={0,0,127}));
  connect(Tset2, office2.T_set) annotation (Line(points={{-100,82},{-26,82},{
          -26,63},{-10,63}}, color={0,0,127}));
  connect(T_in1, office2.T_in) annotation (Line(points={{-100,10},{-56,10},{-56,
          69},{-10,69}}, color={0,0,127}));
  connect(T_AHU_ref.y, office2.T_in_ref) annotation (Line(points={{-89.5,-41},{
          -68,-41},{-68,46},{-26,46},{-26,57},{-10,57}}, color={0,0,127}));
  connect(idealHeater.port1, hall.heatPort)
    annotation (Line(points={{-20.6,30},{14,30},{14,19.6}}, color={191,0,0}));
  connect(hall.hallTemperature, idealHeater.T) annotation (Line(points={{20,16},
          {40,16},{40,42},{-50,42},{-50,32.6},{-40,32.6}}, color={0,0,127}));
  connect(T_CCA1, hall.CCA_SEN_T__WS_SUP__AI_U_C) annotation (Line(points={{
          -100,-20},{-60,-20},{-60,-18},{-20,-18},{-20,4},{0,4}}, color={0,0,
          127}));
  connect(hall.T_fluid, T_in1) annotation (Line(points={{0,9},{-6,9},{-6,10},{
          -100,10}}, color={0,0,127}));
  connect(weather.y[1], weatherCelsius.Kelvin) annotation (Line(points={{-47.4,
          -6},{-42,-6},{-42,-8},{-39.2,-8}}, color={0,0,127}));
  connect(weatherCelsius.Celsius, hall.AIR_AHU_SEN_T_AIR_ODA__AI_U__C)
    annotation (Line(points={{-25.4,-8},{-18,-8},{-18,14},{0,14}}, color={0,0,
          127}));
  connect(T_AHU_ref.y, hall_ref.T_fluid) annotation (Line(points={{-89.5,-41},{
          -68,-41},{-68,-50},{-12,-50},{-12,-51},{0,-51}}, color={0,0,127}));
  connect(weatherCelsius.Celsius, hall_ref.AIR_AHU_SEN_T_AIR_ODA__AI_U__C)
    annotation (Line(points={{-25.4,-8},{-6,-8},{-6,-46},{0,-46}}, color={0,0,
          127}));
  connect(idealHeater_ref.port1, hall_ref.heatPort) annotation (Line(points={{
          -20.6,-30},{14,-30},{14,-40.4}}, color={191,0,0}));
  connect(hall_ref.hallTemperature, idealHeater_ref.T) annotation (Line(points=
          {{20,-44},{22,-44},{22,-20},{-46,-20},{-46,-27.4},{-40,-27.4}}, color
        ={0,0,127}));
  connect(AHU_power.y, integrator1.u) annotation (Line(points={{-76.9,-79},{-74,
          -79},{-74,-69},{-69.4,-69}}, color={0,0,127}));
  connect(AHU_power_ref.y, integrator2.u) annotation (Line(points={{-76.9,-97},
          {-74,-97},{-74,-93},{-69.4,-93}}, color={0,0,127}));
  connect(hall.hallTemperature, T_hall)
    annotation (Line(points={{20,16},{100,16}}, color={0,0,127}));
  connect(hall_ref.hallTemperature, T_hall_ref) annotation (Line(points={{20,
          -44},{60,-44},{60,-30},{100,-30}}, color={0,0,127}));
  connect(weatherCelsius.Celsius, hall_ref.CCA_SEN_T__WS_SUP__AI_U_C)
    annotation (Line(points={{-25.4,-8},{-6,-8},{-6,-56},{0,-56}}, color={0,0,
          127}));
  connect(simTime, timer.y) annotation (Line(points={{100,-52},{92,-52},{92,-51},
          {83.1,-51}}, color={0,0,127}));
  connect(energyMeter.y, integrator3.u) annotation (Line(points={{-20.9,-79},{
          -16,-79},{-16,-71},{-9.4,-71}}, color={0,0,127}));
  connect(energyMeter_ref.y, integrator4.u) annotation (Line(points={{-20.9,-97},
          {-16.45,-97},{-16.45,-93},{-9.4,-93}}, color={0,0,127}));
  connect(integrator4.y, energy_ref) annotation (Line(points={{6.7,-93},{49.35,
          -93},{49.35,-96},{100,-96}}, color={0,0,127}));
  connect(integrator3.y, energy) annotation (Line(points={{6.7,-71},{49.35,-71},
          {49.35,-72},{100,-72}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, Interval=10));
end TestHall;
