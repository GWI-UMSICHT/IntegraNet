within IntegraNet.Components.Sensors.RealGas;
model Sensor
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


  // Sensor model, which calculates different gas properties and returns them as output of type real
  // Equations are taken from exisiting sensors (CompositionSensor, WobbeGCVSensor, NCVSensor) in the
  // TransiEnt library and are grouped into the sensor model at hand

outer IntegraNet.SimCenter simCenter;
 // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  import TransiEnt;
  extends TransiEnt.Components.Sensors.RealGas.Base.RealGas_SensorBase;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________
  constant Modelica.SIunits.Density rho_air_stp=1.2931 "Density of ambient air at T=273.15 K, p=1 bar";
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter SI.MassFraction xi_start[medium.nc-1]= medium.xi_default "Initial composition";
   parameter Modelica.SIunits.VolumeFraction phi_H2max = 0.3 "Maximum admissible volume fraction of H2 in NGH2 at STP";

 constant SI.Pressure p_stp = 1.01325e5 "Standard pressure";
  constant SI.Temperature T_stp = 273.15 "Standard temperature";
  SI.Density rho_H2_stp=H2.d "Density of hydrogen at STP";
  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  //  SI.EnergyDensity GCV_stp "Gross calorific value in J/m3 at STP";
  SI.MassFraction[medium.nc-1] xi(start=xi_start) "Mass fraction vector";
  Real d_stp "Relative density of NG at STP";
  SI.Density d_NG " density of NG ";
  SI.MassFlowRate m_flow_NG "Mass flow of NG";
SI.MassFraction xi_H2inNG "Mass fraction of H2 in NG";
 SI.VolumeFlowRate V_flow_H2_NG_stp( start = 0) "Volume flow rate of H2 in NG at STP";
  SI.VolumeFlowRate V_flow_NG_stp "Volume flow rate of NG at STP";
 SI.VolumeFlowRate V_flow_H2_PtG_max_stp "Maximum admissible PtG volume flow rate at STP";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

   Modelica.Blocks.Interfaces.RealOutput NCV(
  final quantity="SpecificEnthalpy",
  displayUnit="kWh/kg",
  final unit = "J/kg")
    "Net calorific value for given composition"  annotation (Placement(transformation(extent={{100,-60},
            {120,-40}})));

    Modelica.Blocks.Interfaces.RealOutput fraction_mass[medium.nc](
    final quantity="MassFraction",
    final unit="kg/kg") "Fraction (mass) in port"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,
        origin={-110,0})));

 Modelica.Blocks.Interfaces.RealOutput fraction_mole[medium.nc](
    final quantity="MassFraction",
    final unit="mol/mol") "Fraction (mole) in port"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=180,
        origin={-110,-38})));

 Modelica.Blocks.Interfaces.RealOutput phi_H2_stp( final unit="m3/m3")  "Volume fraction of H2 in NG at STP"
 annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-110,54})));

  Modelica.Blocks.Interfaces.RealOutput W_S_stp(
     final quantity="EnergyDensity",
    final unit="J/m3") "Wobbe Index of composition at STP" annotation (Placement(transformation(extent={{10,-10},
            {-10,10}},
        rotation=180,
        origin={110,0})));

  Modelica.Blocks.Interfaces.RealOutput GCV(
     final quantity="SpecificEnthalpy",
     displayUnit="kWh/kg",
     final unit = "J/kg") "Gross calorific value" annotation (Placement(transformation(extent={{-10,-10},
            {10,10}},
        rotation=0,
        origin={110,44})));

output Modelica.Blocks.Interfaces.RealOutput m_flow_H2_max(
    final quantity="mass flow",
    displayUnit="kg/s",
    final unit="kg/s") "Maximum admissible hydrogen production rate" annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,90})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
protected
    TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT
                         NG_stp(
     xi = xi,
     vleFluidType=medium,
     computeSurfaceTension=false,
     deactivateTwoPhaseRegion=true,
    p=p_stp,
    T=T_stp)                      annotation (Placement(transformation(extent={{-10,-26},{10,-6}})));

protected
 TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph
                      NG(
    vleFluidType=medium,
    p = gasPortIn.p,
    h = actualStream(gasPortIn.h_outflow),
    xi = actualStream(gasPortIn.xi_outflow),
    computeSurfaceTension=false,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,22},{10,42}})));

 TransiEnt.Basics.Media.RealGasGCV_xi realGasGCV_xi(realGasType=medium, xi_in=xi);
 TransiEnt.Basics.Media.RealGasNCV_xi realGasNCV_xi(realGasType=medium, xi_in=xi);

protected
    TILMedia.VLEFluid_pT H2(
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2 vleFluidType,
    computeSurfaceTension=false,
    deactivateTwoPhaseRegion=true,
    p=p_stp,
    T=T_stp) annotation (Placement(transformation(extent={{-10,-74},{10,-54}})));
