within IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump;
model ControlModulatingHeatPump_priceoriented "price-oriented modulating heat pump"
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
  import IntegraNet;

  extends IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump.Base.Controller;
  extends TransiEnt.Basics.Icons.Controller;

  outer IntegraNet.SimCenter simCenter;

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

  parameter SI.Temperature TSet_HP=60+273.15 "Setpoint for heat pump operation" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));

  parameter Real SoCLow_HP=0.5 "SOC limit to switch on the heat pump" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_HP=0.7 "SOC limit to switch off the heat pump" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real SoCLow2_HP=0.7 "SOC limit to switch on the heat pump in case of high prize for electricity" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh2_HP=1 "SOC limit to switch off the heat pump in case of high prize for electricity" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real SoCLow_Heater=0.25 "SOC limit to switch on the heater" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_Heater=0.6 "SOC limit to switch off the heater" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real SoCSet_HP=1 "Setpoint for heat pump operation" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real t_min_on_CHP=1000 "Minimum on time after startup of the HP" annotation (Dialog(group="Control"));
  parameter Real t_min_off_CHP=1000 "Minimum off time after shutdown of the HP" annotation (Dialog(group="Control"));

  parameter SI.Volume V_Storage=0.5 "Volume of the Storage" annotation (Dialog(group="Heatpump"));

  parameter SI.Power P_elHeater=5000 "Nominal electrical power of the electrical heater" annotation (Dialog(group="Heatpump"));

  parameter Real Price_Threshold(unit="€/Kwh") = 0.05 "Price limit for the operation of the CHP" annotation (Dialog(group="Control"));

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
    Real uSet_HP;

  // __________________________________________________________________________
  //
  //                   Complex Components
  // ___________________________________________________________________________

  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={75,39})));
  Modelica.Blocks.Sources.RealExpression zero(y=0) annotation (Placement(transformation(extent={{46,44},{56,56}})));
  Modelica.Blocks.Sources.RealExpression Setpoint_HP(y=uSet_HP) annotation (Placement(transformation(extent={{-10,-46},{6,-30}})));
  Modelica.Blocks.Continuous.LimPID PID(
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMin=0,
    k=5,
    yMax=1)
    annotation (Placement(transformation(extent={{14,-40},{24,-30}})));
  Modelica.Blocks.Logical.Not Not annotation (Placement(transformation(extent={{-30,-10},{-22,-2}})));
  Modelica.Blocks.Sources.RealExpression uHigh(y=uHigh_HP)
    annotation (Placement(transformation(extent={{-7,-8},{7,8}},
        rotation=0,
        origin={-67,0})));
  Modelica.Blocks.Sources.RealExpression uLow(y=uLow_HP)
    annotation (Placement(transformation(extent={{-74,-22},{-60,-6}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_lowerStoragePart annotation (Placement(transformation(extent={{-48,-12},{-36,0}})));
  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais(
    init_state=2,
    t_min_on=t_min_on_CHP,
    t_min_off=t_min_off_CHP)
    annotation (Placement(transformation(extent={{44,34},{56,46}})));
  Modelica.Blocks.Sources.RealExpression T_HP(y=T_set) annotation (Placement(transformation(extent={{58,60},{78,80}})));
  Modelica.Blocks.Math.Product  gain1
    annotation (Placement(transformation(extent={{36,-48},{50,-34}})));
  Modelica.Blocks.Sources.RealExpression P_n_HP(y=P_HP_el_n) annotation (Placement(transformation(extent={{12,-64},{28,-48}})));

  Modelica.Blocks.Sources.RealExpression uHigh1(y=uHigh_Heater)
    annotation (Placement(transformation(extent={{-76,-84},{-62,-68}})));
  Modelica.Blocks.Sources.RealExpression uLow1(y=uLow_Heater) annotation (Placement(transformation(extent={{-76,-102},{-60,-86}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_heater annotation (Placement(transformation(extent={{-50,-90},{-38,-78}})));
  Modelica.Blocks.Logical.Not Not1
    annotation (Placement(transformation(extent={{-32,-88},{-24,-80}})));
  Modelica.Blocks.Sources.RealExpression zero1(y=0) annotation (Placement(transformation(extent={{34,-82},{48,-68}})));
  Modelica.Blocks.Sources.RealExpression P_Heater(y=P_elHeater) annotation (Placement(transformation(extent={{34,-100},{50,-84}})));

  Modelica.Blocks.Logical.Switch switch2 annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={72,-84})));
  Modelica.Blocks.Logical.Or  and2
    annotation (Placement(transformation(extent={{22,46},{34,34}})));
  Modelica.Blocks.Logical.LessThreshold    hysteresis(threshold=Price_Threshold)
                                                                                annotation (Placement(transformation(extent={{-28,80},{-16,92}})));
  Modelica.Blocks.Sources.RealExpression electricityPrice(y=simCenter.electricityPrice.price)
    annotation (Placement(transformation(extent={{-52,78},{-36,96}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-8,52},{2,62}})));
  Modelica.Blocks.Sources.RealExpression uHigh2(y=uHigh2_HP)
    annotation (Placement(transformation(extent={{-76,40},{-60,58}})));
  Modelica.Blocks.Sources.RealExpression uLow2(y=uLow2_HP)
    annotation (Placement(transformation(extent={{-76,24},{-60,42}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_upperStoragePart annotation (Placement(transformation(extent={{-50,36},{-38,48}})));
  Modelica.Blocks.Logical.Not Not2
    annotation (Placement(transformation(extent={{-32,38},{-24,46}})));
equation

  // ___________________________________________________________________________
  //
  //            Characteristic equations
  // ___________________________________________________________________________

   P_highprize=if simCenter.electricityPrice.price >= Price_Threshold then P_set_HP + P_set_electricHeater else 0;
   P_lowprize=if simCenter.electricityPrice.price < Price_Threshold then P_set_HP + P_set_electricHeater else 0;
   der(t_highprize)=if simCenter.electricityPrice.price >= Price_Threshold then 1 else 0;
   der(t_lowprize)=if simCenter.electricityPrice.price < Price_Threshold then 1 else 0;
   der(t_HP_highprize)=if simCenter.electricityPrice.price >= Price_Threshold and P_set_HP+P_set_electricHeater > 0 then 1 else 0;
   der(t_HP_lowprize)=if simCenter.electricityPrice.price < Price_Threshold and P_set_HP+P_set_electricHeater > 0 then 1 else 0;

  uHigh_HP=if control_SoC then SoCHigh_HP else THigh_HP;
  uLow_HP=if control_SoC then SoCLow_HP else TLow_HP;
  uHigh2_HP=if control_SoC then SoCHigh2_HP else THigh_HP;
  uLow2_HP=if control_SoC then SoCLow2_HP else TLow_HP;
  uHigh_Heater=if control_SoC then SoCHigh_Heater else THigh_Heater;
  uLow_Heater=if control_SoC then SoCLow_Heater else TLow_Heater;
  uSet_HP=if control_SoC then SoCSet_HP else TSet_HP;

  connect(hysteresis_lowerStoragePart.y, Not.u) annotation (Line(points={{-35.4,-6},{-35.4,-6},{-30.8,-6}},
                                                                                                       color={255,0,255}));
  connect(Setpoint_HP.y, PID.u_s) annotation (Line(points={{6.8,-38},{6.8,-35},{13,-35}},     color={0,0,127}));
  connect(uLow.y, hysteresis_lowerStoragePart.uLow) annotation (Line(points={{-59.3,-14},{-60,-14},{-60,-10.8},{-48.6,-10.8}},
                                                                                                                             color={0,0,127}));
  connect(onOffRelais.y, switch1.u2) annotation (Line(points={{56.6,40},{56.6,40},{66.6,40},{66.6,39}},
                                              color={255,0,255}));
  connect(SoC, hysteresis_lowerStoragePart.u) annotation (Line(points={{-102,-20},{-84,-20},{-84,-6},{-48.6,-6}},                 color={0,0,127}));
  connect(T_set_HP, T_HP.y) annotation (Line(points={{106,70},{79,70}}, color={0,0,127}));
  connect(P_n_HP.y, gain1.u2) annotation (Line(points={{28.8,-56},{32,-56},{32,-45.2},{34.6,-45.2}}, color={0,0,127}));
  connect(Not1.y, switch2.u2) annotation (Line(points={{-23.6,-84},{-23.6,-84},{64.8,-84}},
                                                                                          color={255,0,255}));
  connect(hysteresis_heater.y, Not1.u) annotation (Line(points={{-37.4,-84},{-37.4,-84},{-32.8,-84}},         color={255,0,255}));
  connect(uHigh1.y,hysteresis_heater. uHigh) annotation (Line(points={{-61.3,-76},{-58,-76},{-58,-79.2},{-50.36,-79.2}},
                                                                                                                       color={0,0,127}));
  connect(uLow1.y, hysteresis_heater.uLow) annotation (Line(points={{-59.2,-94},{-58,-94},{-58,-88.8},{-50.6,-88.8}}, color={0,0,127}));
  connect(switch2.y, P_set_electricHeater) annotation (Line(points={{78.6,-84},{78,-84},{86,-84},{86,-69},{109,-69}},
                                                                                                     color={0,0,127}));
  connect(zero1.y, switch2.u3) annotation (Line(points={{48.7,-75},{60.45,-75},{60.45,-79.2},{64.8,-79.2}}, color={0,0,127}));
  connect(SoC, hysteresis_heater.u) annotation (Line(points={{-102,-20},{-84,-20},{-84,-84},{-50.6,-84}},                   color={0,0,127}));
  connect(switch1.y, P_set_HP) annotation (Line(points={{82.7,39},{90,39},{90,0},{108,0}}, color={0,0,127}));
  connect(and2.y, onOffRelais.u) annotation (Line(points={{34.6,40},{40,40},{43.76,40}},         color={255,0,255}));
  connect(electricityPrice.y, hysteresis.u) annotation (Line(points={{-35.2,87},{-29.2,87},{-29.2,86}},
                                                                                                      color={0,0,127}));
  connect(P_Heater.y, switch2.u1) annotation (Line(points={{50.8,-92},{60,-92},{60,-88.8},{64.8,-88.8}}, color={0,0,127}));
  connect(SoC, PID.u_m) annotation (Line(points={{-102,-20},{-84,-20},{-84,-48},{19,-48},{19,-41}},                     color={0,0,127}));
  connect(gain1.y, switch1.u1) annotation (Line(points={{50.7,-41},{50.7,-42},{64,-42},{64,33.4},{66.6,33.4}}, color={0,0,127}));
  connect(zero.y, switch1.u3) annotation (Line(points={{56.5,50},{64,50},{64,44.6},{66.6,44.6}}, color={0,0,127}));
  connect(hysteresis.y, and1.u1) annotation (Line(points={{-15.4,86},{-14,86},{-14,57},{-9,57}}, color={255,0,255}));
  connect(and1.y, and2.u2) annotation (Line(points={{2.5,57},{2.5,44.8},{20.8,44.8}}, color={255,0,255}));
  connect(uHigh2.y, hysteresis_upperStoragePart.uHigh) annotation (Line(points={{-59.2,49},{-56,49},{-56,46.8},{-50.36,46.8}}, color={0,0,127}));
  connect(uLow2.y, hysteresis_upperStoragePart.uLow) annotation (Line(points={{-59.2,33},{-54,33},{-54,37.2},{-50.6,37.2}}, color={0,0,127}));
  connect(hysteresis_upperStoragePart.y, Not2.u) annotation (Line(points={{-37.4,42},{-37.4,42},{-32.8,42}},
                                                                                                           color={255,0,255}));
  connect(Not2.y, and1.u2) annotation (Line(points={{-23.6,42},{-14,42},{-14,53},{-9,53}}, color={255,0,255}));
  connect(SoC, hysteresis_upperStoragePart.u) annotation (Line(points={{-102,-20},{-84,-20},{-84,42},{-50.6,42}},      color={0,0,127}));
  connect(Not.y, and2.u1) annotation (Line(points={{-21.6,-6},{10,-6},{10,40},{20.8,40}},
                                                                                       color={255,0,255}));
  connect(PID.y, gain1.u1) annotation (Line(points={{24.5,-35},{28.25,-35},{28.25,-36.8},{34.6,-36.8}}, color={0,0,127}));
  connect(uHigh.y, hysteresis_lowerStoragePart.uHigh) annotation (Line(points={{-59.3,0},{-54,0},{-54,-1.2},{-48.36,-1.2}}, color={0,0,127}));
  connect(T, hysteresis_upperStoragePart.u) annotation (Line(points={{-102,20},{-84,20},{-84,42},{-50.6,42}}, color={0,0,127}));
  connect(T, hysteresis_lowerStoragePart.u) annotation (Line(points={{-102,20},{-84,20},{-84,-6},{-48.6,-6}}, color={0,0,127}));
  connect(T, PID.u_m) annotation (Line(points={{-102,20},{-84,20},{-84,-48},{18,-48},{18,-41},{19,-41}}, color={0,0,127}));
  connect(T, hysteresis_heater.u) annotation (Line(points={{-102,20},{-84,20},{-84,-84},{-50.6,-84}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-58,102},{-10,94}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fontSize=9,
          textString="Check if Price < Threshold"),
        Rectangle(
          extent={{-56,96},{-10,76}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-88,64},{-22,62}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fontSize=9,
          textString="SoC Threshold for upper part of storage volume
for operation at low price"),
        Rectangle(
          extent={{-78,58},{-20,26}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-78,8},{-20,-20}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-84,-28},{-18,-30}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fontSize=9,
          textString="SoC Threshold for lower part
of storage volume for backup 
operation at high price"),
        Rectangle(
          extent={{-12,-26},{54,-60}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-8,-22},{58,-24}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fontSize=9,
          textString="Modulation of heat pump power"),
        Rectangle(
          extent={{-80,-68},{-20,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-82,-64},{-16,-66}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fontSize=9,
          textString="Operation of backup heater if SoC too low")}),     Icon(
        coordinateSystem(extent={{-100,-120},{100,100}})),
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
end ControlModulatingHeatPump_priceoriented;

