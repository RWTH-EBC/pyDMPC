within ModelicaModels.ControlledSystems;
model SimpleModelGeo "extends Modelica.Icons.Example;extends ModelicaModels.BaseClasses.Geo.ControlledSystemBaseClass(
                                                               volumeFlow(
        tableOnFile=false, table=[0,0.31,0.29]));"
  replaceable package Water = AixLib.Media.Water;
  AixLib.Fluid.Sources.FixedBoundary bou(          redeclare package Medium =
        Water,
    p=100000,
    T=285.15,
    nPorts=1)                                      annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={64,-50})));
  AixLib.Fluid.MixingVolumes.MixingVolume vol1(redeclare package Medium =
        Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    m_flow_small=50,
    nPorts=3,
    p_start=100000,
    m_flow_nominal=16,
    V=2)                         annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={54,-6})));
  AixLib.Fluid.FixedResistances.HydraulicResistance hydraulicResistance(
    redeclare package Medium = Water,
    m_flow_nominal=100,
    diameter=0.5,
    m_flow_start=0,
    zeta=0.3)
    annotation (Placement(transformation(extent={{-22,-8},{-2,12}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={54,20})));
  AixLib.Fluid.Movers.FlowControlled_m_flow fan(redeclare package Medium =
        Water,
    m_flow_small=1,
    m_flow_start=50,
    m_flow_nominal=16,
    addPowerToMedium=false)
    annotation (Placement(transformation(extent={{8,-44},{-12,-24}})));
  Modelica.Blocks.Sources.Pulse Q_flow_need_heat(
    width=50,
    period=86400,
    amplitude=2200)
    annotation (Placement(transformation(extent={{-96,88},{-88,96}})));
  Modelica.Blocks.Sources.Pulse pulse1(
    width=50,
    period=86400,
    startTime=43200,
    amplitude=2200)
    annotation (Placement(transformation(extent={{-96,72},{-88,80}})));
  Modelica.Blocks.Math.Product Q_flow_need_cold
    annotation (Placement(transformation(extent={{-62,66},{-54,74}})));
  Modelica.Blocks.Sources.Constant const(k=-1)
    annotation (Placement(transformation(extent={{-96,56},{-88,64}})));
  Modelica.Blocks.Math.Sum Q_flow_need(nin=2)
    annotation (Placement(transformation(extent={{-36,60},{-28,68}})));
  Modelica.Blocks.Interfaces.RealOutput buildingNeed annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={-24,100})));
  Modelica.Blocks.Interfaces.RealOutput fieldTemperature annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={-58,-100})));
  Modelica.Blocks.Interfaces.RealOutput buildingTemperature annotation (
      Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={84,-100})));
  AixLib.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        Water)
    annotation (Placement(transformation(extent={{-50,8},{-38,-4}})));
  Modelica.Blocks.Interfaces.RealOutput fieldMassflow_out annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={-44,-100})));
  AixLib.Fluid.Sensors.MassFlowRate senMasFlo1(redeclare package Medium =
        Water)
    annotation (Placement(transformation(extent={{36,-28},{24,-40}})));
  Modelica.Blocks.Interfaces.RealOutput buildingMassflow_out annotation (
      Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={30,-100})));
  AixLib.Fluid.Sensors.Temperature senTem(redeclare package Medium =
        Water)
    annotation (Placement(transformation(extent={{-68,-72},{-58,-64}})));
  AixLib.Fluid.Sensors.Temperature senTem1(redeclare package Medium =
        Water)
    annotation (Placement(transformation(extent={{70,-26},{80,-16}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-12,62},{-2,72}})));
  Modelica.Blocks.Interfaces.RealInput valveQflow "scaling the buildings need"
    annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={-14,100})));
  AixLib.Fluid.Sensors.Temperature senTem2(redeclare package Medium =
        Water)
    annotation (Placement(transformation(extent={{-20,-70},{-10,-62}})));
  AixLib.Fluid.Sensors.Temperature senTem3(redeclare package Medium =
        Water)
    annotation (Placement(transformation(extent={{2,24},{12,34}})));
  AixLib.Fluid.Sensors.MassFlowRate senMasFlo2(redeclare package Medium =
        Water)
    annotation (Placement(transformation(extent={{22,-4},{34,8}})));
  AixLib.Fluid.Sensors.MassFlowRate senMasFlo3(redeclare package Medium =
        Water)
    annotation (Placement(transformation(extent={{-26,-28},{-38,-40}})));
  Modelica.Blocks.Interfaces.RealOutput fieldTemperature_in annotation (
      Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={-10,-100})));
  Modelica.Blocks.Interfaces.RealOutput buildingTemperature_in annotation (
      Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={12,100}), iconTransformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={0,16})));
  Modelica.Blocks.Interfaces.RealOutput fieldMassflow_in annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={-32,-100})));
  Modelica.Blocks.Interfaces.RealOutput buildingMassflow_in annotation (
      Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={28,100})));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual annotation (Placement(
        transformation(
        extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={-23,43})));
  Modelica.Blocks.Sources.Constant const1(k=0)
    annotation (Placement(transformation(extent={{-68,42},{-58,52}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin hRCTemperatureC
    annotation (Placement(transformation(extent={{-4,-4},{4,4}},
        rotation=90,
        origin={12,82})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin hRCTemperatureC1
    annotation (Placement(transformation(extent={{-4,-4},{4,4}},
        rotation=270,
        origin={84,-62})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin hRCTemperatureC2
    annotation (Placement(transformation(extent={{-4,-4},{4,4}},
        rotation=270,
        origin={-10,-80})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin hRCTemperatureC3
    annotation (Placement(transformation(extent={{-4,-4},{4,4}},
        rotation=270,
        origin={-58,-82})));
  Modelica.Blocks.Sources.Constant m_flow(k=16)
    annotation (Placement(transformation(extent={{-68,20},{-58,30}})));
  AixLib.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Water,
    m_flow_small=50,
    V=9000,
    p_start=150000,
    T_start=285.15,
    m_flow_nominal=16,
    nPorts=3)                       annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-88,-14})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=285.15)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-88,-76})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=50)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-88,-48})));
  Modelica.Blocks.Math.Gain maxHeatFlowRate(k=0.02) "Convert from percent"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={-14,84})));
  Modelica.Blocks.Sources.Constant const2(k=-10000)
    annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=180,
        origin={1,49})));
