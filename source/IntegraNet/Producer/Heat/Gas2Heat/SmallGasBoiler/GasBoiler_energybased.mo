within IntegraNet.Producer.Heat.Gas2Heat.SmallGasBoiler;
model GasBoiler_energybased "simple, energy based boiler with constant efficiency"
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
  outer IntegraNet.Statistics.Statistics_collector statistics_collector;
  outer TransiEnt.ModelStatistics modelStatistics;

    //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid FuelMedium=simCenter.gasModel1 "|Fundamental definitions|Fuel gas medium";

  parameter SI.Efficiency eta=1.05 "|Boiler|Boiler's overall efficiency";
  parameter SI.HeatFlowRate Q_flow_n_boiler=20000 "|Boiler|Nominal heating power of the gas boiler";

  parameter TransiEnt.Basics.Types.TypeOfResource TypeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional "|Statistics|Type of resource";
  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat TypeOfEnergyCarrierHeat=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas "|Statistics|Type of energy carrier";
  replaceable model CostRecordBoiler =  TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PeakLoadBoiler
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs "|Statistics|Cost specification" annotation (choicesAllMatching=true);

  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_gas_fuel=simCenter.Cfue_GasBoiler "|Statistics|Specific demand-related cost per gas energy";

 // parameter TILMedia.VLEFluidTypes.BaseVLEFluid  FuelMedium= simCenter.gasModel1 "|Fundamental definitions|Medium to be used for fuel gas";
  parameter Boolean referenceNCV = simCenter.referenceNCV "|Fundamental definitions|true, if heat calculations shall be in respect to NCV, false will give GCV";

   //___________________________________________________________________________
   //
   //                      Variables
   //___________________________________________________________________________

  SI.MassFlowRate m_flow_CDE=fuelSpecificCO2Emissions.m_flow_CDE_per_Energy*heatFlowRate/eta "|Fundamental definitions|CDE mass flow rate";

  SI.HeatFlowRate Q_flow_fuel=m_flow_fuel.y*CalorificValue;


//  input Real CalorificValue(quantity="calorific Value", unit="J/kg")=40e6 annotation(Dialog(group="Parameters"));

  SI.SpecificEnthalpy CalorificValue=if referenceNCV then TransiEnt.Basics.Functions.GasProperties.getRealGasNCV_xi(
      FuelMedium,
      xi_in=xi_fuel[1:FuelMedium.nc - 1],
      NCVIn=0) else TransiEnt.Basics.Functions.GasProperties.getRealGasGCV_xi(
      FuelMedium,
      xi_in=xi_fuel[1:FuelMedium.nc - 1],
      GCVIn=0) "Calorific value of fuel";

  SI.MassFraction xi_fuel[FuelMedium.nc] "[CH4, C2H6, C3H8, C4H10, N2, CO2, H2] Fuel gas mass fractions" annotation(HideREsult=true);

protected
  TransiEnt.Components.Statistics.Functions.GetFuelSpecificCO2Emissions fuelSpecificCO2Emissions(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Functions.getPrimaryEnergyCarrierFromHeat(TypeOfEnergyCarrierHeat));

   //___________________________________________________________________________
   //
   //                      Complex Components
   //___________________________________________________________________________


public
   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TypeOfResource, is_setter=true) annotation (Placement(transformation(extent={{-100,76},{-88,88}})));
   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsHeat collectGwpEmissions(typeOfEnergyCarrierHeat=TypeOfEnergyCarrierHeat) annotation (Placement(transformation(extent={{-100,64},{-88,76}})));
   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts(
     der_E_n=Q_flow_n_boiler,
     E_n=0,
     redeclare model CostRecordGeneral = CostRecordBoiler,
     Cspec_demAndRev_gas_fuel=Cspec_demAndRev_gas_fuel,
     Q_flow=-heatFlowRate,
     H_flow=Q_flow_fuel,
    m_flow_CDE=-m_flow_CDE) annotation (Placement(transformation(extent={{-100,88},{-88,100}})));

public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow gas(variable_m_flow=true, medium=FuelMedium)
                                                                                          annotation (Placement(transformation(extent={{16,-8},{36,12}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{70,-106},{90,-86}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn heatFlowRate annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=270,
        origin={0,94})));
  Modelica.Blocks.Math.Division m_flow_fuel annotation (Placement(transformation(extent={{6,34},{26,54}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=CalorificValue*eta) annotation (Placement(transformation(extent={{-40,28},{-20,48}})));

  Statistics.LocalCollector heating_collector(typeOfResource=IntegraNet.Statistics.TypeOfResource.q_output_Gas) annotation (Placement(transformation(extent={{66,46},{86,66}})));
  Statistics.LocalCollector gas_Mflow(typeOfResource=IntegraNet.Statistics.TypeOfResource.m_flow_gas) annotation (Placement(transformation(extent={{66,-34},{86,-14}})));

equation

 xi_fuel[1:FuelMedium.nc - 1] = inStream(gasPortIn.xi_outflow);
 xi_fuel[end] = 1-sum(xi_fuel[1:FuelMedium.nc - 1]);

   collectHeatingPower.heatFlowCollector.Q_flow=-heatFlowRate;
   collectGwpEmissions.gwpCollector.m_flow_cde =-m_flow_CDE;

  connect(gas.gasPort, gasPortIn) annotation (Line(
      points={{36,2},{54,2},{54,-96},{80,-96}},
      color={255,255,0},
      thickness=1.5));
  connect(realExpression.y, m_flow_fuel.u2) annotation (Line(points={{-19,38},{4,38}},  color={0,0,127}));

  heating_collector.flowCollector.unit_flow = heatFlowRate;
  connect(heating_collector.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.q_output_Gas]);

  gas_Mflow.flowCollector.unit_flow = m_flow_fuel.y;
  connect(gas_Mflow.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.m_flow_gas]);

   connect(modelStatistics.heatFlowCollector[TypeOfResource],collectHeatingPower.heatFlowCollector);
   connect(modelStatistics.gwpCollectorHeat[TypeOfEnergyCarrierHeat],collectGwpEmissions.gwpCollector);
   connect(modelStatistics.costsCollector, collectCosts.costsCollector);

  connect(m_flow_fuel.u1, heatFlowRate) annotation (Line(points={{4,50},{-2,50},{-2,94},{0,94}},  color={0,0,127}));
  connect(m_flow_fuel.y, gas.m_flow) annotation (Line(points={{27,44},{32,44},{32,22},{-2,22},{-2,8},{14,8}},
                                         color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Very simple energybased model of a gas boiler.</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Gas consumption is computed using a constant efficiency and constant heat of combustion.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><br>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn HeatFlowRate</p>
<p>TransiEnt.Basics.Interfaces.Gas.RealGasPortIn - combustion gas inlet</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>m_flow_gas =HeatFlowRate/(CalorificValue*eta)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT, 2018</span></p>
</html>"));
end GasBoiler_energybased;

