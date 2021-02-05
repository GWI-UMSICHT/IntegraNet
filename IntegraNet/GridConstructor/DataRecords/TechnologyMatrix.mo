within IntegraNet.GridConstructor.DataRecords;
record TechnologyMatrix
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
 parameter Integer El_Consumer=1 "el. consumer";

 parameter Integer Boiler=0 "Boiler";

 parameter Integer CHP=0  "CHP";

 parameter Integer heatPump=0  "heat pump";

 parameter Integer PV=0  "PV";

 parameter Integer DHN=0  "DHN";

 parameter Integer ST=0 "Solar heating";

 parameter Integer NSH=0 "night storage heating";

 parameter Integer Oil=0 "Oil";

 parameter Integer Biomass=0 "Biomass";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TechnologyMatrix;

