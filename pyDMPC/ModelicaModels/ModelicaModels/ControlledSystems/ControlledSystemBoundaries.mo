within ModelicaModels.ControlledSystems;
model ControlledSystemBoundaries
  "Version of controlled system with boundary conditions"
  extends ModelicaModels.BaseClasses.ControlledSystemBaseClass(volumeFlow(
        tableOnFile=false, table=[0,0.31,0.29]));
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
  Modelica.Blocks.Interfaces.RealOutput outgoingAirOutletHumidityOutput
    "Relative humidity in port medium" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-230,202})));
  Modelica.Blocks.Interfaces.RealOutput outdoorHumidityOutput
    "Connector of Real output signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-350,198})));
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
  Modelica.Blocks.Sources.RealExpression realExpression1[4](y=inOutlets.IntakeHex.ele[
        :].mas.T)
    annotation (Placement(transformation(extent={{-198,-190},{-178,-170}})));
  Modelica.Blocks.Interfaces.RealOutput inOutletsIntakeHexele1masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{-158,-174},{-138,-154}})));
  Modelica.Blocks.Interfaces.RealOutput inOutletsIntakeHexele2masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{-158,-184},{-138,-164}})));
  Modelica.Blocks.Interfaces.RealOutput inOutletsIntakeHexele3masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{-158,-194},{-138,-174}})));
  Modelica.Blocks.Interfaces.RealOutput inOutletsIntakeHexele4masT
    "Value of Real output"
    annotation (Placement(transformation(extent={{-158,-204},{-138,-184}})));
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
  connect(inOutlets.portExhaustAirIn, outgoingAirOutletTemperature.port)
    annotation (Line(points={{-144.371,29.5765},{-144.371,31.2813},{-214,
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
  connect(outgoingAirOutletHumidity.port, inOutlets.portExhaustAirIn)
    annotation (Line(points={{-246,48},{-246,38},{-220,38},{-220,29.5765},{
          -144.371,29.5765}}, color={0,127,255}));
  connect(outgoingAirOutletHumidity.phi, outgoingAirOutletHumidityOutput)
    annotation (Line(points={{-235,58},{-230,58},{-230,202}}, color={0,0,127}));
  connect(outdoorHumidity.y, outdoorHumidityOutput) annotation (Line(points={{
          -362.6,76},{-350,76},{-350,198}}, color={0,0,127}));
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
  connect(roomTemperature.y, roomTemperatureOutput) annotation (Line(points={{
          140.7,132},{132,132},{132,150},{212,150},{212,178}}, color={0,0,127}));
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
  connect(realExpression1[1].y, inOutletsIntakeHexele1masT) annotation (Line(
        points={{-177,-180},{-166,-180},{-166,-164},{-148,-164}}, color={0,0,
          127}));
  connect(realExpression1[2].y, inOutletsIntakeHexele2masT) annotation (Line(
        points={{-177,-180},{-166,-180},{-166,-174},{-148,-174}}, color={0,0,
          127}));
  connect(realExpression1[3].y, inOutletsIntakeHexele3masT) annotation (Line(
        points={{-177,-180},{-168,-180},{-168,-184},{-148,-184}}, color={0,0,
          127}));
  connect(realExpression1[4].y, inOutletsIntakeHexele4masT) annotation (Line(
        points={{-177,-180},{-166,-180},{-166,-194},{-148,-194}}, color={0,0,
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
end ControlledSystemBoundaries;
