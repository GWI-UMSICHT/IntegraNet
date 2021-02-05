within IntegraNet.Components.Heat.VolumesValvesFittings.Base;
model HT_Single_Buried_LX "Heat Transfer Calculation with spatialDistribution() for a single buried pipe -Based upon Dynamic equation-based thermo-hydraulic pipe model for district heating and cooling systems by B. van der Heide et al."
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

  extends HT_PlugFlow_Base_LX;
  import SI = Modelica.SIunits;
  import TILfluid = TILMedia.VLEFluidObjectFunctions;
  outer pipe_parameters pipe_parameter;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  //____Initialization_____________________________________________________________________________________
  parameter SI.Length depth = 1.2 "Depth of the pipe";
  parameter SI.ThermalConductivity lambda_ground = 1.5  "Thermal conductivity of the soil";

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  SI.MassFlowRate m_flow(start = pipe_parameter.m_flow_start) = waterPortIn.m_flow;
  final SI.SpecificEnthalpy h_in(start = pipe_parameter.h_start) = waterPortIn.h_outflow;
  final SI.SpecificEnthalpy h_out(start = pipe_parameter.h_start_out) = fluidOut.h;
  SI.Temperature T_in(start= pipe_parameter.T_start);
  SI.Temperature T_out(start= pipe_parameter.T_start_out);

  // _____________________________________________
  //
  //                   Interfaces
  // _____________________________________________

  TILMedia.VLEFluid_pT fluidIn(
    vleFluidType=simCenter.fluid1,
    computeTransportProperties=true,
    interpolateTransportProperties=false,
    computeSurfaceTension=false,
    T=T_in,
    p=waterPortIn.p)
    annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));
  TILMedia.VLEFluid_pT fluidOut(
    vleFluidType=simCenter.fluid1,
    computeTransportProperties=true,
    interpolateTransportProperties=false,
    computeSurfaceTension=false,
    T=T_out,
    p=waterPortOut.p)
    annotation (Placement(transformation(extent={{60,-12},{80,8}})));

equation

  // _____________________________________________
  //
  //            Equations
  // _____________________________________________

  R = log(diameter_o/(diameter_i+pipe_wall_thickness*2))/(2*Modelica.Constants.pi*lambda_insulation)+ log(2*depth/(diameter_o))/(2*Modelica.Constants.pi*lambda_ground);
  C = (Modelica.Constants.pi*(1/4))*diameter_i^2*fluidIn.d*fluidIn.cp;
  waterPortIn.h_outflow = inStream(waterPortOut.h_outflow);
  waterPortOut.h_outflow =TILfluid.specificEnthalpy_pTxi(waterPortOut.p,T_out,fluidOut.xi,fluidOut.vleFluidPointer);

  T_in= TILfluid.temperature_phxi(
     waterPortIn.p,
     inStream(waterPortIn.h_outflow),
     fluidIn.xi,
     fluidIn.vleFluidPointer);
  // Mass balance
  waterPortIn.p = waterPortOut.p;
  waterPortIn.m_flow + waterPortOut.m_flow = 0;
  waterPortIn.xi_outflow = waterPortOut.xi_outflow;
  // Heat Loss
  T_out = (heat.T + (T_in - heat.T)*exp(-residence_time/(C*R)));
  heat.Q_flow = - fluidIn.cp*waterPortIn.m_flow*(T_in -T_out);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{100,100},{-100,-100}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={89,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,40},{40,-40}},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{30,40},{50,-40}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-16,40},{4,-40}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-40,40},{-6,-40}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-50,40},{-30,-40}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-6,40},{-6,58},{-12,58},{-2,72},{8,58},{2,58},{2,40},{-6,
              40}},
          pattern=LinePattern.None,
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-4,-16},{-4,2},{-10,2},{0,16},{10,2},{4,2},{4,-16},{-4,-16}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          origin={-70,0},
          rotation=270)}),                                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Calculates heat loss of a single buried district heating pipe </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de) on 10.10.2018</span></p>
</html>"));
end HT_Single_Buried_LX;

