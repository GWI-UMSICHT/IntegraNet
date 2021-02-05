within IntegraNet.Components.Gas.VolumesValvesFittings.Base;
model VolumeRealGas_L4_varXi "A 1D tube-shaped control volume considering one-phase heat transfer in a straight pipe with static momentum balance, simple energy balance, and variable composition"

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
// This component is a modification of model VolumeRealGas_L4_varXi from TransiEnt //
// Library, version: 1.0.0                                                         //
//

// Modified component of the ClaRa library, version: 1.0.1                   //
// Path: ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L4               //
// Modifications: simCenter, media models, connectors, variable composition  //
// updated to ClaRa 1.2.1 except initType

// CHANGES: Balance equations for mass fractions of gas components were copied from the ClaRa release 1.2.2 into the Base_Class VolumeRealGas_L4_varXi of the 1.2.1 ClaRa release

  extends ClaRa.Basics.Icons.Volume_L4;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L4");
  import SI = Modelica.SIunits;
  import Modelica.Constants.eps;
  import Modelica.Constants.g_n "gravity constant";
  import ClaRa.Basics.Functions.Stepsmoother;
  outer IntegraNet.SimCenter simCenter;

//____Media Data_____________________________________________________________________________________
public
 parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.gasModel1 "|Fundamental Definitions|Medium in the component";

//____Physical Effects_____________________________________________________________________________________

public
  inner parameter Boolean frictionAtInlet=true "|Fundamental Definitions|True if pressure loss between first cell and inlet shall be considered"
                                                                                        annotation (choices(checkBox=true));
  inner parameter Boolean frictionAtOutlet=true "|Fundamental Definitions|True if pressure loss between last cell and outlet shall be considered"
                                                                                        annotation (choices(checkBox=true));

  replaceable model PressureLoss =
    IntegraNet.Components.Gas.VolumesValvesFittings.Base.dp_phy_FM_density constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4
                                                                                               "|Fundamental Definitions|Pressure loss model at the tubes side"
    annotation(choicesAllMatching);

  replaceable model HeatTransfer =
     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE_L4 "|Fundamental Definitions|Heat transfer mode at the tubes side"
   annotation(choicesAllMatching);

  replaceable model Geometry =
      ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry_N_cv constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv "|Geometry|Pipe geometry"
   annotation(choicesAllMatching);

//____Nominal Values_________________________________________________________________________________
public
  parameter SI.Pressure p_nom[geo.N_cv]=ones(geo.N_cv)*(simCenter.p_amb_const+simCenter.p_eff_1) "|Nominal Values|Nominal pressure";
  parameter SI.SpecificEnthalpy h_nom[geo.N_cv]=ones(geo.N_cv)*(18427.1) "|Nominal Values|Nominal specific enthalpy for single tube";
  inner parameter SI.MassFlowRate m_flow_nom= 0.008 "|Nominal Values|Nominal mass flow w.r.t. all parallel tubes";
  inner parameter SI.PressureDifference Delta_p_nom=8 "|Nominal Values|Nominal pressure loss w.r.t. all parallel tubes";
  inner parameter SI.MassFraction xi_nom[medium.nc-1]=medium.xi_default "|Nominal Values|Nominal composition";
  final parameter SI.Density rho_nom[geo.N_cv]=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      medium,
      p_nom,
      h_nom,
      xi_nom) "|Nominal Values|Nominal density dependent on xi";

//____Initialisation_____________________________________________________________________________________
  parameter ClaRa.Basics.Choices.Init initType=ClaRa.Basics.Choices.Init.steadyState "|Initialisation||type of initialisation "
                                                annotation(choicesAllMatching);
  inner parameter Boolean useHomotopy=false "|Initialisation||true, if homotopy method is used during initialisation";
  parameter SI.SpecificEnthalpy h_start[geo.N_cv]=h_nom "|Initialisation||Initial specific enthalpy for single tube";
  parameter SI.Pressure p_start[geo.N_cv]=p_nom "|Initialisation||Initial pressure";
  parameter SI.MassFlowRate m_flow_start[geo.N_cv+1]=ones(geo.N_cv+1)*m_flow_nom "|Initialisation||Initial mass flow rate";
  parameter ClaRa.Basics.Units.MassFraction xi_start[medium.nc - 1]= xi_nom "|Initialisation||Initial composition for single tube";

