within IntegraNet.Components.Electrical;
package Grid
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
      Line(
        points={{-40,68},{-40,-40}},
        color={0,0,0},
        smooth=Smooth.None),
      Line(
        points={{0,68},{0,-40}},
        color={0,0,0},
        smooth=Smooth.None),
      Line(
        points={{42,68},{42,-40}},
        color={0,0,0},
        smooth=Smooth.None),
      Line(
        points={{0,54},{0,-54}},
        color={0,0,0},
        smooth=Smooth.None,
        origin={0,48},
        rotation=90),
      Line(
        points={{0,54},{0,-54}},
        color={0,0,0},
        smooth=Smooth.None,
        origin={0,12},
        rotation=90),
      Line(
        points={{0,54},{0,-54}},
        color={0,0,0},
        smooth=Smooth.None,
        origin={2,-22},
        rotation=90)}));
end Grid;

