within IntegraNet.Consumer.Consumer_combined;
model Consumer2 "combined table for electricity, space heating and water heating demand"
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

  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

   parameter Integer startColumn=1 "Starting number of the table column group";

  // _____________________________________________
  //
  //          Interfaces & Classes
  // _____________________________________________

  replaceable IntegraNet.Consumer.Consumer_combined.Data.Demand_Table_combined demand_combined constrainedby Consumer_combined.Base.Demand_combined(consumer_count=startColumn) annotation (Placement(transformation(extent={{-10,16},{10,36}})), choicesAllMatching=true);
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer) annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut demand[3] "Electricity, space heating, water heating" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-98}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={2,-42})));

equation
  // _____________________________________________
  //
  //            Connect statements
  // _____________________________________________

   collectElectricPower.powerCollector.P=demand[1];
   collectHeatingPower.heatFlowCollector.Q_flow =demand[2]+demand[3];

  connect(modelStatistics.powerCollector[TransiEnt.Basics.Types.TypeOfResource.Consumer],collectElectricPower.powerCollector);
  connect(modelStatistics.heatFlowCollector[collectHeatingPower.typeOfResource], collectHeatingPower.heatFlowCollector);
  connect(demand_combined.demand, demand) annotation (Line(
      points={{0,15.6},{0,15.6},{0,-98}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,42},{100,-40}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),                                      Line(points={{-100,-40},{-100,42},{0,100},{100,42},{100,-40},{0,-40},{-100,-40},{-100,-40}}, color={0,0,0}),
        Polygon(
          points={{-100,40},{0,98},{100,38},{-100,40}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Consumer model with combined table for electricity demand as well as heat demand for space heating and domestic hot water. </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>IntegraNet.Basics.Interfaces.General.PowerOut demand</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end Consumer2;

