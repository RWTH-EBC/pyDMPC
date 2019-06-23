within ModelicaModels.Subsystems.BaseClasses;
model GenericModelBaseClass
  AixLib.Fluid.FixedResistances.PressureDrop supplyPressureDrop(
    m_flow_nominal=0.3,
    dp_nominal=350,
    redeclare package Medium = MediumAir) "Pressure drop in supply duct"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={34,0})));
  AixLib.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumAir,
    nPorts=1,
    m_flow_nominal=0.5,
    V=0.1) annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-46,20},{-26,40}})));
  replaceable package MediumAir = AixLib.Media.Air;
  AixLib.Fluid.Sensors.Temperature supplyTempMeas(redeclare package Medium =
        MediumAir) "Temperature after HRC"
    annotation (Placement(transformation(extent={{40,14},{60,34}})));
  Modelica.Blocks.Interfaces.RealOutput supplyTemp "Temperature in port medium"
    annotation (Placement(transformation(extent={{100,14},{120,34}})));
equation
  connect(vol.ports[1],supplyPressureDrop. port_a)
    annotation (Line(points={{0,0},{24,0}},    color={0,127,255}));
  connect(vol.heatPort, prescribedHeatFlow.port) annotation (Line(points={{-10,
          10},{-16,10},{-16,30},{-26,30}}, color={191,0,0}));
  connect(supplyPressureDrop.port_b, supplyTempMeas.port)
    annotation (Line(points={{44,0},{50,0},{50,14}}, color={0,127,255}));
  connect(supplyTempMeas.T, supplyTemp)
    annotation (Line(points={{57,24},{110,24}}, color={0,0,127}));
end GenericModelBaseClass;
