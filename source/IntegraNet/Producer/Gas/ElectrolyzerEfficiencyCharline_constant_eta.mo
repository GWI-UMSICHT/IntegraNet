within IntegraNet.Producer.Gas;
model ElectrolyzerEfficiencyCharline_constant_eta
  "Efficiency charline constant eta"

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

// ++++++++                                                                        //
// This component is a modification of a ElectrolyzerEfficiencyCharline model from //
// TransiEnt Library, version: 1.0.0                                               //
//
// Returns constant efficiency eta of electrolyzer

  extends TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerEfficiencyCharline(
                                                                                    eta_n_cl=0.746699);

equation

  eta_cl =eta_n_cl;

  eta = eta_n;

  annotation (
  defaultConnectionStructurallyInconsistent=true,
  Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>This is a model returns a constant efficiency for an electrolyzer. </p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>The efficiency can be modified by setting the nominal efficiency eta_n. The factor eta_cl has no influence. </p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks) </p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b></p>
<p>(no remarks) </p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks) </p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(no remarks) </p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no remarks) </p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>Based on the model ElectrolyzerEfficencyCharlineSilyzer100 from TransiEnt 1.0.0</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
<p>Created during IntegraNet, 2018</p>
</html>"), Icon(graphics={Line(
          points={{-86,30},{-44,6},{-2,-8},{38,-18},{90,-22}},
          color={255,0,0},
          smooth=Smooth.Bezier)}));
end ElectrolyzerEfficiencyCharline_constant_eta;

