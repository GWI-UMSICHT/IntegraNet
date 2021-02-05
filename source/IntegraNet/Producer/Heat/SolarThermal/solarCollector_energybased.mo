within IntegraNet.Producer.Heat.SolarThermal;
model solarCollector_energybased "modified TransiEnt-model without fluid flow"
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
// This component is a modification of model SolarCollector_L1                     //
// from TransiEnt Library, version: 1.0.0                                          //
//

// Changes to TransiEnt model:
// - removal of fluid ports, energy-based calculation

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import Const = Modelica.Constants;
  import SI = Modelica.SIunits;
  extends TransiEnt.Basics.Icons.SolarThermalCollector;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer IntegraNet.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;
  inner TransiEnt.Producer.Heat.SolarThermal.Base.IrradianceOnATiltedSurface irradiance(redeclare model Skymodel = Skymodel) annotation (Placement(transformation(extent={{-68,-60},{-36,-32}})));

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  //Basics
 // parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 annotation (Dialog(tab="General", group="General"));
  parameter Boolean useHomotopy=simCenter.useHomotopy "true =  homotopy method is used during initialisation" annotation (Dialog(tab="General", group="General"),HideResult=true);
  parameter SI.HeatFlowRate Q_flow_n "Nominal heat flow rate (for cost calculation)" annotation (Dialog(tab="General", group="General"),HideResult=true);
  parameter SI.Area area "Aperture area" annotation (Dialog(tab="General", group="General"));
  parameter Real eta_0 "Zero-loss collector efficiency" annotation (Dialog(group="Coefficients for thermal performance"));
  parameter Real a1(unit="W/(m2.K)") "Heat loss coefficient at (T_m - T_amb) = 0" annotation (Dialog(group="Coefficients for thermal performance"));
  parameter Real a2(unit="W/(m2.K2)") "Temperature dependent heat loss coefficient" annotation (Dialog(group="Coefficients for thermal performance"));
  parameter Real c_eff(unit="J/(m2.K)") "Effective thermal capacity of the collector" annotation (Dialog(tab="General", group="General"),HideResult=true);
  parameter SI.Irradiance G_min=0 "Minimum Irradiance before collector is working" annotation (Dialog(tab="General", group="General"));
  parameter Boolean noFriction=true "true = assume no pressure loss due to friction" annotation(Dialog(group="Pressure drop"),HideResult=true);

  //Pressure loss
  parameter Integer n_serial(max=12)=1 "Number of collectors in series (max. 12)" annotation (Dialog(group="Pressure drop"),HideResult=true);
  parameter Real a(unit="1/(s.m)")=0 "Linear pressure drop coefficient" annotation (Dialog(group="Pressure drop"),HideResult=true);
  parameter Real b(unit="1/(kg.m)")=0 "Quadratic pressure drop coefficient" annotation (Dialog(group="Pressure drop"),HideResult=true);
  parameter SI.Height z1=0 "Height inlet" annotation (Dialog(group="Pressure drop"),HideResult=true);
  parameter SI.Height z2=0 "Height outlet"  annotation (Dialog(group="Pressure drop"),HideResult=true);

  //Parameters for SolarTime
