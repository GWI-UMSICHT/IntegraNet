within IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump;
model ControlStaticHeatPump_PV_heatDriven "heat-driven static heat pump"
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

  extends IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump.Base.Controller_PV;
  extends TransiEnt.Basics.Icons.Controller;

   //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________

  parameter SI.Temperature TLow_HP=55+273.15 "Temperature limit to switch on the heat pump" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));
  parameter SI.Temperature THigh_HP=65+273.15 "Temperature limit to switch off the heat pump" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));

  parameter SI.Temperature TLow_Heater=40+273.15 "Temperature limit to switch on the heater" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));
  parameter SI.Temperature THigh_Heater=50+273.15 "Temperature limit to switch off the heater" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));

  parameter Real SoCLow_HP=0.5 "SoC limit to switch on the heat pump" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_HP=1 "SoC limit to switch off the heat pump" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real SoCLow_Heater=0.25 "SoC limit to switch on the heater" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_Heater=0.6 "SoC limit to switch off the heater" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real t_min_on_HP=1000 "Minimum on time after startup of the heat pump" annotation (Dialog(group="Control"));
  parameter Real t_min_off_HP=1000 "Minimum off time after shutdown of the heat pump" annotation (Dialog(group="Control"));

  parameter SI.Power P_elHeater=5000 "Nominal electrical power of the electrical heater" annotation (Dialog(group="Heatpump"));

   //___________________________________________________________________________
   //
   //                      Variables
   //___________________________________________________________________________

    Real uHigh_HP;
    Real uLow_HP;
    Real uHigh_Heater;
    Real uLow_Heater;

  // __________________________________________________________________________
  //
  //                   Complex Components
  // ___________________________________________________________________________

