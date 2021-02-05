within IntegraNet.Statistics;
type TypeOfResource = enumeration(
    Generic "Generic",
    El_demand "Electricity Demand",
    Heat_demand "Heating Demand",
    tww_demand "TWW Heating Demand",
    el_loading_Battery "Electric Loading Battery",
    el_discharge_Battery "Electric Discharge Battery",
    el_LoadStatus_Battery "Electric LoadStatus Battery",
    el_Losses_Battery "Stationary Losses Battery",
    el_output_Photovoltaic "Electric Output Photovoltaic",
    el_Losses_Inverter "Electric Inverter Losses",
    el_Losses_Photovoltaic_aux "Auxillary DC losses in Photovoltaic Module",
    q_output_CHP "Heat Output CHP",
    q_output_aux_CHP "Heat Output Auxillary Unit CHP",
    el_output_CHP "Electricity Output CHP",
    q_output_DHN "Heat Output DHN",
    q_output_Biomass "Heat Output Biomass",
    q_output_Oil "Heat Output Oil",
    q_output_Gas "Heat Output Gas",
    q_output_SolarThermal "Heat Output SolarThermal",
    q_output_aux_SolarThermal "Heat Output Auxillary Unit SolarThermal",
    el_demand_HeatPump "Electric Demand HeatPump",
    el_demand_aux_HeatPump "Electric Demand Auxillary Unit HeatPump",
    q_output_HeatPump "Heat Output HeatPump",
    q_output_aux_HeatPump "Heat Output Auxillary Unit HeatPump",
    q_output_NSH "Heat Output NSH",
    el_demand_NSH "Electric Output NSH",
    Heat_loss_DHN "DHN Heat Loss of the network",
    q_LoadStatus_Storage "Heat LoadStatus HotWater Tank",
    Heat_loss_Storage "Heat Loss from Waterstorage",
    m_flow_gas "Gas Mass Flow",
    m_flow_oil "Oil Mass Flow",
    m_flow_biomass "Biomass Mass Flow",
    el_Losses_Cable "Cable Losses",
    el_dhw_supply "Electrical Domestic hot water supply",
    n_vrd_lower "Lower Voltage Range Deviation",
    n_vrd_upper "Upper Voltage Range Deviation") annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>List of Resources that can be collected - can be adjusted to specific needs</p>
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
<p>To add new Resources:</p>
<ol>
<li>Add the new Resource to the enumeration in TypeOfResource</li>
<li>Add the variable with Unit as a variable in the GlobalCollector model</li>
<li>In the parameter typeOfResource of the model LocalCollector add the new resource for the drop down menu</li>
</ol>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de) on 10.10.2018</span></p>
</html>"));
