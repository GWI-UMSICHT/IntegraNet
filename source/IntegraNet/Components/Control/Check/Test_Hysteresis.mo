within IntegraNet.Components.Control.Check;
model Test_Hysteresis
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

  Hysteresis_inputVariable hysteresis_inputVariable annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Sine sine(freqHz=0.1) annotation (Placement(transformation(extent={{-72,-10},{-52,10}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=0.9,
    duration=100,
    offset=0,
    startTime=10) annotation (Placement(transformation(extent={{-82,34},{-62,54}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=-0.5) annotation (Placement(transformation(extent={{-74,-48},{-54,-28}})));
equation
  connect(sine.y, hysteresis_inputVariable.u) annotation (Line(points={{-51,0},{-11,0}}, color={0,0,127}));
  connect(ramp1.y, hysteresis_inputVariable.uHigh) annotation (Line(points={{-61,44},{-26,44},{-26,8},{-10.6,8}}, color={0,0,127}));
  connect(realExpression.y, hysteresis_inputVariable.uLow) annotation (Line(points={{-53,-38},{-24,-38},{-24,-8},{-11,-8}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=150,
      Interval=0.05,
      __Dymola_Algorithm="Dassl"));
end Test_Hysteresis;

