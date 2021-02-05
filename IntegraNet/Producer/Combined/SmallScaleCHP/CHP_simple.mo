within IntegraNet.Producer.Combined.SmallScaleCHP;
model CHP_simple "Simple, energy-based CHP unit with constant power output and constant efficiency"
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


  extends TransiEnt.Basics.Icons.CHP;

  outer IntegraNet.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

   //____________________________________________
   //
   //                      Parameters
   //____________________________________________

  parameter Modelica.SIunits.Power Q_CHP=4000 "Heat output of CHP";
  parameter Modelica.SIunits.Power P_CHP=8000 "Electric power output of CHP";

  final parameter Modelica.SIunits.Power Q_total_nom=Q_CHP+P_CHP;

  parameter Real eta_total=0.9  "Total efficiency of CHP as sum of thermal and electrical efficiency";

 // input Real CalorificValue(quantity="calorific Value", unit="J/kg")=40e6 annotation(Dialog(group="Parameters"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid  FuelMedium= simCenter.gasModel1 "|Fundamental definitions|Medium to be used for fuel gas";
  parameter Boolean referenceNCV = simCenter.referenceNCV "|Fundamental definitions|true, if heat calculations shall be in respect to NCV, false will give GCV";

  parameter TransiEnt.Basics.Types.TypeOfResource TypeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional "|Statistics|Type of resource";
  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat TypeOfEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas "|Statistics|Type of energy carrier";

   //____________________________________________
   //
   //                     Compontents
   //____________________________________________

  replaceable function AllocationMethod = TransiEnt.Components.Statistics.Functions.CO2Allocation.AllocationMethod_Efficiencies constrainedby TransiEnt.Components.Statistics.Functions.CO2Allocation.Basics.BasicAllocationMethod "Allocation method for CO2 emissions" annotation (Dialog(tab="General", group="Statistics"), choicesAllMatching=true);
  replaceable model CostRecordCHP = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.CHP_532kW constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs "Cost specification" annotation (Dialog(tab="General", group="Statistics"), choicesAllMatching=true);



   // ___________________________________________
   //
   //                   Interfaces
   // ___________________________________________

   Modelica.Blocks.Interfaces.BooleanInput OnOffSignal annotation (Placement(transformation(extent={{-112,-4},{-92,16}}), iconTransformation(extent={{-112,-4},{-92,16}})));

   TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_CHP_out annotation (Placement(
        transformation(extent={{92,-8},{120,20}}),  iconTransformation(extent={
            {106,60},{146,100}})));

   TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{92,-90},{110,-72}}), iconTransformation(extent={{92,-102},{132,-62}})));

   TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp annotation (Placement(transformation(extent={{90,-64},{110,-44}}), iconTransformation(extent={{86,-54},{136,-4}})));

  // ___________________________________________
  //
  //                   Variables
  // ___________________________________________

  Modelica.SIunits.Power Q_flow_fuel=(Q_CHP_out + calc_P_CHP_out.y)/eta_total;

  Modelica.SIunits.MassFlowRate m_flow_gas=(Q_CHP_out + calc_P_CHP_out.y)/eta_total/CalorificValue;

  SI.MassFlowRate m_flow_CDE[2];//=fuelSpecificCO2Emissions.m_flow_CDE_per_Energy*(Q_CHP_out + calc_P_CHP_out.y)/eta_total "|Fundamental definitions|CDE mass flow rate";

  SI.SpecificEnthalpy CalorificValue=if referenceNCV then TransiEnt.Basics.Functions.GasProperties.getRealGasNCV_xi(
      FuelMedium,
      xi_in=xi_fuel[1:FuelMedium.nc - 1],
      NCVIn=0) else TransiEnt.Basics.Functions.GasProperties.getRealGasGCV_xi(
      FuelMedium,
      xi_in=xi_fuel[1:FuelMedium.nc - 1],
      GCVIn=0) "Calorific value of fuel";

  SI.MassFraction xi_fuel[FuelMedium.nc] "[CH4, C2H6, C3H8, C4H10, N2, CO2, H2] Fuel gas mass fractions";



protected
     TransiEnt.Components.Statistics.Functions.GetFuelSpecificCO2Emissions fuelSpecificCO2Emissions(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Functions.getPrimaryEnergyCarrierFromHeat(TypeOfEnergyCarrier));


   // ___________________________________________
   //
   //                   Complex Components
   // ____________________________________________

