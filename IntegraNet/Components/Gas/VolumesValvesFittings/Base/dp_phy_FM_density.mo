within IntegraNet.Components.Gas.VolumesValvesFittings.Base;
model dp_phy_FM_density "VLE|| dp_phy_FM_density"
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


 // Nominal-value independent pressure loss model for pipes with Ncv > 1
 // Model uses the function dp_overall_MFLOW from the FluidDissipation library (see FluidDissipation Documentation for further information)
 // Discretization scheme is based on the pressure loss model ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4

  import SI = ClaRa.Basics.Units;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.density_phxi;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.PressureLoss_L4;

  //parameter Modelica.SIunits.Pressure Delta_p_smooth=iCom.Delta_p_nom/iCom.N_cv*0.2 "|Small Mass Flows|For pressure losses below this value the square root of the quadratic pressure loss model is regularised";

 SI.DensityMassSpecific rho[iCom.N_cv + 1] "Density in FlowModel cells";

//protected
  Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_IN_con inCon[iCom.N_cv + 1](each d_hyd= geo.diameter,
     L= geo.Delta_x_FM,
    each roughness=Modelica.Fluid.Dissipation.Utilities.Types.Roughness.Considered,
    each K=0.0005) annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

  Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_IN_var inVar[iCom.N_cv + 1](each eta=1.051e-5,
   rho=rho) annotation (Placement(transformation(extent={{-28,-80},{-8,-60}})));

equation

   /////// Calcultae Media Data Required //////////////////
   rho[2:geo.N_cv] = {smooth(1, noEvent(max(1e-6, if m_flow[i] > 0 then density_phxi(
    iCom.p[i - 1],
    iCom.h[i - 1],
    iCom.xi[i - 1, :],
    iCom.fluidPointer[i - 1]) else density_phxi(
    iCom.p[i],
    iCom.h[i],
    iCom.xi[i, :],
    iCom.fluidPointer[i])))) for i in 2:iCom.N_cv};
   rho[1] = smooth(1, noEvent(max(1e-6, if m_flow[1] > 0 then density_phxi(
     iCom.p_in[1],
     iCom.h_in[1],
     iCom.xi_in[1, :],
     iCom.fluidPointer_in[1]) else density_phxi(
     iCom.p[1],
     iCom.h[1],
     iCom.xi[1, :],
     iCom.fluidPointer[1]))));
   rho[geo.N_cv + 1] = smooth(1, noEvent(max(1e-6, if m_flow[geo.N_cv + 1] > 0 then density_phxi(
     iCom.p_in[end],
     iCom.h_in[end],
     iCom.xi_in[end, :],
     iCom.fluidPointer_in[end]) else density_phxi(
     iCom.p_out[1],
     iCom.h_out[1],
     iCom.xi_out[1, :],
     iCom.fluidPointer_out[1]))));

    //frictionAtInlet and frictionAtOutlet
    if not frictionAtInlet and not frictionAtOutlet then
    for i in 2:iCom.N_cv loop
      m_flow[i] = if useHomotopy then homotopy(Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_MFLOW(
        inCon[i],
        inVar[i],
        Delta_p[i]), (iCom.m_flow_nom/iCom.Delta_p_nom)*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1] - geo.Delta_x_FM[iCom.N_cv + 1])*Delta_p[i]) else Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_MFLOW(
        inCon[i],
        inVar[i],
        Delta_p[i]);
    end for;

    Delta_p[1] = 0;

    Delta_p[iCom.N_cv + 1] = 0;

  elseif not frictionAtInlet and frictionAtOutlet then
    for i in 2:iCom.N_cv + 1 loop

      m_flow[i] = if useHomotopy then homotopy(Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_MFLOW(
        inCon[i],
        inVar[i],
        Delta_p[i]), (iCom.m_flow_nom/iCom.Delta_p_nom)*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1])*Delta_p[i]) else Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_MFLOW(
        inCon[i],
        inVar[i],
        Delta_p[i]);
    end for;

    Delta_p[1] = 0;

  elseif frictionAtInlet and not frictionAtOutlet then
    for i in 1:iCom.N_cv loop

      m_flow[i] = if useHomotopy then homotopy(Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_MFLOW(
        inCon[i],
        inVar[i],
        Delta_p[i]), (iCom.m_flow_nom/iCom.Delta_p_nom)*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[iCom.N_cv + 1])*Delta_p[i]) else Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_MFLOW(
        inCon[i],
        inVar[i],
        Delta_p[i]);
    end for;

    Delta_p[iCom.N_cv + 1] = 0;

  else
    //frictionAtInlet and frictionAtOutlet
    for i in 1:iCom.N_cv + 1 loop

      m_flow[i] = if useHomotopy then homotopy(Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_MFLOW(
        inCon[i],
        inVar[i],
        Delta_p[i]), (iCom.m_flow_nom/iCom.Delta_p_nom)*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM))*Delta_p[i]) else Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_MFLOW(
        inCon[i],
        inVar[i],
        Delta_p[i]);
    end for;
  end if;

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>This model is a physical pressure loss model usable also for pipes with N_cv &gt; 1. </p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The structure and discretization scheme is based on ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4 </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>For pressure loss calculation the the function dp_overall_MFLOW (Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_MFLOW) is used. </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p>-</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(none)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">-</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>-</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>-</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>-</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>-</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Michael Djukow, GWI Essen e.V., 2017</span></p>
</html>"));
end dp_phy_FM_density;

