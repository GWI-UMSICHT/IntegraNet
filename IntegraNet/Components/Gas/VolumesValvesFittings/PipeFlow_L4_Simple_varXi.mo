﻿within IntegraNet.Components.Gas.VolumesValvesFittings;
model PipeFlow_L4_Simple_varXi
  "A 1D tube-shaped control volume considering one-phase heat transfer in a straight pipe with static momentum balance, simple energy balance, and variable composition."

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
// This component is a modification of model PipeFlow_L4_Simple_varXi from         //
// TransiEnt Library, version: 1.0.0                                               //
//

// Modified component of the ClaRa library, version: 1.0.1                   //
// Path: ClaRa.Components.VolumeValvesFittings.Pipes.PipeFlow_L4_Simple      //
// Modifications: minimum number of finite volumes adjusted to 1             //


// CHANGES:
// Default parametrization was changed to values for operation in low pressure grids
// Balance equations for mass fractions of gas components were copied from the ClaRa release 1.2.2 into the Base_Class VolumeRealGas_L4_varXi of the 1.2.1 ClaRa release
// Nominal-value independent pressure loss models dp_phy_simple and dp_phy_FM were implemented and added to the pressure loss model selection
// New pressure loss models are based on the function dp_overall_MFLOW from the FluidDissipation library, which is itself based on the Darcy-Weisbach law
// Use dp_phy_simple for pipes with N_cv = 1 and dp_phy_FM for pipes with N_cv > 1

   extends IntegraNet.Components.Gas.VolumesValvesFittings.Base.VolumeRealGas_L4_varXi(
    gasBulk(each deactivateTwoPhaseRegion=true),
    gasOut(deactivateTwoPhaseRegion=true),
    gasIn(deactivateTwoPhaseRegion=true),
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry_N_cv (
        z_in=z_in,
        z_out=z_out,
        N_tubes=N_tubes,
        N_cv=N_cv,
        diameter=diameter_i,
        length=length,
        Delta_x=Delta_x));
  extends ClaRa.Basics.Icons.Pipe_L4;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L4");
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=noEvent(if sum(heat.Q_flow) > 0 then sum(heat.Q_flow) else 0),
    powerOut_th=if not heatFlowIsLoss then -sum(heat.Q_flow) else 0,
    powerOut_elMech=0,
    powerAux=0) if  contributeToCycleSummary;

    //## S U M M A R Y   D E F I N I T I O N #######################################################################
protected
  model Outline
    extends TransiEnt.Basics.Icons.Record;
    //parameter Boolean showExpertSummary annotation(Dialog(hide));
    parameter Integer N_cv "|Discretisation|Number of finite volumes";
    input SI.Volume volume_tot "Total volume of system" annotation (Dialog(show));
    input SI.PressureDifference Delta_p "Pressure difference between outlet and inlet" annotation(Dialog);
    input SI.Mass mass_tot "Total fluid mass in system mass" annotation (Dialog(show));
    input SI.HeatFlowRate Q_flow_tot "Heat flow through entire pipe wall" annotation (Dialog);
    input SI.MassFlowRate m_flow[N_cv + 1] "Mass flow through cell borders" annotation (Dialog(show));
    input SI.Velocity w_inlet "Velocity at the inlet" annotation (Dialog(show));
    input SI.Velocity w[N_cv] "Velocity within the cells" annotation (Dialog(show));
    input SI.Velocity w_outlet "Velocity at the outlet" annotation (Dialog(show));
  end Outline;

  model Summary
     extends TransiEnt.Basics.Icons.Record;
     Outline outline;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    TransiEnt.Basics.Records.RealGasBulk_L4 gasBulk;
    TransiEnt.Basics.Records.FlangeHeat_L4 heat;
    TransiEnt.Basics.Records.Costs costs;
  end Summary;
//## P A R A M E T E R S #######################################################################################

//____Geometric data_____________________________________________________________________________________
public
  parameter ClaRa.Basics.Units.Length length=50 "|Geometry|Length of the pipe";
  parameter ClaRa.Basics.Units.Length diameter_i=0.1 "|Geometry|Inner diameter of the pipe";
  parameter ClaRa.Basics.Units.Length z_in=0 "|Geometry|height of inlet above ground";
  parameter ClaRa.Basics.Units.Length z_out=0 "|Geometry|height of outlet above ground";

  parameter Integer N_tubes= 1 "|Geometry|Number Of parallel pipes";

//____Discretisation_____________________________________________________________________________________
  parameter Integer N_cv=1 "|Discretisation|Number of finite volumes";

public
  inner parameter ClaRa.Basics.Units.Length Delta_x[N_cv]=ClaRa.Basics.Functions.GenerateGrid(
      {0},
      length,
      N_cv) "|Discretisation|Discretisation scheme";

