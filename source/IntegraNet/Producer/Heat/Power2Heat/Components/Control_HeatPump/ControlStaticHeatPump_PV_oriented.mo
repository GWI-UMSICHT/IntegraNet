within IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump;
model ControlStaticHeatPump_PV_oriented "static heat pump, operation preferably when excess PV energy available"
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

  extends IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump.Base.Controller_PV;
  extends TransiEnt.Basics.Icons.Controller;

   //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________

  parameter SI.Temperature TLow_HP=55+273.15  "Temperature limit to switch on the heat pump";
  parameter SI.Temperature THigh_HP=65+273.15 "Temperature limit to switch off the heat pump";

  parameter SI.Temperature THigh2_HP=60+273.15 "Temperature limit to switch off the heat pump in case of no excess PV energy";
  parameter SI.Temperature TLow2_HP=55+273.15  "Temperature limit to switch on the heat pump in the of no excess PV energy";

  parameter SI.Temperature TLow_Heater=50+273.15 "Temperature limit to switch on the heater";
  parameter SI.Temperature THigh_Heater=56+273.15 "Temperature limit to switch off the heater";

  parameter Real SoCLow_HP=0.5  "SOC limit to switch on the heat pump";
  parameter Real SoCHigh_HP=1.2 "SOC limit to switch off the heat pump";

  parameter Real SoCHigh2_HP=0.8 "SOC limit to switch off the heat pump in case of no excess PV energy";
  parameter Real SoCLow2_HP=0.5  "SOC limit to switch on the heat pump in the of no excess PV energy";

  parameter Real SoCLow_Heater=0.25 "SOC limit to switch on the heater";
  parameter Real SoCHigh_Heater=0.6 "SOC limit to switch off the heater";

  parameter Real t_min_on_HP=1800 "Min on time after startup of the heat pump";
  parameter Real t_min_off_HP=1800 "Min off time after shutdown of the heat pump";

  parameter Real Threshold=1000 "Excess PV power to start heat pump operation";

  parameter Real summer_start=121 "Day of the year for the start of summer operation";
  parameter Real winter_start=274 "Day of the year for the end of summer operation";

  parameter SI.Power P_elHeater=5000 "Nominal electrical power of the electrical heater";

   //___________________________________________________________________________
   //
   //                      Variables
   //___________________________________________________________________________

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

  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={81,-21})));
  Modelica.Blocks.Sources.RealExpression zero(y=0) annotation (Placement(transformation(extent={{42,-4},{58,12}})));
  Modelica.Blocks.Logical.Not Not
    annotation (Placement(transformation(extent={{-32,-22},{-22,-12}})));
  Modelica.Blocks.Sources.RealExpression uHigh(y=uHigh_HP)
    annotation (Placement(transformation(extent={{-74,-20},{-58,-4}})));
  Modelica.Blocks.Sources.RealExpression uLow(y=uLow_HP)
    annotation (Placement(transformation(extent={{-76,-34},{-60,-18}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_upperStoragePart annotation (Placement(transformation(extent={{-52,-24},{-38,-10}})));
  Modelica.Blocks.Sources.RealExpression P_n_HP(y=P_HP_el_n) annotation (Placement(transformation(extent={{42,-58},{58,-42}})));
  Modelica.Blocks.Sources.RealExpression T_HP(y=T_set) annotation (Placement(transformation(extent={{62,54},{78,74}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{10,30},{22,42}})));
  Modelica.Blocks.Logical.Greater          greaterThreshold
    annotation (Placement(transformation(extent={{-56,44},{-44,56}})));
  Modelica.Blocks.Sources.RealExpression P_Threshold(y=Threshold) annotation (Placement(transformation(extent={{-94,32},{-80,46}})));

  Modelica.Blocks.Logical.Or  and2
    annotation (Placement(transformation(extent={{42,42},{54,30}})));
  Modelica.Blocks.Sources.RealExpression uHigh2(y=uHigh2_HP)
    annotation (Placement(transformation(extent={{-32,74},{-15,90}})));
  Modelica.Blocks.Sources.RealExpression uLow2(y=uLow2_HP)
    annotation (Placement(transformation(extent={{-30,58},{-14,74}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_lowerStoragePart annotation (Placement(transformation(extent={{-6,68},{8,82}})));
  Modelica.Blocks.Logical.Not not2
    annotation (Placement(transformation(extent={{14,70},{24,80}})));
  IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump.SummerWinterSwitch summerWinterSwitch(summer_start=summer_start, winter_start=winter_start) annotation (Placement(transformation(extent={{4,-28},{18,-16}})));

  Modelica.Blocks.Logical.LogicalSwitch switch3 annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={36,-22})));
  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais2(
    init_state=2,
    t_min_on=t_min_on_HP,
    t_min_off=t_min_off_HP)
    annotation (Placement(transformation(extent={{50,-28},{62,-16}})));

  Modelica.Blocks.Sources.RealExpression uHigh3(y=uHigh_Heater)  annotation (Placement(transformation(extent={{-62,-80},{-46,-66}})));
  Modelica.Blocks.Sources.RealExpression uLow3(y=uLow_Heater) annotation (Placement(transformation(extent={{-58,-96},{-44,-84}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_heater annotation (Placement(transformation(extent={{-32,-90},{-18,-76}})));
  Modelica.Blocks.Logical.Not Not1 annotation (Placement(transformation(extent={{-12,-88},{-2,-78}})));
  Modelica.Blocks.Sources.RealExpression zero1(y=0) annotation (Placement(transformation(extent={{24,-78},{40,-62}})));
  Modelica.Blocks.Sources.RealExpression P_Heater(y=P_elHeater) annotation (Placement(transformation(extent={{24,-102},{40,-84}})));
  Modelica.Blocks.Logical.Switch switch2 annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={68,-82})));
equation
  // ___________________________________________________________________________
  //
  //            Characteristic equations
  // ___________________________________________________________________________

  uHigh_HP=if control_SoC then SoCHigh_HP else THigh_HP;
  uLow_HP=if control_SoC then SoCLow_HP else TLow_HP;
  uHigh2_HP=if control_SoC then SoCHigh2_HP else THigh2_HP;
  uLow2_HP=if control_SoC then SoCLow2_HP else TLow2_HP;
  uHigh_Heater=if control_SoC then SoCHigh_Heater else THigh_Heater;
  uLow_Heater=if control_SoC then SoCLow_Heater else TLow_Heater;

  connect(uLow.y, hysteresis_upperStoragePart.uLow) annotation (Line(points={{-59.2,-26},{-56,-26},{-56,-22.6},{-52.7,-22.6}}, color={0,0,127}));
  connect(uHigh.y, hysteresis_upperStoragePart.uHigh) annotation (Line(points={{-57.2,-12},{-57.2,-12},{-58,-12},{-58,-11.4},{-52.42,-11.4}}, color={0,0,127}));
  connect(P_n_HP.y, switch1.u1) annotation (Line(points={{58.8,-50},{66,-50},{66,-26.6},{72.6,-26.6}}, color={0,0,127}));
  connect(SoC, hysteresis_upperStoragePart.u) annotation (Line(points={{-102,-20},{-80,-20},{-80,-18},{-52.7,-18},{-52.7,-17}},
                                                                                                                              color={0,0,127}));
  connect(T_HP.y, T_set_HP) annotation (Line(points={{78.8,64},{78.8,52},{106,52}}, color={0,0,127}));
  connect(greaterThreshold.y, and1.u1) annotation (Line(points={{-43.4,50},{-43.4,36},{8.8,36}},             color={255,0,255}));
  connect(and1.y, and2.u1) annotation (Line(points={{22.6,36},{40.8,36}},                 color={255,0,255}));
  connect(not2.y, and2.u2) annotation (Line(points={{24.5,75},{36,75},{36,40.8},{40.8,40.8}},           color={255,0,255}));
  connect(hysteresis_lowerStoragePart.y, not2.u) annotation (Line(points={{8.7,75},{13,75}},                        color={255,0,255}));
  connect(uHigh2.y, hysteresis_lowerStoragePart.uHigh) annotation (Line(points={{-14.15,82},{-10.725,82},{-10.725,80.6},{-6.42,80.6}},  color={0,0,127}));
  connect(uLow2.y, hysteresis_lowerStoragePart.uLow) annotation (Line(points={{-13.2,66},{-9.225,66},{-9.225,69.4},{-6.7,69.4}},    color={0,0,127}));
  connect(SoC, hysteresis_lowerStoragePart.u) annotation (Line(points={{-102,-20},{-86,-20},{-86,24},{-36,24},{-36,52},{-36,74},{-36,74},{-8,74},{-8,75},{-6.7,75}},
                                                                                                                                  color={0,0,127}));
  connect(summerWinterSwitch.summer_operation,switch3. u2) annotation (Line(points={{18.28,-22},{18.28,-22},{28.8,-22}},
                                                                                                             color={255,0,255}));
  connect(switch1.y, P_set_HP) annotation (Line(points={{88.7,-21},{88.7,-1},{105,-1}},   color={0,0,127}));
  connect(and2.y,switch3. u1) annotation (Line(points={{54.6,36},{62,36},{62,22},{24,22},{24,-17.2},{28.8,-17.2}},
                                                                                                   color={255,0,255}));
  connect(switch3.y, onOffRelais2.u) annotation (Line(points={{42.6,-22},{49.76,-22}}, color={255,0,255}));
  connect(onOffRelais2.y, switch1.u2) annotation (Line(points={{62.6,-22},{64,-22},{64,-21},{72.6,-21}}, color={255,0,255}));
  connect(Not.y, and1.u2) annotation (Line(points={{-21.5,-17},{-4,-17},{-4,31.2},{8.8,31.2}},     color={255,0,255}));
  connect(Not.y,switch3. u3) annotation (Line(points={{-21.5,-17},{-4,-17},{-4,-32},{24,-32},{24,-26.8},{28.8,-26.8}},
                                                                                                     color={255,0,255}));
  connect(zero.y, switch1.u3) annotation (Line(points={{58.8,4},{62,4},{62,-15.4},{72.6,-15.4}}, color={0,0,127}));
  connect(PV_excess, greaterThreshold.u1) annotation (Line(points={{-90,104},{-98,104},{-98,50},{-57.2,50}},          color={0,127,127}));
  connect(hysteresis_heater.u, SoC) annotation (Line(points={{-32.7,-83},{-32.7,-83},{-86,-83},{-86,-20},{-102,-20}},
                                                                                                                    color={0,0,127}));
  connect(zero1.y,switch2. u3) annotation (Line(points={{40.8,-70},{45.45,-70},{45.45,-75.6},{58.4,-75.6}}, color={0,0,127}));
  connect(P_Heater.y,switch2. u1) annotation (Line(points={{40.8,-93},{40.8,-92},{50,-92},{50,-90},{50,-88},{50,-88.4},{54,-88.4},{58.4,-88.4}},
                                                                                                                                    color={0,0,127}));
  connect(uLow3.y, hysteresis_heater.uLow) annotation (Line(points={{-43.3,-90},{-38,-90},{-38,-88.6},{-32.7,-88.6}}, color={0,0,127}));
  connect(uHigh3.y,hysteresis_heater. uHigh) annotation (Line(points={{-45.2,-73},{-38,-73},{-38,-77.4},{-32.42,-77.4}},
                                                                                                                       color={0,0,127}));
  connect(switch2.y, P_set_electricHeater) annotation (Line(points={{76.8,-82},{88,-82},{88,-51},{109,-51}},
                                                                                                     color={0,0,127}));
  connect(Not1.y,switch2. u2) annotation (Line(points={{-1.5,-83},{-1.5,-82},{58.4,-82}},
                                                                              color={255,0,255}));
  connect(hysteresis_heater.y, Not1.u) annotation (Line(points={{-17.3,-83},{-13,-83}},            color={255,0,255}));
  connect(hysteresis_upperStoragePart.y, Not.u) annotation (Line(points={{-37.3,-17},{-34,-17},{-33,-17}},     color={255,0,255}));
  connect(T, hysteresis_upperStoragePart.u) annotation (Line(points={{-102,20},{-90,20},{-90,18},{-82,18},{-82,-17},{-52.7,-17}}, color={0,0,127}));
  connect(T, hysteresis_heater.u) annotation (Line(points={{-102,20},{-92,20},{-92,18},{-90,18},{-90,-83},{-32.7,-83}}, color={0,0,127}));
  connect(T, hysteresis_lowerStoragePart.u) annotation (Line(points={{-102,20},{-40,20},{-40,75},{-6.7,75}}, color={0,0,127}));
  connect(P_Threshold.y, greaterThreshold.u2) annotation (Line(points={{-79.3,39},{-64,39},{-64,45.2},{-57.2,45.2}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-96,58},{-40,30}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-92,64},{-44,56}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          textString="Check if sufficient excess PV",
          fontSize=9),
        Rectangle(
          extent={{-34,90},{26,62}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-40,96},{34,92}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          textString="SoC Threshold for lower part of storage to offer flexibility 
in summer operation"),
        Rectangle(
          extent={{-78,-2},{-18,-30}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-84,-32},{-2,-42}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          textString="SoC Threshold for upper part of storage volume 
for winter operation or if enough 
excess PV energy in summer",
          fontSize=9),
        Rectangle(
          extent={{-64,-66},{0,-94}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-70,-62},{0,-64}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          textString="SoC Threshold for electric backup heater",
          fontSize=9)}),                                                 Icon(
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
end ControlStaticHeatPump_PV_oriented;