protected
  parameter SI.Pressure p_start_internal[geo.N_cv]=if size(p_start, 1) == 2 then linspace(
      p_start[1],
      p_start[2],
      geo.N_cv) else p_start "Internal p_start array which allows the user to either state p_inlet, p_outlet if p_start has length 2, otherwise the user can specify an individual pressure profile for initialisation";

//## V A R I A B L E   P A R T#######################################################################################

//____Energy / Enthalpy_________________________________________________________________________________________
protected
  SI.SpecificEnthalpy h[geo.N_cv](start=h_start, stateSelect=StateSelect.prefer) "Cell enthalpy";

//____Pressure__________________________________________________________________________________________________
  SI.Pressure p[geo.N_cv](start=p_start_internal) "Cell pressure";
  SI.PressureDifference Delta_p_fric[geo.N_cv + 1] "Pressure difference due to friction";
  SI.PressureDifference Delta_p_grav[geo.N_cv + 1] "pressure drop due to gravity";

//____Mass and Density__________________________________________________________________________________________
  SI.Mass mass[geo.N_cv] "Mass of fluid in cells";
  SI.Mass mass_FM[geo.N_cv + 1]=cat(
      1,
      {mass[1]/2},
      {(mass[i] + mass[i - 1])/2 for i in 2:geo.N_cv},
      {mass[geo.N_cv]/2}) "Mass of fluid in flow cells";

  Real drhodt[geo.N_cv];//(unit="kg/(m3s)")

  //____Mass Fractions____________________________________________________________________________________________
  Modelica.SIunits.MassFraction xi[geo.N_cv, medium.nc - 1] "Mass fraction";
  Real[geo.N_cv + 1, medium.nc - 1] Xi_flow "Mass flow rate of fraction";

  //Aus Clara 1.2.2
  Modelica.SIunits.MassFraction xi_inlet[medium.nc - 1] "Inlet mass fraction of component";
  Modelica.SIunits.MassFraction xi_outlet[medium.nc - 1] "Outlet mass fraction of component";

//____Flows and Velocities______________________________________________________________________________________
  SI.Power H_flow[geo.N_cv + 1] "Enthalpy flow rate at cell borders";
  SI.MassFlowRate m_flow[geo.N_cv + 1](nominal=ones(geo.N_cv + 1)*m_flow_nom, start=m_flow_start);
  SI.Velocity w[geo.N_cv] "flow velocities within cells of energy model == flow velocities across cell borders of flow model ";
  SI.Velocity w_inlet "flow velocity at inlet";
  SI.Velocity w_outlet "flow velocity at outlet";

