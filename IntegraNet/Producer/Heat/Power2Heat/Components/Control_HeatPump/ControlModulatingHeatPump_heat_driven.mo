within IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump;
model ControlModulatingHeatPump_heat_driven "heat-driven modulating heat pump"
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

   //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________

  parameter SI.Temperature TSet_HP=60+273.15 "Setpoint for heat pump operation" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));

  parameter SI.Temperature TLow_HP=55+273.15 "Temperature limit to switch on the heat pump" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));
  parameter SI.Temperature THigh_HP=65+273.15 "Temperature limit to switch off the heat pump" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));

  parameter SI.Temperature TLow_Heater=40+273.15 "Temperature limit to switch on the heater" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));
  parameter SI.Temperature THigh_Heater=50+273.15 "Temperature limit to switch off the heater" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));

  parameter Real SoCSet_HP=0.8 "Setpoint for heat pump operation" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real SoCLow_HP=0.5 "SoC limit to switch on the heat pump" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_HP=1 "SoC limit to switch off the heat pump" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real SoCLow_Heater=0.4 "SoC limit to switch on the heater" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_Heater=0.7 "SoC limit to switch off the heater" annotation (Dialog(group="SoC limits", enable=control_SoC));

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
    Real uSet_HP;

  // __________________________________________________________________________
  //
  //                   Complex Components
  // ___________________________________________________________________________