equation

  // Mass fractions of gas components
  xi = actualStream(gasPortIn.xi_outflow);

  // NCV
 NCV = realGasNCV_xi.NCV;

  // Wobbe Index and GCV

  d_stp = NG_stp.d/rho_air_stp;
  GCV = realGasGCV_xi.GCV;
  W_S_stp = NG_stp.d*GCV / sqrt(d_stp);
 // GCV_stp = NG_stp.d*GCV;

 // Component fractions

  fraction_mass[1:medium.nc-1] = {NG.xi[i] for i in 1:medium.nc-1};
  fraction_mass[medium.nc] = 1-sum(NG.xi[i] for i in 1:medium.nc-1);

   fraction_mole[1:medium.nc-1] = {NG.x[i] for i in 1:medium.nc-1};
  fraction_mole[medium.nc] = 1-sum(NG.x[i] for i in 1:medium.nc-1);

// Volume fraction H2 in NG at STP

 m_flow_NG = gasPortIn.m_flow;

 xi_H2inNG =(1.0 - sum(NG_stp.xi));
  V_flow_NG_stp =m_flow_NG/NG_stp.d;
  V_flow_H2_NG_stp = xi_H2inNG * m_flow_NG / rho_H2_stp;


if noEvent(abs(V_flow_NG_stp)> Modelica.Constants.eps) then
  phi_H2_stp=V_flow_H2_NG_stp / V_flow_NG_stp;
else
  phi_H2_stp=V_flow_H2_NG_stp/Modelica.Constants.eps;
end if;


// Admissible mass flow of H2 considering phi_H2max
V_flow_H2_PtG_max_stp = (phi_H2max * V_flow_NG_stp - V_flow_H2_NG_stp)/(1-phi_H2max);
m_flow_H2_max = V_flow_H2_PtG_max_stp * rho_H2_stp;

// Density of gas at given conditions
d_NG = NG.d;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                   graphics={
       Polygon(
         points={{-20,40},{-20,40},{-62,40},{-86,0},{-62,-40},{-20,-40},{20,-40},{62,-40},{86,0},{62,40},{20,40},{-20,40}},
         lineColor={27,36,42},
         smooth=Smooth.Bezier,
         lineThickness=0.5),
       Line(
         points={{0,-40},{0,-100}},
         color={27,36,42},
         thickness=0.5,
         smooth=Smooth.None),
       Text(
         extent={{-100,24},{100,-16}},
         fillColor={0,255,0},
         fillPattern=FillPattern.Solid,
          textString="%name",
          lineColor={0,0,0}),
       Line(
         points={{0,30},{-3.06156e-015,10}},
         color={27,36,42},
          origin={110,0},
          rotation=90),
        Line(points={{-92,-100},{92,-100}}, color={255,255,0},
          thickness=1),
        Line(points={{-56,-48}}, color={28,108,200})}),
       Line(
         points={{-96,-100},{98,-100}},
         color={255,255,0},
         thickness=0.5),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Sensor model calculating the gross Wobbe index, gross calorific value, net calorific value sensor, composition (mass and mole) and the volume fraction of H2 in NG at STP for VLEFluidTypes. Additionally the maximum admissible H2 mass flow feed-in for a given maximum volume fraction is calculated.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>-</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Can only be used for VLEFluidTypes.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>GasPortIn, GasPortOut and RealOutputs for Wobbe index, GCV, NCV, mass and mole fraction, volume fraction of H2 in NG and maximum admissible H2 mass flow.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p>Gross Wobbe index (W_S_stp) in J/m3 stp</p>
<p>GCV in J/kg</p>
<p>NCV in J/kg</p>
<p>Volume fraction of H2 at stp (phi_H2_stp) in m3/m3</p>
<p>Maximum H2 mass flow (m_flow_H2_max) in kg/s</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>W_S_stp = GCV*rho_stp/sqrt(rho_stp/rho_air_stp)</p>
<p>GCV = sum(xi_i*GCV_i)</p>
<p>NCV = sum(xi_i*NCV_i)</p>
<p>phi_H2_stp = xi_H2_stp*rho_stp/rho_H2_stp</p>
<p>V_flow_H2_max = (phi_H2_max * m_flow/rho_stp - m_flow_H2/rho_H2_stp)/(1-phi_H2_max)</p>
<p>m_flow_H2_max = V_flow_H2_max/rho_H2_stp</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>Gross and net calorific values of the pure components are defined in the records TransiEnt.Basics.Records.GasProperties.GrossCalorificValues and TransiEnt.Basics.Records.GasProperties.NetCalorificValues.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>Based on the following models from TransiEnt 1.1.0:</p>
<p>TransiEnt.Components.Sensors.RealGas.WobbeGCVSensor</p>
<p>TransiEnt.Components.Sensors.RealGas.NCVSensor</p>
<p>TransiEnt.Components.Sensors.RealGas.ConpositionSensor</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created during IntegraNet by Michael Djukow, GWI Essen e.V., 2017.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Annika Heyer (GWI Essen e.V.), June 2020</span></p>
</html>"));
end Sensor;