// parameter Real[4] offset(unit={"d","h","m","s"})={0,0,0,0} annotation (Dialog(tab="Irradiance", group="Solartime")); //(NOT USEABLE) day/hour/month/second; Offset=[0,0,0,0] at t=0 equals 1.1. 00:00:00
  parameter SI.Angle longitude_local=SI.Conversions.from_deg(10) "longitude of the local position, east positive, 10 East for Hamburg" annotation (Dialog(tab="Irradiance", group="Solartime"),HideResult=true);
  parameter SI.Angle longitude_standard=SI.Conversions.from_deg(15) "needed for calculation of coordinated universal time (utc), 15 for central european time, 30 for central european summer time" annotation (Dialog(tab="Irradiance", group="Solartime"),HideResult=true);
  SI.Conversions.NonSIunits.Time_day totaldays=365 "total days of the year, standard=365, leap year=366" annotation (Dialog(tab="Irradiance", group="Solartime"),HideResult=true);

  //Parameters for ExtraterrestrialIrradiance
  parameter SI.Angle latitude=SI.Conversions.from_deg(53.55) "latitude of the local position, north posiive, 53,55 North for Hamburg" annotation (Dialog(tab="Irradiance", group="Extraterrestrial Irradiance"),HideResult=true);
  parameter SI.Angle slope=SI.Conversions.from_deg(53.55) "slope of the tilted surface, assumption"  annotation (Dialog(tab="Irradiance", group="Extraterrestrial Irradiance"),HideResult=true);
  parameter SI.Angle surfaceAzimuthAngle=0 "surface azimuth angle" annotation (Dialog(tab="Irradiance", group="Extraterrestrial Irradiance"),HideResult=true);

  //Skymodel
  replaceable model Skymodel=TransiEnt.Producer.Heat.SolarThermal.Base.SkymodelBase (
      longitude_local=longitude_local,
      longitude_standard=longitude_standard,
      latitude=latitude,
      slope=slope,
      surfaceAzimuthAngle=surfaceAzimuthAngle,
      reflectance_ground=reflectance_ground,
      direct_normal=direct_normal,
      totaldays=totaldays) "choose between HDKR and isotropic sky model" annotation (choicesAllMatching=true, Dialog(tab="Irradiance", group="Skymodel"));
  parameter Real reflectance_ground=0.2 "reflectance of the ground" annotation (Dialog(tab="Irradiance", group="Skymodel"),HideResult=true);
  parameter Boolean direct_normal=true "Is the direct irradiance measured on a surface normal to irradiance?" annotation (Dialog(tab="Irradiance", group="Skymodel"),HideResult=true);

  //Parameters for IAM
  parameter Integer kind(min=1, max=3)=1 "different ways to determine the IAM's; 1: constant IAM (assumption) 2: IAM as a function of b0, 3: IAM by interpolation of record" annotation (Dialog(tab="IAM", group="General"),HideResult=true);
  parameter Real constant_iam_dir=1 "constant IAM for direct irradiation" annotation (Dialog(tab="IAM", group="General"),HideResult=true);
  parameter Real constant_iam_diff=1 "constant IAM for diffuse irradiation" annotation (Dialog(tab="IAM", group="General"),HideResult=true);
  parameter Real constant_iam_ground=1 "constant IAM for ground-reflected irradiation" annotation (Dialog(tab="IAM", group="General"),HideResult=true);
  parameter Real b0=1 "assumption: constant b0-value for IAM=1-b0*(1/cos(theta)-1)" annotation (Dialog(tab="IAM", group="General"),HideResult=true);
  parameter Real[8] iam_SRCC={1,1,1,1,1,1,1,1} "IAM for theta = 0, 10, 20, ..., 70" annotation (Dialog(tab="IAM", group="General"),HideResult=true);
  parameter SI.Conversions.NonSIunits.Angle_deg[8] theta={0,10,20,30,40,50,60,70} annotation (Dialog(tab="IAM", group="General"),HideResult=true);

  //Statistics
   replaceable model CostRecordSolarThermal =
       TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.SolarThermal
     constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs
                                                                                          "|Statistics|Cost specification" annotation (choicesAllMatching=true);

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Temperature T_amb=simCenter.T_amb_var+273.15 "Ambient temperature in K";
  SI.Temperature T_m "Average temperature of the medium";
//   SI.TemperatureSlope der_T "Derivative of T_m";
//   Real x;
  SI.Irradiance G_total "Total irradiance";
  SI.HeatFlowRate Q_flow_collector "Heat flow provided by solar collector";


  SI.HeatFlowRate Q_flow_out "Generated heat (tranferred to fluid)";
  Real eta "Efficiency factor";


  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
public
  Modelica.Blocks.Interfaces.RealInput  T_in annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-76,88}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-76,88})));
  Modelica.Blocks.Interfaces.RealOutput T_out annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={62,86})));
  Modelica.Blocks.Interfaces.RealOutput G=G_total annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={88,86})));

          Modelica.Blocks.Interfaces.RealInput m_flow annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-98,86})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TransiEnt.Producer.Heat.SolarThermal.Base.IAM IAM(
    kind=kind,
    constant_iam_dir=constant_iam_dir,
    constant_iam_diff=constant_iam_diff,
    constant_iam_ground=constant_iam_ground,
    b0=b0,
    iam_SRCC=iam_SRCC,
    theta=theta) annotation (Placement(transformation(extent={{36,-58},{56,-38}})),HideResult=true);

   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Renewable) annotation (Placement(transformation(extent={{-60,100},{-40,80}})),HideResult=true);
   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts(
     der_E_n=Q_flow_n,
     E_n=0,
     redeclare model CostRecordGeneral = CostRecordSolarThermal (size1=area),
     Q_flow=Q_flow_out) annotation (Placement(transformation(
         extent={{-10,-10},{10,10}},
         rotation=180,
         origin={-10,90})),HideResult=true);
   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsHeat collectGwpEmissions(typeOfEnergyCarrierHeat=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.Solar) annotation (Placement(transformation(extent={{-40,100},{-20,80}})),HideResult=true);

   TransiEnt.Components.Statistics.Functions.GetFuelSpecificCO2Emissions fuelSpecificCO2Emissions(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Solar);

