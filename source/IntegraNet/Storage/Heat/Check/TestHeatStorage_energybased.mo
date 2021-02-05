within IntegraNet.Storage.Heat.Check;
model TestHeatStorage_energybased
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  HeatStorage_energybased heatStorage_energybased annotation (Placement(transformation(extent={{-4,-14},{22,12}})));
  Modelica.Blocks.Sources.Step step(
    height=500,
    offset=500,
    startTime=5000) annotation (Placement(transformation(extent={{-58,24},{-38,44}})));
  Modelica.Blocks.Sources.Step step1(
    height=500,
    startTime=20000,
    offset=600) annotation (Placement(transformation(extent={{-58,-48},{-38,-28}})));
  inner Statistics.Statistics_collector statistics_collector annotation (Placement(transformation(extent={{-58,80},{-38,100}})));
  inner SimCenter           simCenter(useHomotopy=false) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
equation
  connect(step.y, heatStorage_energybased.Q_Demand) annotation (Line(points={{-37,34},{-14,34},{-14,6.41},{-2.31,6.41}}, color={0,0,127}));
  connect(step1.y, heatStorage_energybased.Q_Generation) annotation (Line(points={{-37,-38},{-22,-38},{-22,-6.46},{-2.18,-6.46}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), experiment(StopTime=30000),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Tester for IntegraNet.Storage.Heat.HeatStorageStratified_constProp.StratifiedHotWaterStorage_L3_noFluidPorts</p>
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
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2019</span></p>
</html>"));
end TestHeatStorage_energybased;

