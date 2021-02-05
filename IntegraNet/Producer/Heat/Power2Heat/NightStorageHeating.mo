within IntegraNet.Producer.Heat.Power2Heat;
model NightStorageHeating "NSH - Takes in the Heat demand which has been altered to represent the heat delivered by NSH"
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
 //          Outer models
 // _____________________________________________

  outer IntegraNet.Statistics.Statistics_collector statistics_collector;
  outer IntegraNet.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  parameter Real eff = 1 "Efficiency of the night storage heater";

 // _____________________________________________
 //
 //          Interfaces
 // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput Q_demand_sh annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,104}), iconTransformation(
        extent={{-15,-15},{15,15}},
        rotation=-90,
        origin={1,95})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp   annotation (Placement(transformation(extent={{-130,-40},{-102,-12}}), iconTransformation(extent={{-152,-12},{-120,20}})));

 // _____________________________________________
 //
 //          Components
 // _____________________________________________

  IntegraNet.Components.Boundaries.Electrical.ApparentPower.Electric_Consumer Electric_Consumer(useCosPhi=false) annotation (Placement(transformation(extent={{-6,-40},{24,-12}})));

   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer) annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));

  Statistics.LocalCollector output_heating(typeOfResource=IntegraNet.Statistics.TypeOfResource.q_output_NSH) annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Statistics.LocalCollector output_electric(typeOfResource=IntegraNet.Statistics.TypeOfResource.el_demand_NSH) annotation (Placement(transformation(extent={{100,40},{120,60}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Generic) annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));

  Modelica.Blocks.Math.Division division annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-6,54})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=eff) annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
equation

 collectElectricPower.powerCollector.P=Q_demand_sh / eff;
 collectHeatingPower.heatFlowCollector.Q_flow=Q_demand_sh / eff;

 output_heating.flowCollector.unit_flow =Q_demand_sh / eff;
 connect(output_heating.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.q_output_NSH]);

  output_electric.flowCollector.unit_flow =Q_demand_sh / eff;
  connect(output_electric.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.el_demand_NSH]);

  connect(Electric_Consumer.epp, epp) annotation (Line(
      points={{-6.15,-26.14},{-16,-26.14},{-16,-26},{-116,-26}},
      color={0,127,0},
      thickness=0.5));

  connect(modelStatistics.powerCollector[collectElectricPower.typeOfResource],collectElectricPower.powerCollector);
  connect(modelStatistics.heatFlowCollector[collectHeatingPower.typeOfResource],collectHeatingPower.heatFlowCollector);

  connect(division.y, Electric_Consumer.P_el_set) annotation (Line(points={{-6,43},{-6,18},{0,18},{0,-9.2}}, color={0,0,127}));
  connect(Q_demand_sh, division.u1) annotation (Line(points={{0,104},{0,66},{1.77636e-15,66}}, color={0,0,127}));
  connect(realExpression.y, division.u2) annotation (Line(points={{-59,80},{-12,80},{-12,66}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}}), graphics={
        Ellipse(lineColor={0,125,125}, extent={{-126,-126},{128,128}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,80},{80,-80}},
          fillColor={241,240,229},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-58,-46},{-22,-50}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,-46},{18,-50}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-46},{58,-50}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,-54},{-22,-58}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,-54},{18,-58}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-54},{58,-58}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,-62},{-22,-66}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,-62},{18,-66}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-62},{58,-66}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,-70},{-22,-74}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,-70},{18,-74}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-70},{58,-74}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-118,-246},{146,-36}},
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="%name")}),                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of a night storage heating unit </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>For simplicity the passed heat demand is directly with converted to the electricity demand on default. The efficiency can be changed by the param eff. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Philipp Huismann (huismann@gwi-essen.de) on Jan, 2021</p>
</html>"));
end NightStorageHeating;
