within ModelicaModels.Export.TestHall;
model HallExport "Model for exprting the hall model to statespace"
  TestHallRC.BaseClasses.HallBaseClass hallBaseClass
    annotation (Placement(transformation(extent={{-12,-10},{12,10}})));
  AixLib.FastHVAC.Components.Pumps.FluidSource
                                        fluidSource
    annotation (Placement(transformation(extent={{-58,10},{-40,-8}})));
  AixLib.FastHVAC.Components.Sinks.Vessel vessel
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Interfaces.RealInput AIR_AHU_SEN_T_AIR_ODA__AI_U__C
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput CCA_SEN_T__WS_SUP__AI_U_C
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));
  Modelica.Blocks.Interfaces.RealInput dotm
    "External real input to set the mass flow rate"
    annotation (Placement(transformation(extent={{-120,0},{-80,40}})));
  Modelica.Blocks.Interfaces.RealInput T_fluid
    "External real input to set the temperature of the fluid"
    annotation (Placement(transformation(extent={{-120,-40},{-80,0}})));
  Modelica.Blocks.Interfaces.RealOutput hallTemperature
    "Absolute temperature as output signal"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
equation
  connect(hallBaseClass.enthalpyPort_b, vessel.enthalpyPort_a)
    annotation (Line(points={{12,0},{43,0}}, color={176,0,0}));
  connect(fluidSource.enthalpyPort_b, hallBaseClass.enthalpyPort_a) annotation (
     Line(points={{-40,0.1},{-25,0.1},{-25,0},{-12,0}}, color={176,0,0}));
  connect(hallBaseClass.AIR_AHU_SEN_T_AIR_ODA__AI_U__C,
    AIR_AHU_SEN_T_AIR_ODA__AI_U__C) annotation (Line(points={{-12,5},{-20,5},{
          -20,60},{-100,60}}, color={0,0,127}));
  connect(hallBaseClass.CCA_SEN_T__WS_SUP__AI_U_C, CCA_SEN_T__WS_SUP__AI_U_C)
    annotation (Line(points={{-12,-7},{-20,-7},{-20,-60},{-100,-60}}, color={0,
          0,127}));
  connect(fluidSource.dotm, dotm) annotation (Line(points={{-56.2,3.34},{-58,
          3.34},{-58,4},{-60,4},{-60,20},{-100,20}}, color={0,0,127}));
  connect(fluidSource.T_fluid, T_fluid) annotation (Line(points={{-56.2,-2.78},
          {-60,-2.78},{-60,-20},{-100,-20}}, color={0,0,127}));
  connect(hallBaseClass.hallTemperature, hallTemperature) annotation (Line(
        points={{12,7},{20,7},{20,40},{100,40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HallExport;
