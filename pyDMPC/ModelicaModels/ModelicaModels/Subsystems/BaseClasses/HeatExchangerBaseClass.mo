within ModelicaModels.Subsystems.BaseClasses;
model HeatExchangerBaseClass
  "Base class for the heat exchanger subsystems"

  replaceable package MediumAir = AixLib.Media.Air;
  replaceable package MediumWater = AixLib.Media.Water;


  parameter Modelica.SIunits.Pressure defaultPressure = 101300 "Default pressure";

  parameter String fileName="../CoolerCost.txt"
    "Name of the file containing the efficiency";
  parameter Real specificCost=15 "cost in ct/kWh";

  Modelica.Blocks.Interfaces.RealInput T_in "Prescribed boundary temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={56,-220})));
  Buildings.Fluid.Sensors.Temperature senTemp1(redeclare package Medium =
        MediumWater)
    annotation (Placement(transformation(extent={{72,-122},{92,-102}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin returnTempInC annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={112,-112})));
  Modelica.Blocks.Interfaces.RealOutput returnTemperature
    "Water return temperature in Celsius"
    annotation (Placement(transformation(extent={{200,-170},{220,-150}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-86},{-80,-66}})));
  Buildings.Fluid.HeatExchangers.WetCoilCounterFlow hex(
    redeclare package Medium2 = MediumAir,
    redeclare package Medium1 = MediumWater,
    m1_flow_nominal=0.5,
    m2_flow_nominal=0.5,
    dp2_nominal=200,
    UA_nominal=1000,
    dp1_nominal=8000)
    annotation (Placement(transformation(extent={{80,16},{60,-4}})));
  AixLib.Fluid.Sources.Boundary_pT    warmWaterSource(
    use_X_in=false,
    redeclare package Medium = MediumWater,
    use_T_in=true,
    p(displayUnit="Pa") = defaultPressure,
    T=303.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,-170})));
  AixLib.Fluid.Sources.Boundary_pT    waterSink(
    use_T_in=false,
    use_X_in=false,
    redeclare package Medium = MediumWater,
    use_p_in=false,
    p(displayUnit="Pa") = defaultPressure)
              annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={80,-170})));
  Modelica.Blocks.Sources.Constant Pressure1(k=10000)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={10,-70})));
  Modelica.Blocks.Tables.CombiTable1D ValveCharacteristicCurve(
    tableOnFile=true,
    tableName="valve",
    fileName="PreHeater/PreHeaterValve.txt")
    annotation (Placement(transformation(extent={{-6,-120},{14,-100}})));
  Modelica.Blocks.Math.Gain gain3(k=1/100)
    annotation (Placement(transformation(extent={{-26,-114},{-14,-102}})));
equation
  connect(senTemp1.T, returnTempInC.Kelvin) annotation (Line(points={{89,-112},{
          92,-112},{100,-112}}, color={0,0,127}));
  connect(returnTempInC.Celsius, returnTemperature) annotation (Line(points={{
          123,-112},{182,-112},{182,-160},{210,-160}}, color={0,0,127}));
  connect(ValveCharacteristicCurve.u[1],gain3. y) annotation (Line(points={{-8,-110},
          {-10,-110},{-10,-108},{-13.4,-108}},                color={0,0,127}));
  connect(T_in, warmWaterSource.T_in)
    annotation (Line(points={{56,-220},{56,-182}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatExchangerBaseClass;
