within IntegraNet.Storage.Heat.HeatStorageStratified_constProp;
model StratifiedHotWaterStorage_L3_noFluidPorts "Model of one dimensional hot water storage, constant media properties"
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
// This component is a modification of model StratifiedHotWaterStorage_L4 from     //
// TransiEnt Library, version: 1.0.0                                               //
//

  //Modification to TransiEnt model:
  // - heatPorts instead of fluid ports
  // - variable volume of each of the segments

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.ThermalStorageBasic;

  import SI = Modelica.SIunits;
  // _____________________________________________
  //
  //                Outer models
  // _____________________________________________

  outer IntegraNet.SimCenter simCenter;
   outer TransiEnt.ModelStatistics modelStatistics;
   outer IntegraNet.Statistics.Statistics_collector statistics_collector;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1 "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fluid Definition"));

  parameter Integer N_cv(min=3)=3 "Number of finite control volumes" annotation(HideResult=true);

  parameter SI.Volume Volume_segments[N_cv]={0.2*3,0.5*3,0.3*3} annotation(HideResult=true);

  // geometry

  parameter SI.Volume V = 1e3 "Volume of tank" annotation(Dialog(group="Geometry"));
  parameter SI.Length h = 1 "height of tank" annotation(Dialog(group="Geometry"));

  parameter SI.CoefficientOfHeatTransfer U_wall = 0.5 "Coefficient of heat transfer from wall to ambient " annotation(Dialog(group="Thermodynamics"));
  parameter SI.CoefficientOfHeatTransfer U_top = U_wall "Coefficient of heat transfer from top to ambient " annotation(Dialog(group="Thermodynamics"));
  parameter SI.CoefficientOfHeatTransfer U_bottom = U_wall "Coefficient of heat transfer from bottom to ambient " annotation(Dialog(group="Thermodynamics"));
  parameter SI.ThermalConductivity k = 0.6 "Thermal conductivity of fluid in storage" annotation(Dialog(group="Thermodynamics"));
  parameter SI.Density rho = 1e3 "Density of fluid in storage" annotation(Dialog(group="Thermodynamics"),HideResult=true);
  parameter SI.SpecificHeatCapacity c_v = 4.185e3 "Heat capacity of fluid in storage" annotation(Dialog(group="Thermodynamics"),HideResult=true);
  parameter SI.Temperature[N_cv] T_start=fill(273.15+60, N_cv) "Time constant of buoyancy model" annotation(HideResult=true);
  parameter SI.Temperature T_max_ref = 90+273.15 "Maximum reference temperature (SOC=1)" annotation(HideResult=true);
  parameter SI.Temperature T_min_ref = 30+273.15 "Minimm reference temperature (SOC=0)" annotation(HideResult=true);
  parameter SI.Time tau_buoyancy = 1 "Time constant of buoyancy model" annotation(HideResult=true);

   replaceable model CostStatisticsModel =
       TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.SmallHotWaterStorage constrainedby TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.PartialStorageCostSpecs
    "Model for global cost calculation" annotation (choicesAllMatching=true, Dialog(group="Statistics"));

  // _____________________________________________
  //
  //               Final Parameters
  // _____________________________________________

  final parameter SI.Length dx = h/N_cv "Height of finite volumes" annotation(HideResult=true);
  final parameter SI.Mass m=V*rho annotation(HideResult=true);
  final parameter SI.ThermalConductance[N_cv] G = cat(1,{(A_wall/N_cv+A_top)*U_bottom}, fill(A_wall/N_cv*U_wall, N_cv-2), {(A_wall/N_cv+A_bottom)*U_top}) annotation(HideResult=true);
  final parameter SI.Area A_top=V/h "top tank area" annotation(Dialog(group="Geometry"));
  final parameter SI.Area A_bottom=A_top "bottom tank area" annotation(Dialog(group="Geometry"));
  final parameter SI.Area A_wall=Modelica.Constants.pi*d*h "outside tank area" annotation(Dialog(group="Geometry"));
  final parameter SI.Length d = sqrt(4*V/h/Modelica.Constants.pi) annotation(HideResult=true);

  final parameter Real G_diff = A_top*k/dx annotation(HideResult=true);

  // _____________________________________________
  //
  //                  Components
  // _____________________________________________

  Base.IncompressibleFluidVolume_noFluidPort[
                                 N_cv] controlVolume(
    each d=rho,
    each c_v=c_v,
    T_start=T_start,
    V=Volume_segments) annotation (Placement(transformation(extent={{-10,-6},{10,14}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[N_cv] condAmbient(G=G) "Thermal conductance through side wall of storage" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,56})));

   TransiEnt.Components.Statistics.Collectors.LocalCollectors.StorageCost collectStorageCosts(
     isThermalStorage=true,
     Delta_E_n=m*c_v*(T_max_ref - T_min_ref),
     redeclare model StorageCostModel = CostStatisticsModel,
     Q_flow_is=max(0,port[1].Q_flow)+max(0,port[2].Q_flow)+max(0,port[3].Q_flow)+Q_flow_loss2amb) annotation (Placement(transformation(extent={{40,-100},{60,-80}})));


  TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Base.Buoyancy    buoyancy(
    V=V,
    N_cv=N_cv,
    tau=tau_buoyancy,
    rho=rho,
    c_v=c_v) "Models buoyancy in tank columes" annotation (Placement(transformation(extent={{16,21},{36,41}})));
  TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Base.Diffusion    diffusion(
    A=A_top,
    N_cv=N_cv,
    dx=dx,
    k=k) annotation (Placement(transformation(extent={{-26,22},{-46,42}})));
     Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(final m=N_cv) "Collects the thermal lossen from top, sidewall and bottom"
          annotation (Placement(transformation(
         extent={{-8,-8},{8,8}},
         rotation=180,
         origin={0,82})));
  // _____________________________________________
  //
  //                  Variables
  // _____________________________________________

  SI.Temperature T_mean = sum(controlVolume.T)/N_cv;
  Real SOC = (T_mean-T_min_ref)/(T_max_ref - T_min_ref);
  SI.Energy E = (sum(controlVolume.T)-T_min_ref)*c_v*m/N_cv;
  SI.HeatFlowRate Q_flow_loss2amb = -heatPortAmbient.Q_flow;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________



  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortAmbient "Heat port connecting control volumes with ambient temperature to model energy losses (connect ambient temperature)"
                                                                                                    annotation (Placement(transformation(extent={{-12,88},{12,112}}), iconTransformation(extent={{-10,75},{10,95}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port[N_cv] "Heat port connecting control volumes with ambient temperature to model energy losses (connect ambient temperature)" annotation (Placement(transformation(extent={{90,78},{114,102}}), iconTransformation(extent={{82,53},{102,73}})));

  Statistics.LocalCollector E_Storage_output(typeOfResource=IntegraNet.Statistics.TypeOfResource.q_LoadStatus_Storage) annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Statistics.LocalCollector loss_storage(typeOfResource=IntegraNet.Statistics.TypeOfResource.Heat_loss_Storage) annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
equation

  // _____________________________________________
  //
  //           Equations
  // _____________________________________________

  // ======== Heat port connections ===========

  // buoyancy model to control volume
  connect(buoyancy.heatPort, controlVolume.heatPort) annotation (Line(points={{15.8,31.4},{15.8,29.4},{0,29.4},{0,13.6}},
                                                                                                                        color={191,0,0}));

  // heat loss: control volume to conductor
  connect(controlVolume.heatPort, condAmbient.port_a) annotation (Line(points={{0,13.6},{0,20},{-6.66134e-016,20},{-6.66134e-016,46}}, color={191,0,0}));

  // heat loss: conductor to ambient

  // heat diffusion between elements
  connect(diffusion.heatPort, controlVolume.heatPort) annotation (Line(points={{-25.8,32.4},{0,32.4},{0,13.6}}, color={191,0,0}));

  loss_storage.flowCollector.unit_flow = -Q_flow_loss2amb;
  connect(loss_storage.flowCollector, statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.Heat_loss_Storage]);



  E_Storage_output.flowCollector.unit_flow = der(E);
   connect(E_Storage_output.flowCollector, statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.q_LoadStatus_Storage]);


  // ======== Statistics =====
   connect(modelStatistics.costsCollector, collectStorageCosts.costsCollector);



   connect(thermalCollector.port_b, heatPortAmbient) annotation (Line(points={{0,90},{0,100}}, color={191,0,0}));
   connect(thermalCollector.port_a, condAmbient.port_b) annotation (Line(points={{0,74},{0,66}}, color={191,0,0}));


  for i in 1:N_cv loop
  connect(controlVolume[i].heatPort, port[i]) annotation (Line(points={{0,13.6},
            {54,13.6},{54,90},{102,90}},                                                                     color={191,0,0}));
  end for;

// _____________________________________________
//
//               Documentation
// _____________________________________________

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b> </p>
<p>One dimensional fluid storage model with stratification. Intention of the model is to represent a hot water storage in a bigger system with more accurate outflow temperatures compared to a zero dimensional storage model. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L3: Storage is diveded in layered volumes. Each volume is ideally stirred. Between the fluid volumes heat conduction, heat diffusion, heat losses and boyancy are considered. </p>
<p>Heat losses to the ambient are simplified as heat conduction through top, side wall and bottom. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>- The storage model includes just a vertical temperature distribution. No horizontal temperature distribution is modeled. Mixing effects due to the velocity of the fluid at inlets an outlets are not modelled. </p>
<p>- Losses to the ambient are modeled as linear dependent from temperature difference (no radiation or convection modeled)</p>
<p>- Thermodynamic properties of fluid are constant (no temperature dependency modeled)</p>
<p>- No pressure losses or levels modeled</p>
<p>- No change of gaseous state modeled</p>
<p>- Geometry is cylindric </p>
<p>- four fluid port locations with individual heigths </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<h5>Heat</h5>
<p>heatLosses: ambient temperature and the collected heat flow to the ambient through top, side wall and bottom</p>
<p>heat input/output: heat ports ports[] connecting to each of the layers</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p><br>Just parameters and of the main model are described. Further explanations are in the sub models. </p>
<p><br>nSeg: number of vertical layered fluid segments</p>
<p><br>T_max: maximum allowed temperatur inside the storage</p>
<p><br>T_min: minimum allowed temperatur inside the storage</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Energy and mass or volume balance inside every volume segment. Heat losses due to one dimensional thermal conductance through top, bottom and side wall. Thermal conductance between volume segments. Modeled boyancy introducing heat flow from lower to higher segment if the lower segemnt has a higher temperature. Direct fluid connection between the volumes. </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>No fluid flow into or out of the storage tank is modeled. Instead, heat input into each of the segments is specified via a heat port. For demonstration of usage in combination with a solar heating system see IntegraNet.Producer.Heat.SolarThermal.Check.TestSolarThermalSystem.</p>
<p>The allowed minimum number of volume segements is two. The higher the number of segments the higher the number of equations. </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p><br>The model orginial model TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.HotWaterStorage_constProp_L4 was validated with measured data from a storage tank. See model documentation for details.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Modification of model TransiEnt.Storage.Heat.HeatStorageStratified_constProp.StratifiedHotWaterStorage_L3 from TransiEnt 1.0.0 by Anne Hagemeier, Fraunhofer UMSICHT in 2017</p>
</html>"));
end StratifiedHotWaterStorage_L3_noFluidPorts;