public
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={72,1.77636e-015})));
  Modelica.Blocks.Sources.RealExpression zero(y=0) annotation (Placement(transformation(extent={{32,6},{50,24}})));
  Modelica.Blocks.Logical.Not Not
    annotation (Placement(transformation(extent={{-2,-6},{10,6}})));
  Modelica.Blocks.Sources.RealExpression uHigh(y=uHigh_HP)
    annotation (Placement(transformation(extent={{-64,0},{-44,22}})));
  Modelica.Blocks.Sources.RealExpression uLow(y=uLow_HP)
    annotation (Placement(transformation(extent={{-64,-22},{-44,0}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_HP annotation (Placement(transformation(extent={{-28,-8},{-12,8}})));
  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais(
    init_state=2,
    t_min_on=t_min_on_HP,
    t_min_off=t_min_off_HP)
    annotation (Placement(transformation(extent={{34,-6},{46,6}})));
  Modelica.Blocks.Sources.RealExpression P_n_HP(y=P_HP_el_n) annotation (Placement(transformation(extent={{32,-30},{50,-12}})));
  Modelica.Blocks.Sources.RealExpression T_HP(y=T_set) annotation (Placement(transformation(extent={{62,60},{80,82}})));
public
  Modelica.Blocks.Logical.Switch switch2 annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={71,-69})));
  Modelica.Blocks.Sources.RealExpression zero1(y=0) annotation (Placement(transformation(extent={{32,-66},{50,-48}})));
  Modelica.Blocks.Sources.RealExpression P_Heater(y=P_elHeater) annotation (Placement(transformation(extent={{32,-92},{50,-72}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_heater annotation (Placement(transformation(extent={{-26,-76},{-10,-60}})));
  Modelica.Blocks.Sources.RealExpression uHigh1(y=uHigh_Heater)
    annotation (Placement(transformation(extent={{-66,-70},{-46,-48}})));
  Modelica.Blocks.Sources.RealExpression uLow1(y=uLow_Heater) annotation (Placement(transformation(extent={{-66,-90},{-46,-68}})));
  Modelica.Blocks.Logical.Not Not1
    annotation (Placement(transformation(extent={{0,-76},{14,-62}})));
equation
  // ___________________________________________________________________________
  //
  //            Characteristic equations
  // ___________________________________________________________________________

  uHigh_HP=if control_SoC then SoCHigh_HP else THigh_HP;
  uLow_HP=if control_SoC then SoCLow_HP else TLow_HP;
  uHigh_Heater=if control_SoC then SoCHigh_Heater else THigh_Heater;
  uLow_Heater=if control_SoC then SoCLow_Heater else TLow_Heater;
  connect(hysteresis_HP.y, Not.u) annotation (Line(points={{-11.2,0},{-11.2,0},{-3.2,0}},     color={255,0,255}));
  connect(uLow.y, hysteresis_HP.uLow) annotation (Line(points={{-43,-11},{-38,-11},{-38,-6.4},{-28.8,-6.4}}, color={0,0,127}));
  connect(uHigh.y, hysteresis_HP.uHigh) annotation (Line(points={{-43,11},{-43,12},{-38,12},{-38,6},{-28.48,6},{-28.48,6.4}}, color={0,0,127}));
  connect(Not.y, onOffRelais.u) annotation (Line(points={{10.6,0},{10.6,0},{33.76,0}},
                         color={255,0,255}));
  connect(P_n_HP.y, switch1.u1) annotation (Line(points={{50.9,-21},{58,-21},{58,-6.4},{62.4,-6.4}}, color={0,0,127}));
  connect(onOffRelais.y, switch1.u2) annotation (Line(points={{46.6,0},{52,0},{52,2.9976e-015},{62.4,2.9976e-015}},
                                  color={255,0,255}));
  connect(T, hysteresis_HP.u) annotation (Line(points={{-102,20},{-80,20},{-80,0},{-28.8,0}},
                                                                                color={0,0,127}));
  connect(T_HP.y, T_set_HP) annotation (Line(points={{80.9,71},{80.9,52},{106,52}}, color={0,0,127}));
  connect(switch1.y, P_set_HP) annotation (Line(points={{80.8,6.66134e-16},{80.8,-1},{105,-1}},        color={0,0,127}));
  connect(switch2.y, P_set_electricHeater) annotation (Line(points={{78.7,-69},{94,-69},{94,-51},{109,-51}},
                                                                                                     color={0,0,127}));
  connect(zero1.y, switch2.u3) annotation (Line(points={{50.9,-57},{53.45,-57},{53.45,-63.4},{62.6,-63.4}}, color={0,0,127}));
  connect(hysteresis_heater.u, T) annotation (Line(points={{-26.8,-68},{-26.8,-68},{-80,-68},{-80,20},{-102,20}},   color={0,0,127}));
  connect(uHigh1.y, hysteresis_heater.uHigh) annotation (Line(points={{-45,-59},{-36,-59},{-36,-61.6},{-26.48,-61.6}}, color={0,0,127}));
  connect(uLow1.y, hysteresis_heater.uLow) annotation (Line(points={{-45,-79},{-36,-79},{-36,-74.4},{-26.8,-74.4}}, color={0,0,127}));
  connect(hysteresis_heater.y, Not1.u) annotation (Line(points={{-9.2,-68},{-6,-68},{-6,-69},{-1.4,-69}}, color={255,0,255}));
  connect(Not1.y, switch2.u2) annotation (Line(points={{14.7,-69},{14.7,-69},{62.6,-69}}, color={255,0,255}));
  connect(zero.y, switch1.u3) annotation (Line(points={{50.9,15},{58,15},{58,6.4},{62.4,6.4}}, color={0,0,127}));
  connect(P_Heater.y, switch2.u1) annotation (Line(points={{50.9,-82},{56,-82},{56,-74.6},{62.6,-74.6}}, color={0,0,127}));
  connect(SoC, hysteresis_HP.u) annotation (Line(points={{-102,-20},{-80,-20},{-80,0},{-28.8,0}}, color={0,0,127}));
  connect(SoC, hysteresis_heater.u) annotation (Line(points={{-102,-20},{-80,-20},{-80,-68},{-26.8,-68}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller model to set electric input power for heat pump and electric heater as well as heat pump temperature according to storage tank level and PV power</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
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
<p>Created by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), June 2018</p>
</html>"));
end ControlStaticHeatPump_PV_heatDriven;

