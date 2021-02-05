within IntegraNet.Components.Boundaries.Ambient;
model AmbientConditions_Koeln_TRY
//_________________________________________________________________________________//
// Component of the IntegraNet Library, version: 1.0.0                             //
//                                                                                 //
// Licensed by Fraunhofer UMSICHT and GWI Essen e.V. under Modelica License 2.     //
// Copyright 2021, Fraunhofer UMSICHT and GWI Essen e.V.                           //
//_________________________________________________________________________________//
//                                                                                 //
// IntegraNet is a research project supported by the German                        //
// Federal Ministry of Economics and Energy (FKZ 0324027).                         //
// The IntegraNet Library research team consists of the following project partners://
// Fraunhofer Institute for Environmental, Safety and Energy Technology UMSICHT,   //
// Gas- und Wärme-Institut Essen e.V.                                              //
// and is supported by                                                             //
// XRG Simulation GmbH (Hamburg, Germany)                                          //
//_________________________________________________________________________________//

  extends TransiEnt.Components.Boundaries.Ambient.AmbientConditions(
      redeclare IntegraNet.Basics.Tables.Ambient.GHI_Koeln_3600s_TRY globalSolarRadiation,
      redeclare IntegraNet.Basics.Tables.Ambient.DNI_Koeln_3600s_TRY directSolarRadiation,
      redeclare IntegraNet.Basics.Tables.Ambient.DHI_Koeln_3600s_TRY diffuseSolarRadiation,
      redeclare IntegraNet.Basics.Tables.Ambient.Temperature_Koeln_3600s_TRY temperature,
      redeclare IntegraNet.Basics.Tables.Ambient.Wind_Koeln_3600s_TRY wind);
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Ambient conditions (GHI, DNI, DHI, temperature and wind speed) for Koeln (test reference year TRY) </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Source: BBR, DWD 2017: <i>Ortsgenaue Testreferenzjahre f&uuml;r Deutschland f&uuml;r mittlere, extreme und zuk&uuml;nftige Witterungsverh&auml;ltnisse</i></p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), Nov 2019</p>
</html>"));
end AmbientConditions_Koeln_TRY;