//________Summary_________________
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                        annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean heatFlowIsLoss = true "True if negative heat flow is a loss (not a process product)" annotation(Dialog(tab="Summary and Visualisation"));
//parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if an extended summary shall be shown, else false";
public
  parameter Boolean showData=false "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";
  Summary summary(
    outline(
      N_cv=geo.N_cv,
      volume_tot=sum(geo.volume),
      Delta_p=gasPortOut.p - gasPortIn.p,
      mass_tot=sum(mass),
      Q_flow_tot=sum(heat.Q_flow),
      m_flow=m_flow,
      w_inlet=w_inlet,
      w=w,
      w_outlet=w_outlet),
    gasPortIn(
      mediumModel=medium,
      xi=gasIn.xi,
      x=gasIn.x,
      m_flow=gasPortIn.m_flow,
      T=gasIn.T,
      p=gasPortIn.p,
      h=gasIn.h,
      rho=gasIn.d),
    gasPortOut(
      mediumModel=medium,
      xi=gasOut.xi,
      x=gasOut.x,
      m_flow=gasPortOut.m_flow,
      T=gasOut.T,
      p=gasPortOut.p,
      h=gasOut.h,
      rho=gasOut.d),
    gasBulk(
      mediumModel=medium,
      N_cv=geo.N_cv,
      mass=mass,
      T=gasBulk.T,
      p=p,
      h=h,
      xi=gasBulk.xi,
      x=gasBulk.x,
      rho=gasBulk.d),
    heat(
      N_cv=geo.N_cv,
      T=heat.T,
      Q_flow=heat.Q_flow),
    costs(
      costs=collectCosts.costsCollector.Costs,
      investCosts=collectCosts.costsCollector.InvestCosts,
      demandCosts=collectCosts.costsCollector.DemandCosts,
      oMCosts=collectCosts.costsCollector.OMCosts,
      otherCosts=collectCosts.costsCollector.OtherCosts,
      revenues=collectCosts.costsCollector.Revenues)) annotation (Placement(transformation(extent={{-52,-50},
            {-32,-32}})));
protected
  ClaRa.Basics.Interfaces.EyeIn eye_int annotation (Placement(transformation(extent={{85,-41},{87,-39}})));
public
  ClaRa.Basics.Interfaces.EyeOut eye if showData annotation (Placement(transformation(extent={{130,-50},{150,-30}}), iconTransformation(extent={{136,-44},{156,-24}})));

// VARIABLES

SI.PressureDifference Delta_p;

  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  replaceable model CostSpecsGeneral =
      TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty                                  constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs
                                                                                                                                                                                 "Cost model" annotation(Dialog(group="Statistics"),choicesAllMatching);

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral
    collectCosts(
    der_E_n=0,
    E_n=0,
    redeclare model CostRecordGeneral = CostSpecsGeneral (size1=diameter_i,
          size2=length*N_tubes))
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));

//### E Q U A T I O N P A R T #######################################################################################
//-------------------------------------------
equation

  Delta_p = gasPortIn.p - gasPortOut.p;

  assert(abs(z_out-z_in) <= length, "Length of pipe less than vertical height", AssertionLevel.error);
  //Summary:
  eye_int.m_flow=-gasPortOut.m_flow;
  eye_int.T=gasOut.T - 273.15;
  eye_int.s=gasOut.s/1e3;
  eye_int.p=gasPortOut.p/1e5;
  eye_int.h=actualStream(gasPortOut.h_outflow)/1e3;
         //fillColor={0,131,169};//DynamicSelect(if time > 0 then (if not FlowModel==FlowModelStructure.inlet_innerPipe_outlet and not FlowModel==FlowModelStructure.inlet_innerPipe_dp_outlet then {0,131,169} else {255,255,255}) else {255,255,255}),
    connect(modelStatistics.costsCollector, collectCosts.costsCollector);
  connect(eye_int,eye)  annotation (Line(
      points={{86,-40},{140,-40}},
      color={255,204,51},
      smooth=Smooth.None,
      thickness=0.5));
annotation (defaultComponentName="pipe",Icon(coordinateSystem(preserveAspectRatio=false,
                                                           extent={{-140,-50},{
            140,50}}),
                   graphics={
        Polygon(
          points={{-132,42},{-122,42},{-114,34},{-114,-36},{-122,-42},{-132,-42},
              {-132,42}},
          lineColor=none,
          smooth=Smooth.None,
          fillColor=DynamicSelect({221,222,223}, if frictionAtInlet then {0,131,
              169} else {221,222,223}),
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{132,42},{122,42},{114,34},{114,-36},{122,-42},{132,-42},
              {132,42}},
          lineColor=none,
          smooth=Smooth.None,
          fillColor=DynamicSelect({221,222,223},if frictionAtOutlet then {0,131,169} else {221,222,223}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-142,64},{132,94}},
          lineColor={28,108,200},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-50},{140,50}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">1D Flow of real gas mixtures. Default parametrization for low pressure gas grids</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L4, considers HeatTransfer, PressureLoss, Discretisation of the pipe Length and time delay from inlet to outlet. Is able to use real gas mixtures (VLEFluids). Static momentum and simple energy balance.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">-</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">gasPortIn: inlet for real gas</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">gasPortOut: outlet for real gas</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">heat: heat port</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">-</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>Use&nbsp;dp_phy_simple&nbsp;for&nbsp;pipes&nbsp;with&nbsp;N_cv&nbsp;=&nbsp;1&nbsp;and&nbsp;dp_phy_FM&nbsp;for&nbsp;pipes&nbsp;with&nbsp;N_cv&nbsp;&gt;&nbsp;1<span style=\"font-family: MS Shell Dlg 2;\"> </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>Based on the model PipeFlow_L4_Simple_varXi from TransiEnt 1.0.0, which is based on <span style=\"font-family: MS Shell Dlg 2;\">ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple (ClaRa Library 1.0.1).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Michael Djukow, 2017</span></p>
</html>"));
end PipeFlow_L4_Simple_varXi;

