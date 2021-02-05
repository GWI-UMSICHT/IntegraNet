within IntegraNet.Producer.Electrical;
package Photovoltaics
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
          extent={{-8,76},{-54,30}},
          lineColor={255,128,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere),
        Line(
          points={{-28,6},{-28,-42}},
          color={255,191,0},
          smooth=Smooth.None),
        Line(
          points={{0,24},{-36,-16}},
          color={255,191,0},
          smooth=Smooth.None,
          origin={34,12},
          rotation=90),
        Line(
          points={{0,24},{0,-24}},
          color={255,191,0},
          smooth=Smooth.None,
          origin={44,54},
          rotation=90)}));
end Photovoltaics;

