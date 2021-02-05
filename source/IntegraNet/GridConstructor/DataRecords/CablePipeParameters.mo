within IntegraNet.GridConstructor.DataRecords;
record CablePipeParameters
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

 // _____________________________________________
 //
 //            Parameter
 // _____________________________________________
  parameter ClaRa.Basics.Units.Length diameter_i=0.1 "Inner diameter of the pipe segments in the Basic_Grid_Elements";
  parameter ClaRa.Basics.Units.Length l_pipe=50 "Length of the gas pipe segments in the Basic_Grid_Elements";
  parameter SI.Length l_cable=50 "Length of the cable segments in the Basic_Grid_Elements";
 // parameter IntegraNet.Components.Electrical.Grid.Characteristics.LVCabletypes CableType=IntegraNet.Components.Electrical.Grid.Characteristics.LVCabletypes.K17 "Type of low voltage cable in the Basic_Grid_Elements ";
  parameter SI.Impedance losses=0.00007;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end CablePipeParameters;

