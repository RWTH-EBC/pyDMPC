within ModelicaModels.Subsystems.BaseClasses;
model HRCBaseClass
  "Subsystem model including dampers and heat recovery system"

extends ModelicaModels.Subsystems.BaseClasses.BaseClass;

parameter Modelica.SIunits.MassFlowRate mFlowNomOut=1
    "Nominal mass flow rate OutgoingAir";
parameter Modelica.SIunits.MassFlowRate mFlowNomIn=1
    "Nominal mass flow rate IntakeAir";

parameter String resultFileName1 = "HrcResult.txt";
parameter String resultFileName2 = "HumResult.txt";

parameter String header = "Objective function value" "Header for result file";

parameter Modelica.SIunits.Pressure defaultPressure = 101300 "Default pressure";
// parameter Integer nEle = 4 "Number of elements of the heat exchangers";
// parameter Modelica.SIunits.Temperature T_start_supply = 293.15 "Initial temperature of supply duct";
// parameter Modelica.SIunits.Temperature T_start_exhaust = 293.15 "Initial temperature of exhaust duct";

  Buildings.Fluid.HeatExchangers.WetCoilCounterFlow OutgoingHex(
    redeclare package Medium2 = MediumAir,
    redeclare package Medium1 = MediumWater,
    show_T=true,
    m2_flow_nominal=0.5,
    m1_flow_nominal=0.5,
    UA_nominal=86062.0,
    dp1_nominal=50,
    dp2_nominal=20)
    annotation (Placement(transformation(extent={{0,64},{20,44}})));
  Buildings.Fluid.HeatExchangers.WetCoilCounterFlow IntakeHex(
    redeclare package Medium2 = MediumAir,
    redeclare package Medium1 = MediumWater,
    m2_flow_nominal=0.5,
    show_T=true,
    m1_flow_nominal=0.5,
    dp1_nominal=50,
    dp2_nominal=20,
    UA_nominal=27062.0)
    annotation (Placement(transformation(extent={{20,-64},{0,-44}})));
  AixLib.Fluid.Movers.FlowControlled_dp CurculationPump(redeclare package
      Medium = MediumWater, m_flow_nominal=0.5) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,-20})));
  AixLib.Fluid.Actuators.Valves.ThreeWayLinear val(
    redeclare package Medium = MediumWater,
    m_flow_nominal=0.5,
    l={0.01,0.01},
    dpValve_nominal=10)
                   annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,0})));
  Modelica.Blocks.Tables.CombiTable1D ValveCharacteristicCurve(tableOnFile=false,
      table=[0,0; 0.25,0; 0.5,0.025; 0.7,1; 0.9,1; 1,1])
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  Modelica.Blocks.Math.Gain gain2(k=1/100)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  AixLib.Fluid.Sensors.TemperatureTwoPort OutgoingAirOutletTemp(redeclare
      package Medium = MediumAir, m_flow_nominal=mFlowNomOut)
    annotation (Placement(transformation(extent={{-70,70},{-90,50}})));
  AixLib.Fluid.Sensors.RelativeHumidity OutgoingAirRelHumid(redeclare package
      Medium =         MediumAir)
    annotation (Placement(transformation(extent={{-130,80},{-110,100}})));
  Modelica.Fluid.Sources.Boundary_pT RecirculationPressure(
    redeclare package Medium = MediumWater,
    use_X_in=false,
    use_p_in=false,
    p(displayUnit="Pa") = 101300,
    nPorts=1,
    use_T_in=false)
    annotation (Placement(transformation(extent={{60,10},{40,30}})));
  AixLib.Fluid.Actuators.Valves.TwoWayLinear outsideAirInletValve(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mFlowNomIn,
    dpValve_nominal=50)
    annotation (Placement(transformation(extent={{-320,-50},{-300,-70}})));
  AixLib.Fluid.Actuators.Valves.TwoWayLinear outletValve(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mFlowNomOut,
    dpValve_nominal=50)
    annotation (Placement(transformation(extent={{-300,50},{-320,70}})));
  AixLib.Fluid.Actuators.Valves.TwoWayLinear reciculationValve(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mFlowNomOut,
    dpValve_nominal=50) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-260,0})));
  Modelica.Blocks.Math.Gain gain3(k=1/100)
    annotation (Placement(transformation(extent={{-240,-112},{-260,-92}})));
  Modelica.Blocks.Math.Gain gain4(k=1/100)
    annotation (Placement(transformation(extent={{-180,-10},{-200,10}})));
  Modelica.Blocks.Math.Gain gain5(k=1/100) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-310,130})));
  Modelica.Blocks.Sources.Constant flapOpening(k=100) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-424,-160})));
  Modelica.Blocks.Sources.Constant oneHundred(k=100) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-424,-198})));
  Modelica.Blocks.Math.Add add1(k1=-1)
    annotation (Placement(transformation(extent={{-346,-204},{-326,-184}})));
  Modelica.Blocks.Sources.Constant PumpDp(k=12000) "Pa"
    annotation (Placement(transformation(extent={{88,-30},{68,-10}})));
public
  Modelica.Fluid.Sensors.Temperature hrcTemp(redeclare package Medium =
        MediumWater) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,32})));
