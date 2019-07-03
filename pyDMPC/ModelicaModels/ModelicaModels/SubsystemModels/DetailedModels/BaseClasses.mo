within ModelicaModels.SubsystemModels.DetailedModels;
package BaseClasses
  model HallBaseClass

    extends ModelicaModels.Subsystems.BaseClasses.HallBaseClass(volume(nPorts=2, T_start=
            295.15),
      concreteFloor(T(fixed=true, start=295.15)),
      CCAConductor(G=5000),
      SolarShare(k=50),
      outdoorAirConductor(G=400));

    Modelica.Blocks.Sources.CombiTimeTable weather(
      tableOnFile=true,
      extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
      columns={2},
      tableName="InputTable",
      fileName="weather.mat",
      smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
      "Table with weather forecast" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-90,-70})));
    AixLib.Fluid.Sensors.RelativeHumidity supplyAirHumidity(redeclare package
        Medium = MediumAir) "Relative humidity of supply air"
      annotation (Placement(transformation(extent={{56,38},{76,58}})));
    AixLib.Fluid.Sensors.Temperature supplyAirTemperature(redeclare package
        Medium = MediumAir) "Temperature of supply air"
      annotation (Placement(transformation(extent={{94,38},{114,58}})));
    Modelica.Thermal.HeatTransfer.Celsius.FromKelvin fromKelvin annotation (
        Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=180,
          origin={186,48})));
    Modelica.Fluid.Sources.MassFlowSource_T IntakeAirSource(
      nPorts=1,
      m_flow=0.5,
      redeclare package Medium = MediumAir,
      X={0.03,0.97},
      T=30 + 273.15,
      use_T_in=true,
      use_m_flow_in=true,
      use_X_in=false)
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    Modelica.Fluid.Sources.Boundary_pT IntakeAirSink(
      nPorts=1,
      redeclare package Medium = MediumAir,
      use_T_in=false,
      use_X_in=false,
      use_p_in=false,
      p(displayUnit="Pa") = 101300)
      annotation (Placement(transformation(extent={{190,2},{170,22}})));
    Modelica.Blocks.Sources.CombiTimeTable decisionVariables(
      tableOnFile=true,
      extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
      tableName="tab1",
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      columns={2},
      fileName="decisionVariables.mat")
      "Table with decision variables"              annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-128,-110})));
    Modelica.Blocks.Sources.Constant AirVolumeFlow(k=8000)
      "Air volume flow rate, could be an initial value"
      annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
    Modelica.Blocks.Math.Gain V2m(k=1.2/3600) "Volume to mass flow"
      annotation (Placement(transformation(extent={{-126,34},{-114,46}})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor wallMasses(C=100000000, T(start=
            295.15))
      annotation (Placement(transformation(extent={{164,-18},{184,2}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor wallConductor(G=8000)
      "Conducts heat from/to walls"
      annotation (Placement(transformation(extent={{132,-40},{152,-20}})));
  equation
    connect(IntakeAirSource.ports[1], volume.ports[2]) annotation (Line(points={{-80,20},
            {-60,20},{-60,-170},{54,-170},{54,-90},{100,-90}},          color={0,
            127,255}));
    connect(res.port_b, IntakeAirSink.ports[1]) annotation (Line(points={{152,
            -110},{168,-110},{168,12},{170,12}}, color={0,127,255}));
    connect(res.port_b, supplyAirHumidity.port) annotation (Line(points={{152,
            -110},{168,-110},{168,0},{66,0},{66,38}}, color={0,127,255}));
    connect(res.port_b, supplyAirTemperature.port) annotation (Line(points={{152,
            -110},{168,-110},{168,0},{104,0},{104,38}}, color={0,127,255}));
    connect(supplyAirTemperature.T,fromKelvin. Kelvin)
      annotation (Line(points={{111,48},{174,48},{174,48}}, color={0,0,127}));
    connect(AirVolumeFlow.y, V2m.u) annotation (Line(points={{-139,50},{-132,50},
            {-132,40},{-127.2,40}}, color={0,0,127}));
    connect(V2m.y, IntakeAirSource.m_flow_in) annotation (Line(points={{-113.4,
            40},{-108,40},{-108,28},{-100,28}}, color={0,0,127}));
    connect(weather.y[1], outdoorAir.T) annotation (Line(points={{-79,-70},{-40,
            -70},{-40,-80},{-2,-80}}, color={0,0,127}));
    connect(wallConductor.port_b,wallMasses. port)
      annotation (Line(points={{152,-30},{174,-30},{174,-18}},
                                                         color={191,0,0}));
    connect(volume.heatPort, wallConductor.port_a) annotation (Line(points={{90,
            -80},{84,-80},{80,-80},{80,-30},{132,-30}}, color={191,0,0}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      experiment(StopTime=86400, Interval=10));
  end HallBaseClass;

  model Selector "Select from various signal sources"
    Modelica.Blocks.Routing.Extractor extractor(nin=2)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Sources.Step step
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
    Modelica.Blocks.Sources.Step step1
      annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
    Modelica.Blocks.Interfaces.RealOutput y1
                 "Connector of Real output signal"
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    Modelica.Blocks.Interfaces.RealInput u
      annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
    Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(u) +
          1)
      annotation (Placement(transformation(extent={{-48,-44},{-28,-24}})));
  equation
    connect(step.y, extractor.u[1]) annotation (Line(points={{-39,70},{-20,70},
            {-20,-1},{-12,-1}}, color={0,0,127}));
    connect(step1.y, extractor.u[2]) annotation (Line(points={{-39,30},{-30,30},
            {-30,1},{-12,1}}, color={0,0,127}));
    connect(extractor.y, y1)
      annotation (Line(points={{11,0},{100,0}}, color={0,0,127}));
    connect(integerExpression.y, extractor.index)
      annotation (Line(points={{-27,-34},{0,-34},{0,-12}}, color={255,127,0}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Selector;
end BaseClasses;
