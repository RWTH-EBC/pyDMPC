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
    annotation (Placement(transformation(extent={{-60,22},{-40,42}})));
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
        origin={2,-34})));
  Modelica.Blocks.Tables.CombiTable1D HumidifierCharacteristics(
    tableOnFile=false, table=[0,0; 1,0.012])            annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={82,-24})));

  Modelica.Blocks.Sources.Constant SteamFlowNominal(k=0.2) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={82,-60})));
  Modelica.Blocks.Math.Product product3
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,-54})));
  Modelica.Blocks.Sources.Constant steamTemperature(k=100 + 273.15)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={42,-14})));

  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
equation

  connect(HumidifierCharacteristics.y[1], product3.u2) annotation (Line(
      points={{71,-24},{62,-24},{62,-48},{54,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SteamFlowNominal.y, product3.u1) annotation (Line(
      points={{71,-60},{54,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product3.y, SteamSource.m_flow_in) annotation (Line(
      points={{31,-54},{22,-54},{22,-42},{12,-42}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(steamTemperature.y, SteamSource.T_in)
    annotation (Line(points={{31,-14},{22,-14},{22,-38},{14,-38}},
                                                          color={0,0,127}));
   annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{120,100}})), Diagram(coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}})),
    experiment(StopTime=3600, Interval=60),
    __Dymola_experimentSetupOutput);
end HumidifierBaseClass;