equation
  connect(pulse1.y, Q_flow_need_cold.u1) annotation (Line(points={{-87.6,76},{
          -66,76},{-66,72.4},{-62.8,72.4}}, color={0,0,127}));
  connect(const.y, Q_flow_need_cold.u2) annotation (Line(points={{-87.6,60},{
          -76,60},{-76,66},{-62.8,66},{-62.8,67.6}}, color={0,0,127}));
  connect(Q_flow_need_heat.y, Q_flow_need.u[1]) annotation (Line(points={{-87.6,
          92},{-46,92},{-46,63.6},{-36.8,63.6}},
                                           color={0,0,127}));
  connect(prescribedHeatFlow.port, vol1.heatPort)
    annotation (Line(points={{54,14},{54,4}},  color={191,0,0}));
  connect(senMasFlo.m_flow, fieldMassflow_out) annotation (Line(points={{-44,
          -4.6},{-44,-100}},               color={0,0,127}));
  connect(senMasFlo1.m_flow, buildingMassflow_out) annotation (Line(points={{30,
          -40.6},{30,-100}},                 color={0,0,127}));
  connect(senMasFlo.port_b, hydraulicResistance.port_a) annotation (Line(points={{-38,2},
          {-22,2}},                             color={0,127,255}));
  connect(fan.port_a, senMasFlo1.port_b)
    annotation (Line(points={{8,-34},{24,-34}}, color={0,127,255}));
  connect(product.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-1.5,67},
          {16,67},{16,52},{54,52},{54,26}}, color={0,0,127}));
  connect(buildingNeed, Q_flow_need.y) annotation (Line(points={{-24,100},{-24,
          64},{-27.6,64}},       color={0,0,127}));
  connect(hydraulicResistance.port_b, senMasFlo2.port_a)
    annotation (Line(points={{-2,2},{22,2}},   color={0,127,255}));
  connect(senMasFlo2.port_b, vol1.ports[1])
    annotation (Line(points={{34,2},{44,2},{44,-3.33333}},
                                                       color={0,127,255}));
  connect(senMasFlo1.port_a, vol1.ports[2]) annotation (Line(points={{36,-34},{
          44,-34},{44,-6}},               color={0,127,255}));
  connect(bou.ports[1], vol1.ports[2]) annotation (Line(points={{64,-40},{64,
          -34},{44,-34},{44,-6}},                          color={0,127,255}));
  connect(senTem1.port, vol1.ports[3]) annotation (Line(points={{75,-26},{66,
          -26},{66,-18},{44,-18},{44,-8.66667}},
                                  color={0,127,255}));
  connect(senMasFlo3.port_a, fan.port_b)
    annotation (Line(points={{-26,-34},{-12,-34}}, color={0,127,255}));
  connect(senTem2.port, fan.port_b) annotation (Line(points={{-15,-70},{-20,-70},
          {-20,-34},{-12,-34}}, color={0,127,255}));
  connect(senMasFlo3.m_flow, fieldMassflow_in)
    annotation (Line(points={{-32,-40.6},{-32,-100}}, color={0,0,127}));
  connect(senMasFlo2.m_flow, buildingMassflow_in)
    annotation (Line(points={{28,8.6},{28,100}},  color={0,0,127}));
  connect(senTem3.port, senMasFlo2.port_a)
    annotation (Line(points={{7,24},{7,2},{22,2}},   color={0,127,255}));
  connect(Q_flow_need_cold.y, Q_flow_need.u[2]) annotation (Line(points={{-53.6,
          70},{-48,70},{-48,56},{-36.8,56},{-36.8,64.4}}, color={0,0,127}));
  connect(const1.y, greaterEqual.u2) annotation (Line(points={{-57.5,47},{
          -42.75,47},{-42.75,49},{-27,49}}, color={0,0,127}));
  connect(senTem3.T, hRCTemperatureC.Kelvin)
    annotation (Line(points={{10.5,29},{12,29},{12,77.2}}, color={0,0,127}));
  connect(hRCTemperatureC.Celsius, buildingTemperature_in)
    annotation (Line(points={{12,86.4},{12,100}}, color={0,0,127}));
  connect(senTem1.T, hRCTemperatureC1.Kelvin) annotation (Line(points={{78.5,
          -21},{84,-21},{84,-57.2}}, color={0,0,127}));
  connect(hRCTemperatureC1.Celsius, buildingTemperature)
    annotation (Line(points={{84,-66.4},{84,-100}}, color={0,0,127}));
  connect(senTem2.T, hRCTemperatureC2.Kelvin) annotation (Line(points={{-11.5,
          -66},{-10,-66},{-10,-75.2}}, color={0,0,127}));
  connect(hRCTemperatureC2.Celsius, fieldTemperature_in)
    annotation (Line(points={{-10,-84.4},{-10,-100}}, color={0,0,127}));
  connect(senTem.T, hRCTemperatureC3.Kelvin) annotation (Line(points={{-59.5,
          -68},{-58,-68},{-58,-77.2}}, color={0,0,127}));
  connect(hRCTemperatureC3.Celsius, fieldTemperature)
    annotation (Line(points={{-58,-86.4},{-58,-100}}, color={0,0,127}));
  connect(m_flow.y, fan.m_flow_in) annotation (Line(points={{-57.5,25},{-30,25},
          {-30,-14},{-2,-14},{-2,-22}}, color={0,0,127}));
  connect(thermalConductor.port_b, vol.heatPort)
    annotation (Line(points={{-88,-42},{-88,-24}}, color={191,0,0}));
  connect(senMasFlo3.port_b, vol.ports[1]) annotation (Line(points={{-38,-34},{
          -78,-34},{-78,-16.6667}}, color={0,127,255}));
  connect(vol.ports[2], senMasFlo.port_a)
    annotation (Line(points={{-78,-14},{-78,2},{-50,2}}, color={0,127,255}));
  connect(fixedTemperature.port, thermalConductor.port_a)
    annotation (Line(points={{-88,-70},{-88,-54}}, color={191,0,0}));
  connect(vol.ports[3], senTem.port) annotation (Line(points={{-78,-11.3333},{
          -70,-11.3333},{-70,-76},{-63,-76},{-63,-72}}, color={0,127,255}));
  connect(valveQflow, maxHeatFlowRate.u)
    annotation (Line(points={{-14,100},{-14,91.2}}, color={0,0,127}));
  connect(maxHeatFlowRate.y, product.u1) annotation (Line(points={{-14,77.4},{
          -14,74},{-14,70},{-13,70}}, color={0,0,127}));
  connect(Q_flow_need.y, greaterEqual.u1)
    annotation (Line(points={{-27.6,64},{-23,64},{-23,49}}, color={0,0,127}));
  connect(const2.y, product.u2) annotation (Line(points={{-4.5,49},{-16,49},{
          -16,64},{-13,64}}, color={0,0,127}));
 annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{120,100}})),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end SimpleModelGeo;
