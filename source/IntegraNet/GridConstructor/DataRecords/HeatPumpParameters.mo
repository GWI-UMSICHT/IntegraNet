within IntegraNet.GridConstructor.DataRecords;
record HeatPumpParameters
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
    parameter SI.HeatFlowRate Q_flow_n=3.5e3 "Nominal heat flow of heat pump at nominal conditions according to EN14511";
    parameter Real COP_n=3.7 "Heat pump coefficient of performance at nominal conditions according to EN14511";
    parameter String T_source="T_ground" "Temperature of heat source" annotation(choices(choice="T_ground",choice="T_ambient",choice="T_constant",choice="T_other"));
    parameter SI.Power P_el_backup=10e3 "Nominal electric power of the backup heater";
    parameter SI.Temperature T_storage_min=303.15 "Minimum storage temperature of heat pump system";
    parameter SI.Temperature T_storage_max=313.15 "Maximum storage temperature of heat pump system";
    parameter SI.Volume V_storage=0.2 "Volume of the storage of heat pump system";
    parameter SI.Height h_storage=0.5 "Height of heat storage in heat pump system";
    parameter SI.Temp_C T_storage_amb=15 "Assumed constant temperature in tank installation room in heat pump system";
    parameter SI.SurfaceCoefficientOfHeatTransfer k_storage=0.08 "Coefficient of heat transfer through tank surface in heat pump system";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end HeatPumpParameters;

