within IntegraNet.EnergyConverter.Systems.Control_elHeater.Base;
partial model Controller_elHeater
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

  // _____________________________________________
  //
  //                   Inputs
  // _____________________________________________

 // _____________________________________________
 //
 //                   Interfaces
 // _____________________________________________

 TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut     Q_flow_set_boiler
    annotation (Placement(transformation(extent={{96,34},{122,60}}),
        iconTransformation(extent={{88,30},{114,56}})));

 TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn PV_excess annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={-50,102}), iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={-50,102})));
 TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_set_electricHeater annotation (Placement(transformation(extent={{96,-82},{122,-56}}), iconTransformation(extent={{88,-56},
            {114,-30}})));
  Modelica.Blocks.Interfaces.RealInput SoC
    annotation (Placement(transformation(extent={{-124,-20},{-84,20}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Base control model for an electric heater in combination with a PV plant. </p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Modelica.Blocks.Interfaces.RealInput <b>SoC</b></p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut <b>Q_flow_set_boiler</b></p>
<p>TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut <b>P_set_electricHeater</b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end Controller_elHeater;
