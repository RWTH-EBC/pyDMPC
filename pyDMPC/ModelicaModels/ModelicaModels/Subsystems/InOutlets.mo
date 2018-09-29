within ModelicaModels.Subsystems;
model InOutlets
  "Subsystem model including dampers and heat recovery system"
  extends ModelicaModels.Subsystems.BaseClasses.HRCBaseClass;
  Modelica.Fluid.Interfaces.FluidPort_a portSupplyAirIn(
    redeclare final package Medium = MediumAir) "Inlet port of supply air"
    annotation (Placement(transformation(extent={{-650,-168},{-630,-148}}),
        iconTransformation(extent={{-682,-200},{-630,-148}})));
  Modelica.Fluid.Interfaces.FluidPort_a portExtractAirIn(
    redeclare final package Medium = MediumAir) "Inlet port of extract air"
    annotation (Placement(transformation(extent={{670,50},{690,70}}),
        iconTransformation(extent={{650,108},{708,166}})));
  Modelica.Fluid.Interfaces.FluidPort_b portSupplyAirOut(
    redeclare final package Medium = MediumAir) "Outlet port of supply air"
    annotation (Placement(transformation(extent={{662,-164},{642,-144}}),
        iconTransformation(extent={{706,-208},{642,-144}})));
  Modelica.Fluid.Interfaces.FluidPort_b portExhaustAirOut(
    redeclare final package Medium = MediumAir) "Outlet port of exhaust air"
    annotation (Placement(transformation(extent={{-662,156},{-682,176}}),
        iconTransformation(extent={{-628,122},{-682,176}})));
  Modelica.Blocks.Interfaces.RealInput valveOpening
    "Opening of the HRC valve (0..100 %)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-140,300}), iconTransformation(
        extent={{-59,-62},{59,62}},
        rotation=270,
        origin={-2,241})));
equation
  connect(gain2.u, valveOpening) annotation (Line(points={{-102,0},{-118,0},{
          -140,0},{-140,300}}, color={0,0,127}));
  connect(portSupplyAirIn, outsideAirInletValve.port_a) annotation (Line(points=
         {{-640,-158},{-320,-158},{-320,-60}}, color={0,127,255}));
  connect(outletValve.port_b, portExhaustAirOut) annotation (Line(points={{-320,
          60},{-672,60},{-672,166}}, color={0,127,255}));
  connect(OutgoingHex.port_a2, portExtractAirIn)
    annotation (Line(points={{20,60},{350,60},{680,60}}, color={0,127,255}));
  connect(IntakeHex.port_b2, portSupplyAirOut) annotation (Line(points={{20,-60},
          {338,-60},{338,-154},{652,-154}}, color={0,127,255}));
end InOutlets;
