within IntegraNet.Producer.Combined.SmallScaleCHP.Control_CHP_boiler_storage;
model price_driven "price-driven CHP operation"
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

  outer IntegraNet.SimCenter simCenter;

extends IntegraNet.Producer.Combined.SmallScaleCHP.Control_CHP_boiler_storage.Base.Controller_Base;
   //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________

  parameter Real uLow_CHP=0.4  "Storage charging level for CHP switch on";
  parameter Real uHigh_CHP=1   "Storage charging level for CHP switch off ";

  parameter Real uLow_Boiler=0.3 "Storage charging level for boiler switch on";
  parameter Real uHigh_Boiler=0.6 "Storage charging level for boiler switch off ";
  parameter Real uSet_Boiler=0.5 "Setpoint for boiler operation";
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
      origin={74,-60})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{8,54},{20,42}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-26,42},{-14,54}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(k=1)
    annotation (Placement(transformation(extent={{-62,-82},{-50,-70}})));
  Modelica.Blocks.Sources.RealExpression zero(y=0) annotation (Placement(transformation(extent={{12,-60},{30,-44}})));
  Modelica.Blocks.Sources.RealExpression uSet(y=uSet_Boiler) annotation (Placement(transformation(extent={{-46,-66},{-24,-50}})));
  Modelica.Blocks.Continuous.LimPID PID(           yMin=1000,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    Ti=1,
    yMax=Q_Boiler,
    k=1e8)
    annotation (Placement(transformation(extent={{-4,-88},{8,-76}})));
  Modelica.Blocks.Logical.Not NotCHP2
    annotation (Placement(transformation(extent={{18,-6},{30,6}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_CHP annotation (Placement(transformation(extent={{-50,42},{-38,54}})));
  Modelica.Blocks.Sources.RealExpression uHigh(y=uHigh_CHP)
    annotation (Placement(transformation(extent={{-84,50},{-64,66}})));
  Modelica.Blocks.Sources.RealExpression uLow(y=uLow_CHP)
    annotation (Placement(transformation(extent={{-82,26},{-62,42}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_Boiler annotation (Placement(transformation(extent={{-10,-6},{2,6}})));
  Modelica.Blocks.Sources.RealExpression uHigh1(y=uHigh_Boiler)
    annotation (Placement(transformation(extent={{-50,10},{-32,30}})));
  Modelica.Blocks.Sources.RealExpression uLow1(y=uLow_Boiler)
    annotation (Placement(transformation(extent={{-58,-26},{-40,-10}})));
  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais(
    init_state=2,
    t_min_on=t_min_on_CHP,
    t_min_off=t_min_off_CHP)
    annotation (Placement(transformation(extent={{32,42},{44,54}})));

  Modelica.Blocks.Sources.RealExpression electricityPrice(y=simCenter.electricityPrice.price)
    annotation (Placement(transformation(extent={{-84,74},{-64,96}})));
  Modelica.Blocks.Logical.GreaterThreshold hysteresis(threshold=Price_Threshold)
                                                                                annotation (Placement(transformation(extent={{-34,76},
            {-18,92}})));
equation
 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________

  connect(zero.y, switch1.u3) annotation (Line(points={{30.9,-52},{30.9,-55.2},{66.8,-55.2}}, color={0,0,127}));
  connect(not1.y,and1. u1) annotation (Line(points={{-13.4,48},{-2,48},{6.8,48}},
                            color={255,0,255}));
  connect(PID.u_m,firstOrder1. y) annotation (Line(points={{2,-89.2},{-36,-89.2},{-36,-76},{-49.4,-76}},
                                color={0,0,127}));
  connect(PID.y,switch1. u1) annotation (Line(points={{8.6,-82},{8.6,-84},{24,-84},{44,-84},{44,-64.8},{66.8,-64.8}},
                                                       color={0,0,127}));
  connect(uSet.y, PID.u_s) annotation (Line(points={{-22.9,-58},{-9.3,-58},{-9.3,-82},{-5.2,-82}}, color={0,0,127}));
  connect(switch1.u2,NotCHP2. y) annotation (Line(points={{66.8,-60},{66.8,-59},{40,-59},{40,0},{30.6,0}},
                                               color={255,0,255}));
  connect(uHigh.y, hysteresis_CHP.uHigh) annotation (Line(points={{-63,58},{-54,58},{-54,52.8},{-50.36,52.8}}, color={0,0,127}));
  connect(uLow.y, hysteresis_CHP.uLow) annotation (Line(points={{-61,34},{-60,34},{-60,44},{-52,44},{-52,43.2},{-50.6,43.2}}, color={0,0,127}));
  connect(uHigh1.y, hysteresis_Boiler.uHigh) annotation (Line(points={{-31.1,20},{-23,20},{-23,4.8},{-10.36,4.8}}, color={0,0,127}));
  connect(uLow1.y, hysteresis_Boiler.uLow) annotation (Line(points={{-39.1,-18},{-20.2,-18},{-20.2,-4.8},{-10.6,-4.8}}, color={0,0,127}));
  connect(hysteresis_CHP.y, not1.u) annotation (Line(points={{-37.4,48},{-37.4,48},{-27.2,48}}, color={255,0,255}));
  connect(hysteresis_Boiler.y, NotCHP2.u) annotation (Line(points={{2.6,0},{16.8,0}}, color={255,0,255}));
  connect(and1.y, onOffRelais.u) annotation (Line(points={{20.6,48},{20.6,48},{31.76,48}},
                 color={255,0,255}));
  connect(SoC, hysteresis_CHP.u) annotation (Line(points={{-102,1.77636e-15},{-86,1.77636e-15},{-86,48},{-50.6,48}},
                                                                                                 color={0,0,127}));
  connect(SoC, hysteresis_Boiler.u) annotation (Line(points={{-102,1.77636e-15},{-56,1.77636e-15},{-56,0},{-10.6,0}},
                                                                                                  color={0,0,127}));
  connect(SoC, firstOrder1.u) annotation (Line(points={{-102,1.77636e-15},{-102,0},{-98,0},{-98,-28},{-80,-28},{-80,-76},{-70,-76},{-63.2,-76}},
                                                                                                                                       color={0,0,127}));
  connect(to_CHP, onOffRelais.y) annotation (Line(points={{104,40},{74,40},{74,48},{44.6,48}}, color={255,0,255}));
  connect(switch1.y, to_Boiler) annotation (Line(points={{80.6,-60},{86,-60},{86,-40},{108,-40}}, color={0,0,127}));
  connect(electricityPrice.y, hysteresis.u) annotation (Line(points={{-63,85},{-49.5,
          85},{-49.5,84},{-35.6,84}}, color={0,0,127}));
  connect(hysteresis.y, and1.u2) annotation (Line(points={{-17.2,84},{-4,84},{-4,
          52.8},{6.8,52.8}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-120},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller for the operation of a CHP unit and a boiler. CHP is operated only if electricity prices are above a threshold value and if storage tank is not full. </p>
<p>The boiler will switch on additionally if the storage tank state of charge drops below threshold value. The boiler has a modulating power output so that the storage tank level stays at set point value.</p>
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
end price_driven;

