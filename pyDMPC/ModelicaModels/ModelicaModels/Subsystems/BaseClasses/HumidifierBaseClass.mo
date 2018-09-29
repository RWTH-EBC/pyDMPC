within ModelicaModels.Subsystems.BaseClasses;
model HumidifierBaseClass "Base class of the humdifier"

  replaceable package MediumAir =
      AixLib.Media.Air;
  replaceable package MediumWater = AixLib.Media.Water;

  parameter Modelica.SIunits.MassFlowRate mFlowNomIn=1
    "Nominal mass flow rate IntakeAir";

  AixLib.Fluid.MixingVolumes.MixingVolume    vol(
    redeclare package Medium = MediumAir,
    m_flow_nominal=0.5,
    V=0.1)
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Modelica.Fluid.Sources.MassFlowSource_T  SteamSource(
    m_flow=0.5,
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    use_X_in=false,
    T=100 + 273.15,
    X={0.99,0.01},
    use_T_in=true)
             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-140})));
  Modelica.Blocks.Math.Gain gain(k=1/100) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={164,-130})));
  Modelica.Blocks.Tables.CombiTable1D HumidifierCharacteristics(
    tableOnFile=true,
    tableName="Humidifier",
    fileName="Steam_humidifier/InHumidifier.txt")
                                  annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,-130})));

  Modelica.Blocks.Sources.Constant SteamFlowNominal(k=0.2) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,-166})));
  Modelica.Blocks.Math.Product product3
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-160})));
  Modelica.Blocks.Sources.Constant steamTemperature(k=100 + 273.15)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,-120})));

equation

  connect(HumidifierCharacteristics.y[1], product3.u2) annotation (Line(
      points={{119,-130},{110,-130},{110,-154},{102,-154}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SteamFlowNominal.y, product3.u1) annotation (Line(
      points={{119,-166},{102,-166}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product3.y, SteamSource.m_flow_in) annotation (Line(
      points={{79,-160},{70,-160},{70,-148},{60,-148}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(steamTemperature.y, SteamSource.T_in)
    annotation (Line(points={{79,-120},{70,-120},{70,-144},{62,-144}},
                                                          color={0,0,127}));
  connect(gain.y, HumidifierCharacteristics.u[1]) annotation (Line(points={{153,
          -130},{142,-130}},            color={0,0,127}));
   annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-260,
            -200},{280,240}})), Diagram(coordinateSystem(preserveAspectRatio=false,
                   extent={{-260,-200},{280,240}}), graphics={Text(
            extent={{-366,216},{-378,164}},
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
end HumidifierBaseClass;
