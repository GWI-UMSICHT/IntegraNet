within IntegraNet.Producer.Combined.SmallScaleCHP.Control_CHP_boiler_storage;
model price_oriented "price-oriented CHP operation"
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

 import IntegraNet;

 extends IntegraNet.Producer.Combined.SmallScaleCHP.Control_CHP_boiler_storage.Base.Controller_Base;
 extends TransiEnt.Basics.Icons.Controller;

 outer IntegraNet.SimCenter simCenter;

   //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________

  parameter Real uLow_CHP=0.3 "Storage charging level for CHP switch on";
  parameter Real uHigh_CHP=0.75   "Storage charging level for CHP switch off ";
  parameter Real uLow2_CHP=0.75  "Storage charging level for CHP switch on in case of high prize for electricity";
  parameter Real uHigh2_CHP=1   "Storage charging level for CHP switch off in case of high prize for electricity";

  parameter Real uLow_Boiler=0.2 "Storage charging level for boiler switch on";
  parameter Real uHigh_Boiler=0.75 "Storage charging level for boiler switch off";

  parameter Real uSet_Boiler=0.7 "Setpoint for boiler operation";
  parameter Real t_min_on_CHP=3600 "Minimum on time after startup of the CHP";
  parameter Real t_min_off_CHP=3600 "Minimum off time after shutdown of the CHP";

  parameter Real Price_Threshold(unit="€/Kwh")=0.05 "Price limit for the operation of the CHP";

protected
  parameter Real Q_Boiler=6000;

 // __________________________________________________________________________
 //
 //                   Complex Components
 // ___________________________________________________________________________

