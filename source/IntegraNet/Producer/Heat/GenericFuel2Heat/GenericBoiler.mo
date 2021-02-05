within IntegraNet.Producer.Heat.GenericFuel2Heat;
model GenericBoiler "Simple boiler with variable fuel"
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

  outer IntegraNet.SimCenter simCenter;
  outer IntegraNet.Statistics.Statistics_collector statistics_collector;
  outer TransiEnt.ModelStatistics modelStatistics;

  import FT=IntegraNet.Basics.Types.FuelType;

   //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________

  parameter IntegraNet.Basics.Types.FuelType FuelType=FT.Gas "Choice of fuel";

  parameter SI.Efficiency eta = 0.78 "Efficency of the boiler";

  parameter SI.SpecificEnthalpy HeatingValue_Gas=TransiEnt.Basics.Functions.GasProperties.getRealGasNCV_xi(
      GasModel,
      xi_in=GasModel.xi_default,
      NCVIn=0) "Heating value of natural gas"  annotation(HideResult=true, Dialog(group="Fuel", enable=FuelType == "Gas"));

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid GasModel=simCenter.gasModel1 "Medium name of fuel gas model"  annotation (Dialog(group="Fuel", enable=FuelType == "Gas"),
                                                                                                                                                choicesAllMatching);

  parameter SI.SpecificEnthalpy HeatingValue_Oil=simCenter.HeatingValue_Oil "Heating value of oil"   annotation(HideResult=true, Dialog(group="Fuel", enable=FuelType == "Oil"));

  parameter SI.SpecificEnthalpy HeatingValue_Pellet=simCenter.HeatingValue_Wood "Heating value of wood pellets"   annotation(HideResult=true, Dialog(group="Fuel", enable=FuelType == "Pellets"));

  parameter TransiEnt.Basics.Types.TypeOfResource TypeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional
                                                                                                                   "|Statistics|Type of resource";
  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat TypeOfEnergyCarrier= if FuelType==FT.Gas then TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas elseif FuelType==FT.Oil then TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.Oil else TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.Biomass "|Statistics|Type of energy carrier";

  parameter SI.HeatFlowRate Q_flow_n_boiler=20000 "|Statistics|Nominal heating power of the gas boiler";

  replaceable model BoilerCostModel =
      TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasBoiler
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.BoilerCost  "|Statistics|Cost specification" annotation (choicesAllMatching=true);

protected
  parameter IntegraNet.Statistics.TypeOfResource m_flow_typeOfRes=if FuelType == FT.Oil then IntegraNet.Statistics.TypeOfResource.m_flow_oil else if FuelType == FT.Gas then IntegraNet.Statistics.TypeOfResource.m_flow_gas else IntegraNet.Statistics.TypeOfResource.m_flow_biomass annotation (Dialog(group="Statistics"));

   //___________________________________________________________________________
   //
   //                      Variables
   //___________________________________________________________________________

  SI.MassFlowRate m_flow_CDE=fuelSpecificCO2Emissions.m_flow_CDE_per_Energy*Q_Demand/eta "|Fundamental definitions|CDE mass flow rate";

   //___________________________________________________________________________
   //
   //                      Components
   //___________________________________________________________________________


   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TypeOfResource, is_setter=true) annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsHeat collectGwpEmissions(typeOfEnergyCarrierHeat=TypeOfEnergyCarrier) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
   TransiEnt.Components.Statistics.Collectors.LocalCollectors.HeatingPlantCost collectCosts(
     Q_flow_n=Q_flow_n_boiler,
     m_flow_CDE_is=-collectGwpEmissions.gwpCollector.m_flow_cde,
     Q_flow_is=-Q_Demand,
     Q_flow_fuel_is=Q_Demand/eta,
     redeclare model HeatingPlantCostModel = BoilerCostModel) annotation (Placement(transformation(
         extent={{-10,-10},{10,10}},
         rotation=0,
         origin={-70,-90})));


protected
  TransiEnt.Components.Statistics.Functions.GetFuelSpecificCO2Emissions fuelSpecificCO2Emissions(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Functions.getPrimaryEnergyCarrierFromHeat(TypeOfEnergyCarrier));

  parameter IntegraNet.Statistics.TypeOfResource q_typeOfRes=if FuelType == FT.Oil then IntegraNet.Statistics.TypeOfResource.q_output_Oil else if FuelType == FT.Gas then IntegraNet.Statistics.TypeOfResource.q_output_Gas else IntegraNet.Statistics.TypeOfResource.q_output_Biomass annotation (Dialog(group="Statistics"));

  Real heating_value;
  SI.Power P_fuel;

 // Real V_fuel "L of Gas/Oil";
 // SI.MassFlowRate co2_emission "CO2 kg/s";
 // SI.Mass sum_co2_emission "CO2 kg/a";

public
  SI.MassFlowRate m_fuel;

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn
                                       Q_Demand annotation (Placement(
        transformation(
        rotation=-90,
        extent={{-10,-10},{10,10}},
        origin={0,100})));

  IntegraNet.Statistics.LocalCollector heating_collector(typeOfResource=q_typeOfRes) annotation (Placement(transformation(extent={{56,6},{98,46}})));
  IntegraNet.Statistics.LocalCollector mass_collector(typeOfResource=m_flow_typeOfRes) annotation (Placement(transformation(extent={{58,60},{98,100}})));

equation

  Q_Demand = P_fuel * eta;
 // der(sum_co2_emission) = co2_emission;

  if FuelType==FT.Gas then
     heating_value=HeatingValue_Gas;

  elseif FuelType==FT.Oil then
     heating_value=HeatingValue_Oil;
   //  co2_emission = der(m_fuel / rho_oil) * 3.17; // 3.17 kgCO2/l HEL
  else
    heating_value=HeatingValue_Pellet;
//      co2_emissions = 1.83*m_pellet; //1.83 kgCO2/kgBS
  end if;

   P_fuel = m_fuel * heating_value;

  mass_collector.flowCollector.unit_flow = m_fuel;
  heating_collector.flowCollector.unit_flow = P_fuel;

  collectHeatingPower.heatFlowCollector.Q_flow=-Q_Demand;
  collectGwpEmissions.gwpCollector.m_flow_cde =-m_flow_CDE;

  connect(modelStatistics.gwpCollectorHeat[TypeOfEnergyCarrier],collectGwpEmissions.gwpCollector);
  connect(modelStatistics.heatFlowCollector[TypeOfResource],collectHeatingPower.heatFlowCollector);
  connect(modelStatistics.costsCollector, collectCosts.costsCollector);


  if FuelType==FT.Gas then
    connect(heating_collector.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.q_output_Gas]);
    connect(mass_collector.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.m_flow_gas]);
  elseif FuelType==FT.Oil then
    connect(heating_collector.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.q_output_Oil]);
    connect(mass_collector.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.m_flow_oil]);
  else
    connect(heating_collector.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.q_output_Biomass]);
    connect(mass_collector.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.m_flow_biomass]);
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-98,-100},{102,100}}),
        Rectangle(
          extent={{-60,60},{60,-62}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,66},{30,48}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,60},{52,100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-62},{40,8}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}),                      Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Simple model of a boiler with either gas, oil or pellet as fuel</p>
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
<p>(no remarks) </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de) on 10.10.2018</span></p>
</html>"));
end GenericBoiler;
