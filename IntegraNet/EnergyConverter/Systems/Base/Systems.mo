within IntegraNet.EnergyConverter.Systems.Base;
partial model Systems
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


  parameter Boolean el_grid annotation(HideResult=true);
  parameter Boolean gas_grid annotation(HideResult=true);
  parameter Boolean DHN annotation(HideResult=true);

  outer IntegraNet.SimCenter simCenter;

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn demand[3] "Electricity, space heating, water heating" annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={0,100})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=medium) if  DHN annotation (Placement(transformation(extent={{-30,-108},{-10,-88}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=medium) if  DHN annotation (Placement(transformation(extent={{10,-108},{30,-88}})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort    epp if      el_grid annotation (Placement(transformation(extent={{-90,-108},{-70,-88}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium1) if  gas_grid annotation (Placement(transformation(extent={{70,-106},{90,-86}})));

protected
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1 if DHN "Heat carrier medium for district heat, if applicable"
                         annotation(choicesAllMatching, Dialog(group="Fluid Definition"));

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium1= simCenter.gasModel1 "Medium to be used for fuel gas, if applicable"
             annotation(choicesAllMatching, Dialog(group="Fluid Definition"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Systems;