equation
  connect(OutgoingHex.port_b1,CurculationPump. port_a)
    annotation (Line(points={{20,48},{20,48},{20,-10}}, color={0,127,255}));
  connect(val.port_3,CurculationPump. port_a)
    annotation (Line(points={{10,0},{20,0},{20,-10}},color={0,127,255}));
  connect(CurculationPump.port_b,IntakeHex. port_a1) annotation (Line(points={{20,-30},
          {20,-39},{20,-48}},           color={0,127,255}));
  connect(ValveCharacteristicCurve.y[1],val. y)
    annotation (Line(points={{-37,0},{-37,0},{-12,0}}, color={0,0,127}));
  connect(gain2.y,ValveCharacteristicCurve. u[1])
    annotation (Line(points={{-79,0},{-79,0},{-60,0}}, color={0,0,127}));
  connect(OutgoingHex.port_b2,OutgoingAirOutletTemp. port_a) annotation (Line(
        points={{0,60},{-70,60}},            color={0,127,255}));
  connect(OutgoingAirRelHumid.port,OutgoingAirOutletTemp. port_b) annotation (
     Line(points={{-120,80},{-120,60},{-90,60},{-90,60}},   color={0,127,255}));
  connect(RecirculationPressure.ports[1],CurculationPump. port_a) annotation (
     Line(points={{40,20},{20,20},{20,10},{20,-10}},  color={0,127,255}));
  connect(val.port_2,IntakeHex. port_b1) annotation (Line(points={{0,-10},{0,-48}},
                               color={0,127,255}));
  connect(val.port_1,OutgoingHex. port_a1)
    annotation (Line(points={{0,10},{0,48}},     color={0,127,255}));
  connect(outletValve.port_a,reciculationValve. port_a) annotation (Line(
        points={{-300,60},{-260,60},{-260,10}},
                                             color={0,127,255}));
  connect(reciculationValve.port_b,outsideAirInletValve. port_b) annotation (
      Line(points={{-260,-10},{-260,-10},{-260,-60},{-300,-60}},
                                                           color={0,127,255}));
  connect(outsideAirInletValve.port_b, IntakeHex.port_a2) annotation (Line(
        points={{-300,-60},{-150,-60},{0,-60}}, color={0,127,255}));
  connect(outletValve.port_a, OutgoingAirOutletTemp.port_b) annotation (Line(
        points={{-300,60},{-90,60},{-90,60}},  color={0,127,255}));
  connect(flapOpening.y, gain3.u) annotation (Line(points={{-413,-160},{-278,-160},
          {-212,-160},{-212,-102},{-212,-102},{-238,-102},{-238,-102}},
        color={0,0,127}));
  connect(flapOpening.y, gain5.u) annotation (Line(points={{-413,-160},{-360,
          -160},{-360,160},{-320,160},{-310,160},{-310,142}}, color={0,0,127}));
  connect(flapOpening.y, add1.u1) annotation (Line(points={{-413,-160},{-360,
          -160},{-360,-188},{-348,-188}}, color={0,0,127}));
  connect(oneHundred.y, add1.u2) annotation (Line(points={{-413,-198},{-348,
          -198},{-348,-200}}, color={0,0,127}));
  connect(add1.y, gain4.u) annotation (Line(points={{-325,-194},{-160,-194},{
          -160,0},{-178,0}}, color={0,0,127}));
  connect(val.port_1, hrcTemp.port) annotation (Line(points={{0,10},{0,22},{0,
          32},{-20,32}}, color={0,127,255}));
  connect(PumpDp.y, CurculationPump.dp_in) annotation (Line(points={{67,-20},{66,
          -20},{66,-20},{32,-20}},        color={0,0,127}));
  connect(gain5.y, outletValve.y) annotation (Line(points={{-310,119},{-310,72},
          {-310,72}}, color={0,0,127}));
  connect(gain4.y, reciculationValve.y)
    annotation (Line(points={{-201,0},{-248,0},{-248,0}}, color={0,0,127}));
  connect(gain3.y, outsideAirInletValve.y) annotation (Line(points={{-261,-102},
          {-282,-102},{-310,-102},{-310,-72}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-660,-500},
            {680,300}})),  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-660,-500},{680,300}}),   graphics={       Text(
            extent={{-892,220},{-904,168}},
            lineColor={238,46,47},
            horizontalAlignment=TextAlignment.Left,
          textString="Measurement Data

1: outside air temperature
2: outside air rel.humidity
3: exhaust air temperature
4: exhaust air rel.humidity
5: outgoing air temperature
6: outgoing air rel.humidity
7: supply air temperature
8: supply rel.humidity
9: temperature after pre-heater
10: temperature after cooler
11: temperature after heater
12: temperature water pre-heater
13: temperature water cooler
14: temperature water heater
15: water return pre-heater
16: water return heater
17: Temperature after recuperator
18: Humidity after recuperator"),
        Text(
          extent={{252,204},{264,186}},
          lineColor={28,108,200},
          textString="1: Supply
2: Exhaust",
          horizontalAlignment=TextAlignment.Left),
        Line(points={{-634,-402},{-568,-402}}, color={238,46,47}),
        Text(
          extent={{-550,-386},{-384,-416}},
          lineColor={238,46,47},
          textString="Pressure connectors")}),
    experiment(StopTime=3600, Interval=60),
    __Dymola_experimentSetupOutput);
end HRCBaseClass;
