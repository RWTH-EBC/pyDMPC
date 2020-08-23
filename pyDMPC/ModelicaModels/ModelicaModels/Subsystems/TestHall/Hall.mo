within ModelicaModels.Subsystems.TestHall;
model Hall
  "Hall model that can be integrated into the controlled system model"

  extends ModelicaModels.Subsystems.TestHall.BaseClasses.HallConnected;

  Modelica.Blocks.Sources.Constant AirVolumeFlow(k=8000)
    "Air volume flow rate, could be an initial value"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Math.Gain V2m(k=1.2/3600) "Volume to mass flow"
    annotation (Placement(transformation(extent={{-62,84},{-50,96}})));
  Modelica.Blocks.Interfaces.RealInput CCA_SEN_T__WS_SUP__AI_U_C
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));
  Modelica.Blocks.Interfaces.RealInput AIR_AHU_SEN_T_AIR_ODA__AI_U__C
    annotation (Placement(transformation(extent={{-120,20},{-80,60}})));
  Modelica.Blocks.Interfaces.RealOutput hallTemperature
    "Absolute temperature as output signal"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat transfer into the working fluid"
    annotation (Placement(transformation(extent={{30,86},{50,106}})));
  Modelica.Blocks.Interfaces.RealInput T_fluid
    "External real input to set the temperature of the fluid"
    annotation (Placement(transformation(extent={{-120,-30},{-80,10}})));
  Modelica.Blocks.Interfaces.RealOutput hallPower "The heat flux of the CCA"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Interfaces.RealOutput hallEnergy "The total heat of the CCA"
    annotation (Placement(transformation(extent={{90,-100},{110,-80}})));
  Modelica.Blocks.Sources.RealExpression heatFlux(y=hallBaseClass.floor.port_b.Q_flow)
    "Measures the CCA heat flux"
    annotation (Placement(transformation(extent={{0,-70},{22,-52}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=1/3600000)
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
equation
  connect(AirVolumeFlow.y,V2m. u) annotation (Line(points={{-79,90},{-63.2,90}},
                                  color={0,0,127}));
  connect(V2m.y, fluidSource.dotm) annotation (Line(points={{-49.4,90},{-40,90},
          {-40,3.34},{-18.2,3.34}}, color={0,0,127}));
  connect(hallBaseClass.CCA_SEN_T__WS_SUP__AI_U_C, CCA_SEN_T__WS_SUP__AI_U_C)
    annotation (Line(points={{20,-14},{-20,-14},{-20,-60},{-100,-60}}, color={0,
          0,127}));
  connect(hallBaseClass.AIR_AHU_SEN_T_AIR_ODA__AI_U__C,
    AIR_AHU_SEN_T_AIR_ODA__AI_U__C) annotation (Line(points={{20,10},{0,10},{0,
          40},{-100,40}}, color={0,0,127}));
  connect(hallBaseClass.hallTemperature, hallTemperature) annotation (Line(
        points={{60,14},{80,14},{80,60},{100,60}}, color={0,0,127}));
  connect(hallBaseClass.heatPort, heatPort) annotation (Line(points={{43.3333,
          19.6},{43.3333,40},{40,40},{40,96}}, color={191,0,0}));
  connect(fluidSource.T_fluid, T_fluid) annotation (Line(points={{-18.2,-2.78},
          {-76,-2.78},{-76,-10},{-100,-10}}, color={0,0,127}));
  connect(heatFlux.y, hallPower) annotation (Line(points={{23.1,-61},{67.55,-61},
          {67.55,-60},{100,-60}}, color={0,0,127}));
  connect(integrator.y, hallEnergy)
    annotation (Line(points={{61,-90},{100,-90}}, color={0,0,127}));
  connect(heatFlux.y, integrator.u) annotation (Line(points={{23.1,-61},{28,-61},
          {28,-90},{38,-90}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Hall;
