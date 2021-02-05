within IntegraNet.Components.Gas.VolumesValvesFittings.Base;
model dp_phy_simple "VLE|| dp_phy_simple"
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


// Nominal-value independent pressure loss model for pipes with Ncv = 1
// Model uses the function dp_overall_MFLOW from the FluidDissipation library (see FluidDissipation Documentation for further information)
// Pipe is discretized by frictionAtInlet and frictionAtOutlet (see ClaRa documentation for further information)
// Constant value of density in the centre of the pipe is used for pressure loss calculation

  import SI = ClaRa.Basics.Units;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.density_phxi;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.PressureLoss_L4;
  outer IntegraNet.SimCenter simCenter;



   Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_IN_con inCon[2](each d_hyd= geo.diameter,
        L = geo.Delta_x_FM,
       each roughness = Modelica.Fluid.Dissipation.Utilities.Types.Roughness.Considered,
    each K=simCenter.K_gas)
                     annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));


   Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_IN_var inVar[2](each eta=1.0579e-5,
      each rho = density_phxi(
      iCom.p[1],
      iCom.h[1],
      iCom.xi[1, :],
      iCom.fluidPointer[1]))
  annotation (Placement(transformation(extent={{-28,-80},{-8,-60}})));

equation

  m_flow = Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_MFLOW(inCon, inVar, Delta_p);

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This model is a physical pressure loss model for pipes with N_cv=1. The model uses the function dp_overall_MFLOW (Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_MFLOW).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>Pipe&nbsp;is&nbsp;discretized&nbsp;by&nbsp;frictionAtInlet&nbsp;and&nbsp;frictionAtOutlet. Constant&nbsp;value&nbsp;of&nbsp;density&nbsp;in&nbsp;the&nbsp;centre&nbsp;of&nbsp;the&nbsp;pipe&nbsp;is&nbsp;used&nbsp;for&nbsp;pressure&nbsp;loss&nbsp;calculation</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p>Only valid for pipes with N_cv = 1</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Michael Djukow during IntegraNet, GWI Essen e.V., 2017</span></p>
</html>"));
end dp_phy_simple;

