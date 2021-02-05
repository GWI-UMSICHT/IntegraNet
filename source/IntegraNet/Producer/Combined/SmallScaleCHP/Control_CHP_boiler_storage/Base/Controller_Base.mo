within IntegraNet.Producer.Combined.SmallScaleCHP.Control_CHP_boiler_storage.Base;
partial model Controller_Base
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

  extends TransiEnt.Basics.Icons.Controller;

 // _____________________________________________
 //
 //                   Interfaces
 // _____________________________________________

Modelica.Blocks.Interfaces.RealInput                SoC annotation (Placement(transformation(extent={{-116,-14},{-88,14}}),
                          iconTransformation(extent={{-122,-24},{-82,16}})));
  Modelica.Blocks.Interfaces.BooleanOutput to_CHP annotation (Placement(
        transformation(extent={{94,30},{114,50}}), iconTransformation(extent={{94,30},{114,50}})));
TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut to_Boiler annotation (Placement(transformation(extent={{94,-54},{122,-26}}), iconTransformation(extent={{102,-46},{122,-26}})));
 annotation (
   Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
       defaultComponentName="systems",
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller base model for the operation of a CHP unit and a boiler.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica.Blocks.Interfaces.RealInput SoC</p>
<p>Modelica.Blocks.Interfaces.BooleanOutput toCHP</p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut toBoiler</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Yousef Omran, Fraunhofer UMSICHT, 2017</p>
<p>Model revised by Anne Hagemeier, Fraunhofer UMSICHT, 2018</p>
</html>"));
end Controller_Base;