//____Connectors________________________________________________________________________________________________
public
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) "Inlet port" annotation (Placement(transformation(extent={{-150,-10},{-130,10}}), iconTransformation(extent={{-150,-10},{-130,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) "Outlet port" annotation (Placement(transformation(extent={{130,-10},{150,10}}), iconTransformation(extent={{130,-10},{150,10}})));
  ClaRa.Basics.Interfaces.HeatPort_a heat[geo.N_cv]
    annotation (Placement(transformation(extent={{-10,30},
            {10,50}}),          iconTransformation(
         extent={{-10,-10},{10,10}},
         rotation=90,
         origin={0,40})));

//___Instantiation of Replaceable Models___________________________________________________________________________
public
  PressureLoss pressureLoss "Pressure loss model"  annotation(Placement(transformation(extent={{-40,0},
            {-20,20}})));
  HeatTransfer heatTransfer(A_heat=geo.A_heat_CF[:,1]) "heat transfer model"
                            annotation(Placement(transformation(extent={{-80,0},
            {-60,20}})));

protected
  inner TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph
                             gasOut(
    p=gasPortOut.p,
    vleFluidType=medium,
    h=noEvent(actualStream(gasPortOut.h_outflow)),
    xi=xi_outlet,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{70,-30},{90,-10}}, rotation=0)));


protected
  inner TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph
                             gasBulk[geo.N_cv](
    p=p,
    h=h,
    xi=xi,
    each vleFluidType=medium,
    each computeTransportProperties=true,
    each deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,-40},{10,-20}}, rotation=0)));

  inner TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph
                             gasIn(
    p=gasPortIn.p,
    vleFluidType=medium,
    h=noEvent(actualStream(gasPortIn.h_outflow)),
    xi=xi_inlet,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-90,-30},{-70,-10}}, rotation=0)));

  inner ClaRa.Basics.Records.IComVLE_L3_OnePort iCom(
    mediumModel=medium,
    xi=xi,
    N_cv=geo.N_cv,
    volume=geo.volume,
    xi_in={gasIn.xi},
    p_in={gasPortIn.p},
    T_in={gasIn.T},
    m_flow_in={gasPortIn.m_flow},
    h_in={gasIn.h},
    xi_out={gasOut.xi},
    p_out={gasPortOut.p},
    T_out={gasOut.T},
    m_flow_out={gasPortOut.m_flow},
    h_out={gasOut.h},
    p_nom=p_nom[1],
    Delta_p_nom=Delta_p_nom,
    m_flow_nom=m_flow_nom,
    h_nom=h_nom[1],
    xi_nom=xi_nom,
    T=gasBulk.T,
    p=p,
    h=h,
    fluidPointer_in={gasIn.vleFluidPointer},
    fluidPointer_out={gasOut.vleFluidPointer},
    fluidPointer=gasBulk.vleFluidPointer) annotation (Placement(transformation(extent={{-80,-52},{-60,-34}})));
protected
  inner Geometry geo annotation (Placement(transformation(extent={{0,0},{20,20}})));

//### E Q U A T I O N P A R T #######################################################################################
//-------------------------------------------
//initialisation

initial equation
  if initType == ClaRa.Basics.Choices.Init.steadyState then
    der(h)=zeros(geo.N_cv);
    if frictionAtInlet or frictionAtOutlet then
      der(p)=zeros(geo.N_cv);
      for i in 1:geo.N_cv loop
        xi[i,:]=xi_start[1:end];
      end for;
    else
      der(gasPortOut.p) = 0;
      for i in 1:geo.N_cv loop
        der(xi[i,1:medium.nc-1])=zeros(medium.nc - 1);
      end for;
    end if;

  elseif initType == ClaRa.Basics.Choices.Init.steadyPressure then
    der(p)=zeros(geo.N_cv);
    for i in 1:geo.N_cv loop
      xi[i,:]=xi_start[1:end];
    end for;

  elseif initType == ClaRa.Basics.Choices.Init.steadyEnthalpy then
    der(h)=zeros(geo.N_cv);
    for i in 1:geo.N_cv loop
      xi[i,:]=xi_start[1:end];
    end for;
  end if;

equation

  connect(heat, heatTransfer.heat) annotation (Line(
      points={{0,40},{0,28},{-61,28},{-61,19}},
      color={0,0,0},
      smooth=Smooth.None));

//-------------------------------------------
//flow velocities at inlet and outlet
  w_inlet=gasPortIn.m_flow/(geo.A_cross_FM[1]*gasIn.d);
  w_outlet=-gasPortOut.m_flow/(geo.A_cross_FM[geo.N_cv + 1]*gasOut.d);

//flow velocities in cells
  for i in 1:geo.N_cv loop
     w[i]=(m_flow[i] + m_flow[i + 1])/(2*gasBulk[i].d*geo.A_cross[i]);
  end for;

//-------------------------------------------
//data exchange with friction model

   m_flow[1]=gasPortIn.m_flow;
   m_flow=pressureLoss.m_flow;
   m_flow[geo.N_cv+1]=-gasPortOut.m_flow;

//-------------------------------------------
//data exchange with heat transfer model
  heatTransfer.m_flow=m_flow;

