within ModelicaModels.ControlledSystems;
model ControlledSystemBoundaries
  "Version of controlled system with boundary conditions"
  extends ModelicaModels.BaseClasses.ControlledSystemBaseClass(volumeFlow(
        fileName="Inputs/VolumeFlow.txt"));
  Modelica.Blocks.Sources.Sine     outdoorTemperature(
    amplitude=10,
    freqHz=1/7200,
    offset=20)                                              annotation (
      Placement(transformation(
        extent={{14,-14},{-14,14}},
        rotation=180,
        origin={-378,120})));
  Modelica.Blocks.Sources.Constant outdoorHumidity(k=0.7) annotation (Placement(
        transformation(
        extent={{14,-14},{-14,14}},
        rotation=180,
        origin={-378,76})));
  Modelica.Blocks.Sources.Constant roomTemperature(k=25) annotation (Placement(
        transformation(
        extent={{13,13},{-13,-13}},
        rotation=0,
        origin={155,132})));
  Modelica.Blocks.Sources.Constant roomHumidity(k=0.4) annotation (Placement(
        transformation(
        extent={{13,-13},{-13,13}},
        rotation=0,
        origin={155,183})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={92,154})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin1 annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-330,120})));
  Modelica.Blocks.Sources.Constant highTemperatureCircuit(k=65)
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Modelica.Blocks.Sources.Constant
                               coolingCircuit(k=6)
    annotation (Placement(transformation(extent={{-2,100},{18,120}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin2 annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-38,130})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin3 annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={28,72})));
  Modelica.Blocks.Interfaces.RealInput valveHRS
    "Opening of the HRC valve (0..100 %)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-166,206})));
  Modelica.Blocks.Interfaces.RealInput valvePreHeater
    "Opening of the HRC valve (0..100 %)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-64,90})));
  Modelica.Blocks.Interfaces.RealInput valveCooler
    "Opening of the HRC valve (0..100 %)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={16,-106})));
  Modelica.Blocks.Interfaces.RealInput valveHeater
    "Opening of the HRC valve (0..100 %)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={96,82})));
  Modelica.Blocks.Interfaces.RealInput humidifierWSP1
    "Working set point of the humidifier (0..100%)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={224,54})));
  AixLib.Fluid.Sensors.Temperature outgoingAirOutletTemperature(redeclare
      package Medium = MediumAir) "Temperature after HRC"
    annotation (Placement(transformation(extent={{-224,40},{-204,60}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin
    outgoingAirOutletTemperatureC
    annotation (Placement(transformation(extent={{-196,40},{-176,60}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin hRCTemperatureC
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin preHeaterTemperatureC
    annotation (Placement(transformation(extent={{14,20},{34,40}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin coolerTemperatureC
    annotation (Placement(transformation(extent={{88,22},{108,42}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin supplyAirTemperatureC
    annotation (Placement(transformation(extent={{312,20},{332,40}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin heaterTemperatureC
    annotation (Placement(transformation(extent={{172,22},{192,42}})));
equation
  connect(roomHumidity.y, x_indoor.phi) annotation (Line(points={{140.7,183},{
          66,183},{66,182},{40,182}}, color={0,0,127}));
  connect(outdoorTemperature.y, toKelvin1.Celsius) annotation (Line(points={{
          -362.6,120},{-362.6,120},{-342,120}}, color={0,0,127}));
  connect(toKelvin1.Kelvin, x_outdoor.T) annotation (Line(points={{-319,120},{
          -310,120},{-310,-24},{-380,-24},{-380,-50},{-362,-50}}, color={0,0,
          127}));
  connect(outdoorHumidity.y, x_outdoor.phi) annotation (Line(points={{-362.6,76},
          {-340,76},{-340,-16},{-376,-16},{-376,-44},{-362,-44}}, color={0,0,
          127}));
  connect(coolingCircuit.y, toKelvin3.Celsius)
    annotation (Line(points={{19,110},{27.6,110},{28,84}}, color={0,0,127}));
  connect(toKelvin3.Kelvin, cooler.T_in) annotation (Line(points={{28,61},{28,
          40},{56,40},{56,-28},{32.32,-28},{32.32,-44.2}},
                                                       color={0,0,127}));
  connect(highTemperatureCircuit.y, toKelvin2.Celsius) annotation (Line(points=
          {{-59,130},{-54.5,130},{-54.5,130},{-50,130}}, color={0,0,127}));
  connect(toKelvin2.Kelvin, heater.T_in) annotation (Line(points={{-27,130},{
          112.32,130},{112.32,45.2}},
                                  color={0,0,127}));
  connect(toKelvin2.Kelvin, preHeater.T_in) annotation (Line(points={{-27,130},
          {-10,130},{-10,44},{-47.68,44},{-47.68,45.2}},
                                                     color={0,0,127}));
  connect(toKelvin1.Kelvin, freshAirSource.T_in) annotation (Line(points={{-319,
          120},{-310,120},{-310,120},{-310,-36},{-304,-36}}, color={0,0,127}));
  connect(roomTemperature.y, toKelvin.Celsius) annotation (Line(points={{140.7,
          132},{126,132},{126,154},{104,154}}, color={0,0,127}));
  connect(toKelvin.Kelvin, x_indoor.T) annotation (Line(points={{81,154},{62,
          154},{62,176},{40,176}}, color={0,0,127}));
  connect(extractAirSource.T_in, toKelvin.Kelvin) annotation (Line(points={{-78,
          182},{4,182},{4,154},{81,154}}, color={0,0,127}));
  connect(inOutlets.valveOpening, valveHRS) annotation (Line(points={{-166.716,
          26.3125},{-166.716,116.156},{-166,116.156},{-166,206}}, color={0,0,
          127}));
  connect(preHeater.valveOpening, valvePreHeater) annotation (Line(points={{-71.88,
          45.2},{-71.88,47},{-64,47},{-64,90}},    color={0,0,127}));
  connect(cooler.valveOpening, valveCooler) annotation (Line(points={{8.12,
          -44.2},{8.12,-63.5},{16,-63.5},{16,-106}},
                                              color={0,0,127}));
  connect(heater.valveOpening, valveHeater) annotation (Line(points={{88.12,
          45.2},{88.12,52},{96,52},{96,82}},
                                      color={0,0,127}));
  connect(humidifier.humidifierWSP, humidifierWSP1)
    annotation (Line(points={{212,13},{224,13},{224,54}}, color={0,0,127}));
  connect(inOutlets.portExhaustAirOut, outgoingAirOutletTemperature.port)
    annotation (Line(points={{-205.701,20.5625},{-205.701,31.2813},{-214,
          31.2813},{-214,40}}, color={0,127,255}));
  connect(outgoingAirOutletTemperature.T, outgoingAirOutletTemperatureC.Kelvin)
    annotation (Line(points={{-207,50},{-198,50}}, color={0,0,127}));
  connect(hRCTemperature.T, hRCTemperatureC.Kelvin)
    annotation (Line(points={{-81,30},{-72,30}}, color={0,0,127}));
  connect(preHeaterTemperature.T, preHeaterTemperatureC.Kelvin)
    annotation (Line(points={{1,30},{12,30}}, color={0,0,127}));
  connect(coolerTemperature.T, coolerTemperatureC.Kelvin)
    annotation (Line(points={{79,32},{86,32}}, color={0,0,127}));
  connect(supplyAirTemperature.T, supplyAirTemperatureC.Kelvin)
    annotation (Line(points={{295,30},{310,30}}, color={0,0,127}));
  connect(heaterTemperature.T, heaterTemperatureC.Kelvin)
    annotation (Line(points={{161,32},{170,32}}, color={0,0,127}));
end ControlledSystemBoundaries;
