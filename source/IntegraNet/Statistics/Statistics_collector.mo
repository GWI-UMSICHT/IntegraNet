within IntegraNet.Statistics;
model Statistics_collector
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


  final parameter Integer nTypesOfResource= 40   annotation (HideResult=true);

  parameter Integer nConsumer = 10 "Number of consumers/nodes present in the Simulation";


  IntegraNet.Statistics.Base.GlobalCollector globalCollector(nConsumer=nConsumer, final nTypes=nTypesOfResource) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  IntegraNet.Statistics.Base.FlowCollector flowCollector[nTypesOfResource];

equation

  for i in 1:nTypesOfResource loop
    flowCollector[i].unit_flow = globalCollector.Collector[i];
  end for;

annotation (
  defaultComponentName="statistics_collector",
  defaultComponentPrefixes="inner",
        missingInnerMessage=
        "Your model is using an outer \"Statistics_collector\" but it does not contain an inner \"Statistics_collector\" component. Drag model IntegraNet.Statistics.Statistics_collector into your model to make it work.",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{-94,-100}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-94,-94},{100,-100}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-80,-94},{-60,0}},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-40,-94},{-20,40}},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{0,-94},{20,-20}},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{40,-94},{60,80}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}),                                  Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Collects data from models that have a LocalCollector added</p>
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
<p>To have data collected:</p>
<ol>
<li> Place a LocalCollector in your Model of choice</li>
<li>Choose the TypeOfResource to be collected in the LocalCollector</li>
<li>Write the connect statement as follows (fill in #): connect(#LocalCollector#.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.#TYPEOFRESOURCE#]);</li>
<li>Place the Statistics_collector in the model that is simulated.</li>
</ol>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de) on 10.10.2018</span></p>
</html>"));
end Statistics_collector;