//-------------------------------------------
//pressure drop due to friction, gravity

  Delta_p_fric = pressureLoss.Delta_p;
  if geo.N_cv==1 then
    if not frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = 0;
    elseif not frictionAtInlet and frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = gasBulk[1].d*g_n*(geo.z_out - geo.z_in);
    elseif  frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = gasBulk[1].d*g_n*(geo.z_out - geo.z_in);
      Delta_p_grav[2] = 0;
    else
      // frictionAtOutlet and frictionAtnlet
      Delta_p_grav[1] = gasBulk[1].d*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = gasBulk[1].d*g_n*(geo.z_out - geo.z[1]);
    end if;
  elseif geo.N_cv==2 then
    if not frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = gasBulk[2].d*g_n*(geo.z_out - geo.z_in);
      Delta_p_grav[3] = 0;
    elseif not frictionAtInlet and frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = (gasBulk[1].d*geo.Delta_x[1] + gasBulk[2].d*geo.Delta_x[2]/2)/(geo.Delta_x[2]/2+geo.Delta_x[1])*g_n*(geo.z[2] - geo.z_in);
      Delta_p_grav[3] = gasBulk[2].d*g_n*(geo.z_out - geo.z[2]);
    elseif  frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = gasBulk[1].d*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = (gasBulk[2].d*geo.Delta_x[2] + gasBulk[1].d*geo.Delta_x[1]/2)/(geo.Delta_x[1]/2+geo.Delta_x[2])*g_n*(geo.z_out - geo.z[1]);
      Delta_p_grav[3] = 0;
    else
      // frictionAtOutlet and frictionAtnlet
      Delta_p_grav[1] = gasBulk[1].d*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = (gasBulk[1].d*geo.Delta_x[1] + gasBulk[2].d*geo.Delta_x[2])/(geo.Delta_x[2]+geo.Delta_x[1])*g_n*(geo.z[2] - geo.z[1]);
      Delta_p_grav[3] = gasBulk[2].d*g_n*(geo.z_out - geo.z[2]);
    end if;
  else
    for i in 3:geo.N_cv-1 loop
      Delta_p_grav[i] = (gasBulk[i].d*geo.Delta_x[i] + gasBulk[i - 1].d*geo.Delta_x[i - 1])/(geo.Delta_x[i - 1]+geo.Delta_x[i])*g_n*(geo.z[i] - geo.z[i-1]);
    end for;

    if frictionAtInlet then
      Delta_p_grav[1] = gasBulk[1].d*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = (gasBulk[1].d*geo.Delta_x[1] + gasBulk[2].d*geo.Delta_x[2])/(geo.Delta_x[2]+geo.Delta_x[1])*g_n*(geo.z[2] - geo.z[1]);
    else
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = (gasBulk[1].d*geo.Delta_x[1] + gasBulk[2].d*geo.Delta_x[2]/2)/(geo.Delta_x[2]/2+geo.Delta_x[1])*g_n*(geo.z[2] - geo.z_in);
    end if;

    if frictionAtOutlet then
      Delta_p_grav[geo.N_cv+1] = gasBulk[geo.N_cv].d*g_n*(geo.z_out - geo.z[geo.N_cv]);
      Delta_p_grav[geo.N_cv] = (gasBulk[geo.N_cv-1].d*geo.Delta_x[geo.N_cv-1] + gasBulk[geo.N_cv].d*geo.Delta_x[geo.N_cv])/(geo.Delta_x[geo.N_cv-1] + geo.Delta_x[geo.N_cv])*g_n*(geo.z[geo.N_cv] - geo.z[geo.N_cv-1]);
    else
      Delta_p_grav[geo.N_cv+1] = 0;
      Delta_p_grav[geo.N_cv] = (gasBulk[geo.N_cv-1].d*geo.Delta_x[geo.N_cv-1]/2 + gasBulk[geo.N_cv].d*geo.Delta_x[geo.N_cv])/(geo.Delta_x[geo.N_cv-1]/2+geo.Delta_x[geo.N_cv])*g_n*(geo.z_out - geo.z[geo.N_cv-1]);
    end if;
  end if;

