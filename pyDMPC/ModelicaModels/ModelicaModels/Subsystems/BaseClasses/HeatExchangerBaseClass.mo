within ModelicaModels.Subsystems.BaseClasses;
model HeatExchangerBaseClass
  "Base class for the heat exchanger subsystems"

  replaceable package MediumAir = AixLib.Media.Air;
  replaceable package MediumWater = AixLib.Media.Water;


  parameter Modelica.SIunits.Pressure defaultPressure = 101300 "Default pressure";

  parameter String fileName="../CoolerCost.txt"
    "Name of the file containing the efficiency";
  parameter Real specificCost=15 "cost in ct/kWh";

  Buildings.Fluid.Sensors.Temperature senTemp1(redeclare package Medium =
        MediumWater)
    annotation (Placement(transformation(extent={{0,-64},{20,-44}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin returnTempInC annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={40,-54})));
  Modelica.Blocks.Interfaces.RealOutput returnTemperature
    "Water return temperature in Celsius"
    annotation (Placement(transformation(extent={{140,-64},{160,-44}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Buildings.Fluid.HeatExchangers.WetCoilCounterFlow hex(
    redeclare package Medium2 = MediumAir,
    redeclare package Medium1 = MediumWater,
    m2_flow_nominal=0.5,
    dp2_nominal=200,
    UA_nominal=1000,
    dp1_nominal=8000,
    m1_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{8,74},{-12,54}})));
  AixLib.Fluid.Sources.Boundary_pT    warmWaterSource(
    use_X_in=false,
    redeclare package Medium = MediumWater,
    use_T_in=true,
    p(displayUnit="Pa") = defaultPressure,
    T=303.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-12,-112})));
  AixLib.Fluid.Sources.Boundary_pT    waterSink(
    use_T_in=false,
    use_X_in=false,
    redeclare package Medium = MediumWater,
    use_p_in=false,
    p(displayUnit="Pa") = defaultPressure)
              annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={8,-112})));
  Modelica.Blocks.Sources.Constant Pressure1(k=10000)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,-10})));
  Modelica.Blocks.Tables.CombiTable1D ValveCharacteristicCurve(tableOnFile=
        false)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Constant Temperature(k=273 + 50) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-130,-128})));
  Modelica.Blocks.Math.Gain convertCommand(k=1/100) "Convert from percent"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-96,-50})));
equation
  connect(senTemp1.T, returnTempInC.Kelvin) annotation (Line(points={{17,-54},{
          28,-54}},             color={0,0,127}));
  connect(returnTempInC.Celsius, returnTemperature) annotation (Line(points={{51,-54},
          {150,-54}},                                  color={0,0,127}));
  connect(Temperature.y, warmWaterSource.T_in) annotation (Line(points={{-119,
          -128},{-16,-128},{-16,-124}}, color={0,0,127}));
  connect(ValveCharacteristicCurve.u[1], convertCommand.y)
    annotation (Line(points={{-82,-50},{-89.4,-50}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -140},{140,120}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,
            120}})));
end HeatExchangerBaseClass;
