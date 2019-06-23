within ModelicaModels;
package DataBase "Contians records for the various case studies"
  package Geo

    record GeoRecord

      parameter Modelica.SIunits.MassFlowRate m_flow_tot = 16.0
       "The total mass flow rate circulating through field and
   building";

      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end GeoRecord;
  end Geo;
end DataBase;
