within ModelicaModels.Subsystems.TestHall.BaseClasses;
record SimpleAir "A FastHVAC medium model for air"

extends AixLib.FastHVAC.Media.BaseClasses.MediumSimple(
    rho=1.2,
    c=1000,
    lambda=0.579,
    eta=0.0013059 "all Data from VDI-Waermeatlas 1bar, 10 °C");
  annotation (Documentation(info="<html><p>
  This record declares parameters that are used by models within the
  FastHVAC Package.
</p>
</html>", revisions="<html>
<ul>
  <li>
    <i>April 25, 2017</i>, by Michael Mans:<br/>
    Moved to AixLib.
  </li>
  <li>
    <i>August 11, 2017</i>, by David Jansen:<br/>
    corrected data and inserted dynamic viscosity.
  </li>
</ul>
</html>"));
end SimpleAir;