public
   Modelica.Blocks.Logical.Switch switch annotation (Placement(transformation(
        extent={{9,-9},{-9,9}},
        rotation=180,
        origin={-29,5})));
   Modelica.Blocks.Sources.RealExpression one(y=1) annotation (Placement(transformation(extent={{-76,-30},{-56,-10}})));
   Modelica.Blocks.Sources.RealExpression zero(y=0)  annotation (Placement(transformation(extent={{-78,18},{-60,36}})));

   Modelica.Blocks.Sources.RealExpression massFlowGas(y=m_flow_gas)  annotation (Placement(transformation(
        extent={{-13,-9},{13,9}},
        rotation=0,
        origin={-3,-81})));

   TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow gas(variable_m_flow=true, medium=simCenter.gasModel1)    annotation (Placement(transformation(extent={{26,-90},{44,-72}})));
   TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower power(useInputConnectorQ=false, useCosPhi=false) annotation (Placement(transformation(extent={{68,-62},{52,-46}})));

  Modelica.Blocks.Math.Gain calc_Q_CHP_out(k=Q_CHP) annotation (Placement(transformation(extent={{20,22},{36,38}})));
  Modelica.Blocks.Math.Gain calc_P_CHP_out(k=P_CHP) annotation (Placement(transformation(extent={{20,-24},{36,-8}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(k=1, T=3) annotation (Placement(transformation(extent={{-12,-4},{6,14}})));

//   Statistics.Basics.LocalCollector CHP_collector(typeOfResource=IntegraNet.Statistics.TypeOfResource.el_output_CHP)
//                                                                                                           "Collects power supplied by CHP"        annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Math.Gain sign_change(k=-1) annotation (Placement(transformation(extent={{44,-24},{60,-8}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts(
    redeclare model CostRecordGeneral = CostRecordCHP,
    der_E_n=P_CHP,
    P_el=calc_P_CHP_out.y,
    Q_flow=Q_CHP_out,
    H_flow=Q_flow_fuel,
    m_flow_CDE=-m_flow_CDE[1] - m_flow_CDE[2],
    E_n=0,
    consumes_P_el=false,
    consumes_Q_flow=false,
    produces_H_flow=false,
    produces_other_flow=false,
    consumes_other_flow=false,
    consumes_m_flow_CDE=false) annotation (Placement(transformation(extent={{80,80},{100,100}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsHeat collectGwpEmissionsHeat(typeOfEnergyCarrierHeat=TypeOfEnergyCarrier) annotation (Placement(transformation(extent={{60,80},{80,100}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsElectric collectGwpEmissionsElectrical(typeOfEnergyCarrier=TypeOfEnergyCarrier) annotation (Placement(transformation(extent={{40,80},{60,100}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TypeOfResource) annotation (Placement(transformation(extent={{20,80},{40,100}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TypeOfResource) annotation (Placement(transformation(extent={{0,80},{20,100}})));
equation

 xi_fuel[1:FuelMedium.nc - 1] = inStream(gasPortIn.xi_outflow);
 xi_fuel[end] = 1-sum(xi_fuel[1:FuelMedium.nc - 1]);

   m_flow_CDE = AllocationMethod(
    m_flow_spec=fuelSpecificCO2Emissions.m_flow_CDE_per_Energy*(Q_CHP_out + calc_P_CHP_out.y)/eta_total,
    eta_el=Q_CHP/Q_total_nom*eta_total,
    eta_th=P_CHP/Q_total_nom*eta_total);


  collectGwpEmissionsElectrical.gwpCollector.m_flow_cde = -m_flow_CDE[1];
  collectGwpEmissionsHeat.gwpCollector.m_flow_cde = -m_flow_CDE[2];
  collectHeatingPower.heatFlowCollector.Q_flow=-Q_CHP_out;
  collectElectricPower.powerCollector.P =-calc_P_CHP_out.y;



 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________

  connect(modelStatistics.heatFlowCollector[TypeOfResource], collectHeatingPower.heatFlowCollector);
  connect(modelStatistics.powerCollector[TypeOfResource], collectElectricPower.powerCollector);
  connect(modelStatistics.gwpCollector[TypeOfEnergyCarrier], collectGwpEmissionsElectrical.gwpCollector);
  connect(modelStatistics.gwpCollectorHeat[TypeOfEnergyCarrier], collectGwpEmissionsHeat.gwpCollector);
  connect(modelStatistics.costsCollector, collectCosts.costsCollector);


  connect(OnOffSignal, switch.u2) annotation (Line(points={{-102,6},{-102,5},{
          -39.8,5}},                                                                   color={255,0,255}));
  connect(one.y, switch.u1) annotation (Line(points={{-55,-20},{-44,-20},{-44,
          -2.2},{-39.8,-2.2}},                                                                     color={0,0,127}));
  connect(zero.y, switch.u3) annotation (Line(points={{-59.1,27},{-48,27},{-48,
          12.2},{-39.8,12.2}},                                                              color={0,0,127}));
  connect(massFlowGas.y,gas. m_flow) annotation (Line(points={{11.3,-81},{14,-81},{14,-75.6},{24.2,-75.6}},
                                                                                                        color={0,0,127}));
  connect(gas.gasPort, gasPortIn) annotation (Line(
      points={{44,-81},{66,-81},{101,-81}},
      color={255,255,0},
      thickness=1.5));
  connect(power.epp, epp) annotation (Line(
      points={{68,-54},{83.96,-54},{83.96,-54},{100,-54}},
      color={0,127,0},
      thickness=0.5));
  connect(calc_Q_CHP_out.y, Q_CHP_out) annotation (Line(points={{36.8,30},{72,30},{72,6},{106,6}}, color={0,0,127}));
  connect(switch.y, firstOrder1.u)
    annotation (Line(points={{-19.1,5},{-13.8,5}}, color={0,0,127}));
  connect(firstOrder1.y, calc_P_CHP_out.u) annotation (Line(points={{6.9,5},{14,5},{14,-16},{18.4,-16}}, color={0,0,127}));
  connect(firstOrder1.y, calc_Q_CHP_out.u) annotation (Line(points={{6.9,5},{14,5},{14,30},{18.4,30}}, color={0,0,127}));
  connect(calc_P_CHP_out.y, sign_change.u) annotation (Line(points={{36.8,-16},{42.4,-16}}, color={0,0,127}));
  connect(sign_change.y, power.P_el_set) annotation (Line(points={{60.8,-16},{64,-16},{64,-44.4},{64.8,-44.4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Simple energybased model of a CHP unit. </p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Gas consumption is computed using a constant thermal and electrical efficiency and constant heat of combustion. Constant thermal and electrical power output is assumed.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Modelica.Blocks.Interfaces.BooleanInput OnOffSignal</p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_CHP_out</p>
<p>TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp</p>
<p>TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>m_flow_gas=(Q_CHP_out + calc_P_CHP_out.y)/CalorificValue/eta_total;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT, 2018</span></p>
</html>"));
end CHP_simple;

