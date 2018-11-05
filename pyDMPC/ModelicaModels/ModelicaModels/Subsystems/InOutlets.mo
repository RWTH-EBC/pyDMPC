within ModelicaModels.Subsystems;
model InOutlets
  "Subsystem model including dampers and heat recovery system"
  extends ModelicaModels.Subsystems.BaseClasses.HRCBaseClass;

  extends ModelicaModels.Subsystems.BaseClasses.HeatExchangerPorts;
  Modelica.Fluid.Interfaces.FluidPort_a portExhaustAirIn(redeclare package
      Medium = MediumAir) "Inlet port of exhaust air" annotation (Placement(
        transformation(extent={{148,110},{168,130}}), iconTransformation(extent
          ={{180,102},{214,132}})));
  Modelica.Fluid.Interfaces.FluidPort_b portExhaustAirOut(redeclare package
      Medium = MediumAir) "Outlet port of exhaust air"
    annotation (Placement(transformation(extent={{-90,110},{-110,130}}),
        iconTransformation(extent={{-82,100},{-114,134}})));
equation
  connect(IntakeHex.port_b2, portSupplyAirOut)
    annotation (Line(points={{8,-90},{100,-90},{100,0}}, color={0,127,255}));
  connect(portSupplyAirIn, IntakeHex.port_a2) annotation (Line(points={{-100,0},
          {-26,0},{-26,-90},{-12,-90}}, color={0,127,255}));
  connect(Temperature.y, waterInflowTemperature) annotation (Line(points={{-119,
          -128},{84,-128},{84,-90},{100,-90}}, color={0,0,127}));
  connect(OutgoingAirOutletTemp.port_b, portExhaustAirOut) annotation (Line(
        points={{-44,76},{-90,76},{-90,120},{-100,120}}, color={0,127,255}));
  connect(portExhaustAirIn, hex.port_a2) annotation (Line(points={{158,120},{
          -12,120},{-12,70}}, color={0,127,255}));
  connect(OutgoingAirOutletTemp.port_a, hex.port_b2) annotation (Line(points={{
          -24,76},{20,76},{20,70},{8,70}}, color={0,127,255}));
  connect(valveOpening, convertCommand.u) annotation (Line(points={{-100,-90},{
          -62,-90},{-62,-66},{-118,-66},{-118,-50},{-103.2,-50}}, color={0,0,
          127}));
  annotation (Diagram(coordinateSystem(extent={{-140,-220},{200,120}})), Icon(
        coordinateSystem(extent={{-140,-220},{200,120}})));
end InOutlets;
