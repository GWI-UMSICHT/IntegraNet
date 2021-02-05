within IntegraNet.Producer.Combined.SmallScaleCHP.Control_CHP_boiler_storage;
model heat_driven "heat-driven CHP operation"
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

   //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________

 parameter Real uLow_CHP=0.55 "Storage charging level for CHP switch on ";
 parameter Real uHigh_CHP=0.8 "Storage charging level for CHP switch off ";

 parameter Real uLow_Boiler=0.4 "Storage charging level for boiler switch on ";
 parameter Real uHigh_Boiler=0.6 "Storage charging level for boiler switch off";
 parameter Real uSet_Boiler=0.5 "Setpoint for boiler operation";
 parameter Real t_min_on_CHP=3600 "Minimum on time after startup of the CHP";
 parameter Real t_min_off_CHP=3600 "Minimum off time after shutdown of the CHP";

 parameter Real Q_Boiler=6000;

   // __________________________________________________________________________
   //
   //                   Complex Components
  // ___________________________________________________________________________

public
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={74,-40})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(k=1)
    annotation (Placement(transformation(extent={{-74,-92},{-64,-82}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=0)
    annotation (Placement(transformation(extent={{44,-42},{58,-26}})));
  Modelica.Blocks.Sources.RealExpression max_Storage_Heat(y=uSet_Boiler)
    annotation (Placement(transformation(extent={{-82,-50},{-60,-30}})));
  Modelica.Blocks.Continuous.LimPID PID(
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=Q_Boiler,
    k=1e8,
    yMin=0,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    y_start=Q_Boiler)
    annotation (Placement(transformation(extent={{-34,-68},{-22,-56}})));
  Modelica.Blocks.Logical.Not NotBoiler annotation (Placement(transformation(extent={{-22,10},{-8,24}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{22,24},{36,38}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_CHP annotation (Placement(transformation(extent={{-28,68},{-12,84}})));
  Modelica.Blocks.Sources.RealExpression uHigh(y=uHigh_CHP)
    annotation (Placement(transformation(extent={{-80,74},{-60,90}})));
  Modelica.Blocks.Sources.RealExpression uLow(y=uLow_CHP)
    annotation (Placement(transformation(extent={{-80,54},{-60,72}})));
  Modelica.Blocks.Logical.Not NotCHP annotation (Placement(transformation(extent={{-2,68},{14,84}})));
  IntegraNet.Components.Control.Hysteresis_inputVariable hysteresis_Boiler annotation (Placement(transformation(extent={{-50,10},{-34,26}})));
  Modelica.Blocks.Sources.RealExpression uHigh1(y=uHigh_Boiler)
    annotation (Placement(transformation(extent={{-88,20},{-68,38}})));
  Modelica.Blocks.Sources.RealExpression uLow1(y=uLow_Boiler)
    annotation (Placement(transformation(extent={{-86,-18},{-66,0}})));
  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais(
    init_state=2,
    t_min_on=t_min_on_CHP,
    t_min_off=t_min_off_CHP)
    annotation (Placement(transformation(extent={{42,44},{56,58}})));

equation
 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________
  connect(PID.u_m,firstOrder1. y) annotation (Line(points={{-28,-69.2},{-48,-69.2},{-48,-87},{-63.5,-87}},
                                color={0,0,127}));
  connect(NotBoiler.y, and1.u2) annotation (Line(points={{-7.3,17},{10,17},{10,25.4},{20.6,25.4}}, color={255,0,255}));
  connect(uLow.y, hysteresis_CHP.uLow) annotation (Line(points={{-59,63},{-38,63},{-38,70},{-28.8,70},{-28.8,69.6}},            color={0,0,127}));
  connect(uHigh.y, hysteresis_CHP.uHigh) annotation (Line(points={{-59,82},{-30,82},{-30,82.4},{-28.48,82.4}}, color={0,0,127}));
  connect(hysteresis_CHP.y, NotCHP.u) annotation (Line(points={{-11.2,76},{-3.6,76}}, color={255,0,255}));
  connect(hysteresis_Boiler.y, NotBoiler.u) annotation (Line(points={{-33.2,18},{-28.15,18},{-28.15,17},{-23.4,17}}, color={255,0,255}));
  connect(hysteresis_Boiler.uLow, uLow1.y) annotation (Line(points={{-50.8,11.6},{-57.85,11.6},{-57.85,-9},{-65,-9}}, color={0,0,127}));
  connect(hysteresis_Boiler.uHigh, uHigh1.y) annotation (Line(points={{-50.48,24.4},{-61.51,24.4},{-61.51,29},{-67,29}}, color={0,0,127}));
  connect(max_Storage_Heat.y, PID.u_s) annotation (Line(points={{-58.9,-40},{-58.9,-62},{-35.2,-62}},
                                         color={0,0,127}));
  connect(PID.y, switch1.u1) annotation (Line(points={{-21.4,-62},{-4,-62},{-4,-46.4},{64.4,-46.4}},
                      color={0,0,127}));
  connect(NotCHP.y, onOffRelais.u) annotation (Line(points={{14.8,76},{32,76},{32,51},{41.72,51}}, color={255,0,255}));
  connect(and1.u1, NotCHP.y) annotation (Line(points={{20.6,31},{14.8,31},{14.8,76}}, color={255,0,255}));
  connect(SoC, hysteresis_Boiler.u) annotation (Line(points={{-102,1.77636e-15},{-78,1.77636e-15},{-78,18},{-50.8,18}},
                                                                                                    color={0,0,127}));
  connect(SoC, hysteresis_CHP.u) annotation (Line(points={{-102,1.77636e-15},{-114,1.77636e-15},{-114,76},{-28.8,76}},
                                                                                                 color={0,0,127}));
  connect(firstOrder1.u,SoC)  annotation (Line(points={{-75,-87},{-75,-88},{-114,-88},{-114,1.77636e-15},{-102,1.77636e-15}},
                                                                                                                color={0,0,127}));
  connect(to_CHP, onOffRelais.y) annotation (Line(points={{104,40},{82,40},{82,51},{56.7,51}}, color={255,0,255}));
  connect(switch1.y, to_Boiler) annotation (Line(points={{82.8,-40},{108,-40}},                   color={0,0,127}));
  connect(realExpression.y, switch1.u3) annotation (Line(points={{58.7,-34},{60,-34},{60,-33.6},{64.4,-33.6}}, color={0,0,127}));
  connect(and1.y, switch1.u2) annotation (Line(points={{36.7,31},{36.7,-40.5},{64.4,-40.5},{64.4,-40}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller for the operation of a CHP unit and a boiler. CHP is operated at constant heat output every time the storage tank is not full. </p>
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
end heat_driven;

