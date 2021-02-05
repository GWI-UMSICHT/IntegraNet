within IntegraNet.Producer.Heat.Gas2Heat.SmallGasBoiler;
model GasBoiler_energybased_noGasPort "simple, energy based boiler with constant efficiency"
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

  extends TransiEnt.Basics.Icons.Boiler;

  outer IntegraNet.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;
  outer IntegraNet.Statistics.Statistics_collector statistics_collector;

    //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid FuelMedium=simCenter.gasModel1 "|Fundamental definitions|Fuel gas medium";

  parameter SI.Efficiency eta=1.05 "|Boiler|Boiler's overall efficiency";
  parameter SI.HeatFlowRate Q_flow_n_boiler=20000 "|Boiler|Nominal heating power of the gas boiler";

  parameter TransiEnt.Basics.Types.TypeOfResource TypeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional "|Statistics|Type of resource";
  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat TypeOfEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas "|Statistics|Type of energy carrier";

  replaceable model BoilerCostModel =
      TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasBoiler
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.BoilerCost  "|Statistics|Cost specification" annotation (choicesAllMatching=true);

  parameter Boolean referenceNCV = simCenter.referenceNCV "|Fundamental definitions|true, if heat calculations shall be in respect to NCV, false will give GCV";

  //parameter Modelica.SIunits.SpecificEnthalpy HoC_gas=40e6 "Heat of combustion of natural gas";

   //___________________________________________________________________________
   //
   //                      Variables
   //___________________________________________________________________________

  SI.MassFlowRate m_flow_CDE=fuelSpecificCO2Emissions.m_flow_CDE_per_Energy*heatFlowRate/eta "|Fundamental definitions|CDE mass flow rate";

  SI.HeatFlowRate Q_flow_fuel=m_flow_fuel.y*CalorificValue;

  SI.SpecificEnthalpy CalorificValue=if referenceNCV then TransiEnt.Basics.Functions.GasProperties.getRealGasNCV_xi(
      FuelMedium,
      xi_in=FuelMedium.xi_default,
      NCVIn=0) else TransiEnt.Basics.Functions.GasProperties.getRealGasGCV_xi(
      FuelMedium,
      xi_in=FuelMedium.xi_default,
      GCVIn=0) "Calorific value of fuel";

protected
   TransiEnt.Components.Statistics.Functions.GetFuelSpecificCO2Emissions fuelSpecificCO2Emissions(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Functions.getPrimaryEnergyCarrierFromHeat(TypeOfEnergyCarrier));

   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TypeOfResource, is_setter=true) annotation (Placement(transformation(extent={{-100,86},{-88,98}})));
   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsHeat collectGwpEmissions(typeOfEnergyCarrierHeat=TypeOfEnergyCarrier) annotation (Placement(transformation(extent={{-100,74},{-88,86}})));
   TransiEnt.Components.Statistics.Collectors.LocalCollectors.HeatingPlantCost collectCosts(
     Q_flow_n=Q_flow_n_boiler,
     m_flow_CDE_is=-collectGwpEmissions.gwpCollector.m_flow_cde,
     Q_flow_is=-heatFlowRate,
     Q_flow_fuel_is=heatFlowRate/eta,
     redeclare model HeatingPlantCostModel = BoilerCostModel) annotation (Placement(transformation(
         extent={{-6,-6},{6,6}},
         rotation=0,
         origin={-94,68})));

public
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn heatFlowRate annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=270,
        origin={0,94})));
  Modelica.Blocks.Math.Division m_flow_fuel annotation (Placement(transformation(extent={{0,-6},{20,14}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=CalorificValue*eta) annotation (Placement(transformation(extent={{-54,-12},{-34,8}})));
  Statistics.LocalCollector heating_collector(typeOfResource=IntegraNet.Statistics.TypeOfResource.q_output_Gas) annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Statistics.LocalCollector gas_Mflow(typeOfResource=IntegraNet.Statistics.TypeOfResource.m_flow_gas) annotation (Placement(transformation(extent={{40,-40},{60,-20}})));


equation

  collectHeatingPower.heatFlowCollector.Q_flow=heatFlowRate;
  collectGwpEmissions.gwpCollector.m_flow_cde =m_flow_CDE;

  heating_collector.flowCollector.unit_flow = heatFlowRate;
  connect(heating_collector.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.q_output_Gas]);

  gas_Mflow.flowCollector.unit_flow = m_flow_fuel.y;
  connect(gas_Mflow.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.m_flow_gas]);




  connect(realExpression.y, m_flow_fuel.u2) annotation (Line(points={{-33,-2},{-10,-2},{-2,-2}},
                                                                                        color={0,0,127}));

  connect(modelStatistics.heatFlowCollector[TypeOfResource],collectHeatingPower.heatFlowCollector);
  connect(modelStatistics.gwpCollectorHeat[TypeOfEnergyCarrier],collectGwpEmissions.gwpCollector);
  connect(modelStatistics.costsCollector, collectCosts.costsCollector);

  connect(m_flow_fuel.u1, heatFlowRate) annotation (Line(points={{-2,10},{-2,10},{-2,94},{0,94}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Very simple energybased model of a gas boiler. Gas flow is calculated but no connection to a gas grid is modeled.</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Gas consumption is computed using a constant efficiency and constant heat of combustion.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn HeatFlowRate</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>m_flow_fuel =HeatFlowRate/(CalorificValue*eta)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT, 2018</span></p>
</html>"));
end GasBoiler_energybased_noGasPort;

