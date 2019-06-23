within ModelicaModels.Subsystems;
model Hall "Subsystem of the hall part of the new test hall building"

  extends ModelicaModels.Subsystems.BaseClasses.HallBaseClass(volume(nPorts=2, T_start=
          297.15),
    concreteFloor(T(fixed=true, start=308.15)),
    wallMasses(T(fixed=true, start=291.15)));

  Modelica.Blocks.Interfaces.RealInput u1
                         "Input signal connector"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumAir)
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        MediumAir)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  connect(port_a, volume.ports[2]) annotation (Line(points={{-140,0},{-60,0},{-60,
          -60},{60,-60},{60,-90},{100,-90}}, color={0,127,255}));
  connect(res.port_b, port_b) annotation (Line(points={{152,-110},{160,-110},{160,
          -56},{136,-56},{136,-20},{100,-20},{100,0}}, color={0,127,255}));
  connect(u1, waterTemperature.Celsius) annotation (Line(points={{-140,-80},{
          -86,-80},{-86,-100},{-29.2,-100}}, color={0,0,127}));
  annotation (experiment(StartTime=1000));
end Hall;
