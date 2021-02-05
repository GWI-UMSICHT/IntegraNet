within IntegraNet.Storage.Heat.Check;
model TestStratifiedHotWaterStorage_noFluidPorts
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

  inner SimCenter           simCenter(useHomotopy=false) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  HeatStorageStratified_constProp.StratifiedHotWaterStorage_L3_noFluidPorts                         storage(
    N_cv=3,
    T_start=fill(273.15 + 30, 3),
    Volume_segments={0.2*2,0.5*2,0.3*2},
    V=2) annotation (Placement(transformation(extent={{-44,-14},{-24,6}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1 annotation (Placement(transformation(extent={{16,26},{2,40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation (Placement(transformation(extent={{18,8},{4,22}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow3 annotation (Placement(transformation(extent={{18,-18},{4,-4}})));
  Modelica.Blocks.Sources.RealExpression Q_flow1(y=100) annotation (Placement(transformation(extent={{60,32},{44,44}})));
  Modelica.Blocks.Sources.RealExpression Q_flow2(y=20)                                               annotation (Placement(transformation(extent={{60,4},{44,16}})));
  Modelica.Blocks.Sources.RealExpression Q_flow3(y=-100)                                             annotation (Placement(transformation(extent={{60,-20},{44,-8}})));
  inner Statistics.Statistics_collector statistics_collector annotation (Placement(transformation(extent={{-58,80},{-38,100}})));
equation
  connect(storage.port[1], prescribedHeatFlow1.port) annotation (Line(points={{-24.8,1.63333},{-24.8,33.15},{2,33.15},{2,33}}, color={191,0,0}));
  connect(storage.port[2], prescribedHeatFlow.port) annotation (Line(points={{-24.8,2.3},{-18.4,2.3},{-18.4,15},{4,15}}, color={191,0,0}));
  connect(storage.port[3], prescribedHeatFlow3.port) annotation (Line(points={{-24.8,2.96667},{-12.4,2.96667},{-12.4,-11},{4,-11}}, color={191,0,0}));
  connect(Q_flow1.y, prescribedHeatFlow1.Q_flow) annotation (Line(points={{43.2,38},{26,38},{26,33},{16,33}}, color={0,0,127}));
  connect(Q_flow2.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{43.2,10},{32,10},{32,15},{18,15}}, color={0,0,127}));
  connect(Q_flow3.y, prescribedHeatFlow3.Q_flow) annotation (Line(points={{43.2,-14},{30,-14},{30,-11},{18,-11}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Documentation(info="<html>
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
end TestStratifiedHotWaterStorage_noFluidPorts;

