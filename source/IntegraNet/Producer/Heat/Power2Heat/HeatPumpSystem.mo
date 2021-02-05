within IntegraNet.Producer.Heat.Power2Heat;
model HeatPumpSystem "Heat pump system with storage and controller, input: heat demand, output: electrical power"
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


  // _____________________________________________
 //
 //          Imports and Class Hierarchy
 // _____________________________________________

  import IntegraNet;
  outer IntegraNet.SimCenter simCenter;
  outer IntegraNet.Statistics.Statistics_collector statistics_collector;
 // _____________________________________________
 //
 //          Parameters
 // _____________________________________________

  parameter SI.TemperatureDifference Delta_T_internal=5 "|Heat pump|Temperature difference between refrigerant and source/sink temperature";
  parameter SI.TemperatureDifference Delta_T_db=2 "|Heat pump|Deadband of hysteresis control";
  parameter SI.HeatFlowRate Q_flow_n=3.5e3 "|Heat pump|Nominal heat flow of heat pump at nominal conditions according to EN14511";
  parameter Real COP_n=3.7 "|Heat pump|Coefficient of performance at nominal conditions according to EN14511";
  SI.Temperature T_set=323.15 "Output temperature of the heat pump" annotation(Dialog(group="Heat pump"));

  parameter SI.Temperature T_s_min=303.15 "|Heat storage|Minimum storage temperature";
  parameter SI.Volume V_Storage=0.5 "|Heat storage|Volume of the Storage";
  parameter SI.Height height=1.3 "|Heat storage|Height of heat storage";
  parameter SI.Temp_C T_amb=15 "|Heat storage|Assumed constant temperature in tank installation room";
  parameter SI.SurfaceCoefficientOfHeatTransfer k=0.08 "|Heat storage|Coefficient of heat transfer through tank surface";

  SI.Temperature T_source=simCenter.ambientConditions.temperature.value+273.15  "Temperature of heat source" annotation (Dialog(group="Heat pump"));

  parameter SI.Power P_el_n=10e3 "|Heat pump|Nominal electric power of the backup heater";
  parameter SI.Efficiency eta_Heater=0.95   "|Heat pump|Efficiency of the backup heater";

 // _____________________________________________
 //
 //          Complex Components
 // _____________________________________________

  IntegraNet.Storage.Heat.HeatStorage_energybased heatStorage(
    T_s_max=T_set,
    T_s_min=T_s_min,
    V_Storage=V_Storage,
    height=height,
    T_amb=T_amb,
    k=k,
    T_s_max_start=T_s_min)
         annotation (Placement(transformation(extent={{48,6},{72,30}})));

  IntegraNet.Producer.Heat.Power2Heat.Components.HeatPump_L0_externalController heatPump(
    Delta_T_internal=Delta_T_internal,
    Delta_T_db=Delta_T_db,
    Q_flow_n=Q_flow_n,
    COP_n=COP_n,
    T_source=T_source) annotation (Placement(transformation(extent={{-16,0},{10,26}})));

  replaceable IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump.ControlModulatingHeatPump_heat_driven controller constrainedby IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump.Base.Controller(P_HP_el_n=heatPump.P_el_n, T_set=T_set) annotation (choicesAllMatching=true, Placement(transformation(extent={{-60,0},{-36,26}})));

 // _____________________________________________
 //
 //          Interfaces
 // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn  Q_Demand annotation (Placement(transformation(
          extent={{-14,-14},{14,14}},
        rotation=270,
        origin={0,100}),                 iconTransformation(extent={{-108,-14},{-82,12}})));

  IntegraNet.Components.Boundaries.Electrical.ApparentPower.Electric_Consumer Electric_Consumer(useCosPhi=false) annotation (Placement(transformation(extent={{58,-62},{76,-44}})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp   annotation (Placement(transformation(extent={{36,-108},{56,-88}})));

  IntegraNet.Producer.Heat.Power2Heat.ElectricBoiler_noFluidPorts electricHeater(P_el_n=P_el_n, eta=eta_Heater) annotation (Placement(transformation(extent={{-38,-48},{-18,-28}})));
  Modelica.Blocks.Math.Add add  annotation (Placement(transformation(extent={{24,-6},{40,10}})));

  IntegraNet.Statistics.LocalCollector wp_heat_output_collector(typeOfResource=IntegraNet.Statistics.TypeOfResource.q_output_HeatPump) annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  IntegraNet.Statistics.LocalCollector wp_electric_demand(typeOfResource=IntegraNet.Statistics.TypeOfResource.el_demand_HeatPump) annotation (Placement(transformation(extent={{40,60},{60,80}})));
  IntegraNet.Statistics.LocalCollector aux_heat_output_collector(typeOfResource=IntegraNet.Statistics.TypeOfResource.q_output_aux_HeatPump) annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  IntegraNet.Statistics.LocalCollector aux_electric_demand(typeOfResource=IntegraNet.Statistics.TypeOfResource.el_demand_aux_HeatPump) annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  wp_heat_output_collector.flowCollector.unit_flow = add.u1;
  connect(wp_heat_output_collector.flowCollector, statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.q_output_HeatPump]);

  wp_electric_demand.flowCollector.unit_flow = -Electric_Consumer.P_el_set;
  connect(wp_electric_demand.flowCollector, statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.el_demand_HeatPump]);


  aux_electric_demand.flowCollector.unit_flow = -electricHeater.P_set;
  connect(aux_electric_demand.flowCollector, statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.el_demand_aux_HeatPump]);

  aux_heat_output_collector.flowCollector.unit_flow = add.u2;
  connect(aux_heat_output_collector.flowCollector, statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.q_output_aux_HeatPump]);


  connect(heatStorage.SoC, controller.SoC) annotation (Line(points={{72.84,18.48},{78,18.48},{78,-12},{-70,-12},{-70,14.1818},{-59.76,14.1818}},color={0,0,127}));
  connect(heatStorage.Q_Demand, Q_Demand) annotation (Line(
      points={{49.56,24.84},{16,24.84},{16,58},{1.77636e-015,58},{1.77636e-015,100}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(controller.P_set_HP, heatPump.P_set_el) annotation (Line(
      points={{-35.4,14.0636},{-22.95,14.0636},{-22.95,10.14},{-16.52,10.14}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(Electric_Consumer.epp, epp) annotation (Line(
      points={{57.91,-53.09},{57.91,-74.04},{46,-74.04},{46,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(controller.P_set_HP, Electric_Consumer.P_el_set) annotation (Line(
      points={{-35.4,14.0636},{-26,14.0636},{-26,-14},{62,-14},{62,-20},{62,-42.2},{61.6,-42.2}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(controller.T_set_HP, heatPump.T_set) annotation (Line(points={{-35.16,23.0455},{-27.58,23.0455},{-27.58,16.9},{-16.52,16.9}}, color={0,0,127}));
  connect(controller.P_set_electricHeater, electricHeater.P_set) annotation (Line(
      points={{-35.4,5.08182},{-28,5.08182},{-28,-28}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(electricHeater.Heat_output, add.u2) annotation (Line(
      points={{-16.8,-38.4},{12,-38.4},{12,-2.8},{22.4,-2.8}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(heatPump.Heat_output, add.u1) annotation (Line(
      points={{11.56,13},{11.56,6.8},{22.4,6.8}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(heatStorage.Q_Generation, add.y) annotation (Line(
      points={{49.68,12.96},{46,12.96},{46,2},{40.8,2}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(electricHeater.epp, epp) annotation (Line(
      points={{-28,-48},{8,-48},{8,-98},{46,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(heatStorage.T, controller.T) annotation (Line(points={{72.84,19.92},{80,19.92},{80,-16},{-76,-16},{-76,14.1818},{-59.76,14.1818}}, color={0,0,127}));
  annotation (Icon(graphics={      Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Rectangle(
          extent={{-38,40},{42,-48}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,8},{-44,8},{-30,8},{-38,-4},{-30,-14},{-48,-14},{-38,-4},{-48,8}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,48},{20,32}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,-40},{22,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,10},{56,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{34,-10},{42,10},{52,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-20,22},{-20,-24},{28,-24}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-20,-22},{-16,-14},{-4,4},{-2,6},{6,12},{16,16},{24,16}},
          color={0,0,255},
          smooth=Smooth.None)}), Diagram(graphics={
        Rectangle(extent={{-96,94},{-32,52}}, lineColor={28,108,200}),
        Text(
          extent={{-102,92},{-66,86}},
          lineColor={28,108,200},
          textString="Output"),
        Text(
          extent={{10,94},{68,78}},
          lineColor={28,108,200},
          textString="Demand
"),     Rectangle(extent={{24,94},{88,52}}, lineColor={28,108,200})}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Combination of storage tank, heat pump, supplementary electric heater and controller</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>All components use energy based modeling without consideration of fluid flow.</p> 
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model from TransiEnt 1.1.0 modified by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), Nov 2019</p>
</html>"));
end HeatPumpSystem;

