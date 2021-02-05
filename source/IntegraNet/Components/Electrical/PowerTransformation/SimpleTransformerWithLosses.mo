within IntegraNet.Components.Electrical.PowerTransformation;
model SimpleTransformerWithLosses
  "Transformer model of a predefined Dy with simple efficiency modell considering losses"
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

public
  parameter Real ratio = 45 "Turn ratio" annotation(Dialog(enable = UseRatio, group = "Transformer properties"));
  parameter SI.Efficiency eta( min = 0, max = 1)=0.95 "Efficiency of the transformer" annotation(Dialog(group = "Transformer properties"));
  parameter SI.ApparentPower S_rating=35000 "|Transformer properties|Rated power of the transformer";
  parameter SI.Impedance losses=0.005 "|Transformer properties|Losses due to the internal impedance of the transformer";

  // _____________________________________________
  //
  //             Variables
  // _____________________________________________

  SI.Voltage Secondary_Voltage= epp_p.v/ratio;
  SI.ApparentPower S_tot;
  Real drop=((sqrt(epp_p.P^2+epp_p.Q^2)/(Secondary_Voltage^2))*losses); // Decrease of power and voltage
  Real switch_sign "1 for positive power at epp_p, 0 for negative power at epp_p";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp_p annotation (
      Placement(transformation(extent={{-108,-10},{-88,10}}),
        iconTransformation(extent={{-108,-10},{-88,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp_n annotation (
      Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(
          extent={{90,-10},{110,10}})));

  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

equation

  switch_sign*(-2*sqrt(epp_p.P^2))=-epp_p.P-sqrt(epp_p.P^2);

// Calculation of apparent power
  S_tot=sqrt(epp_n.P^2+epp_n.Q^2);

  epp_p.f = epp_n.f;

 // consider the efficiency of the transformer and the impedance to calculate the output power

   epp_p.P * eta*(1-drop)*switch_sign + epp_p.P * (1+drop)*(1-switch_sign)/eta+ epp_n.P = 0;
   epp_p.Q * eta*(1-drop)*switch_sign + epp_p.Q * (1+drop)*(1-switch_sign)/eta+ epp_n.Q = 0;

 // Voltage change with respect to the threshold value of the transformer S_rating

    if ( S_tot > S_rating) then
    epp_n.v =(Secondary_Voltage)*S_rating/(S_tot)*switch_sign + (Secondary_Voltage)*(S_tot/S_rating)*(1-switch_sign);
    else
    (Secondary_Voltage)*(1-drop)*switch_sign+((Secondary_Voltage)*(1+drop))*(1-switch_sign) = epp_n.v;
    end if;

  annotation(Icon(coordinateSystem(preserveAspectRatio=false,   extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{-92,0},{-58,0},{90,0}},
          color={0,0,0},
          smooth=Smooth.None),
                             Ellipse(
          extent={{-24,36},{50,-34}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Ellipse(
          extent={{-58,36},{16,-34}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-82,14},{-72,0}},
          lineColor={0,128,0},
          textString="1"),
        Text(
          extent={{68,14},{78,0}},
          lineColor={0,128,0},
          textString="2"),
        Text(
          extent={{-34,72},{30,46}},
          lineColor={0,0,0},
          textString="\\eta")}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Simple model of a power transformer. It considers constant losses through the internal impedances and losses that occur when the nominal power is exceeded.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Saba Al-Sader, Fraunhofer UMSICHT in 2018</span></p>
</html>"));
end SimpleTransformerWithLosses;

