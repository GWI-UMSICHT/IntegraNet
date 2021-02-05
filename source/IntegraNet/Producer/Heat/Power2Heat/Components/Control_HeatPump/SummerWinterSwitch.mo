within IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump;
model SummerWinterSwitch "Switch between two distinct days of the year"
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

  parameter Real summer_start = 121 "Day of the year for the start of summer operation";
  parameter Real winter_start = 274 "Day of the year for the end of summer operation";

  Modelica.Blocks.Logical.Greater          greaterThreshold1
    annotation (Placement(transformation(extent={{-22,-40},{-6,-22}})));
  Modelica.Blocks.Sources.RealExpression time_1(y=time) annotation (Placement(transformation(extent={{-70,-28},{-54,-8}})));
  Modelica.Blocks.Sources.RealExpression summer(y=summer_start*24*3600) annotation (Placement(transformation(extent={{-70,-58},{-54,-38}})));
  Modelica.Blocks.Logical.Less             greaterThreshold2
    annotation (Placement(transformation(extent={{-22,44},{-6,62}})));
  Modelica.Blocks.Sources.RealExpression time_2(y=time) annotation (Placement(transformation(extent={{-70,56},{-54,76}})));
  Modelica.Blocks.Sources.RealExpression winter(y=winter_start*24*3600) annotation (Placement(transformation(extent={{-72,18},{-56,38}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{14,4},{30,20}})));
  Modelica.Blocks.Interfaces.BooleanOutput summer_operation "Connector of Boolean output signal" annotation (Placement(transformation(extent={{94,-10},{114,10}})));
equation
  connect(time_1.y, greaterThreshold1.u1) annotation (Line(points={{-53.2,-18},{-42,-18},{-42,-31},{-23.6,-31}}, color={0,0,127}));
  connect(summer.y, greaterThreshold1.u2) annotation (Line(points={{-53.2,-48},{-35.6,-48},{-35.6,-38.2},{-23.6,-38.2}}, color={0,0,127}));
  connect(time_2.y, greaterThreshold2.u1) annotation (Line(points={{-53.2,66},{-52,66},{-52,53},{-23.6,53}}, color={0,0,127}));
  connect(winter.y, greaterThreshold2.u2) annotation (Line(points={{-55.2,28},{-45.6,28},{-45.6,45.8},{-23.6,45.8}}, color={0,0,127}));
  connect(greaterThreshold2.y, and1.u1) annotation (Line(points={{-5.2,53},{-5.2,32.5},{12.4,32.5},{12.4,12}}, color={255,0,255}));
  connect(greaterThreshold1.y, and1.u2) annotation (Line(points={{-5.2,-31},{-5.2,6.5},{12.4,6.5},{12.4,5.6}}, color={255,0,255}));
  connect(and1.y, summer_operation) annotation (Line(points={{30.8,12},{62,12},{62,0},{104,0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                         Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Line(
          points={{-84,0},{90,0}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-80,8},{-80,-8}}, color={0,0,0}),
        Line(
          points={{82,8},{90,0},{84,-10}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-60,8},{-60,-8}}, color={0,0,0}),
        Line(points={{-40,8},{-40,-8}}, color={0,0,0}),
        Line(points={{-20,8},{-20,-8}}, color={0,0,0}),
        Line(points={{0,8},{0,-8}}, color={0,0,0}),
        Line(points={{20,8},{20,-8}}, color={0,0,0}),
        Line(points={{40,8},{40,-8}}, color={0,0,0}),
        Line(points={{60,8},{60,-8}}, color={0,0,0}),
        Line(
          points={{-84,2},{-40,2},{-40,60},{40,60},{40,2},{80,2}},
          color={0,0,255},
          thickness=0.5)}),                                      Diagram(coordinateSystem(preserveAspectRatio=false)));
end SummerWinterSwitch;