//-------------------------------------------
//Enthalpy  flows

  for i in 2:geo.N_cv loop
    H_flow[i] = if useHomotopy then homotopy(semiLinear(m_flow[i], h[i-1], h[i]), h[i-1]*m_flow_nom) else semiLinear(m_flow[i], h[i-1], h[i]);
  end for;
  H_flow[1] =if useHomotopy then homotopy(semiLinear(
    m_flow[1],
    inStream(gasPortIn.h_outflow),
    h[1]), inStream(gasPortIn.h_outflow)*m_flow_nom) else semiLinear(
    m_flow[1],
    inStream(gasPortIn.h_outflow),
    h[1]);
  H_flow[geo.N_cv+1]=if useHomotopy then homotopy(semiLinear(
    m_flow[geo.N_cv + 1],
    h[geo.N_cv],
    inStream(gasPortOut.h_outflow)), h[geo.N_cv]*m_flow_nom) else semiLinear(
    m_flow[geo.N_cv + 1],
    h[geo.N_cv],
    inStream(gasPortOut.h_outflow));

//-------------------------------------------
//Fluid mass in cells
  mass =if useHomotopy then homotopy(geo.volume .* gasBulk.d, geo.volume .* rho_nom) else geo.volume .* gasBulk.d;

//-------------------------------------------

 //-------------------------------------------
  // definition of the cells' states:
  for i in 1:geo.N_cv loop

    der(h[i]) = (H_flow[i] - H_flow[i + 1] + heat[i].Q_flow + der(p[i])*geo.volume[i] - h[i]*geo.volume[i]*drhodt[i])/mass[i];
    der(xi[i, :]) = 1/mass[i]*((Xi_flow[i, :] -  m_flow[i]*xi[i, :]) - (Xi_flow[i + 1, :] - m_flow[i+1]*xi[i, :])) "Component mass balance";
    drhodt[i]*geo.volume[i] = m_flow[i] - m_flow[i + 1] "Mass balance";
    gasBulk[i].drhodp_hxi*der(p[i]) = (drhodt[i] - der(h[i])*gasBulk[i].drhodh_pxi- sum({gasBulk[i].drhodxi_ph[j]*der(xi[i, j]) for j in 1:medium.nc - 1})) "Calculate pressure from enthalpy and density derivative";

  end for;


//-------------------------------------------
  // Static momentum balance:
  // notice that for a static momentum balance we need to apply the same balance as homotopy start equation. Otherwise the equations become trivial.
  // For now we leave the homotopy inside for future development

  for i in 2:geo.N_cv loop
    0 =if useHomotopy then homotopy(p[i-1] - p[i] - Delta_p_fric[i] -Delta_p_grav[i],p[i-1] - p[i] - Delta_p_fric[i] -Delta_p_grav[i]) else p[i-1] - p[i]- Delta_p_fric[i] -Delta_p_grav[i];
end for;
  gasPortIn.h_outflow = h[1];
  gasPortOut.h_outflow = h[geo.N_cv];

//enable / disable pressure losses due to friction for flows  inlet --> first cell / last cell --> outlet
if not frictionAtInlet and not frictionAtOutlet then //no friction pressure loss inlet->first cell / no friction pressure loss last cell->outlet
    gasPortIn.p = gasBulk[1].p + Delta_p_grav[1];
    gasPortOut.p = gasBulk[geo.N_cv].p - Delta_p_grav[geo.N_cv + 1];

elseif frictionAtInlet and not frictionAtOutlet then //friction pressure loss inlet->first cell / no friction pressure loss last cell->outlet
  0 =if useHomotopy then homotopy(gasPortIn.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1], gasPortIn.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1]) else gasPortIn.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1];
    gasPortOut.p = gasBulk[geo.N_cv].p - Delta_p_grav[geo.N_cv + 1];