public
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={61,43})));
  Modelica.Blocks.Sources.RealExpression zero(y=0) annotation (Placement(transformation(extent={{26,50},{40,66}})));
  Modelica.Blocks.Sources.RealExpression Setpoint_HP(y=uSet_HP) annotation (Placement(transformation(extent={{-74,-14},{-56,4}})));
  Modelica.Blocks.Continuous.LimPID PID(
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMin=0,
    k=5,
    yMax=1)
    annotation (Placement(transformation(extent={{-46,-12},{-32,2}})));
  Modelica.Blocks.Logical.Not Not_HP annotation (Placement(transformation(extent={{-30,36},{-18,48}})));
  Modelica.Blocks.Sources.RealExpression uHigh(y=uHigh_HP)
    annotation (Placement(transformation(extent={{-80,46},{-66,60}})));
  Modelica.Blocks.Sources.RealExpression uLow(y=uLow_HP)
    annotation (Placement(transformation(extent={{-78,20},{-64,40}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_HP annotation (Placement(transformation(extent={{-54,34},{-38,50}})));
  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais(
    init_state=2,
    t_min_on=t_min_on_HP,
    t_min_off=t_min_off_HP)
    annotation (Placement(transformation(extent={{26,36},{40,50}})));
  Modelica.Blocks.Sources.RealExpression T_HP(y=T_set) annotation (Placement(transformation(extent={{58,60},{78,80}})));
  Modelica.Blocks.Math.Product gain annotation (Placement(transformation(extent={{20,2},{34,16}})));
  Modelica.Blocks.Sources.RealExpression P_n_HP(y=P_HP_el_n) annotation (Placement(transformation(extent={{-12,-10},{4,6}})));

  Modelica.Blocks.Sources.RealExpression uHigh1(y=uHigh_Heater)
    annotation (Placement(transformation(extent={{-76,-64},{-62,-46}})));
  Modelica.Blocks.Sources.RealExpression uHigh2(y=uLow_Heater)
    annotation (Placement(transformation(extent={{-76,-92},{-60,-76}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_heater annotation (Placement(transformation(extent={{-52,-76},{-36,-60}})));
  Modelica.Blocks.Logical.Not Not_heater annotation (Placement(transformation(extent={{-26,-74},{-14,-62}})));
  Modelica.Blocks.Sources.RealExpression zero1(y=0) annotation (Placement(transformation(extent={{28,-64},{42,-48}})));
  Modelica.Blocks.Sources.RealExpression P_Heater(y=P_elHeater) annotation (Placement(transformation(extent={{30,-92},{44,-74}})));
public
  Modelica.Blocks.Logical.Switch switch2 annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={67,-69})));
equation

  // ___________________________________________________________________________
  //
  //            Characteristic equations
  // ___________________________________________________________________________

  uHigh_HP=if control_SoC then SoCHigh_HP else THigh_HP;
  uLow_HP=if control_SoC then SoCLow_HP else TLow_HP;
  uHigh_Heater=if control_SoC then SoCHigh_Heater else THigh_Heater;
  uLow_Heater=if control_SoC then SoCLow_Heater else TLow_Heater;
  uSet_HP=if control_SoC then SoCSet_HP else TSet_HP;

  connect(zero.y, switch1.u3) annotation (Line(points={{40.7,58},{40.7,58},{46,58},{46,48.6},{52.6,48.6}},
                                                                                     color={0,0,127}));
  connect(hysteresis_HP.y, Not_HP.u) annotation (Line(points={{-37.2,42},{-31.2,42}},            color={255,0,255}));
  connect(Setpoint_HP.y, PID.u_s) annotation (Line(points={{-55.1,-5},{-55.1,-5},{-47.4,-5}}, color={0,0,127}));
  connect(uLow.y, hysteresis_HP.uLow) annotation (Line(points={{-63.3,30},{-60,30},{-60,35.6},{-54.8,35.6}}, color={0,0,127}));
  connect(Not_HP.y, onOffRelais.u) annotation (Line(points={{-17.4,42},{-17.4,43},{25.72,43}},color={255,0,255}));
  connect(onOffRelais.y, switch1.u2) annotation (Line(points={{40.7,43},{40.7,42},{52.6,42},{52.6,43}},
                                              color={255,0,255}));
  connect(SoC, hysteresis_HP.u) annotation (Line(points={{-102,-20},{-84,-20},{-84,42},{-54.8,42}},                   color={0,0,127}));
  connect(T_set_HP, T_HP.y) annotation (Line(points={{106,70},{79,70}}, color={0,0,127}));
  connect(gain.y, switch1.u1) annotation (Line(points={{34.7,9},{34.7,10},{44,10},{44,36},{48,36},{52.6,36},{52.6,37.4}}, color={0,0,127}));
  connect(PID.y, gain.u1) annotation (Line(points={{-31.3,-5},{-20,-5},{-20,13.2},{18.6,13.2}}, color={0,0,127}));
  connect(P_n_HP.y, gain.u2) annotation (Line(points={{4.8,-2},{6,-2},{6,4.8},{18.6,4.8}}, color={0,0,127}));
  connect(Not_heater.y, switch2.u2) annotation (Line(points={{-13.4,-68},{-13.4,-69},{58.6,-69}},
                                                                                                color={255,0,255}));
  connect(uHigh1.y,hysteresis_heater. uHigh) annotation (Line(points={{-61.3,-55},{-58,-55},{-58,-61.6},{-52.48,-61.6}},
                                                                                                                       color={0,0,127}));
  connect(uHigh2.y,hysteresis_heater. uLow) annotation (Line(points={{-59.2,-84},{-58,-84},{-58,-74.4},{-52.8,-74.4}}, color={0,0,127}));
  connect(switch2.y, P_set_electricHeater) annotation (Line(points={{74.7,-69},{74.7,-69},{109,-69}},color={0,0,127}));
  connect(zero1.y, switch2.u3) annotation (Line(points={{42.7,-56},{50.45,-56},{50.45,-63.4},{58.6,-63.4}}, color={0,0,127}));
  connect(SoC, hysteresis_heater.u) annotation (Line(points={{-102,-20},{-84,-20},{-84,-68},{-52.8,-68}},                   color={0,0,127}));
  connect(switch1.y, P_set_HP) annotation (Line(points={{68.7,43},{82,43},{82,0},{108,0}}, color={0,0,127}));
  connect(P_Heater.y, switch2.u1) annotation (Line(points={{44.7,-83},{50,-83},{50,-74.6},{58.6,-74.6}}, color={0,0,127}));
  connect(uHigh.y, hysteresis_HP.uHigh) annotation (Line(points={{-65.3,53},{-60,53},{-60,48.4},{-54.48,48.4}}, color={0,0,127}));
  connect(hysteresis_heater.y, Not_heater.u) annotation (Line(points={{-35.2,-68},{-27.2,-68},{-27.2,-68}}, color={255,0,255}));
  connect(T, hysteresis_HP.u) annotation (Line(points={{-102,20},{-84,20},{-84,42},{-54.8,42}}, color={0,0,127}));
  connect(T, hysteresis_heater.u) annotation (Line(points={{-102,20},{-84,20},{-84,-68},{-52.8,-68}}, color={0,0,127}));
  connect(T, PID.u_m) annotation (Line(points={{-102,20},{-84,20},{-84,-20},{-40,-20},{-40,-13.4},{-39,-13.4}}, color={0,0,127}));
  connect(SoC, PID.u_m) annotation (Line(points={{-102,-20},{-39,-20},{-39,-13.4}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-120},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller model to set electric input power for heat pump and electric heater as well as heat pump temperature according to storage tank level</p>
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
end ControlModulatingHeatPump_heat_driven;

