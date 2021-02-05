within IntegraNet.GridConstructor.DataRecords;
record DHNParameters
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

 //Geometry
 parameter SI.Length length = 10 "Length of the pipe";
 parameter Integer DN = 20 "Nominal Diameter of the Pipe";
//  parameter SI.Length diameter_i = 0.0217 "Inner Diameter of the pipe - NOT USED";
//  parameter SI.Length diameter_o =  0.0217 "Inner Diameter of the pipe - NOT USED";
// parameter SI.Length pipe_wall_thickness = 0.003 "Pipe Wall Thickness"annotation(Dialog(group="Geometry",enable=no_DN_Table));
 //--------Heat-Transfer
 parameter SI.ThermalConductivity lambda_insulation = 0.024 " Heattransfercoefficient of the insulation";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end DHNParameters;

