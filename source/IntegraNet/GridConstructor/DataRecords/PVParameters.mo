within IntegraNet.GridConstructor.DataRecords;
record PVParameters
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
   parameter Modelica.SIunits.Power P_inst=5000 "Combined installed power";
   parameter Real Tilt=0 "Inclination of surface of PV modules";
   parameter Real Azimuth=0 "Gyration of PV surface; Orientation: +90=West, -90=East, 0=South";
   parameter String PVModuleCharacteristics="Sanyo_HIT_200_BA3" "Characteristics of PV Module" annotation(choices(choice="Sanyo_HIT_200_BA3"));
   parameter SI.Energy E_max_battery=0 "Maximum capacity of the battery";
   parameter SI.Energy E_min_battery=0 "Maximum capacity of the battery";
   parameter SI.Power P_battery=2000 "Charging/discharging power of the battery";
   parameter Real eta_load_battery=0.95 "Conversion efficiency while loading";
   parameter SI.Frequency selfDischargeRate_battery=4e-9 "E.g. 0.5/3600 = 50% discharge per hour, used if no detailed staionary loss model is available";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end PVParameters;
