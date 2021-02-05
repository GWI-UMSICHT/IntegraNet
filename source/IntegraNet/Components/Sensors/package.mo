within IntegraNet.Components;
package Sensors
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

  extends TransiEnt.Basics.Icons.Package;

annotation (Icon(graphics={
        Ellipse(
          origin={0,-30},
          fillColor={255,255,255},
          extent={{-90.0,-90.0},{90.0,90.0}},
          startAngle=20.0,
          endAngle=160.0),
        Ellipse(
          origin={0,-30},
          fillColor={128,128,128},
          fillPattern=FillPattern.Solid,
          extent={{-20.0,-20.0},{20.0,20.0}}),
        Line(origin={0,-30}, points={{0.0,60.0},{0.0,90.0}}),
        Ellipse(
          origin={0,-30},
          fillColor={64,64,64},
          fillPattern=FillPattern.Solid,
          extent={{-10.0,-10.0},{10.0,10.0}}),
        Polygon(
          origin={0,-30},
          rotation=-35.0,
          fillColor={64,64,64},
          fillPattern=FillPattern.Solid,
          points={{-7.0,0.0},{-3.0,85.0},{0.0,90.0},{3.0,85.0},{7.0,0.0}})}));
end Sensors;

