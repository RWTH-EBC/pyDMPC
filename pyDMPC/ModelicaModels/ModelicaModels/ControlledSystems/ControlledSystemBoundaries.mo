within ModelicaModels.ControlledSystems;
model ControlledSystemBoundaries
  "Version of controlled system with boundary conditions"
  extends ModelicaModels.BaseClasses.ControlledSystemBaseClass(volumeFlow(
        tableOnFile=false, table=[0,0.31,0.29]), freshAirSource(nPorts=2));
  Modelica.Blocks.Sources.Sine     outdoorTemperature(
    amplitude=10,
    freqHz=1/7200,
    offset=30)                                              annotation (
      Placement(transformation(
        extent={{14,-14},{-14,14}},
        rotation=180,
        origin={-378,120})));
  Modelica.Blocks.Sources.Constant outdoorHumidity(k=0.007)
                                                          annotation (Placement(
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
  AixLib.Fluid.Sensors.RelativeHumidity outgoingAirOutletHumidity(redeclare
      package Medium = MediumAir) "Relative humidity after HRC"
    annotation (Placement(transformation(extent={{-256,48},{-236,68}})));
  Modelica.Blocks.Sources.RealExpression realExpression[4](y=inOutlets.hex.ele[
        :].mas.T)
    annotation (Placement(transformation(extent={{-200,-142},{-180,-122}})));
  Modelica.Blocks.Sources.RealExpression realExpression2[4](y=preHeater.hex.ele[
        :].mas.T)
    annotation (Placement(transformation(extent={{-78,-186},{-58,-166}})));
  Modelica.Blocks.Sources.RealExpression coolerInitials[4](y=cooler.hex.ele[:].mas.T)
    annotation (Placement(transformation(extent={{8,-188},{28,-168}})));
  Modelica.Blocks.Sources.RealExpression heaterInitials[4](y=heater.hex.ele[:].mas.T)
    annotation (Placement(transformation(extent={{96,-186},{116,-166}})));
  AixLib.Fluid.Sensors.RelativeHumidity outdoorHumidityMeas(redeclare package
      Medium = MediumAir) "Relative humidity outside"
    annotation (Placement(transformation(extent={{-254,-16},{-274,4}})));
equation
  connect(roomHumidity.y, x_indoor.phi) annotation (Line(points={{140.7,183},{
          66,183},{66,182},{40,182}}, color={0,0,127}));
  connect(outdoorTemperature.y, toKelvin1.Celsius) annotation (Line(points={{
          -362.6,120},{-362.6,120},{-342,120}}, color={0,0,127}));
  connect(toKelvin1.Kelvin, freshAirSource.T_in) annotation (Line(points={{-319,
          120},{-310,120},{-310,120},{-310,-36},{-304,-36}}, color={0,0,127}));
  connect(roomTemperature.y, toKelvin.Celsius) annotation (Line(points={{140.7,
          132},{126,132},{126,154},{104,154}}, color={0,0,127}));
  connect(toKelvin.Kelvin, x_indoor.T) annotation (Line(points={{81,154},{62,
          154},{62,176},{40,176}}, color={0,0,127}));
  connect(extractAirSource.T_in, toKelvin.Kelvin) annotation (Line(points={{-78,
          182},{4,182},{4,154},{81,154}}, color={0,0,127}));
  connect(inOutlets.valveOpening, valveHRS) annotation (Line(points={{-181.059,
          0.352941},{-181.059,116.156},{-166,116.156},{-166,206}},color={0,0,
          127}));
  connect(preHeater.valveOpening, valvePreHeater) annotation (Line(points={{
          -75.7143,11.9231},{-75.7143,47},{-64,47},{-64,90}},
                                                   color={0,0,127}));
  connect(cooler.valveOpening, valveCooler) annotation (Line(points={{4.28571,
          -10.9231},{4.28571,-63.5},{16,-63.5},{16,-106}},
                                              color={0,0,127}));
  connect(heater.valveOpening, valveHeater) annotation (Line(points={{84.2857,
          3.94118},{84.2857,52},{96,52},{96,82}},
                                      color={0,0,127}));
  connect(humidifier.humidifierWSP, humidifierWSP1)
    annotation (Line(points={{212.491,3.28},{224,3.28},{224,54}},
                                                          color={0,0,127}));
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
  connect(outdoorHumidity.y, toTotAir.XiDry) annotation (Line(points={{-362.6,
          76},{-350,76},{-350,-6},{-374,-6},{-374,-44},{-363,-44}}, color={0,0,
          127}));
  connect(outdoorHumidityMeas.port, freshAirSource.ports[2]) annotation (Line(
        points={{-264,-16},{-264,-40},{-282,-40}}, color={0,127,255}));
  connect(outgoingAirOutletTemperature.port, inOutlets.portExhaustAirOut)
    annotation (Line(points={{-214,40},{-214,36},{-180.812,36},{-180.812,
          29.5765}}, color={0,127,255}));
  connect(outgoingAirOutletHumidity.port, inOutlets.portExhaustAirOut)
    annotation (Line(points={{-246,48},{-246,36},{-218,36},{-218,34},{-180.812,
          34},{-180.812,29.5765}}, color={0,127,255}));
  annotation (
    experiment(StopTime=86400, Interval=10),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=false,
      OutputFlatModelica=false));
end ControlledSystemBoundaries;
