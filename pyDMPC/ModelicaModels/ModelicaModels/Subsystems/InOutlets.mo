within ModelicaModels.Subsystems;
model InOutlets
  "Subsystem model including dampers and heat recovery system"
  extends ModelicaModels.Subsystems.BaseClasses.HRCBaseClass(
      ValveCharacteristicCurve(table=[0.0,0.0; 1.0,1.0]));

  extends ModelicaModels.Subsystems.BaseClasses.HeatExchangerPorts;
  Modelica.Fluid.Interfaces.FluidPort_a portExhaustAirIn(redeclare package
      Medium = MediumAir) "Inlet port of exhaust air" annotation (Placement(
        transformation(extent={{148,110},{168,130}}), iconTransformation(extent=
           {{180,102},{214,132}})));
  Modelica.Fluid.Interfaces.FluidPort_b portExhaustAirOut(redeclare package
      Medium = MediumAir) "Outlet port of exhaust air"
    annotation (Placement(transformation(extent={{-90,110},{-110,130}}),
        iconTransformation(extent={{-82,100},{-114,134}})));
equation
  connect(OutgoingAirOutletTemp.port_b, portExhaustAirOut) annotation (Line(
        points={{-44,76},{-90,76},{-90,120},{-100,120}}, color={0,127,255}));
  connect(portExhaustAirIn, hex.port_a2) annotation (Line(points={{158,120},{46,
          120},{46,64}},      color={0,127,255}));
  connect(OutgoingAirOutletTemp.port_a, hex.port_b2) annotation (Line(points={{-24,76},
          {24,76},{24,64},{26,64}},        color={0,127,255}));
  connect(dam1.port_b, portSupplyAirOut) annotation (Line(points={{54,-10},{78,
          -10},{78,0},{100,0}}, color={0,127,255}));
  connect(hex.port_b1, portSupplyAirOut) annotation (Line(points={{46,52},{78,
          52},{78,0},{100,0}}, color={0,127,255}));
  connect(valveOpening, convertCommand.u) annotation (Line(points={{-100,-90},{
          -70,-90},{-70,-56},{-65.2,-56}}, color={0,0,127}));
  connect(OutgoingAirOutletTemp.T, waterInflowTemperature) annotation (Line(
        points={{-34,65},{-34,32},{-48,32},{-48,-90},{100,-90}}, color={0,0,127}));
  connect(portSupplyAirIn, exhaustPressureDrop.port_a) annotation (Line(points=
          {{-100,0},{-86,0},{-86,4},{-70,4}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-140,-220},{200,120}})), Icon(
        coordinateSystem(extent={{-140,-220},{200,120}})));
end InOutlets;
