within ModelicaModels.Subsystems;
model GenericHeater
  extends BaseClasses.GenericModelBaseClass(vol(nPorts=2));
  parameter Real Tset = 273.15 + 36;

  Modelica.Fluid.Interfaces.FluidPort_a portSupplyAirIn(redeclare package
      Medium = MediumAir)         "Inlet port of supply air"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b portSupplyAirOut(redeclare package
      Medium = MediumAir)         "Outlet port of supply air"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}),
        iconTransformation(extent={{132,48},{110,70}})));
  AixLib.Fluid.Sensors.Temperature inflowTemp(redeclare package Medium =
        MediumAir) "Temperature entering the system"
    annotation (Placement(transformation(extent={{-98,18},{-78,38}})));
  Modelica.Blocks.Sources.RealExpression controlLaw(y=max(0, -portSupplyAirIn.m_flow
        *1000*(inflowTemp.T - Tset)))
    annotation (Placement(transformation(extent={{-80,48},{-60,68}})));
equation
  connect(portSupplyAirIn, vol.ports[2])
    annotation (Line(points={{-100,0},{0,0}}, color={0,127,255}));
  connect(supplyPressureDrop.port_b, portSupplyAirOut)
    annotation (Line(points={{44,0},{100,0}}, color={0,127,255}));
  connect(inflowTemp.port, portSupplyAirIn)
    annotation (Line(points={{-88,18},{-88,0},{-100,0}}, color={0,127,255}));
  connect(controlLaw.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-59,
          58},{-54,58},{-54,30},{-46,30}}, color={0,0,127}));
end GenericHeater;
