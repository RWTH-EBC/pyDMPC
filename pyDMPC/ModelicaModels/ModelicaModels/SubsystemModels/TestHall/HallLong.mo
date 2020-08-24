within ModelicaModels.SubsystemModels.TestHall;
model HallLong
  "Version of the hall model for long prediction horizons"

  extends ModelicaModels.Subsystems.TestHall.BaseClasses.HallConnected;

  Modelica.Blocks.Sources.CombiTimeTable weather(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    columns={2},
    tableName="InputTable",
    fileName="../weather.mat",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "Table with weather forecast" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,50})));
  Modelica.Blocks.Sources.CombiTimeTable decisionVariables(
    tableOnFile=false,
    table=[0.0,0.0],
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    columns={2})
    "Table with decision variables"              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,50})));
  Modelica.Blocks.Sources.Constant AirVolumeFlow(k=8000)
    "Air volume flow rate, could be an initial value"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Math.Gain V2m(k=1.2/3600) "Volume to mass flow"
    annotation (Placement(transformation(extent={{-62,84},{-50,96}})));
  Modelica.Blocks.Sources.Constant Tnormal(k=273 + 25)
    "Average Temperature of supply air or forecast"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=25 -
        decisionVariables.y[1])
    annotation (Placement(transformation(extent={{-66,-44},{-10,-26}})));
  Modelica.Blocks.Interfaces.RealOutput hallTemperature
    "Absolute temperature as output signal"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin fromKelvin annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={8,30})));
  Modelica.Blocks.Sources.CombiTimeTable variation(
    tableOnFile=false,
    table=[0.0,0.0],
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    columns={2})                    "Table with control input"
                                                            annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,90})));
equation
  connect(AirVolumeFlow.y,V2m. u) annotation (Line(points={{-79,90},{-63.2,90}},
                                  color={0,0,127}));
  connect(realExpression.y, hallBaseClass.CCA_SEN_T__WS_SUP__AI_U_C)
    annotation (Line(points={{-7.2,-35},{0,-35},{0,-14},{20,-14}}, color={0,0,
          127}));
  connect(V2m.y, fluidSource.dotm) annotation (Line(points={{-49.4,90},{-40,90},
          {-40,3.34},{-18.2,3.34}}, color={0,0,127}));
  connect(Tnormal.y, fluidSource.T_fluid) annotation (Line(points={{-79,50},{
          -60,50},{-60,-2.78},{-18.2,-2.78}}, color={0,0,127}));
  connect(hallBaseClass.hallTemperature, hallTemperature) annotation (Line(
        points={{60,14},{80,14},{80,60},{100,60}}, color={0,0,127}));
  connect(weather.y[1], fromKelvin.Kelvin)
    annotation (Line(points={{1,50},{8,50},{8,37.2}}, color={0,0,127}));
  connect(fromKelvin.Celsius, hallBaseClass.AIR_AHU_SEN_T_AIR_ODA__AI_U__C)
    annotation (Line(points={{8,23.4},{8,10},{20,10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HallLong;