elseif  not frictionAtInlet and frictionAtOutlet then//"no friction pressure loss inlet->first cell / friction pressure loss last cell->outlet"
  0 =if useHomotopy then homotopy(p[geo.N_cv] - gasPortOut.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1], p[geo.N_cv] - gasPortOut.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1]) else p[geo.N_cv] - gasPortOut.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1];
    gasPortIn.p = gasBulk[1].p + Delta_p_grav[1];

else //friction pressure loss inlet->first cell / friction pressure loss last cell->outlet
  0 =if useHomotopy then homotopy(gasPortIn.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1], gasPortIn.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1]) else gasPortIn.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1];
  0 =if useHomotopy then homotopy(p[geo.N_cv] - gasPortOut.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1], p[geo.N_cv] - gasPortOut.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1]) else p[geo.N_cv] - gasPortOut.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1];

end if;

//-------------------------------------------

 //species balance from Clara 1.2.2

   for i in 2:geo.N_cv loop
     Xi_flow[i, :] = if useHomotopy then homotopy(semiLinear(
       m_flow[i],
       (xi[i - 1, :]),
       (xi[i, :])), (xi[i - 1, :])*m_flow_nom) else semiLinear(
       m_flow[i],
       (xi[i - 1, :]),
       (xi[i, :]));
   end for;
   Xi_flow[1, :] = if useHomotopy then homotopy(semiLinear(
     m_flow[1],
     (gasIn.xi[:]),
     (xi[1, :])), (gasIn.xi[:])*m_flow_nom) else semiLinear(
     m_flow[1],
     (gasIn.xi[:]),
     (xi[1, :]));
   Xi_flow[geo.N_cv + 1, :] = if useHomotopy then homotopy(semiLinear(
     m_flow[geo.N_cv + 1],
     (xi[geo.N_cv, :]),
     (gasOut.xi[:])), (xi[geo.N_cv, :])*m_flow_nom) else semiLinear(
     m_flow[geo.N_cv + 1],
     (xi[geo.N_cv, :]),
     (gasOut.xi[:]));
  gasPortIn.xi_outflow[:] = xi[1, :];
   gasPortOut.xi_outflow[:] = xi[geo.N_cv, :];

   xi_inlet = noEvent(actualStream(gasPortIn.xi_outflow));
  xi_outlet = noEvent(actualStream(gasPortOut.xi_outflow));


  annotation (defaultComponentName="volume",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-50},
            {140,50}}),
                   graphics),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-50},{140,50}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">A 1D tube-shaped control volume considering one-phase and two-phase heat transfer and Pressure Loss in a straight pipe with static momentum balance and simple energy balance</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L4, Discretisation of the pipe Length. Is able to use real gas mixtures (VLEFluids).</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Considers the time delay of the change of the mass fraction from inlet to outlet.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">-</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">RealGasPorts, HeatPort</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">-</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>Velocities at in or outlet:</p>
<p><img src=\"modelica://IntegraNet/Resources/Images/equations/equation-RfVBDpsE.png\" alt=\"w[inlet,outlet] = m_flow/(A_cross_FM * rho[inlet, outlet])\"/></p>
<p><br>Velocity in discretized cell i:</p>
<p><img src=\"modelica://IntegraNet/Resources/Images/equations/equation-DIAUw8b4.png\" alt=\"w_i = (m_flow[i] +m_flow[i+1])/(2 * A_cross * rho_i)\"/></p>
<p><br>Massflow:</p>
<p>m_flow = f(model PressureLoss)</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>-</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>-</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>Based on the model VolumeRealGas_L4_varXi from TransiEnt 1.0.0, which is based on ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L4 (ClaRa Library 1.2.1).</p>
<p>Balance&nbsp;equations&nbsp;for&nbsp;mass&nbsp;fractions&nbsp;of&nbsp;gas&nbsp;components&nbsp;were&nbsp;copied&nbsp;from&nbsp;the&nbsp;ClaRa&nbsp;release&nbsp;1.2.2</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Michael Djukow, GWI Essen e.V., 2017</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified and revised by Annika Heyer, GWI Essen e.V., Jan 2021 (changes due to newer version of TILMedia library)</span></p>
</html>"));
end VolumeRealGas_L4_varXi;

