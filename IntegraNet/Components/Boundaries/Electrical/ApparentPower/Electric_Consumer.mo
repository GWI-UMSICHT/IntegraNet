within IntegraNet.Components.Boundaries.Electrical.ApparentPower;
model Electric_Consumer "L2 Active and reactive power by parameter or inputs"

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
// This component is a modification of model ApparentPower from TransiEnt Library, //
// version: 1.0.0                                                                  //
//

  // CHANGES:
  //  Equation for reactive power requested by the consumer: Q  = f(cosphi, P)
  //  Equation for power P and reactive power Q drawn by the consumer depending on the actual voltage and frequency in the grid
  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.ElectricSink;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Boolean useInputConnectorP=true
    "Gets parameter from input connector" annotation (
    Evaluate=true,
    HideResult=true,
    choices(__Dymola_checkBox=true),
    Dialog(group="Boundary"));

  parameter SI.Power P_el_set_const=0 "Constant boundary"
    annotation (Dialog(group="Boundary", enable=not useInputConnectorP));

  parameter Boolean useInputConnectorQ=false
    "Gets parameter from input connector" annotation (
    Evaluate=true,
    HideResult=true,
    choices(__Dymola_checkBox=true),
    Dialog(group="Boundary"));

  parameter SI.ReactivePower Q_el_set_const=0 annotation (Dialog(group="Boundary",
        enable=not useInputConnectorQ and not useCosPhi));

  parameter Boolean useCosPhi=true annotation (
    Evaluate=true,
    HideResult=true,
    choices(__Dymola_checkBox=true),
    Dialog(group="Boundary", enable=not useInputConnectorQ));

  parameter SI.PowerFactor cosphi_boundary=0.9 annotation (Dialog(group="Boundary",
        enable=useCosPhi and not useInputConnectorQ));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput P_el_set if useInputConnectorP
    "active power input" annotation (Placement(transformation(extent={{-140,60},
            {-100,100}}, rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,120})));

  Modelica.Blocks.Interfaces.RealInput Q_el_set if useInputConnectorQ
    "reactive power input" annotation (Placement(transformation(extent={{-140,22},
            {-100,62}}, rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,120})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp annotation (
      Placement(transformation(extent={{-102,-10},{-82,10}}),
        iconTransformation(extent={{-118,-16},{-84,14}})));

  // _____________________________________________
  //
  //                Input
  // _____________________________________________

protected
  Modelica.Blocks.Interfaces.RealInput P_internal
    "Needed to connect to conditional connector for active power";
  Modelica.Blocks.Interfaces.RealInput Q_internal
    "Needed to connect to conditional connector for reactive power";

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  if not useInputConnectorP then
    P_internal = P_el_set_const;
  end if;


  // Account for dependency of P from actual voltage v and frequency f in the grid, by using exponents different than 0
  epp.P = P_internal * (epp.v/230)^0 * (epp.f/50)^0;

  if not useInputConnectorQ then
    Q_internal = Q_el_set_const;
  end if;

  if useCosPhi and not useInputConnectorQ then


  // Q  = f(cosphi, P)
  // Account for dependency of Q from actual voltage v and frequency f in the grid, by using exponents different than 0

    epp.Q = ((P_internal)/cosphi_boundary*sin(acos(cosphi_boundary)))* (epp.v/230)^0 * (epp.f/50)^0;

  else
    epp.Q = (Q_internal)* (epp.v/230)^0 * (epp.f/50)^0;

  end if;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(P_internal, P_el_set);
  connect(Q_internal, Q_el_set);

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Text(
          visible=useInputConnectorP,
          extent={{-96,128},{-74,108}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="P"), Text(
          visible=useInputConnectorQ,
          extent={{24,130},{46,110}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("Q", if useInputConnectorQ then "Q" else ""))}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Electric boundary condition with interface type L2 (real and apparent power, voltage and frequency).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarsk for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Michael Djukow in 2017</span></p>
</html>"));
end Electric_Consumer;