public
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
      extent={{6,-6},{-6,6}},
      rotation=180,
      origin={76,-40})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{8,50},{20,38}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-14,36},{0,50}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(k=1)
    annotation (Placement(transformation(extent={{-22,-92},{-10,-80}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=0)
    annotation (Placement(transformation(extent={{-26,-50},{-4,-30}})));
  Modelica.Blocks.Sources.RealExpression max_Storage_Heat(y=uSet_Boiler)
    annotation (Placement(transformation(extent={{16,-88},{36,-68}})));
  Modelica.Blocks.Continuous.LimPID PID(           yMin=1000,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    Ti=1,
    yMax=Q_Boiler,
    k=1e8)
    annotation (Placement(transformation(extent={{46,-94},{58,-82}})));
  Modelica.Blocks.Logical.Not NotCHP2
    annotation (Placement(transformation(extent={{-4,-72},{8,-60}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_CHP_1 annotation (Placement(transformation(extent={{-40,36},{-26,50}})));
  Modelica.Blocks.Sources.RealExpression uHigh(y=uHigh2_CHP)
    annotation (Placement(transformation(extent={{-92,42},{-72,64}})));
  Modelica.Blocks.Sources.RealExpression uLow(y=uLow2_CHP)
    annotation (Placement(transformation(extent={{-70,24},{-49,44}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_Boiler annotation (Placement(transformation(extent={{-32,-72},{-20,-60}})));
  Modelica.Blocks.Sources.RealExpression uHigh1(y=uHigh_Boiler)
    annotation (Placement(transformation(extent={{-78,-62},{-59,-38}})));
  Modelica.Blocks.Sources.RealExpression uLow1(y=uLow_Boiler)
    annotation (Placement(transformation(extent={{-78,-92},{-59,-70}})));

  Modelica.Blocks.Logical.Or  and2
    annotation (Placement(transformation(extent={{34,36},{48,50}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_CHP_2 annotation (Placement(transformation(extent={{-24,-16},{-10,-2}})));
  Modelica.Blocks.Sources.RealExpression uHigh2(y=uHigh_CHP)
    annotation (Placement(transformation(extent={{-74,-2},{-49,20}})));
  Modelica.Blocks.Sources.RealExpression uLow2(y=uLow_CHP)
    annotation (Placement(transformation(extent={{-80,-32},{-57,-10}})));
  Modelica.Blocks.Logical.Not not2
    annotation (Placement(transformation(extent={{20,-6},{32,6}})));
  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais(
    init_state=2,
    t_min_on=t_min_on_CHP,
    t_min_off=t_min_off_CHP)
    annotation (Placement(transformation(extent={{56,36},{70,50}})));
  Modelica.Blocks.Logical.GreaterThreshold hysteresis(threshold=Price_Threshold)
                                                                                annotation (Placement(transformation(extent={{-34,76},
            {-18,92}})));
  Modelica.Blocks.Sources.RealExpression electricityPrice(y=simCenter.electricityPrice.price)
    annotation (Placement(transformation(extent={{-84,74},{-64,96}})));
equation

 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________
  connect(realExpression.y,switch1. u3) annotation (Line(points={{-2.9,-40},{-2.9,-35.2},{68.8,-35.2}},
                                       color={0,0,127}));
  connect(PID.u_m,firstOrder1. y) annotation (Line(points={{52,-95.2},{18,-95.2},{18,-86},{-9.4,-86}},
                                color={0,0,127}));
  connect(PID.y,switch1. u1) annotation (Line(points={{58.6,-88},{62,-88},{62,-80},{62,-44.8},{68.8,-44.8}},
                                                       color={0,0,127}));
  connect(switch1.u2,NotCHP2. y) annotation (Line(points={{68.8,-40},{16,-40},{16,-66},{8.6,-66}},
                                               color={255,0,255}));
  connect(uHigh.y, hysteresis_CHP_1.uHigh) annotation (Line(points={{-71,53},{-71,48.6},{-40.42,48.6}}, color={0,0,127}));
  connect(uLow.y, hysteresis_CHP_1.uLow) annotation (Line(points={{-47.95,34},{-45.55,34},{-45.55,37.4},{-40.7,37.4}}, color={0,0,127}));
  connect(uHigh1.y, hysteresis_Boiler.uHigh) annotation (Line(points={{-58.05,-50},{-58.05,-50},{-46,-50},{-32.36,-50},{-32.36,-61.2}},
                                                                                                                                     color={0,0,127}));
  connect(uLow1.y, hysteresis_Boiler.uLow) annotation (Line(points={{-58.05,-81},{-41.55,-81},{-41.55,-70.8},{-32.6,-70.8}}, color={0,0,127}));
  connect(hysteresis_Boiler.y, NotCHP2.u) annotation (Line(points={{-19.4,-66},{-19.4,-66},{-5.2,-66}}, color={255,0,255}));
  connect(and2.u1,and1. y) annotation (Line(points={{32.6,43},{32.5,43},{32.5,44},{20.6,44}},
                    color={255,0,255}));
  connect(uHigh2.y, hysteresis_CHP_2.uHigh) annotation (Line(points={{-47.75,9},{-47.75,-3.4},{-24.42,-3.4}}, color={0,0,127}));
  connect(uLow2.y, hysteresis_CHP_2.uLow) annotation (Line(points={{-55.85,-21},{-31.5,-21},{-31.5,-14.6},{-24.7,-14.6}}, color={0,0,127}));
  connect(hysteresis_CHP_2.y, not2.u) annotation (Line(points={{-9.3,-9},{10,-9},{10,0},{18.8,0}},  color={255,0,255}));
  connect(not2.y,and2. u2) annotation (Line(points={{32.6,0},{32.6,18},{32.6,37.4}},
                    color={255,0,255}));
  connect(not1.y, and1.u1) annotation (Line(points={{0.7,43},{6.8,43},{6.8,44}},
                      color={255,0,255}));
  connect(max_Storage_Heat.y, PID.u_s) annotation (Line(points={{37,-78},{43.4,-78},{43.4,-88},{44.8,-88}},
                                              color={0,0,127}));
  connect(and2.y, onOffRelais.u) annotation (Line(points={{48.7,43},{48.7,43},{55.72,43}},
                              color={255,0,255}));
  connect(SoC, hysteresis_CHP_1.u) annotation (Line(points={{-102,1.77636e-15},{-80,1.77636e-15},{-80,43},{-40.7,43}},
                                                                                                   color={0,0,127}));
  connect(SoC, hysteresis_CHP_2.u) annotation (Line(points={{-102,1.77636e-15},{-66,1.77636e-15},{-66,-9},{-24.7,-9}},
                                                                                                   color={0,0,127}));
  connect(hysteresis_Boiler.u, SoC) annotation (Line(points={{-32.6,-66},{-32.6,-68},{-86,-68},{-86,-34},{-96,-34},{-96,0},{-98,0},{-98,1.77636e-15},{-102,1.77636e-15}},
                                                                                                                                                      color={0,0,127}));
  connect(firstOrder1.u,SoC)  annotation (Line(points={{-23.2,-86},{-96,-86},{-96,1.77636e-15},{-102,1.77636e-15}},
                                                                                                color={0,0,127}));
  connect(onOffRelais.y, to_CHP) annotation (Line(points={{70.7,43},{70.7,43.5},{104,43.5},{104,40}}, color={255,0,255}));
  connect(switch1.y, to_Boiler) annotation (Line(points={{82.6,-40},{90,-40},{108,-40}},          color={0,0,127}));
  connect(hysteresis_CHP_1.y, not1.u) annotation (Line(points={{-25.3,43},{-25.3,43},{-15.4,43}},  color={255,0,255}));
  connect(electricityPrice.y, hysteresis.u) annotation (Line(points={{-63,85},{-49.5,
          85},{-49.5,84},{-35.6,84}}, color={0,0,127}));
  connect(hysteresis.y, and1.u2) annotation (Line(points={{-17.2,84},{-6,84},{2,
          84},{2,48.8},{6.8,48.8}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{120,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller for the operation of a CHP unit and a boiler. In order to have higher CHP runtimes, CHP will run with a constant heat output if the storage tank state of charge is low. If storage tank level is above threshold value, the CHP will only switch on if electricity prices are high.</p>
<p>The boiler will switch on additionally if the storage tank state of charge drops below another threshold value. The boiler has a modulating power output so that the storage tank level stays at set point value.</p>
<p><br><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
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
end price_oriented;

