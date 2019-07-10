within ModelicaModels.Subsystems;
package Geo
  package BaseClasses
    model BuildingBaseClass "Simplified building model"

      replaceable package Water = AixLib.Media.Water;

      parameter ModelicaModels.DataBase.Geo.GeoRecord baseParam
      "The basic paramters";

      AixLib.Fluid.MixingVolumes.MixingVolume vol1(redeclare package Medium =
            Water,
        energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
        m_flow_small=50,
        p_start=100000,
        m_flow_nominal=16,
        V=2,
        nPorts=2)                    annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={24,42})));
      Modelica.Blocks.Math.Product product1
        annotation (Placement(transformation(extent={{-34,-66},{-14,-46}})));
      Modelica.Blocks.Sources.Constant const(k=-10000)
        annotation (Placement(transformation(extent={{-92,-90},{-72,-70}})));
      AixLib.Fluid.FixedResistances.PressureDrop res(
        m_flow_nominal=16,
        dp_nominal(displayUnit="bar") = 100000,
        redeclare package Medium = Water)
            "total resistance" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={48,32})));
      AixLib.Fluid.Sources.MassFlowSource_T boundary(
        redeclare package Medium = Water,
        use_T_in=true,
        nPorts=1,
        m_flow=baseParam.m_flow_tot)
                  annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
      AixLib.Fluid.Sources.Boundary_pT bou(
      redeclare package Medium = Water,
      nPorts=1) annotation (Placement(
            transformation(
            extent={{-10,-11},{10,11}},
            rotation=180,
            origin={90,-1})));
      AixLib.Fluid.Sensors.TemperatureTwoPort senTem(
      redeclare package Medium = Water, m_flow_nominal=16)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=270,
            origin={70,18})));
      Modelica.Blocks.Interfaces.RealOutput returnTemperature
        "Temperature of the passing fluid"
        annotation (Placement(transformation(extent={{82,50},{102,70}})));
    equation
      connect(vol1.ports[1], res.port_a)
        annotation (Line(points={{22,32},{38,32}}, color={0,127,255}));
      connect(res.port_b, senTem.port_a)
        annotation (Line(points={{58,32},{70,32},{70,28}},
                                                   color={0,127,255}));
      connect(senTem.port_b, bou.ports[1]) annotation (Line(points={{70,8},{70,-1},{
              80,-1}},          color={0,127,255}));
      connect(senTem.T, returnTemperature)
        annotation (Line(points={{81,18},{81,60},{92,60}}, color={0,0,127}));
      connect(boundary.ports[1], vol1.ports[2]) annotation (Line(points={{-60,0},{-52,
              0},{-52,32},{26,32}}, color={0,127,255}));
      connect(const.y, product1.u2) annotation (Line(points={{-71,-80},{-52,-80},{-52,
              -62},{-36,-62}}, color={0,0,127}));
    end BuildingBaseClass;

    model FieldBaseClass "Simplified model of geothermal field"

     replaceable package Water = AixLib.Media.Water;

      parameter ModelicaModels.DataBase.Geo.GeoRecord baseParam
      "The basic paramters";

      AixLib.Fluid.MixingVolumes.MixingVolume vol1(
        redeclare package Medium = Water,
        energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
        nPorts=3,
        m_flow_nominal=16,
        V=2,
        p_start=100000,
        T_start=285.15,
        m_flow_small=0.001)          annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={30,42})));
      AixLib.Fluid.Movers.FlowControlled_m_flow pump(
          nominalValuesDefineDefaultPressureCurve=true,
          redeclare package Medium = Water,
        m_flow_nominal=baseParam.m_flow_tot,
        inputType=AixLib.Fluid.Types.InputType.Constant,
        constantMassFlowRate=baseParam.m_flow_tot,
        T_start=285.15)                     "Main geothermal pump"
        annotation (Placement(transformation(extent={{46,-10},{66,10}})));
      AixLib.Fluid.FixedResistances.PressureDrop res(m_flow_nominal=16, dp_nominal(
            displayUnit="bar") = 100000, redeclare package Medium = Water)
            "total resistance" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={66,32})));
      Modelica.Fluid.Sources.Boundary_pT pressurePoint(
        redeclare package Medium = Water,
        use_T_in=false,
        use_X_in=false,
        use_p_in=false,
        p(displayUnit="Pa") = 101300,
        nPorts=1)
        annotation (Placement(transformation(extent={{10,-10},{-10,10}},
            rotation=270,
            origin={42,-34})));
      AixLib.Fluid.Sensors.Temperature supplyTemperature(T(start=285), redeclare
          package Medium = Water) "Temperature of supply water"
        annotation (Placement(transformation(extent={{82,34},{102,54}})));
      AixLib.Fluid.Sensors.MassFlowRate massFlow(redeclare package Medium =
            Water)
        annotation (Placement(transformation(extent={{6,-6},{-6,6}},
            rotation=270,
            origin={80,12})));
      AixLib.Fluid.Sensors.Temperature returnTemperature(redeclare package Medium =
            Water, T(start=285.15)) "Temperature of supply water"
        annotation (Placement(transformation(extent={{74,-78},{94,-58}})));
      AixLib.Fluid.MixingVolumes.MixingVolume vol(
        redeclare package Medium = Water,
        nPorts=2,
        V=9000,
        m_flow_nominal=16,
        p_start=150000,
        T_start=285.15,
        m_flow_small=0.001)             annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-8,-2})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=285.15)
        annotation (Placement(transformation(
            extent={{-6,-6},{6,6}},
            rotation=90,
            origin={-24,-62})));
      Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=50)
        annotation (Placement(transformation(
            extent={{-6,-6},{6,6}},
            rotation=90,
            origin={-24,-34})));
    equation
      connect(res.port_b, vol1.ports[1])
        annotation (Line(points={{56,32},{27.3333,32}},
                                                  color={0,127,255}));
      connect(pressurePoint.ports[1], pump.port_a)
        annotation (Line(points={{42,-24},{42,0},{46,0}}, color={0,127,255}));
      connect(pump.port_b, massFlow.port_a)
        annotation (Line(points={{66,0},{80,0},{80,6}}, color={0,127,255}));
      connect(massFlow.port_b, res.port_a)
        annotation (Line(points={{80,18},{80,32},{76,32}}, color={0,127,255}));
      connect(supplyTemperature.port, pump.port_b)
        annotation (Line(points={{92,34},{92,0},{66,0}}, color={0,127,255}));
      connect(thermalConductor.port_b, vol.heatPort)
        annotation (Line(points={{-24,-28},{-24,-2},{-18,-2}}, color={191,0,0}));
      connect(fixedTemperature.port, thermalConductor.port_a)
        annotation (Line(points={{-24,-56},{-24,-40}}, color={191,0,0}));
      connect(vol.ports[1], pump.port_a) annotation (Line(points={{-10,-12},{20,
              -12},{20,0},{46,0}},
                              color={0,127,255}));
      connect(vol1.ports[2], vol.ports[2]) annotation (Line(points={{30,32},{-40,32},
              {-40,-12},{-6,-12}}, color={0,127,255}));
      connect(vol1.ports[3], returnTemperature.port) annotation (Line(points={{32.6667,
              32},{-40,32},{-40,-80},{84,-80},{84,-78}},         color={0,127,255}));
      annotation (experiment(StopTime=94608000, Interval=86400),
          __Dymola_experimentSetupOutput);
    end FieldBaseClass;
  end BaseClasses;
end Geo;
