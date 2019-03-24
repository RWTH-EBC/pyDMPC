within ModelicaModels.ControlledSystems;
model ControlledSystemPID "Version of controlled system with PID"
  extends ModelicaModels.BaseClasses.ControlledSystemBaseClass(volumeFlow(
        tableOnFile=false, table=[0,0.31,0.29]), freshAirSource(nPorts=2),
    Tset(k=30));
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
        origin={155,134})));
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
  Modelica.Blocks.Interfaces.RealOutput outgoingAirOutletHumidityOutput
    "Relative humidity in port medium" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-230,202})));
  Modelica.Blocks.Interfaces.RealOutput outdoorHumidityOutput
    "Connector of Real output signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-346,198})));
  Modelica.Blocks.Interfaces.RealOutput outgoingAirOutletTemperatureCOutput
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-210,202})));
  Modelica.Blocks.Interfaces.RealOutput outdoorTemperatureOutput
    "Connector of Real output signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-360,198})));
  Modelica.Blocks.Interfaces.RealOutput hRCHumidityOutput
    "Relative humidity in port medium" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-106,118})));
  Modelica.Blocks.Interfaces.RealOutput hRCTemperatureCOutput annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,118})));
  Modelica.Blocks.Interfaces.RealOutput preHeaterHumidityOutput
    "Relative humidity in port medium" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-2,76})));
  Modelica.Blocks.Interfaces.RealOutput preHeaterTemperatureCOutput
    "Temperature in port medium" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={12,76})));
  Modelica.Blocks.Interfaces.RealOutput coolerHumidityOutput
    "Relative humidity in port medium" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={58,82})));
  Modelica.Blocks.Interfaces.RealOutput coolerTemperatureCOutput annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={72,82})));
  Modelica.Blocks.Interfaces.RealOutput heaterHumidityOutput
    "Relative humidity in port medium" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={144,74})));
  Modelica.Blocks.Interfaces.RealOutput heaterTemperatureCOutput annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={160,74})));
  Modelica.Blocks.Interfaces.RealOutput supplyHumidityOutput
    "Relative humidity in port medium" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={276,76})));
  Modelica.Blocks.Interfaces.RealOutput supplyAirTemperatureCOutput annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={294,76})));
  Modelica.Blocks.Interfaces.RealOutput roomTemperatureOutput
    "Connector of Real output signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={212,178})));
  Modelica.Blocks.Interfaces.RealOutput roomHumidityOutput
    "Connector of Real output signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={190,176})));
  Modelica.Blocks.Interfaces.RealOutput coolingCircuitOutput
    "Connector of Real output signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={32,142})));
  Modelica.Blocks.Interfaces.RealOutput highTemperatureCircuitOutput
    "Connector of Real output signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-54,154})));
  Modelica.Blocks.Interfaces.RealOutput coolerReturnTemperatureOutput
    "Water return temperature in Celsius" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={78,-62})));
  Modelica.Blocks.Interfaces.RealOutput preHeaterReturnTemperatureOutput
    "Water return temperature in Celsius" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-12,-66})));
  Modelica.Blocks.Interfaces.RealOutput heaterReturnTemperatureOutput
    "Water return temperature in Celsius" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={142,-68})));
  Modelica.Blocks.Sources.RealExpression realExpression[4](y=inOutlets.hex.ele[
        :].mas.T)
    annotation (Placement(transformation(extent={{-200,-142},{-180,-122}})));
  Modelica.Blocks.Interfaces.RealOutput inOutletsOutgoingHexele1masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{-160,-126},{-140,-106}})));
  Modelica.Blocks.Interfaces.RealOutput inOutletsOutgoingHexele2masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{-160,-136},{-140,-116}})));
  Modelica.Blocks.Interfaces.RealOutput inOutletsOutgoingHexele3masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{-160,-146},{-140,-126}})));
  Modelica.Blocks.Interfaces.RealOutput inOutletsOutgoingHexele4masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{-160,-156},{-140,-136}})));
  Modelica.Blocks.Sources.RealExpression realExpression2[4](y=preHeater.hex.ele[
        :].mas.T)
    annotation (Placement(transformation(extent={{-78,-186},{-58,-166}})));
  Modelica.Blocks.Interfaces.RealOutput preHeaterhexele1masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{-38,-170},{-18,-150}})));
  Modelica.Blocks.Interfaces.RealOutput preHeaterhexele2masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{-38,-180},{-18,-160}})));
  Modelica.Blocks.Interfaces.RealOutput preHeaterhexele3masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{-38,-190},{-18,-170}})));
  Modelica.Blocks.Interfaces.RealOutput preHeaterhexele4masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{-38,-200},{-18,-180}})));
  Modelica.Blocks.Sources.RealExpression realExpression3[4](y=cooler.hex.ele[:].mas.T)
    annotation (Placement(transformation(extent={{8,-188},{28,-168}})));
  Modelica.Blocks.Interfaces.RealOutput coolerhexele1masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{48,-172},{68,-152}})));
  Modelica.Blocks.Interfaces.RealOutput coolerhexele2masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{48,-182},{68,-162}})));
  Modelica.Blocks.Interfaces.RealOutput coolerhexele3masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{48,-192},{68,-172}})));
  Modelica.Blocks.Interfaces.RealOutput coolerhexele4masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{48,-202},{68,-182}})));
  Modelica.Blocks.Sources.RealExpression realExpression4[4](y=heater.hex.ele[:].mas.T)
    annotation (Placement(transformation(extent={{96,-186},{116,-166}})));
  Modelica.Blocks.Interfaces.RealOutput heaterhexele1masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{136,-170},{156,-150}})));
  Modelica.Blocks.Interfaces.RealOutput heaterhexele2masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{136,-180},{156,-160}})));
  Modelica.Blocks.Interfaces.RealOutput heaterhexele3masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{136,-190},{156,-170}})));
  Modelica.Blocks.Interfaces.RealOutput heaterhexele4masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{136,-200},{156,-180}})));
  AixLib.Fluid.Sensors.RelativeHumidity outdoorHumidityMeas(redeclare package
      Medium = MediumAir) "Relative humidity outside"
    annotation (Placement(transformation(extent={{-254,-16},{-274,4}})));
  AixLib.Controls.Continuous.LimPID preHeaterController(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=100,
    yMin=0,
    yMax=100,
    k=1)
    annotation (Placement(transformation(extent={{-104,60},{-84,80}})));
  AixLib.Controls.Continuous.LimPID heaterController(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=100,
    yMin=0,
    Ti=100,
    k=1)
    annotation (Placement(transformation(extent={{88,80},{108,100}})));
  AixLib.Controls.Continuous.LimPID coolerController(
    yMax=100,
    yMin=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=100,
    y_start=1,
    reverseAction=true,
    k=1)
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  BaseClasses.HRCController hRCController
    annotation (Placement(transformation(extent={{-232,-28},{-212,-8}})));
  Modelica.Blocks.Sources.Constant roomTemperature1(k=0) annotation (Placement(
        transformation(
        extent={{13,13},{-13,-13}},
        rotation=0,
        origin={227,80})));
