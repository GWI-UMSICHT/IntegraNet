within IntegraNet.EnergyConverter.Systems.Control_Battery;
model TimedOperation2 "Timed operation - no charging out of specified hours"
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

  extends IntegraNet.EnergyConverter.Systems.Control_Battery.Base.Controller;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter Real startTime=11 "Time of day to begin charging";
  parameter Real endTime=22 "Time of day to end charging";


  // _____________________________________________
  //
  //          Interfaces
  // _____________________________________________

  Modelica.Blocks.Math.Add add2(k2=-1) annotation (Placement(transformation(extent={{-44,16},{-24,36}})));

  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Components.Control.TimeOfDaySwitch timeOfDaySwitch(startTime=startTime, endTime=endTime) annotation (Placement(transformation(extent={{4,-10},{24,10}})));

  Modelica.Blocks.Math.Min min annotation (Placement(transformation(extent={{-4,-44},{16,-24}})));

  Modelica.Blocks.Sources.RealExpression zero annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

equation

  // _____________________________________________
  //
  //          Connect statements
  // _____________________________________________



  connect(P_PV, add2.u1) annotation (Line(points={{-104,60},{-60,60},{-60,32},{-46,32}},       color={0,0,127}));
  connect(P_Consumer, add2.u2) annotation (Line(points={{-104,-60},{-60,-60},{-60,20},{-46,20}},       color={0,0,127}));
  connect(switch1.y, P_set_battery) annotation (Line(points={{61,0},{104,0}}, color={0,0,127}));
  connect(timeOfDaySwitch.y, switch1.u2) annotation (Line(points={{24.8,0},{24.8,0},{38,0}}, color={255,0,255}));
  connect(add2.y, switch1.u1) annotation (Line(points={{-23,26},{32,26},{32,8},{38,8}}, color={0,0,127}));
  connect(zero.y, min.u2) annotation (Line(points={{-19,-40},{-19,-40},{-6,-40}}, color={0,0,127}));
  connect(add2.y, min.u1) annotation (Line(points={{-23,26},{-14,26},{-14,-28},{-6,-28},{-4,-28},{-6,-28}}, color={0,0,127}));
  connect(min.y, switch1.u3) annotation (Line(points={{17,-34},{30,-34},{30,-8},{38,-8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Control model for a PV battery. Battery charging is only allowed during specific hours of the day, e.g. at midday to reduce the infeed peak.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Modelica.Blocks.Interfaces.RealInput <b>P_PV</b></p>
<p>Modelica.Blocks.Interfaces.RealInput<b> P_Consumer</b></p>
<p>Modelica.Blocks.Interfaces.RealOutput <b>P_set_battery</b></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2018</span></p>
</html>"));
end TimedOperation2;