public
  Modelica.Blocks.Interfaces.RealOutput Q_flow=Q_flow_out
                                              annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-106,10})));
initial equation
//    x=T_m;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

//     if G_total >= G_min and m_flow > 0.001 then
//                                                      // if condition important to avoid jumps during turning on and off the plant. Caution! Take care that XY in waterIn.m_flow > XY (here 0.003) is smaller than the minimal mass flow rate specified by P_drive_min in the COntrollerModell. This means XY can vary.
//    der(x) = 100*(T_m - x);
//     der_T = 100*(T_m - x);
//   else
//     der_T=der(x);
//     der(x)=0;
//   end if;


  Q_flow_out=m_flow*4185*(T_out-T_in);

  Q_flow_out=if noEvent(G_total > G_min) then -Q_flow_collector else 0;

  T_m = 0.5*(T_in+T_out);

  G_total =IAM.iam_dir*irradiance.irradiance_direct_tilted + IAM.iam_diff*irradiance.irradiance_diffuse_tilted + IAM.iam_ground*irradiance.irradiance_ground_tilted;

  Q_flow_collector = area*((G_total*eta_0)-a1*(T_m-T_amb)-a2*(T_m-T_amb)^2);//-c_eff*der(T_m));


  if noEvent(abs(SI.Conversions.to_deg(irradiance.angle_direct_tilted)) <=90) then
    eta=min(1, max(0, Q_flow_collector/max(Const.small, ((area*(irradiance.irradiance_direct_tilted+irradiance.irradiance_diffuse_tilted+irradiance.irradiance_ground_tilted))))));
  else
    eta=0;
  end if;

 // Statistics
 // Heating power Q_flow has to be negative
  collectHeatingPower.heatFlowCollector.Q_flow= Q_flow_out;
 // Emissions
  collectGwpEmissions.gwpCollector.m_flow_cde=fuelSpecificCO2Emissions.m_flow_CDE_per_Energy*Q_flow_collector;

  connect(modelStatistics.costsCollector, collectCosts.costsCollector);
  connect(modelStatistics.heatFlowCollector[TransiEnt.Basics.Types.TypeOfResource.Renewable],collectHeatingPower.heatFlowCollector);
  connect(modelStatistics.gwpCollectorHeat[TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Solar],collectGwpEmissions.gwpCollector);
  annotation (Dialog(tab="Irradiance", group="Solartime"),
                                                 Placement(transformation(extent={{-10,16},{10,36}},  rotation=0)),
               choicesAllMatching, Dialog(group="Environment"),
              Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model provides thermal performance as described in EN 12975 for steady state.</p>
<p>A&nbsp;simple&nbsp;solar&nbsp;collector&nbsp;providing&nbsp;useful&nbsp;energy&nbsp;gain&nbsp;as&nbsp;recommended&nbsp;by&nbsp;EN&nbsp;12975&nbsp;steady&nbsp;state&nbsp;thermal&nbsp;performance&nbsp;equation</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical but parameter based model. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Without effective heat capacity only valid for steady state performance.</p>
<p>Model ignores wind speed.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>&nbsp;&nbsp;Modelica.Blocks.Interfaces.RealInput m_flow</p>
<p>&nbsp;&nbsp;Modelica.Blocks.Interfaces.RealInput&nbsp;T_in</p>
<p>&nbsp;&nbsp;Modelica.Blocks.Interfaces.RealOutput&nbsp;T_out</p>
<p>&nbsp;&nbsp;Modelica.Blocks.Interfaces.RealOutput G</p>
<p>&nbsp;&nbsp;Modelica.Blocks.Interfaces.RealOutput Q_flow</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-8097vOgT.png\" alt=\"

  Q= area*((G_total*eta_0)-a1*(T_m-T_amb)-a2*(T_m-T_amb)^2)

\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-KAbYMmch.png\" alt=\"G_total = iam*direct_irradiance.irradiance+IAM_diffuse*(diffuse_irradiance.irradiance+ground_reflected_irradiance.irradiance)\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-5hGbZvPy.png\" alt=\"    iam= if biaxial then iam_obj.value_longitudinal*iam_obj.value_transversal
  else
   iam_obj.value\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-knGUakuE.png\" alt=\" T_m=0.5*(T_in+T_out)\"/> </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Fluid flow models have been removed compared to the model from the TransiEnt library. Instead, m_flow and T_in are transmitted via input connectors.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>not validated yet</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model from TransiEnt 1.1.0 modified by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), Oct 2017</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end solarCollector_energybased;
