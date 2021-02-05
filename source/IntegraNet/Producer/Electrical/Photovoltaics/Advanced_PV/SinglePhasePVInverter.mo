within IntegraNet.Producer.Electrical.Photovoltaics.Advanced_PV;
model SinglePhasePVInverter "Simple PV inverter"
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


//_______________________________________________________________________

 // This solar inverter model considers:
 //  - losses through the decoupling inductor inside the inverter
 //  - power factor
 //  - losses of the AC side not included in the inverter losses

//_______________________________________________________________________

  // _____________________________________________
  //
  //             Parameters
  // _____________________________________________

   outer IntegraNet.Statistics.Statistics_collector statistics_collector;

  parameter SI.Efficiency Eff_inverter=0.98 "Efficiency of the inverter";
  parameter SI.PowerFactor PF_inverter=1 "Operating power factor of the inverter";
  parameter SI.Power P_inverter=100000 "Rated power of the inverter";
  parameter Real XL(min=0)=0.001 "Decoupling Inductor";
  parameter Real Losses_AC(unit="1")=0.04 "AC side losses not included in the inverter efficiency";
  parameter Real P_PV "Installed peak power of the PV plant";
  parameter Real Threshold=0.7 "Percentage of peak power at which power is cut";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp_DC annotation (Placement(transformation(extent={{-108,-10},{-88,10}}), iconTransformation(extent={{-108,-10},{-88,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp_AC annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  // _____________________________________________
  //
  //                 Variables
  // _____________________________________________

  SI.ApparentPower S;

  Statistics.LocalCollector Inverter_Losses(typeOfResource=IntegraNet.Statistics.TypeOfResource.el_Losses_Inverter) "Inverter losses" annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
equation

 // The apparent power after the decoupling inductor
  S=sqrt(epp_DC.P^2 + (epp_DC.P*XL)^2);
  epp_DC.f = 50;
  S*(Eff_inverter)*sin(acos(PF_inverter))*(1-Losses_AC)=-epp_AC.Q;

// Output power from the inverter considering the efficiency, power factor and the AC losses
  if (epp_DC.P < P_inverter) then
      min(Threshold*P_PV,S*(Eff_inverter)*PF_inverter*(1-Losses_AC))= -epp_AC.P;
    else
      min(Threshold*P_PV,P_inverter)  = -epp_AC.P;
  end if;

    Inverter_Losses.flowCollector.unit_flow = (-epp_DC.P-epp_AC.P);
  connect(Inverter_Losses.flowCollector, statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.el_Losses_Inverter]);


  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(extent={{-96,86},{96,-84}}, lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{96,86},{-96,-84}}, color={28,108,200}),
        Text(
          extent={{16,-12},{64,-68}},
          lineColor={28,108,200},
          textString="AC"),
        Text(
          extent={{-64,66},{-16,10}},
          lineColor={28,108,200},
          textString="DC")}),                                    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The purpose of this model is to calculate the dc power output of a PV inverter.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Input: </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">epp_DC</span></b> for dc power </p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Output: </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">epp_AC</span></b> for dc pwer</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model has not been validated.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><br><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: Courier New;\">Model created by Saba AlSader, Fraunhofer UMSICHT, 2018</span></p>
</html>"));
end SinglePhasePVInverter;

