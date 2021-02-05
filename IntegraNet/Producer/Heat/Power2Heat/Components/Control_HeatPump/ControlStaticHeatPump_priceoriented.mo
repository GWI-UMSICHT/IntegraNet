within IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump;
model ControlStaticHeatPump_priceoriented "static heat pump, price-oriented operation"
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

  extends IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump.Base.Controller;
  extends TransiEnt.Basics.Icons.Controller;

   //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________

  parameter SI.Temperature TLow_HP=55+273.15 "Temperature limit to switch on the heat pump" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));
  parameter SI.Temperature THigh_HP=65+273.15 "Temperature limit to switch off the heat pump" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));

  parameter SI.Temperature TLow2_HP=65+273.15 "Temperature limit to switch on the heat pump in case of high prize for electricity" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));
  parameter SI.Temperature THigh2_HP=70+273.15 "Temperature limit to switch off the heat pump in case of high prize for electricity" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));

  parameter SI.Temperature TLow_Heater=40+273.15 "Temperature limit to switch on the heater" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));
  parameter SI.Temperature THigh_Heater=50+273.15 "Temperature limit to switch off the heater" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));

  parameter Real SoCLow_HP=0.5 "SOC limit to switch on the heat pump" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_HP=0.7 "SOC limit to switch off the heat pump" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real SoCLow2_HP=0.7 "SOC limit to switch on the heat pump in case of high prize for electricity" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh2_HP=1 "SOC limit to switch off the heat pump in case of high prize for electricity" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real SoCLow_Heater=0.25 "SOC limit to switch on the heater" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_Heater=0.6 "SOC limit to switch off the heater" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real t_min_on_HP=1000 "Minimum on time after startup of the heat pump" annotation (Dialog(group="Control"));
  parameter Real t_min_off_HP=1000 "Minimum off time after shutdown of the heat pump" annotation (Dialog(group="Control"));

  parameter SI.Power P_elHeater=5000 "Nominal electrical power of the electrical heater" annotation (Dialog(group="Heatpump"));

  parameter Real Price_Threshold(unit="€/Kwh")=0.05 "Price limit for the operation of the CHP" annotation (Dialog(group="Control"));

   //___________________________________________________________________________
   //
   //                      Variables
   //___________________________________________________________________________

  SI.Power P_highprize "Heat pump power during high prize period";
  SI.Power P_lowprize "Heat pump power during low prize period";
  Real t_highprize "Time period with high electricity prizes";
  Real t_lowprize "Time period with low electricity prizes";
  Real t_HP_highprize "Time period with high prizes and heat pump operation";
  Real t_HP_lowprize "Time period with low prizes and heat pump operation";

    Real uHigh_HP;
    Real uLow_HP;
    Real uHigh2_HP;
    Real uLow2_HP;
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
        origin={74,0})));
  Modelica.Blocks.Sources.RealExpression zero(y=0) annotation (Placement(transformation(extent={{34,4},{52,22}})));
  Modelica.Blocks.Logical.Not Not
    annotation (Placement(transformation(extent={{-18,-24},{-8,-14}})));
  Modelica.Blocks.Sources.RealExpression uHigh(y=uHigh2_HP)
    annotation (Placement(transformation(extent={{-66,-20},{-52,-2}})));
  Modelica.Blocks.Sources.RealExpression uLow(y=uLow2_HP)
    annotation (Placement(transformation(extent={{-68,-38},{-52,-20}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_lowerStoragePart annotation (Placement(transformation(extent={{-40,-28},{-24,-12}})));
  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais(
    init_state=2,
    t_min_on=t_min_on_HP,
    t_min_off=t_min_off_HP)
    annotation (Placement(transformation(extent={{42,-6},{54,6}})));
  Modelica.Blocks.Sources.RealExpression P_n_HP(y=P_HP_el_n) annotation (Placement(transformation(extent={{34,-32},{52,-14}})));
  Modelica.Blocks.Sources.RealExpression T_HP(y=T_set) annotation (Placement(transformation(extent={{56,60},{74,82}})));
public
  Modelica.Blocks.Logical.Switch switch2 annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={71,-69})));
  Modelica.Blocks.Sources.RealExpression zero1(y=0) annotation (Placement(transformation(extent={{30,-66},{46,-50}})));
  Modelica.Blocks.Sources.RealExpression P_Heater(y=P_elHeater) annotation (Placement(transformation(extent={{34,-86},{48,-70}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_heater annotation (Placement(transformation(extent={{-40,-78},{-26,-64}})));
  Modelica.Blocks.Sources.RealExpression uHigh1(y=uHigh_Heater)
    annotation (Placement(transformation(extent={{-68,-72},{-52,-56}})));
  Modelica.Blocks.Sources.RealExpression uLow1(y=uLow_Heater) annotation (Placement(transformation(extent={{-68,-88},{-52,-72}})));
  Modelica.Blocks.Logical.Not Not1
    annotation (Placement(transformation(extent={{-18,-76},{-8,-66}})));
  Modelica.Blocks.Sources.RealExpression electricityPrice(y=simCenter.electricityPrice.price)
    annotation (Placement(transformation(extent={{-58,74},{-44,92}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=Price_Threshold) annotation (Placement(transformation(extent={{-32,76},{-18,90}})));
  Modelica.Blocks.Sources.RealExpression uHigh2(y=uHigh_HP)
    annotation (Placement(transformation(extent={{-68,32},{-52,48}})));
  Modelica.Blocks.Sources.RealExpression uLow2(y=uLow_HP)
    annotation (Placement(transformation(extent={{-68,14},{-50,30}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_upperStoragePart annotation (Placement(transformation(extent={{-40,24},{-26,38}})));
  Modelica.Blocks.Logical.Not Not2
    annotation (Placement(transformation(extent={{-18,26},{-8,36}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{2,32},{12,42}})));
  Modelica.Blocks.Logical.Or  and2
    annotation (Placement(transformation(extent={{22,6},{34,-6}})));
equation
  // ___________________________________________________________________________
  //
  //            Characteristic equations
  // ___________________________________________________________________________

   P_highprize=if simCenter.electricityPrice.price >= Price_Threshold then P_set_HP + P_set_electricHeater else 0;
   P_lowprize=if simCenter.electricityPrice.price < Price_Threshold then P_set_HP + P_set_electricHeater else 0;
   der(t_highprize)=if simCenter.electricityPrice.price >= Price_Threshold then 1 else 0;
   der(t_lowprize)=if simCenter.electricityPrice.price < Price_Threshold then 1 else 0;
   der(t_HP_highprize)=if simCenter.electricityPrice.price >= Price_Threshold and P_set_HP + P_set_electricHeater > 0 then 1 else 0;
   der(t_HP_lowprize)=if simCenter.electricityPrice.price < Price_Threshold and P_set_HP + P_set_electricHeater > 0 then 1 else 0;

  uHigh_HP=if control_SoC then SoCHigh_HP else THigh_HP;
  uLow_HP=if control_SoC then SoCLow_HP else TLow_HP;
  uHigh2_HP=if control_SoC then SoCHigh2_HP else THigh2_HP;
  uLow2_HP=if control_SoC then SoCLow2_HP else TLow2_HP;
  uHigh_Heater=if control_SoC then SoCHigh_Heater else THigh_Heater;
  uLow_Heater=if control_SoC then SoCLow_Heater else TLow_Heater;

  connect(hysteresis_lowerStoragePart.y, Not.u) annotation (Line(points={{-23.2,-20},{-23.2,-19},{-19,-19}}, color={255,0,255}));
  connect(uLow.y, hysteresis_lowerStoragePart.uLow) annotation (Line(points={{-51.2,-29},{-48,-29},{-48,-26.4},{-40.8,-26.4}}, color={0,0,127}));
  connect(P_n_HP.y, switch1.u1) annotation (Line(points={{52.9,-23},{58,-23},{58,-6.4},{64.4,-6.4}}, color={0,0,127}));
  connect(onOffRelais.y, switch1.u2) annotation (Line(points={{54.6,0},{64.4,0},{64.4,1.11022e-015}},
                                  color={255,0,255}));
  connect(T_HP.y, T_set_HP) annotation (Line(points={{74.9,71},{74.9,70},{106,70}}, color={0,0,127}));
  connect(switch1.y, P_set_HP) annotation (Line(points={{82.8,-8.88178e-016},{82.8,0},{108,0}},        color={0,0,127}));
  connect(switch2.y, P_set_electricHeater) annotation (Line(points={{78.7,-69},{109,-69}},           color={0,0,127}));
  connect(zero1.y, switch2.u3) annotation (Line(points={{46.8,-58},{53.45,-58},{53.45,-63.4},{62.6,-63.4}}, color={0,0,127}));
  connect(hysteresis_heater.u, SoC) annotation (Line(points={{-40.7,-71},{-82,-71},{-82,-20},{-102,-20}},           color={0,0,127}));
  connect(uHigh1.y, hysteresis_heater.uHigh) annotation (Line(points={{-51.2,-64},{-46,-64},{-46,-65.4},{-40.42,-65.4}},
                                                                                                                       color={0,0,127}));
  connect(uLow1.y, hysteresis_heater.uLow) annotation (Line(points={{-51.2,-80},{-46,-80},{-46,-76.6},{-40.7,-76.6}}, color={0,0,127}));
  connect(hysteresis_heater.y, Not1.u) annotation (Line(points={{-25.3,-71},{-25.3,-71},{-19,-71}},       color={255,0,255}));
  connect(Not1.y, switch2.u2) annotation (Line(points={{-7.5,-71},{-7.5,-69},{62.6,-69}}, color={255,0,255}));
  connect(electricityPrice.y, lessThreshold.u) annotation (Line(points={{-43.3,83},{-43.3,83},{-33.4,83}}, color={0,0,127}));
  connect(uHigh2.y, hysteresis_upperStoragePart.uHigh) annotation (Line(points={{-51.2,40},{-46,40},{-46,36.6},{-40.42,36.6}}, color={0,0,127}));
  connect(uLow2.y, hysteresis_upperStoragePart.uLow) annotation (Line(points={{-49.1,22},{-46,22},{-46,25.4},{-40.7,25.4}}, color={0,0,127}));
  connect(hysteresis_upperStoragePart.y, Not2.u) annotation (Line(points={{-25.3,31},{-19,31}}, color={255,0,255}));
  connect(Not2.y, and1.u2) annotation (Line(points={{-7.5,31},{1,31},{1,33}}, color={255,0,255}));
  connect(lessThreshold.y, and1.u1) annotation (Line(points={{-17.3,83},{-17.3,84},{-4,84},{-4,38},{1,38},{1,37}}, color={255,0,255}));
  connect(Not.y, and2.u1) annotation (Line(points={{-7.5,-19},{16,-19},{16,0},{20.8,0}}, color={255,0,255}));
  connect(SoC, hysteresis_upperStoragePart.u) annotation (Line(points={{-102,-20},{-82,-20},{-82,31},{-40.7,31}},
                                                                                                              color={0,0,127}));
  connect(zero.y, switch1.u3) annotation (Line(points={{52.9,13},{58,13},{58,6.4},{64.4,6.4}}, color={0,0,127}));
  connect(P_Heater.y, switch2.u1) annotation (Line(points={{48.7,-78},{54,-78},{54,-74.6},{62.6,-74.6}}, color={0,0,127}));
  connect(and2.y, onOffRelais.u) annotation (Line(points={{34.6,0},{41.76,0}}, color={255,0,255}));
  connect(and1.y, and2.u2) annotation (Line(points={{12.5,37},{16,37},{16,4.8},{20.8,4.8}}, color={255,0,255}));
  connect(uHigh.y, hysteresis_lowerStoragePart.uHigh) annotation (Line(points={{-51.3,-11},{-46,-11},{-46,-13.6},{-40.48,-13.6}}, color={0,0,127}));
  connect(T, hysteresis_upperStoragePart.u) annotation (Line(points={{-102,20},{-82,20},{-82,31},{-40.7,31}}, color={0,0,127}));
  connect(T, hysteresis_heater.u) annotation (Line(points={{-102,20},{-82,20},{-82,-71},{-40.7,-71}}, color={0,0,127}));
  connect(SoC, hysteresis_lowerStoragePart.u) annotation (Line(points={{-102,-20},{-40.8,-20}}, color={0,0,127}));
  connect(T, hysteresis_lowerStoragePart.u) annotation (Line(points={{-102,20},{-82,20},{-82,-20},{-40.8,-20}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-72,-56},{-4,-88}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-74,-52},{-4,-54}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          textString="SoC Threshold for electric backup heater",
          fontSize=9),
        Rectangle(
          extent={{-62,94},{-10,72}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-58,100},{-10,92}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fontSize=9,
          textString="Check if Price < Threshold"),
        Text(
          extent={{-74,54},{-8,52}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fontSize=9,
          textString="SoC Threshold for upper part of storage volume
for operation at low price"),
        Rectangle(
          extent={{-70,48},{-6,14}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-74,4},{-8,2}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fontSize=9,
          textString="SoC Threshold for lower part of storage volume 
for backup operation at high price"),
        Rectangle(
          extent={{-70,-2},{-6,-36}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash)}),                                   Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller model to set electric input power for heat pump and electric heater as well as heat pump temperature according to storage tank level and electricity prices</p>
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
end ControlStaticHeatPump_priceoriented;

