within IntegraNet.Statistics;
model LocalCollector "Collects the defined variables in TypeOfResource locally inside the specific model"
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

  // BASED ON TRANSIENT HEATING COLLECTOR //

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  constant Boolean is_setter=true "just for change of icon.." annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
  //parameter Boolean is_setter=true "just for change of icon.." annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));

  parameter IntegraNet.Statistics.TypeOfResource typeOfResource=IntegraNet.Statistics.TypeOfResource.Generic "Select the kind of resource" annotation (choices(
      choice=IntegraNet.Statistics.TypeOfResource.Generic "Generic",
      choice=IntegraNet.Statistics.TypeOfResource.El_demand "Electricity Demand",
      choice=IntegraNet.Statistics.TypeOfResource.Heat_demand "Heating Demand",
      choice=IntegraNet.Statistics.TypeOfResource.tww_demand "TWW heating Demand",
      choice=IntegraNet.Statistics.TypeOfResource.el_loading_Battery "Electric Loading Battery",
      choice=IntegraNet.Statistics.TypeOfResource.el_discharge_Battery "Electric Discharge Battery",
      choice=IntegraNet.Statistics.TypeOfResource.el_LoadStatus_Battery "Electric LoadStatus Battery",
      choice=IntegraNet.Statistics.TypeOfResource.el_Losses_Battery "Stationary Losses Battery",
      choice=IntegraNet.Statistics.TypeOfResource.el_Losses_Inverter "Electric Inverter Losses",
      choice=IntegraNet.Statistics.TypeOfResource.q_output_CHP "Heat Output CHP",
      choice=IntegraNet.Statistics.TypeOfResource.el_output_CHP "Electricity Output CHP",
      choice=IntegraNet.Statistics.TypeOfResource.q_output_aux_CHP "Heat Output Auxillary Unit CHP",
      choice=IntegraNet.Statistics.TypeOfResource.q_output_DHN "Heat Output DHN",
      choice=IntegraNet.Statistics.TypeOfResource.q_output_Gas "Heat Output Gas",
      choice=IntegraNet.Statistics.TypeOfResource.q_output_Oil "Heat Output Oil",
      choice=IntegraNet.Statistics.TypeOfResource.el_demand_HeatPump "Electric Demand HeatPump",
      choice=IntegraNet.Statistics.TypeOfResource.el_demand_aux_HeatPump "Electric Demand Auxillary Unit HeatPump",
      choice=IntegraNet.Statistics.TypeOfResource.q_output_HeatPump "Heat Output HeatPump",
      choice=IntegraNet.Statistics.TypeOfResource.q_output_aux_HeatPump "Heat Output Auxillary Unit HeatPump",
      choice=IntegraNet.Statistics.TypeOfResource.q_output_Biomass "Heat Output Biomass",
      choice=IntegraNet.Statistics.TypeOfResource.q_output_SolarThermal "Heat Output SolarThermal",
      choice=IntegraNet.Statistics.TypeOfResource.q_output_aux_SolarThermal "Heat Output Auxillary Unit SolarThermal",
      choice=IntegraNet.Statistics.TypeOfResource.el_output_Photovoltaic "Electric Output Photovoltaic",
      choice=IntegraNet.Statistics.TypeOfResource.el_Losses_Photovoltaic_aux "Auxillary DC losses in Photovoltaic Module",
      choice=IntegraNet.Statistics.TypeOfResource.q_output_NSH "Heat Output NSH",
      choice=IntegraNet.Statistics.TypeOfResource.el_demand_NSH "Electric Demand NSH",
      choice=IntegraNet.Statistics.TypeOfResource.Heat_loss_DHN "DHN Network Heatloss",
      choice=IntegraNet.Statistics.TypeOfResource.q_LoadStatus_Storage "Heat LoadStatus HotWater Tank",
      choice=IntegraNet.Statistics.TypeOfResource.Heat_loss_Storage "Heat Loss from Waterstorage",
      choice=IntegraNet.Statistics.TypeOfResource.m_flow_gas "Gas Mass Flow",
      choice=IntegraNet.Statistics.TypeOfResource.m_flow_oil "Oil Mass Flow",
      choice=IntegraNet.Statistics.TypeOfResource.m_flow_biomass "Biomass Mass Flow",
      choice=IntegraNet.Statistics.TypeOfResource.el_Losses_Cable "Cable Losses",
      choice=IntegraNet.Statistics.TypeOfResource.el_dhw_supply "Electrical Domestic hot water supply",
      choice=IntegraNet.Statistics.TypeOfResource.n_vrd_lower "Lower Voltage Range Deviation",
      choice=IntegraNet.Statistics.TypeOfResource.n_vrd_upper "Upper Voltage Range Deviation"), Dialog(enable=is_setter));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Base.FlowCollector flowCollector annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Energy E(start=0,fixed=true, stateSelect=StateSelect.never);

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  der(E)=flowCollector.unit_flow;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),             Polygon(
          visible=not is_setter,
          points={{-7,19},{-7,-5},{-23,-5},{3,-33},{27,-5},{11,-5},{11,19},{1,19},
              {-7,19}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          origin={3,-37},
          rotation=180),
        Ellipse(
          visible=not is_setter,
          extent={{-34,80},{32,16}},
          lineColor={0,0,0},
          fillColor={255,255,170},
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
          extent={{-100,98},{100,132}},
          lineColor={62,62,62},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          textString="%name"),            Polygon(
          points={{-10,70},{-10,-8},{-46,-8},{4,-76},{46,-8},{12,-8},{12,70},{8,70},{-10,70}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-14,68},{-14,-10},{-50,-10},{0,-78},{42,-10},{8,-10},{8,68},{4,68},{-14,68}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
                                 Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Collects data from a model</p>
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
<p>See Statistics_collector usage for detailed description</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de) on 10.10.2018</span></p>
</html>"));
end LocalCollector;
