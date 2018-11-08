within ModelicaModels.Subsystems.BaseClasses;
model HRCBaseClass
  "Subsystem model including dampers and heat recovery system"

extends ModelicaModels.Subsystems.BaseClasses.HeatExchangerBaseClass(
      ValveCharacteristicCurve(table=[0.0,0.0; 1,1]));

parameter Modelica.SIunits.MassFlowRate mFlowNomOut=1
    "Nominal mass flow rate OutgoingAir";
parameter Modelica.SIunits.MassFlowRate mFlowNomIn=1
    "Nominal mass flow rate IntakeAir";

parameter String resultFileName1 = "HrcResult.txt";
parameter String resultFileName2 = "HumResult.txt";

parameter String header = "Objective function value" "Header for result file";

parameter Modelica.SIunits.Pressure defaultPressure = 101300 "Default pressure";


  Buildings.Fluid.HeatExchangers.WetCoilCounterFlow IntakeHex(
    redeclare package Medium2 = MediumAir,
    redeclare package Medium1 = MediumWater,
    m2_flow_nominal=0.5,
    show_T=true,
    m1_flow_nominal=0.5,
    dp1_nominal=50,
    dp2_nominal=20,
    UA_nominal=27062.0)
    annotation (Placement(transformation(extent={{8,-94},{-12,-74}})));
  AixLib.Fluid.Movers.FlowControlled_dp CurculationPump(redeclare package
      Medium = MediumWater, m_flow_nominal=0.5) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={8,-24})));
  AixLib.Fluid.Actuators.Valves.ThreeWayLinear val(
    redeclare package Medium = MediumWater,
    m_flow_nominal=0.5,
    l={0.01,0.01},
    dpValve_nominal=10)
                   annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-12,6})));
  AixLib.Fluid.Sensors.TemperatureTwoPort OutgoingAirOutletTemp(redeclare
      package Medium = MediumAir, m_flow_nominal=mFlowNomOut)
    annotation (Placement(transformation(extent={{-24,86},{-44,66}})));
  AixLib.Fluid.Sensors.RelativeHumidity OutgoingAirRelHumid(redeclare package
      Medium =         MediumAir)
    annotation (Placement(transformation(extent={{-70,94},{-50,114}})));
  Modelica.Fluid.Sources.Boundary_pT RecirculationPressure(
    redeclare package Medium = MediumWater,
    use_X_in=false,
    use_p_in=false,
    p(displayUnit="Pa") = 101300,
    nPorts=1,
    use_T_in=false)
    annotation (Placement(transformation(extent={{66,-18},{46,2}})));
equation
  connect(val.port_3,CurculationPump. port_a)
    annotation (Line(points={{-2,6},{8,6},{8,-14}},  color={0,127,255}));
  connect(CurculationPump.port_b,IntakeHex. port_a1) annotation (Line(points={{8,-34},
          {8,-78}},                     color={0,127,255}));
  connect(OutgoingAirRelHumid.port,OutgoingAirOutletTemp. port_b) annotation (
     Line(points={{-60,94},{-60,76},{-44,76}},              color={0,127,255}));
  connect(RecirculationPressure.ports[1],CurculationPump. port_a) annotation (
     Line(points={{46,-8},{8,-8},{8,-14}},            color={0,127,255}));
  connect(val.port_2,IntakeHex. port_b1) annotation (Line(points={{-12,-4},{-12,
          -78}},               color={0,127,255}));
  connect(val.port_1, hex.port_b1)
    annotation (Line(points={{-12,16},{-12,58}}, color={0,127,255}));
  connect(hex.port_a1, CurculationPump.port_a)
    annotation (Line(points={{8,58},{8,-14}}, color={0,127,255}));
  connect(ValveCharacteristicCurve.y[1], val.y) annotation (Line(points={{-59,
          -50},{-34,-50},{-34,6},{-24,6}}, color={0,0,127}));
  connect(Pressure1.y, CurculationPump.dp_in) annotation (Line(points={{-59,-10},
          {32,-10},{32,-24},{20,-24}}, color={0,0,127}));
  connect(senTemp1.port, CurculationPump.port_b)
    annotation (Line(points={{10,-64},{8,-64},{8,-34}}, color={0,127,255}));
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
18: Humidity after recuperator")}),
    experiment(StopTime=3600, Interval=60),
    __Dymola_experimentSetupOutput);
end HRCBaseClass;
