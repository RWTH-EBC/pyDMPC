within ModelicaModels.SubsystemModels;
model HeatRecovery "Mockup model of the heat recovery"
  extends BaseClasses.HeatExchangerMockupCommunicationBaseClass;
  Modelica.Blocks.Sources.Constant zero(k=0)
    annotation (Placement(transformation(extent={{34,16},{54,36}})));
equation
  connect(gain.y, add.u2) annotation (Line(points={{-23,-108},{0,-108},{0,-58},
          {-100,-58},{-100,90},{-82,90}}, color={0,0,127}));
  connect(zero.y, sum.u[2]) annotation (Line(points={{55,26},{70,26},{70,-13},{
          88,-13}}, color={0,0,127}));
  annotation (Icon(graphics={Line(points={{-180,-140},{-140,-40},{-62,60},{-6,
              100},{48,120},{142,120}}, color={255,0,0})}));
end HeatRecovery;
