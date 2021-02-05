within IntegraNet.GridConstructor.Systems.Base;
partial model Systems_Base
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

  outer IntegraNet.SimCenter simCenter;
  outer IntegraNet.Statistics.Statistics_collector statistics_collector;
  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  // Every  parameter activates(=1) or deactivates(=0) a certain technology in an extended Systems model.
  // The assignment of the booleans to the specific technologies is carried out in the respective Systems model
  // Approach is needed for the possibility of vector assignment in the Grid_Constructor model

  parameter Boolean onlyElectric=false;

  parameter Integer El_Consumer = 1 annotation (HideResult=true, choices(__Dymola_checkBox=true)); // El_Consumer existant in Systems

  parameter Integer PV=0  annotation (HideResult=true, choices(__Dymola_checkBox=true)); // PV existant in Systems

  parameter Integer CHP=0
    annotation (HideResult=true, choices(__Dymola_checkBox=true)); // CHP existant in Systems

  parameter Integer Boiler=1
    annotation (HideResult=true, choices(__Dymola_checkBox=true));   // Simple Gas Boiler existant in Systems

  parameter Integer HeatPump=1
   annotation (HideResult=true, choices(__Dymola_checkBox=true));   // Heat pump system (heat pump + thermal storage + controller) existant in Systems

  parameter Integer DHN=0
   annotation (HideResult=true, choices(__Dymola_checkBox=true));   // Substation for district heating existant in Systems

  parameter Integer NSH=1
   annotation (HideResult=true, choices(__Dymola_checkBox=true));   // Night storage heating present in Systems


  parameter Integer ST=1
   annotation (HideResult=true, choices(__Dymola_checkBox=true));   // Solar thermal system (solar heating + thermal storage + boiler) existant in Systems

  parameter Integer Oil=1
   annotation (HideResult=true, choices(__Dymola_checkBox=true));

  parameter Integer Biomass=1
   annotation (HideResult=true, choices(__Dymola_checkBox=true));

   parameter IntegraNet.Basics.Types.FuelType fuel_ST=IntegraNet.Basics.Types.FuelType.Gas "choice of fuel";

  // _____________________________________________
  //
  //                   Interfaces
  // _____________________________________________

  // Switch off physical connectors which are not needed (e.g. no gas consuming technologies --> No gas connection to the grid is needed -->  Gas Port is switched off)
  // Approach is needed to allow for a successful compilation of the simulation

  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp if El_Consumer==1 or PV==1   annotation (Placement(transformation(extent={{-90,-108},{-70,-88}})));

  // Real-Input Ports for load profile data

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn el_Demand annotation (
      Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=270,
        origin={-60,94}), iconTransformation(
        extent={{-16,-14},{16,14}},
        rotation=270,
        origin={-62,92})));

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn q_Demand annotation (
      Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=270,
        origin={0,94})));

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn q_Demand_water annotation (
     Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=270,
        origin={60,94})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=simCenter.fluid1) if  DHN==1  annotation (Placement(transformation(extent={{-30,-108},{-10,-88}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=simCenter.fluid1) if  DHN==1  annotation (Placement(transformation(extent={{10,-108},{30,-88}})));
   TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasIn_grid(Medium=simCenter.gasModel1) if Boiler==1 and not onlyElectric or CHP==1 and not onlyElectric or ST==1 and fuel_ST==IntegraNet.Basics.Types.FuelType.Gas and not onlyElectric  annotation (Placement(transformation(extent={{70,-106},{90,-86}})));
  Statistics.LocalCollector El_collector(typeOfResource=IntegraNet.Statistics.TypeOfResource.El_demand) annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Statistics.LocalCollector Heat_collector(typeOfResource=IntegraNet.Statistics.TypeOfResource.Heat_demand) annotation (Placement(transformation(extent={{20,80},{40,100}})));
equation

  El_collector.flowCollector.unit_flow = -el_Demand;
  connect(El_collector.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.El_demand]);

  Heat_collector.flowCollector.unit_flow = -q_Demand;
  connect(Heat_collector.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.Heat_demand]);




  annotation (
    HideResult=true,
    choices(__Dymola_checkBox=true),
    Placement(transformation(extent={{-30,-108},{-10,-88}})),
    Placement(transformation(extent={{10,-108},{30,-88}})),
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,82},{100,-96}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    defaultComponentName="systems",
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Base Class of the systems model </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created during IntegraNet I </span></p>
</html>"));
end Systems_Base;
