within IntegraNet.Producer.Combined.SmallScaleCHP;
model CHPSystem_noGasPort "CHP, boiler and storage"

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
  extends TransiEnt.Basics.Icons.CHP;

  outer IntegraNet.SimCenter simCenter;
  outer IntegraNet.Statistics.Statistics_collector statistics_collector;

  // __________________________________________________________________________
  //
  //                  Parameters
  // ___________________________________________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid FuelMedium= simCenter.gasModel1 "|Fundamental definitions|Medium to be used for fuel gas";
  parameter Boolean referenceNCV = simCenter.referenceNCV "|Fundamental definitions|true, if heat calculations shall be in respect to NCV, false will give GCV";
  parameter SI.Temperature T_s_max=363.15 "|Storage parameters|Maximum storage temperature";
  parameter SI.Temperature T_s_min=303.15 "|Storage parameters|Minimum storage temperature";
  parameter SI.Volume V_Storage=0.5 "|Storage parameters|Volume of the Storage";
  parameter SI.Height height=1.3 "|Storage parameters|Height of heat storage";
  parameter SI.Diameter d=sqrt(Storage.V_Storage/Storage.height*4/Modelica.Constants.pi) "|Storage parameters|Diameter of heat storage";
  parameter SI.Temp_C T_amb=15 "|Storage parameters|Assumed constant temperature in tank installation room";
  parameter SI.SurfaceCoefficientOfHeatTransfer k=0.08 "|Storage parameters|Coefficient of heat Transfer";
  parameter SI.Power Q_CHP=4000 "|CHP parameters|Heat output of CHP";
  parameter SI.Power P_CHP=8000 "|CHP parameters|Electric power output of CHP";
  parameter Real eta_total=0.9 "|CHP parameters|Total efficiency of CHP as sum of thermal and electrical efficiency";
  parameter SI.Efficiency eta=1.05 "|Boiler parameters|Boiler's overall efficiency";
  parameter SI.HeatFlowRate Q_flow_n_boiler=20000 "|Boiler parameters|Nominal heating power of the gas boiler";

  // __________________________________________________________________________
  //
  //                   Variables
  // ___________________________________________________________________________

//  parameter Modelica.SIunits.SpecificEnthalpy HoC_gas=40e6 "heat of combustion of natural gas";

  SI.SpecificEnthalpy CalorificValue=if referenceNCV then TransiEnt.Basics.Functions.GasProperties.getRealGasNCV_xi(
      FuelMedium,
      xi_in=FuelMedium.xi_default,
      NCVIn=0) else TransiEnt.Basics.Functions.GasProperties.getRealGasGCV_xi(
      FuelMedium,
      xi_in=FuelMedium.xi_default,
      GCVIn=0) "Calorific value of fuel";

  Modelica.Blocks.Math.Division m_flow_fuel annotation (Placement(transformation(extent={{-2,-50},{12,-36}})));

  // __________________________________________________________________________
  //
  //                   Complex Components
  // ___________________________________________________________________________

  IntegraNet.Storage.Heat.HeatStorage_energybased Storage(
    T_amb=T_amb,
    k=k,
    T_s_max=T_s_max,
    T_s_min=T_s_min,
    V_Storage=V_Storage,
    height=height,
    d=d) annotation (Placement(transformation(extent={{58,22},{78,42}})));

  CHP_simple_noGasPort cHP(
    eta_total=eta_total,
    Q_CHP=Q_CHP,
    P_CHP=P_CHP,
    FuelMedium=FuelMedium,
    referenceNCV=referenceNCV)
       annotation (Placement(transformation(extent={{-6,-20},{14,0}})));

  replaceable IntegraNet.Producer.Combined.SmallScaleCHP.Control_CHP_boiler_storage.heat_driven controller constrainedby IntegraNet.Producer.Combined.SmallScaleCHP.Control_CHP_boiler_storage.Base.Controller_Base(Q_Boiler=Q_flow_n_boiler) "Choose a control strategy" annotation (
    Dialog(group="CHP parameters"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-70,-20},{-52,-2}})));

  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{30,14},{46,30}})));

  Modelica.Blocks.Math.Add add1  annotation (Placement(transformation(extent={{12,58},{28,74}})));

  Modelica.Blocks.Math.Add gasFlow annotation (Placement(transformation(extent={{54,-74},{70,-58}})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=CalorificValue*eta) annotation (Placement(transformation(extent={{-44,-64},{-24,-44}})));

  Modelica.Blocks.Sources.RealExpression realExpression1(y=cHP.m_flow_gas)    annotation (Placement(transformation(extent={{-2,-98},{18,-78}})));

 //Statistics
  IntegraNet.Statistics.LocalCollector heat_CHP_output(typeOfResource=IntegraNet.Statistics.TypeOfResource.q_output_CHP) "Collects power supplied by CHP" annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  IntegraNet.Statistics.LocalCollector elec_CHP_output(typeOfResource=IntegraNet.Statistics.TypeOfResource.el_output_CHP) "Collects power supplied by CHP" annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  IntegraNet.Statistics.LocalCollector gasFlow_Demand(typeOfResource=IntegraNet.Statistics.TypeOfResource.m_flow_gas) "Collects gas used by the CHP " annotation (Placement(transformation(extent={{80,80},{100,100}})));
  IntegraNet.Statistics.LocalCollector heat_AUX_output(typeOfResource=IntegraNet.Statistics.TypeOfResource.q_output_aux_CHP) "Collects power supplied by CHP Auxillary unit" annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));



  // __________________________________________________________________________
  //
  //                   Interfaces
  // ___________________________________________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort  epp  annotation (Placement(transformation(extent={{-88,-112},{-68,-92}}), iconTransformation(extent={{-94,-118},{-68,-92}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn  Q_Demand annotation (Placement(transformation(
          extent={{-14,-14},{14,14}},
        rotation=270,
        origin={0,100}),                 iconTransformation(extent={{-13,-13},{13,13}},
        rotation=270,
        origin={1,97})));


