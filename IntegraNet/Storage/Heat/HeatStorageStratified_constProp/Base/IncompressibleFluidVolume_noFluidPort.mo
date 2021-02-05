within IntegraNet.Storage.Heat.HeatStorageStratified_constProp.Base;
model IncompressibleFluidVolume_noFluidPort "very simple vontrol volume for incompressible liquids with constant media properties and without FluidPorts based on the model from the TransiEnt Library"
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

// ++++++++                                                                        //
// This component is a modification of model Storage.Heat.HeatStorageStratified_constProp.Base.IncompressibleFluidVolume  //
// from TransiEnt Library, version: 1.0.0                                          //
//


//Changes to TransiEnt model:
  // Removal of FluidPorts
  // Consideration only of energy balance, no mass balance calculated

// _____________________________________________
//
//          Imports and Class Hierarchy
// _____________________________________________

extends ClaRa.Basics.Icons.Volume;

import Modelica.Constants.eps;
import ClaRa;
import SI = Modelica.SIunits;

outer TransiEnt.SimCenter simCenter;

// _____________________________________________
//
//                   Parameters
// _____________________________________________

parameter SI.Volume V=1e3 "Volume";
parameter SI.Density d = 1e3;
parameter SI.SpecificHeatCapacity c_v=4.2e3 "Specific Heat Capacity";
parameter SI.Temperature T_start= 273.15+20 "Start value of sytsem specific enthalpy"
                                                  annotation(Dialog(tab="Initialisation"));

constant SI.Temperature Tref = 273.15 "Reference temperature of incoming enthalpy flows";
final parameter SI.Mass m = V*d "Total system mass";

// _____________________________________________
//
//                   Internal variables
// _____________________________________________

SI.Temperature  T(start=T_start, fixed=true, stateSelect=StateSelect.prefer) "Volume bulk temperature";

// _____________________________________________
//
//                  Interfaces
// _____________________________________________

Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation (Placement(transformation(extent={{-10,86},{10,106}})));

// _____________________________________________
//
//                  Equations
// _____________________________________________

equation

// === Energy balance ===
der(T) = (heatPort.Q_flow)/(m*c_v) "Energy balance";

// === Interface allocation ===
heatPort.T = T;

end IncompressibleFluidVolume_noFluidPort;

