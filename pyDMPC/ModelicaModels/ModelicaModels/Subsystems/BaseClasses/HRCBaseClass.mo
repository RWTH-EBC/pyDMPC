within ModelicaModels.Subsystems.BaseClasses;
model HRCBaseClass
  "Subsystem model including dampers and heat recovery system"

replaceable package MediumAir = AixLib.Media.Air;
parameter Modelica.SIunits.MassFlowRate mFlowNomOut=1
    "Nominal mass flow rate OutgoingAir";
parameter Modelica.SIunits.MassFlowRate mFlowNomIn=1
    "Nominal mass flow rate IntakeAir";

parameter String resultFileName1 = "HrcResult.txt";
parameter String resultFileName2 = "HumResult.txt";

parameter String header = "Objective function value" "Header for result file";

parameter Modelica.SIunits.Pressure defaultPressure = 101300 "Default pressure";


  AixLib.Fluid.Sensors.TemperatureTwoPort OutgoingAirOutletTemp(redeclare
      package Medium = MediumAir, m_flow_nominal=mFlowNomOut)
    annotation (Placement(transformation(extent={{-24,86},{-44,66}})));
  AixLib.Fluid.Sensors.RelativeHumidity OutgoingAirRelHumid(redeclare package
      Medium =         MediumAir)
    annotation (Placement(transformation(extent={{-70,94},{-50,114}})));
  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow hex(
    redeclare package Medium2 = MediumAir,
    redeclare package Medium1 = MediumAir,
    m2_flow_nominal=0.5,
    dp2_nominal=200,
    UA_nominal=1000,
    m1_flow_nominal=0.5,
    dp1_nominal=200)
    annotation (Placement(transformation(extent={{26,68},{46,48}})));
  Modelica.Blocks.Sources.Constant Pressure1(k=10000)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-32,-16})));
  Modelica.Blocks.Tables.CombiTable1D ValveCharacteristicCurve(tableOnFile=
        false, table=[0.0,0.0; 1,1])
    annotation (Placement(transformation(extent={{-42,-66},{-22,-46}})));
  Modelica.Blocks.Math.Gain convertCommand(k=1/100) "Convert from percent"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-58,-56})));
  AixLib.Fluid.Actuators.Dampers.Exponential dam(m_flow_nominal=0.5, redeclare
      package Medium =                                                                          MediumAir,

    linearized=true)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={22,34})));
  Modelica.Blocks.Math.Add add(k2=-1)
    annotation (Placement(transformation(extent={{-16,4},{-4,16}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{-40,8},{-28,20}})));
  AixLib.Fluid.Actuators.Dampers.Exponential dam1(m_flow_nominal=0.5, redeclare
      package Medium =                                                                           MediumAir,

    linearized=true)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={44,-10})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-72,140},{-52,160}})));
  AixLib.Fluid.FixedResistances.PressureDrop exhaustPressureDrop(m_flow_nominal=
       0.3, dp_nominal=350,redeclare package Medium =
               MediumAir) "Pressure drop in exhaust duct" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,4})));
equation
  connect(OutgoingAirRelHumid.port,OutgoingAirOutletTemp. port_b) annotation (
     Line(points={{-60,94},{-60,76},{-44,76}},              color={0,127,255}));
  connect(ValveCharacteristicCurve.u[1],convertCommand. y)
    annotation (Line(points={{-44,-56},{-51.4,-56}}, color={0,0,127}));
  connect(ValveCharacteristicCurve.y[1], dam.y) annotation (Line(points={{-21,-56},
          {0,-56},{0,34},{10,34}}, color={0,0,127}));
  connect(const.y, add.u1) annotation (Line(points={{-27.4,14},{-22,14},{-22,13.6},
          {-17.2,13.6}}, color={0,0,127}));
  connect(add.y, dam1.y)
    annotation (Line(points={{-3.4,10},{44,10},{44,2}}, color={0,0,127}));
  connect(ValveCharacteristicCurve.y[1], add.u2) annotation (Line(points={{-21,
          -56},{-17.2,-56},{-17.2,6.4}}, color={0,0,127}));
  connect(dam.port_b, hex.port_a1)
    annotation (Line(points={{22,44},{22,52},{26,52}}, color={0,127,255}));
  connect(exhaustPressureDrop.port_b, dam.port_a)
    annotation (Line(points={{-50,4},{22,4},{22,24}}, color={0,127,255}));
  connect(exhaustPressureDrop.port_b, dam1.port_a) annotation (Line(points={{
          -50,4},{22,4},{22,-10},{34,-10}}, color={0,127,255}));
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
