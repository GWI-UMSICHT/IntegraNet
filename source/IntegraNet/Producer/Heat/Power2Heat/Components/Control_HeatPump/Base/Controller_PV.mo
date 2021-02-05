within IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump.Base;
partial model Controller_PV
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
 //          Imports and Class Hierarchy
 // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Parameters
  // _____________________________________________
  parameter Boolean control_SoC=true "Choose controlled variable, 'true'=SoC, 'false'=Storage temperature" annotation (Dialog(group="Control"),
  choices(choice=true "SoC as controlled variable", choice=false "Storage temperature as controlled variable"));

  // _____________________________________________
  //
  //                   Inputs
  // _____________________________________________

  input Modelica.SIunits.Power  P_HP_el_n=1500 "Nominal electric power of Heatpump";
  input Modelica.SIunits.Temperature T_set=30+273.15;

 // _____________________________________________
 //
 //                   Interfaces
 // _____________________________________________
public
 Modelica.Blocks.Interfaces.RealInput  SoC if control_SoC annotation (Placement(transformation(extent={{-116,-34},{-88,-6}}),
                          iconTransformation(extent={{-122,-20},{-82,20}})));
  TransiEnt.Basics.Interfaces.General.TemperatureOut
                                             T_set_HP annotation (Placement(transformation(extent={{94,40},{118,64}}), iconTransformation(extent={{94,62},{120,88}})));

 TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_set_HP annotation (Placement(transformation(extent={{92,-14},{118,12}}),
        iconTransformation(extent={{92,-12},{118,14}})));

 TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn PV_excess annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={-90,104}), iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={-90,104})));
 TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_set_electricHeater annotation (Placement(transformation(extent={{96,-64},{122,-38}}), iconTransformation(extent={{92,-98},{118,-72}})));
  TransiEnt.Basics.Interfaces.General.TemperatureIn
                                            T if control_SoC==false annotation (Placement(transformation(extent={{-116,6},{-88,34}}), iconTransformation(extent={{-122,-20},{-82,20}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Controller_PV;

