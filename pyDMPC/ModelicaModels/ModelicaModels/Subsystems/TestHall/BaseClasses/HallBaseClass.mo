within ModelicaModels.Subsystems.TestHall.BaseClasses;
model HallBaseClass "Simplified model of hall 1"

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)=8000*1.2/3600
  "Nominal mass flow rate"
  annotation(Dialog(group = "Nominal condition"));

  parameter AixLib.FastHVAC.Media.BaseClasses.MediumSimple medium = AixLib.FastHVAC.Media.WaterSimple();

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature outdoorAir
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature supplyWater
    "Supply water to concrete core activiation"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin waterTemperature
    annotation (Placement(transformation(extent={{-80,-76},{-68,-64}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,158},{-80,178}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor
    supplyAirTemperature
    annotation (Placement(transformation(extent={{28,60},{48,80}})));
  Modelica.Blocks.Interfaces.RealInput CCA_SEN_T__WS_SUP__AI_U_C
    annotation (Placement(transformation(extent={{-160,-90},{-120,-50}})));
  Modelica.Blocks.Interfaces.RealOutput hallTemperature
    "Absolute temperature as output signal"
    annotation (Placement(visible = true, transformation(extent={{90,60},{110,
            80}},                                                                         rotation = 0), iconTransformation(extent={{90,60},
            {110,80}},                                                                                                                                       rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput AIR_AHU_SEN_T_AIR_ODA__AI_U__C
    annotation (Placement(transformation(extent={{-160,30},{-120,70}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin
                                                 waterTemperature1
    annotation (Placement(transformation(extent={{62,64},{74,76}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin waterTemperature2
    annotation (Placement(transformation(extent={{-90,44},{-78,56}})));
  AixLib.FastHVAC.BaseClasses.WorkingFluid workingFluid(
    T0=295.15,
    m_fluid=1.2*720*8,
                 medium = medium)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  AixLib.FastHVAC.Interfaces.EnthalpyPort_a enthalpyPort_a
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}})));
  AixLib.FastHVAC.Interfaces.EnthalpyPort_b enthalpyPort_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  AixLib.ThermalZones.ReducedOrder.RC.BaseClasses.ExteriorWall extWalRC(
    n=1,
    RExt={1/4000},
    RExtRem=1/4000,
    CExt={10^7},
    T_start=295.15)
    annotation (Placement(transformation(extent={{0,40},{-20,62}})));
  AixLib.ThermalZones.ReducedOrder.RC.BaseClasses.ExteriorWall floor(
    n=1,
    RExt={1/8000},
    RExtRem=1/7000,
    CExt={10^9},
    T_start=295.15)
    annotation (Placement(transformation(extent={{-20,-80},{0,-58}})));
  AixLib.ThermalZones.ReducedOrder.RC.BaseClasses.InteriorWall intWalRC(
    n=1,
    RInt={1/1000},
    CInt={10^8},
    T_start=295.15)
    annotation (Placement(transformation(extent={{60,20},{80,42}})));
equation
  connect(waterTemperature.Kelvin,supplyWater. T) annotation (Line(points={{-67.4,
          -70},{-62,-70}},                        color={0,0,127}));
  connect(waterTemperature.Celsius, CCA_SEN_T__WS_SUP__AI_U_C)
    annotation (Line(points={{-81.2,-70},{-140,-70}}, color={0,0,127}));
  connect(supplyAirTemperature.T, waterTemperature1.Kelvin)
    annotation (Line(points={{48,70},{60.8,70}}, color={0,0,127}));
  connect(waterTemperature1.Celsius, hallTemperature)
    annotation (Line(points={{74.6,70},{100,70}},   color={0,0,127}));
  connect(outdoorAir.T, waterTemperature2.Kelvin)
    annotation (Line(points={{-62,50},{-77.4,50}}, color={0,0,127}));
  connect(waterTemperature2.Celsius, AIR_AHU_SEN_T_AIR_ODA__AI_U__C)
    annotation (Line(points={{-91.2,50},{-140,50}}, color={0,0,127}));
  connect(enthalpyPort_a, workingFluid.enthalpyPort_a) annotation (Line(points={{-140,0},
          {11,0}},                                                 color={176,0,
          0}));
  connect(workingFluid.enthalpyPort_b, enthalpyPort_b) annotation (Line(points={{29,0},{
          100,0}},                            color={176,0,0}));
  connect(supplyAirTemperature.port, workingFluid.heatPort) annotation (Line(
        points={{28,70},{20,70},{20,9.4}},                  color={191,0,0}));
  connect(extWalRC.port_b, outdoorAir.port)
    annotation (Line(points={{-20,50},{-40,50}}, color={191,0,0}));
  connect(extWalRC.port_a, workingFluid.heatPort)
    annotation (Line(points={{0,50},{20,50},{20,9.4}}, color={191,0,0}));
  connect(supplyWater.port, floor.port_a)
    annotation (Line(points={{-40,-70},{-20,-70}}, color={191,0,0}));
  connect(floor.port_b, workingFluid.heatPort) annotation (Line(points={{0,-70},
          {4,-70},{4,20},{20,20},{20,9.4}}, color={191,0,0}));
  connect(workingFluid.heatPort, intWalRC.port_a)
    annotation (Line(points={{20,9.4},{20,30},{60,30}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,100}})),
    experiment(StopTime=3841200, Interval=10),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=false,
      OutputFlatModelica=false));
end HallBaseClass;