equation
  connect(roomHumidity.y, x_indoor.phi) annotation (Line(points={{140.7,183},{
          66,183},{66,182},{40,182}}, color={0,0,127}));
  connect(outdoorTemperature.y, toKelvin1.Celsius) annotation (Line(points={{
          -362.6,120},{-362.6,120},{-342,120}}, color={0,0,127}));
  connect(toKelvin1.Kelvin, freshAirSource.T_in) annotation (Line(points={{-319,
          120},{-310,120},{-310,120},{-310,-36},{-304,-36}}, color={0,0,127}));
  connect(roomTemperature.y, toKelvin.Celsius) annotation (Line(points={{140.7,
          134},{126,134},{126,154},{104,154}}, color={0,0,127}));
  connect(toKelvin.Kelvin, x_indoor.T) annotation (Line(points={{81,154},{62,
          154},{62,176},{40,176}}, color={0,0,127}));
  connect(extractAirSource.T_in, toKelvin.Kelvin) annotation (Line(points={{-78,
          182},{4,182},{4,154},{81,154}}, color={0,0,127}));
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
  connect(outgoingAirOutletHumidity.phi, outgoingAirOutletHumidityOutput)
    annotation (Line(points={{-235,58},{-230,58},{-230,202}}, color={0,0,127}));
  connect(outgoingAirOutletTemperatureC.Celsius,
    outgoingAirOutletTemperatureCOutput) annotation (Line(points={{-175,50},{
          -152,50},{-152,122},{-210,122},{-210,202}}, color={0,0,127}));
  connect(outdoorTemperature.y, outdoorTemperatureOutput) annotation (Line(
        points={{-362.6,120},{-360,120},{-360,198}}, color={0,0,127}));
  connect(hRCHumidity.phi, hRCHumidityOutput) annotation (Line(points={{-105,34},
          {-106,34},{-106,118}}, color={0,0,127}));
  connect(hRCTemperatureC.Celsius, hRCTemperatureCOutput) annotation (Line(
        points={{-49,30},{-38,30},{-38,98},{-90,98},{-90,118}}, color={0,0,127}));
  connect(preHeaterHumidity.phi, preHeaterHumidityOutput)
    annotation (Line(points={{-17,30},{-2,30},{-2,76}}, color={0,0,127}));
  connect(coolerHumidity.phi, coolerHumidityOutput)
    annotation (Line(points={{59,34},{58,34},{58,82}}, color={0,0,127}));
  connect(coolerTemperatureC.Celsius, coolerTemperatureCOutput) annotation (
      Line(points={{109,32},{114,32},{114,52},{72,52},{72,82}}, color={0,0,127}));
  connect(heaterHumidity.phi, heaterHumidityOutput)
    annotation (Line(points={{139,34},{144,34},{144,74}}, color={0,0,127}));
  connect(preHeaterTemperatureC.Celsius, preHeaterTemperatureCOutput)
    annotation (Line(points={{35,30},{38,30},{38,52},{12,52},{12,76}}, color={0,
          0,127}));
  connect(heaterTemperatureC.Celsius, heaterTemperatureCOutput) annotation (
      Line(points={{193,32},{198,32},{198,54},{160,54},{160,74}}, color={0,0,
          127}));
  connect(supplyHumidity.phi, supplyHumidityOutput)
    annotation (Line(points={{271,30},{276,30},{276,76}}, color={0,0,127}));
  connect(supplyAirTemperatureC.Celsius, supplyAirTemperatureCOutput)
    annotation (Line(points={{333,30},{348,30},{348,54},{294,54},{294,76}},
        color={0,0,127}));
  connect(roomTemperature.y, roomTemperatureOutput) annotation (Line(points={{140.7,
          134},{132,134},{132,150},{212,150},{212,178}},       color={0,0,127}));
  connect(roomHumidity.y, roomHumidityOutput) annotation (Line(points={{140.7,
          183},{126,183},{126,156},{190,156},{190,176}}, color={0,0,127}));
  connect(cooler.returnTemperature, coolerReturnTemperatureOutput) annotation (
      Line(points={{43.5714,-5.10769},{78,-5.10769},{78,-62}},
                                                      color={0,0,127}));
  connect(preHeater.returnTemperature, preHeaterReturnTemperatureOutput)
    annotation (Line(points={{-36.4286,6.10769},{-12,6.10769},{-12,-66}},
                                                                 color={0,0,127}));
  connect(heater.returnTemperature, heaterReturnTemperatureOutput) annotation (
      Line(points={{123.571,-0.505882},{142,-0.505882},{142,-68}},
                                                         color={0,0,127}));
  connect(realExpression[1].y, inOutletsOutgoingHexele1masT) annotation (Line(
        points={{-179,-132},{-168,-132},{-168,-116},{-150,-116}}, color={0,0,
          127}));
  connect(realExpression[2].y, inOutletsOutgoingHexele2masT) annotation (Line(
        points={{-179,-132},{-168,-132},{-168,-126},{-150,-126}}, color={0,0,
          127}));
  connect(realExpression[3].y, inOutletsOutgoingHexele3masT) annotation (Line(
        points={{-179,-132},{-170,-132},{-170,-136},{-150,-136}}, color={0,0,
          127}));
  connect(realExpression[4].y, inOutletsOutgoingHexele4masT) annotation (Line(
        points={{-179,-132},{-168,-132},{-168,-146},{-150,-146}}, color={0,0,
          127}));
  connect(realExpression2[1].y, preHeaterhexele1masT) annotation (Line(points={
          {-57,-176},{-46,-176},{-46,-160},{-28,-160}}, color={0,0,127}));
  connect(realExpression2[2].y, preHeaterhexele2masT) annotation (Line(points={
          {-57,-176},{-46,-176},{-46,-170},{-28,-170}}, color={0,0,127}));
  connect(realExpression2[3].y, preHeaterhexele3masT) annotation (Line(points={
          {-57,-176},{-48,-176},{-48,-180},{-28,-180}}, color={0,0,127}));
  connect(realExpression2[4].y, preHeaterhexele4masT) annotation (Line(points={
          {-57,-176},{-46,-176},{-46,-190},{-28,-190}}, color={0,0,127}));
  connect(realExpression3[1].y, coolerhexele1masT) annotation (Line(points={{29,
          -178},{40,-178},{40,-162},{58,-162}}, color={0,0,127}));
  connect(realExpression3[2].y, coolerhexele2masT) annotation (Line(points={{29,
          -178},{40,-178},{40,-172},{58,-172}}, color={0,0,127}));
  connect(realExpression3[3].y, coolerhexele3masT) annotation (Line(points={{29,
          -178},{38,-178},{38,-182},{58,-182}}, color={0,0,127}));
  connect(realExpression3[4].y, coolerhexele4masT) annotation (Line(points={{29,
          -178},{40,-178},{40,-192},{58,-192}}, color={0,0,127}));
  connect(realExpression4[1].y, heaterhexele1masT) annotation (Line(points={{
          117,-176},{128,-176},{128,-160},{146,-160}}, color={0,0,127}));
  connect(realExpression4[2].y, heaterhexele2masT) annotation (Line(points={{
          117,-176},{128,-176},{128,-170},{146,-170}}, color={0,0,127}));
  connect(realExpression4[3].y, heaterhexele3masT) annotation (Line(points={{
          117,-176},{126,-176},{126,-180},{146,-180}}, color={0,0,127}));
  connect(realExpression4[4].y, heaterhexele4masT) annotation (Line(points={{
          117,-176},{128,-176},{128,-190},{146,-190}}, color={0,0,127}));
  connect(preHeater.waterInflowTemperature, highTemperatureCircuitOutput)
    annotation (Line(points={{-44.2857,11.9231},{-36,11.9231},{-36,116},{-54,
          116},{-54,154}}, color={0,0,127}));
  connect(cooler.waterInflowTemperature, coolingCircuitOutput) annotation (Line(
        points={{35.7143,-10.9231},{56,-10.9231},{56,68},{32,68},{32,142}},
        color={0,0,127}));
  connect(outdoorHumidity.y, toTotAir.XiDry) annotation (Line(points={{-362.6,
          76},{-350,76},{-350,-6},{-374,-6},{-374,-44},{-363,-44}}, color={0,0,
          127}));
  connect(outdoorHumidityMeas.port, freshAirSource.ports[2]) annotation (Line(
        points={{-264,-16},{-264,-40},{-282,-40}}, color={0,127,255}));
  connect(outdoorHumidityMeas.phi, outdoorHumidityOutput) annotation (Line(
        points={{-275,-6},{-346,-6},{-346,198}}, color={0,0,127}));
  connect(outgoingAirOutletTemperature.port, inOutlets.portExhaustAirOut)
    annotation (Line(points={{-214,40},{-214,36},{-180.812,36},{-180.812,
          29.5765}}, color={0,127,255}));
  connect(outgoingAirOutletHumidity.port, inOutlets.portExhaustAirOut)
    annotation (Line(points={{-246,48},{-246,36},{-218,36},{-218,34},{-180.812,
          34},{-180.812,29.5765}}, color={0,127,255}));
  connect(preHeaterController.y, preHeater.valveOpening) annotation (Line(
        points={{-83,70},{-75.7143,70},{-75.7143,11.9231}}, color={0,0,127}));
  connect(heaterController.y, heater.valveOpening) annotation (Line(points={{109,90},
          {120,90},{120,58},{84.2857,58},{84.2857,3.94118}},         color={0,0,
          127}));
  connect(coolerController.y, cooler.valveOpening) annotation (Line(points={{-19,-70},
          {4.28571,-70},{4.28571,-10.9231}},          color={0,0,127}));
  connect(hRCController.opening, inOutlets.valveOpening) annotation (Line(
        points={{-211,-18},{-196.5,-18},{-196.5,0.352941},{-181.059,0.352941}},
        color={0,0,127}));
  connect(hRCTemperature.T, hRCController.T_HRC) annotation (Line(points={{-81,
          30},{-78,30},{-78,48},{-126,48},{-126,76},{-268,76},{-268,18},{-217,
          18},{-217,-8}}, color={0,0,127}));
  connect(toKelvinSet.Kelvin, hRCController.T_set) annotation (Line(points={{
          -339,-96},{-280,-96},{-280,-52},{-242,-52},{-242,-11},{-232,-11}},
        color={0,0,127}));
  connect(toKelvin1.Kelvin, hRCController.T_fresh) annotation (Line(points={{
          -319,120},{-310,120},{-310,12},{-248,12},{-248,-18},{-232,-18}},
        color={0,0,127}));
  connect(toKelvin.Kelvin, hRCController.T_extract) annotation (Line(points={{
          81,154},{-252,154},{-252,-25},{-232,-25}}, color={0,0,127}));
  connect(toKelvinSet.Kelvin, preHeaterController.u_s) annotation (Line(points=
          {{-339,-96},{-280,-96},{-280,-52},{-242,-52},{-242,8},{-204,8},{-204,
          70},{-106,70}}, color={0,0,127}));
  connect(toKelvinSet.Kelvin, heaterController.u_s) annotation (Line(points={{
          -339,-96},{-280,-96},{-280,-52},{-242,-52},{-242,8},{-204,8},{-204,70},
          {-118,70},{-118,90},{86,90}}, color={0,0,127}));
  connect(toKelvinSet.Kelvin, coolerController.u_s) annotation (Line(points={{
          -339,-96},{-102,-96},{-102,-108},{-54,-108},{-54,-70},{-42,-70}},
        color={0,0,127}));
  connect(roomTemperature1.y, humidifier.humidifierWSP) annotation (Line(points={{212.7,
          80},{208,80},{208,3.28},{212.491,3.28}},        color={0,0,127}));
  connect(heaterTemperature.T, heaterController.u_m) annotation (Line(points={{
          161,32},{164,32},{164,74},{98,74},{98,78}}, color={0,0,127}));
  connect(coolerTemperature.T, coolerController.u_m) annotation (Line(points={{
          79,32},{79,-98},{-30,-98},{-30,-82}}, color={0,0,127}));
  connect(preHeaterTemperature.T, preHeaterController.u_m) annotation (Line(
        points={{1,30},{2,30},{2,52},{-94,52},{-94,58}}, color={0,0,127}));
  annotation (
    experiment(StopTime=10800, Interval=10),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=false,
      OutputFlatModelica=false));
end ControlledSystemPID;
