﻿within IntegraNet.Producer.Heat.Heat2Heat;
model Indirect_HEX_L1 "A model representing a energy based hex part of a substation with indirect connection."
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

 import SI = Modelica.SIunits;
 import TIL = TILMedia.VLEFluidFunctions;
 outer IntegraNet.SimCenter simCenter;

 // _____________________________________________
 //
 //                   Parameters
 // _____________________________________________

 parameter SI.Temperature T_start = 90+273.15 "Temperature at start of simulation";
 parameter Real dT_soll = 10 "Setpoint temperature difference between Supply and Return pipe";
 parameter SI.MassFlowRate m_flow_min = 0.01 "Minimum mass flow rate to counteract possible zero massflow sitations";
 final parameter SI.SpecificHeatCapacityAtConstantPressure cp = TIL.specificIsobaricHeatCapacity_pTxi(simCenter.fluid1,simCenter.p_nom[2],T_start,{1,0,0});

 // _____________________________________________
 //
 //                   Variables
 // _____________________________________________

 SI.HeatFlowRate Q_withdrawal "Heat taken out of the district heating";

 SI.Temperature T_out "Outlet Temperature of the idealHEX";

 // _____________________________________________
 //
 //                   Interfaces
 // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput Q_demand
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-72,80})));
  Modelica.Blocks.Interfaces.RealOutput T_out_calc annotation (Placement(
        transformation(extent={{100,-60},{120,-40}}),iconTransformation(extent={{92,-20},{132,20}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow annotation (Placement(
        transformation(extent={{100,30},{140,70}}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,-114})));
  Modelica.Blocks.Interfaces.RealInput T_in annotation (Placement(
        transformation(extent={{-120,64},{-80,104}}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={68,80})));

equation
  // Explanation - Calculation of the needed mass flow to archive the given constant temperature difference between supply and return.

    Q_withdrawal = Q_demand;
    m_flow = max(Q_withdrawal/(cp*dT_soll),m_flow_min);
    T_out =  T_in - Q_withdrawal/(cp*m_flow);
    T_out_calc = T_out;

    annotation (Line(points={{120,50},{11,50},{11,50},{120,50}}, color={0,0,127}),
              Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{102,-100}},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-84,6},{-84,6}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-92,0},{-40,0},{92,0}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{4,0},{4,0},{92,0}},
          color={28,108,200},
          thickness=1),
        Rectangle(
          extent={{-38,22},{46,-22}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-38,0},{-18,14},{-18,-10},{6,14},{6,-10},{30,14},{30,-10},{46,
              0}},
          color={0,0,0},
          thickness=1),
        Rectangle(
          extent={{2,20},{10,4}},
          lineThickness=0.5,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-4,20},{6,34},{16,20},{-4,20}},
          lineThickness=0.5,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Simple heat exchanger model specifically modeled to be used in district heating networks.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Calculates the necessary mass flow for a constant dT between supply and return:</span></p>
<p><img src=\"modelica://IntegraNet/Resources/Images/equations/equation-W7rTOKK8.png\" alt=\"Q = m * cp * dT\"/></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>Due to the simple nature of the model it is important to have a realistic supply temperature such that the return temperature doesn&apos;t fall below possible values. </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de) on 10.10.2018</span></p>
</html>"));
end Indirect_HEX_L1;

