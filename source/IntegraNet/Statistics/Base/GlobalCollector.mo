within IntegraNet.Statistics.Base;
model GlobalCollector "Collects Globaly"

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

  constant Integer nTypes=40;

  parameter Integer nConsumer = 10;

  final parameter Boolean is_setter=false "just for change of icon.." annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));

  Modelica.Blocks.Interfaces.RealInput Collector[nTypes]
    annotation (Placement(transformation(extent={{-10,-108},{10,-88}}),
        iconTransformation(extent={{-16,-16},{16,16}},
        rotation=90,
        origin={0,-87})));
protected
  SI.Energy E[nTypes](each start=0, each fixed=true, each stateSelect=StateSelect.never);

  //               GUIDE FOR NEW VARIABLES               //
  // Add new VARIABLE to TypeofResource                  //
  // Increase nTypes += 1                                //
  // P_TYPEOFVARIABLE = Collector[TypeofResource.VARIABLE] //
  // E_TYPEOFVARIABLE = E[TypeofResource.VARIABLE]       //
  // Generic //
public
  SI.Power P_generic=Collector[IntegraNet.Statistics.TypeOfResource.Generic];
  SI.Energy E_generic=E[IntegraNet.Statistics.TypeOfResource.Generic];
  //***********

  // HeatPump //
  //-- Demand:
  SI.Power P_el_heatpump_demand=Collector[IntegraNet.Statistics.TypeOfResource.el_demand_HeatPump];   //HP
  SI.Energy E_el_heatpump_demand=E[IntegraNet.Statistics.TypeOfResource.el_demand_HeatPump];    //HP
  SI.Power P_el_aux_heatpump_demand=Collector[IntegraNet.Statistics.TypeOfResource.el_demand_aux_HeatPump];   //AUX
  SI.Energy E_el_aux_heatpump_demand=E[IntegraNet.Statistics.TypeOfResource.el_demand_aux_HeatPump];    //AUX
  //-- Output:
  SI.Power P_heat_heatpump_output=Collector[IntegraNet.Statistics.TypeOfResource.q_output_HeatPump];   //HP
  SI.Power P_heat_aux_heatpump_output=Collector[IntegraNet.Statistics.TypeOfResource.q_output_aux_HeatPump];   //HP
  SI.Energy E_heat_heatpump_output=E[IntegraNet.Statistics.TypeOfResource.q_output_HeatPump];   //HP
  SI.Energy E_heat_aux_heatpump_output=E[IntegraNet.Statistics.TypeOfResource.q_output_aux_HeatPump];   //AUX
  //***********

  // Biomass & Oil & Gas //
  //-- Output:
  SI.Power P__heat_bioTech_output=Collector[IntegraNet.Statistics.TypeOfResource.q_output_Biomass];   //Biomass P
  SI.Power P_heat_oilTech_output=Collector[IntegraNet.Statistics.TypeOfResource.q_output_Oil];   // Oil P
  SI.Power P_heat_gasTech_output=Collector[IntegraNet.Statistics.TypeOfResource.q_output_Gas];  // Gas P
  SI.Energy E_heat_bioTech_output=E[IntegraNet.Statistics.TypeOfResource.q_output_Biomass];  // Biomass E
  SI.Energy E_heat_oilTech_output=E[IntegraNet.Statistics.TypeOfResource.q_output_Oil];  // Oil E
  SI.Energy E_heat_gasTech_output=E[IntegraNet.Statistics.TypeOfResource.q_output_Gas];  // Gas E
  //***********

  // Consumer Demand //
  //-- Demand:
  SI.Power P_el_demand=Collector[IntegraNet.Statistics.TypeOfResource.El_demand];
  SI.Power P_heating_demand=Collector[IntegraNet.Statistics.TypeOfResource.Heat_demand];
  SI.Power P_tww_demand=Collector[IntegraNet.Statistics.TypeOfResource.tww_demand];
  SI.Power P_heat_total_demand = P_heating_demand + P_tww_demand;
  SI.Energy E_el_demand_total=E[IntegraNet.Statistics.TypeOfResource.El_demand];
  SI.Energy E_heating_demand=E[IntegraNet.Statistics.TypeOfResource.Heat_demand];
  SI.Energy E_tww_demand=E[IntegraNet.Statistics.TypeOfResource.tww_demand];
  SI.Energy E_heat_demand_total = E_heating_demand + E_tww_demand;
  //***********

  // Solar Thermal//
  //-- Output:
  SI.Power P_heat_solarthermal_output=Collector[IntegraNet.Statistics.TypeOfResource.q_output_SolarThermal];
  SI.Power P_heat_aux_solarthermal=Collector[IntegraNet.Statistics.TypeOfResource.q_output_aux_SolarThermal];   //Also collected as Gas / Oil / Biomass
  SI.Energy E_heat_solarthermal=E[IntegraNet.Statistics.TypeOfResource.q_output_SolarThermal];
  SI.Energy E_heat_aux_solarthermal=E[IntegraNet.Statistics.TypeOfResource.q_output_aux_SolarThermal];   //Also collected as Gas / Oil / Biomass
  //***********

  // DHN //
  //-- Output:
  SI.Power P_heat_substation=Collector[IntegraNet.Statistics.TypeOfResource.q_output_DHN];
  SI.Power E_heat_substation=Collector[IntegraNet.Statistics.TypeOfResource.q_output_DHN];
  SI.Power P_heat_loss_DHN=Collector[IntegraNet.Statistics.TypeOfResource.Heat_loss_DHN];
  SI.Energy E_heat_loss_DHN=E[IntegraNet.Statistics.TypeOfResource.Heat_loss_DHN];

  SI.Power P_DHNGridSegment = P_heat_total_demand - P_heat_loss_DHN;
  SI.Energy E_DHNGridSegment = E_heat_demand_total - E_heat_loss_DHN;
  Real heatloss_share = abs(P_heat_loss_DHN/(Modelica.Constants.eps+P_DHNGridSegment));
  //***********

  // CHP //
  //-- Output:
  SI.Power P_elec_chp_output=Collector[IntegraNet.Statistics.TypeOfResource.el_output_CHP];
  SI.Power P_heat_chp_output=Collector[IntegraNet.Statistics.TypeOfResource.q_output_CHP];
  SI.Power P_heat_aux_chp_output=Collector[IntegraNet.Statistics.TypeOfResource.q_output_aux_CHP];

  SI.Energy E_elec_chp_output=E[IntegraNet.Statistics.TypeOfResource.el_output_CHP];
  SI.Energy E_heat_chp_output=E[IntegraNet.Statistics.TypeOfResource.q_output_CHP];
  SI.Power E_heat_aux_chp_output=E[IntegraNet.Statistics.TypeOfResource.q_output_aux_CHP];
  //***********

  // PV //
  //-- Output:
  SI.Power P_photovoltaic_output=Collector[IntegraNet.Statistics.TypeOfResource.el_output_Photovoltaic];
  SI.Power P_battery_loading=Collector[IntegraNet.Statistics.TypeOfResource.el_loading_Battery];
  SI.Power P_battery_discharge=Collector[IntegraNet.Statistics.TypeOfResource.el_discharge_Battery];
  SI.Energy E_photovoltaic_output=E[IntegraNet.Statistics.TypeOfResource.el_output_Photovoltaic];
  SI.Energy E_battery_loading=E[IntegraNet.Statistics.TypeOfResource.el_loading_Battery];
  SI.Energy E_battery_discharge=E[IntegraNet.Statistics.TypeOfResource.el_discharge_Battery];
  SI.Energy E_battery_LoadStatus=E[IntegraNet.Statistics.TypeOfResource.el_LoadStatus_Battery];
  //***********

  // NSH //
  //-- Demand
  SI.Power P_elec_NSH_demand=Collector[IntegraNet.Statistics.TypeOfResource.el_demand_NSH];
  SI.Energy E_elec_NSH_demand=E[IntegraNet.Statistics.TypeOfResource.el_demand_NSH];
  //-- Output
  SI.Power P_heat_NSH_output=Collector[IntegraNet.Statistics.TypeOfResource.q_output_NSH];
  SI.Energy E_heat_NSH_output=E[IntegraNet.Statistics.TypeOfResource.q_output_NSH];
  /////

  // Electrical DHW Demand //
  SI.Power P_elec_DHW_demand = Collector[IntegraNet.Statistics.TypeOfResource.el_dhw_supply];
  SI.Energy E_elec_DHW_demand = E[IntegraNet.Statistics.TypeOfResource.el_dhw_supply];

  // Storage //
  SI.Power P_heat_Loss_Storage=Collector[IntegraNet.Statistics.TypeOfResource.Heat_loss_Storage];
  SI.Power E_heat_Loss_Storage=E[IntegraNet.Statistics.TypeOfResource.Heat_loss_Storage];

  SI.Energy E_LoadStatus_Storage=E[IntegraNet.Statistics.TypeOfResource.q_LoadStatus_Storage];

  // Mass Flow //
  SI.MassFlowRate m_flow_gas=Collector[IntegraNet.Statistics.TypeOfResource.m_flow_gas];
  SI.Mass mass_gas=E[IntegraNet.Statistics.TypeOfResource.m_flow_gas];

  SI.MassFlowRate m_flow_oil=Collector[IntegraNet.Statistics.TypeOfResource.m_flow_oil];
  SI.Mass mass_oil=E[IntegraNet.Statistics.TypeOfResource.m_flow_oil];

  SI.MassFlowRate m_flow_pellet=Collector[IntegraNet.Statistics.TypeOfResource.m_flow_biomass];
  SI.Mass mass_pellet=E[IntegraNet.Statistics.TypeOfResource.m_flow_biomass];

  // Losses //
  SI.Power P_CableLosses=Collector[IntegraNet.Statistics.TypeOfResource.el_Losses_Cable];
  SI.Power E_CableLosses=E[IntegraNet.Statistics.TypeOfResource.el_Losses_Cable];

  SI.Power P_PVLosses_aux=Collector[IntegraNet.Statistics.TypeOfResource.el_Losses_Photovoltaic_aux];
  SI.Power E_PVLosses_aux=E[IntegraNet.Statistics.TypeOfResource.el_Losses_Photovoltaic_aux];

  SI.Power P_BatteryLosses=Collector[IntegraNet.Statistics.TypeOfResource.el_Losses_Battery];
  SI.Energy E_BatteryLosses=E[IntegraNet.Statistics.TypeOfResource.el_Losses_Battery];

  SI.Power P_InverterLosses=Collector[IntegraNet.Statistics.TypeOfResource.el_Losses_Inverter];
  SI.Energy E_InverterLosses=E[IntegraNet.Statistics.TypeOfResource.el_Losses_Inverter];

  // EVALUATION //
  Real n_vrd_upper=abs(min(Collector[IntegraNet.Statistics.TypeOfResource.n_vrd_upper], 1));
  Real n_vrd_lower=abs(max(Collector[IntegraNet.Statistics.TypeOfResource.n_vrd_lower], -1));
  Real t_vrd_lower;
  Real t_vrd_upper;
  Real n_vrd_sum = n_vrd_upper+n_vrd_lower;
  Real t_n_vrd_sum = t_vrd_lower+t_vrd_upper;

  //SI.Power P_conventional_heating = P_oil_output + P_gas_output + P_heat_chp_output + P_biomass_output;
  //SI.Energy E_conventional_heating = E_oil_output + E_biomass_output + E_gas_output + E_heat_chp_output;

  SI.Power P_renewable_output_elec = P_photovoltaic_output;
  SI.Energy E_renewable_output_elec = E_photovoltaic_output;

  SI.Power P_renewable_output_heat = P_heat_solarthermal_output;
  SI.Energy E_renewable_output_heat = E_heat_solarthermal;

equation
  der(t_vrd_upper) = n_vrd_upper;
  der(t_vrd_lower) = n_vrd_lower;

  der(E)=Collector;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),             Polygon(
          visible=is_setter,
          points={{-12,81},{-12,3},{-48,3},{0,-65},{44,3},{10,3},{10,81},{6,81},
              {-12,81}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-7,19},{-7,-5},{-23,-5},{3,-33},{27,-5},{11,-5},{11,19},{1,19},
              {-7,19}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={3,-37},
          rotation=180),
        Ellipse(
          extent={{-34,80},{32,16}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{-4,69},{-14,59}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{14,69},{4,59}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{-16,51},{-26,41}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{12,29},{2,39}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{26,51},{16,41}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{-4,33},{-14,23}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{4,53},{-6,43}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-136,150},{146,106}},
          lineColor={0,0,0},
          textString="%name")}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Inner model of the Statistics_collector holds all logic to collect the data</p>
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
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de) on 10.10.2018</span></p>
</html>"));
end GlobalCollector;

