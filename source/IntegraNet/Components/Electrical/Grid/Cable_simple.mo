within IntegraNet.Components.Electrical.Grid;
model Cable_simple "Transmission line model with a constant loss per unit length between power input and power output"
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
  outer IntegraNet.Statistics.Statistics_collector statistics_collector;
  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

   parameter SI.Length l=1 "Length of the cable";
   parameter SI.Impedance losses=0.0005 "Losses from cable impedance per unit lenght";


  // _____________________________________________
  //
  //             Variables
  // _____________________________________________

   SI.ApparentPower S1=sqrt(epp_p.P^2+epp_p.Q^2);
   Real f_loss= ((S1/(230^2))*losses*l) "Decrease in power and voltage";
   Real switch_sign "1 for positive power at epp_p, 0 for negative power at epp_p";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

    TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp_p annotation (Placement(transformation(extent={{-110,-8},
              {-90,12}})));
    TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp_n annotation (Placement(transformation(extent={{90,-8},
              {110,12}})));

public
  Statistics.LocalCollector losses_LocalCollector(typeOfResource=IntegraNet.Statistics.TypeOfResource.el_Losses_Cable) annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  losses_LocalCollector.flowCollector.unit_flow = f_loss;
  connect(losses_LocalCollector.flowCollector, statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.el_Losses_Cable]);


    switch_sign*(-2*sqrt(epp_p.P^2))=-epp_p.P-sqrt(epp_p.P^2);

    epp_p.f=epp_n.f;
    epp_n.v= epp_p.v*(1-f_loss)*(switch_sign)+epp_p.v*(1+f_loss)*(1-switch_sign);
    epp_n.P=-epp_p.P*(1-f_loss)*(switch_sign)-epp_p.P*(1+f_loss)*(1-switch_sign);
    epp_n.Q=-epp_p.Q*(1-f_loss)*(switch_sign)-epp_p.Q*(1+f_loss)*(1-switch_sign);

  annotation(Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100,-100},{100,100}}), graphics), Icon(coordinateSystem(preserveAspectRatio=false,   extent={{-100,
            -100},{100,100}}),                                                                                                    graphics={  Line(points = {{-100,0},{100,0}}, color = {0,0,0}, smooth = Smooth.None),Rectangle(extent = {{-80,6},{80,-6}}, lineColor = {0,0,0}, fillColor = {0,0,0},
            fillPattern =                                                                                                   FillPattern.Solid),Text(extent = {{-100,-16},{100,-52}}, lineColor = {0,0,0}, fillColor = {0,0,255},
            fillPattern =                                                                                                   FillPattern.Solid, textString = "L = %l m"),Text(extent={{
              -144,56},{156,16}},                                                                                                    lineColor=
              {0,0,0},
          textString="%CableType"),
        Text(
          extent={{-202,94},{196,56}},
          lineColor={0,0,0},
          textString="%name")}),defaultComponentName = "Cable",
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Simple model of a cable with a constant loss per unit length.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarsk for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Saba Al-Sader during the project IntegraNet in 2017</span></p>
</html>"));
end Cable_simple;

