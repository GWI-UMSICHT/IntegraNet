within IntegraNet.GridConstructor.DataRecords;
record SolarHeatingParameters
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

 import FT=IntegraNet.Basics.Types.FuelType;

 // _____________________________________________
 //
 //            Parameter
 // _____________________________________________


 //System setup
  parameter Boolean SpaceHeating=true "Does the solar heating system provide energy for space heating?";
  parameter SI.Temperature T_return=308.15 "Return temperature of the heating system";

 //Solar Heating
  parameter SI.Area area=5 "Aperture area";
  parameter SI.Temperature T_set=348.15 "Temperature set point for controller";
  parameter SI.Temperature T_max=368.15 "Maximum input temperature for collector switch-off";
  parameter SI.Angle slope=53.55 "Slope of the tilted surface, assumption";
  parameter SI.Angle azimuth=0 "Surface azimuth angle";

 //Storage
  parameter SI.Volume V=2 "Volume of the storage tank";

 //Boiler
  parameter Real eta_boiler=0.9 "Efficiency of the boiler";
  parameter SI.Temperature T_set_boiler=333.15 "Temperature setpoint of the boiler";
  parameter FT fuel=FT.Gas;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end SolarHeatingParameters;
