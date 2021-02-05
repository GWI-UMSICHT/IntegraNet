within IntegraNet.Basics;
package Interfaces
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

  extends TransiEnt.Basics.Icons.InterfacesPackage;

  annotation (Icon(graphics={
      Polygon(
        fillColor={102,102,102},
        fillPattern=FillPattern.Solid,
        points={{-100,28},{-60,28},{-30,78},{-10,78},{-10,-62},{-30,-62},{-60,-12},
            {-100,-12}}),
      Polygon(
        origin={20,8},
        lineColor={64,64,64},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        points={{-10.0,70.0},{10.0,70.0},{40.0,20.0},{80.0,20.0},{80.0,-20.0},{
            40.0,-20.0},{10.0,-70.0},{-10.0,-70.0}})}));
end Interfaces;

