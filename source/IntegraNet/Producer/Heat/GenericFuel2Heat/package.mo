within IntegraNet.Producer.Heat;
package GenericFuel2Heat
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
        extent={{-34,-44},{24,-32}},
        lineThickness=0.5,
        fillColor={175,175,175},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Rectangle(
        extent={{-34,56},{24,-38}},
        lineThickness=0.5,
        fillColor={175,175,175},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Ellipse(
        extent={{-34,50},{24,62}},
        lineThickness=0.5,
        fillColor={215,215,215},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Bitmap(
        extent={{-32,-41},{32,41}},
        fileName="modelica://IntegraNet/../../etc/imgs/Generic_Fuel.png",
        origin={-5,4},
        rotation=360)}));
end GenericFuel2Heat;