equation

  // ___________________________________________________________________________
  //
  //            Characteristic equations
  // ___________________________________________________________________________


  heat_CHP_output.flowCollector.unit_flow = cHP.Q_CHP_out;
  connect(heat_CHP_output.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.q_output_CHP]);

  elec_CHP_output.flowCollector.unit_flow = -epp.P;
  connect(elec_CHP_output.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.el_output_CHP]);

  gasFlow_Demand.flowCollector.unit_flow = gasFlow.y;
  connect(gasFlow_Demand.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.m_flow_gas]);

  heat_AUX_output.flowCollector.unit_flow = m_flow_fuel.u1;
  connect(heat_AUX_output.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.q_output_aux_CHP]);

 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________


  connect(controller.to_CHP,cHP. OnOffSignal) annotation (Line(points={{-51.64,-7.4},{-6.2,-7.4},{-6.2,-9.4}}, color={255,0,255}));
  connect(controller.SoC,Storage.SoC)  annotation (Line(points={{-70.18,-11.36},{-80,-11.36},{-80,50},{86,50},{86,32},{80,32},{80,29.6},{78.7,29.6}},
                                                                                                                                         color={0,0,127}));
  connect(cHP.epp,epp)  annotation (Line(
      points={{15.1,-12.9},{15.1,-14},{20,-14},{36,-14},{36,-60},{-78,-60},{-78,-102}},
      color={0,127,0},
      thickness=0.5));
  connect(controller.to_Boiler,add. u1) annotation (Line(
      points={{-50.92,-14.24},{-18,-14.24},{-18,26.8},{28.4,26.8}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(Storage.Q_Demand,add1. y) annotation (Line(
      points={{59.3,37.7},{36,37.7},{36,66},{28.8,66}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(Storage.Q_Generation,add. y) annotation (Line(
      points={{59.4,27.8},{58,27.8},{58,28},{54,28},{48.8,28},{48.8,22},{46.8,22}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(cHP.Q_CHP_out,add. u2) annotation (Line(
    points={{16.6,-2},{20,-2},{20,17.2},{28.4,17.2}},
    color={162,29,33},
    pattern=LinePattern.Dash));
  connect(Q_Demand, add1.u1) annotation (Line(
      points={{1.77636e-015,100},{1.77636e-015,70},{10.4,70},{10.4,70.8}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(Q_Demand, add1.u2) annotation (Line(
      points={{0,100},{0,61.2},{10.4,61.2}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(controller.to_Boiler, m_flow_fuel.u1) annotation (Line(
      points={{-50.92,-14.24},{-50.92,-38.12},{-3.4,-38.12},{-3.4,-38.8}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(realExpression.y, m_flow_fuel.u2) annotation (Line(points={{-23,-54},{-3.4,-54},{-3.4,-47.2}}, color={0,0,127}));
  connect(m_flow_fuel.y, gasFlow.u1) annotation (Line(points={{12.7,-43},{32.35,-43},{32.35,-61.2},{52.4,-61.2}}, color={0,0,127}));
  connect(realExpression1.y, gasFlow.u2) annotation (Line(points={{19,-88},{36,-88},{36,-70.8},{52.4,-70.8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Combination of storage tank, CHP unit, boiler and controller model into one system model with connection to the electrical grid but not to a gas grid.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_demand</p>
<p>TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>All components use energy based modeling without consideration of heat transfer media. </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Anne Hagemeier, Fraunhofer UMSICHT, 2018</p>
</html>"));
end CHPSystem_noGasPort;

