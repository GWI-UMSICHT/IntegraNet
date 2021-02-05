within IntegraNet.GridConstructor.DataRecords;
record CHPParameters
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
  parameter SI.Efficiency eta_total_CHP=1.05 "CHP overall efficiency";
  parameter SI.Efficiency eta_boiler=1.05 "Boiler efficiency of CHP system";
  parameter SI.Power Q_CHP=4000 "Heat output of CHP";
  parameter SI.Power P_CHP=8000 "Electric power output of CHP";
  parameter SI.Temperature T_storage_max=363.15 "Maximum storage temperature" annotation (HideResult=true);
  parameter SI.Temperature T_storage_min=303.15 "Minimum storage temperature" annotation (HideResult=true);
  parameter SI.Volume V_storage=0.5 "Volume of the Storage" annotation (HideResult=true);
  parameter SI.Height h_storage=1.3 "Height of heat storage" annotation (HideResult=true);
  parameter SI.Temp_C T_storage_amb=15 "Assumed constant temperature in tank installation room" annotation (HideResult=true);
  parameter SI.SurfaceCoefficientOfHeatTransfer k_storage=0.08 "Coefficient of heat Transfer" annotation (HideResult=true);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end CHPParameters;

