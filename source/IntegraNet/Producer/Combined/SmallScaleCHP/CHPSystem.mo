within IntegraNet.Producer.Combined.SmallScaleCHP;
model CHPSystem "CHP, boiler and storage"
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

 outer IntegraNet.Statistics.Statistics_collector statistics_collector;
 outer IntegraNet.SimCenter simCenter;

  // __________________________________________________________________________
  //
  //                  Parameters
  // ___________________________________________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid FuelMedium= simCenter.gasModel1 "|Fundamental definitions|Medium to be used for fuel gas";
  parameter Boolean referenceNCV = simCenter.referenceNCV
                                                         "|Fundamental definitions|true, if heat calculations shall be in respect to NCV, false will give GCV";
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

SI.SpecificEnthalpy CalorificValue=if referenceNCV then TransiEnt.Basics.Functions.GasProperties.getRealGasNCV_xi(
      FuelMedium,
      xi_in=xi_fuel[1:FuelMedium.nc - 1],
      NCVIn=0) else TransiEnt.Basics.Functions.GasProperties.getRealGasGCV_xi(
      FuelMedium,
      xi_in=xi_fuel[1:FuelMedium.nc - 1],
      GCVIn=0) "Calorific value of fuel";

  SI.MassFraction xi_fuel[FuelMedium.nc] "[CH4, C2H6, C3H8, C4H10, N2, CO2, H2] Fuel gas mass fractions";

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
    d=d,
    T_s_max_start=T_s_max)
         annotation (Placement(transformation(extent={{58,22},{78,42}})));

  CHP_simple cHP(
    eta_total=eta_total,
    Q_CHP=Q_CHP,
    P_CHP=P_CHP,
    referenceNCV=referenceNCV)
   annotation (Placement(transformation(extent={{-6,-20},{14,0}})));
   // CalorificValue=CalorificValue)

  replaceable IntegraNet.Producer.Combined.SmallScaleCHP.Control_CHP_boiler_storage.heat_driven controller constrainedby IntegraNet.Producer.Combined.SmallScaleCHP.Control_CHP_boiler_storage.Base.Controller_Base(Q_Boiler=Q_flow_n_boiler) "Choose a control strategy" annotation (
    Dialog(group="CHP parameters"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-70,-20},{-52,-2}})));

  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{30,14},{46,30}})));

  Heat.Gas2Heat.SmallGasBoiler.GasBoiler_energybased gasBoiler_energybased(
    FuelMedium=FuelMedium,
    eta=eta,
    Q_flow_n_boiler=Q_flow_n_boiler,
    referenceNCV=referenceNCV)
    annotation (Placement(transformation(extent={{-32,-46},{-12,-26}})));
   // CalorificValue=CalorificValue)

  // __________________________________________________________________________
  //
  //                   Interfaces
  // ___________________________________________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp  annotation (Placement(transformation(extent={{-88,-112},{-68,-92}}), iconTransformation(extent={{-94,-118},{-68,-92}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=FuelMedium)  annotation (Placement(transformation(extent={{68,-116},{88,-96}}), iconTransformation(extent={{66,-118},{88,-96}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_Demand annotation (Placement(transformation(
          extent={{-14,-14},{14,14}},
        rotation=270,
        origin={0,100}),                 iconTransformation(extent={{-13,-13},{13,13}},
        rotation=270,
        origin={1,97})));

  IntegraNet.Statistics.LocalCollector heat_CHP_output(typeOfResource=IntegraNet.Statistics.TypeOfResource.q_output_CHP) "Collects power supplied by CHP" annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  IntegraNet.Statistics.LocalCollector elec_CHP_output(typeOfResource=IntegraNet.Statistics.TypeOfResource.el_output_CHP) "Collects power supplied by CHP" annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

equation

  // ___________________________________________________________________________
  //
  //            Characteristic equations
  // ___________________________________________________________________________

 xi_fuel[1:FuelMedium.nc - 1] = inStream(gasPortIn.xi_outflow);
 xi_fuel[end] = 1-sum(xi_fuel[1:FuelMedium.nc - 1]);

 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________

  connect(cHP.gasPortIn,gasPortIn)  annotation (Line(
      points={{15.2,-18.2},{78,-18.2},{78,-106}},
      color={255,255,0},
      thickness=1.5));
  connect(controller.to_CHP,cHP. OnOffSignal) annotation (Line(points={{-51.64,-7.4},{-6.2,-7.4},{-6.2,-9.4}}, color={255,0,255}));
  connect(controller.SoC,Storage.SoC)  annotation (Line(points={{-70.18,-11.36},{-80,-11.36},{-80,50},{86,50},{86,32},{80,32},{80,29.6},{78.7,29.6}},
                                                                                                                                         color={0,0,127}));
  connect(cHP.epp,epp)  annotation (Line(
      points={{15.1,-12.9},{15.1,-14},{20,-14},{36,-14},{36,-60},{-78,-60},{-78,-102}},
      color={0,127,0},
      thickness=0.5));
  connect(controller.to_Boiler,gasBoiler_energybased. heatFlowRate) annotation (Line(
      points={{-50.92,-14.24},{-50.92,-14},{-22,-14},{-22,-18},{-22,-26.6}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(gasBoiler_energybased.gasPortIn,gasPortIn)  annotation (Line(
      points={{-14,-45.6},{-4,-45.6},{-4,-70},{78,-70},{78,-106}},
      color={255,255,0},
      thickness=1.5));
  connect(controller.to_Boiler,add. u1) annotation (Line(
      points={{-50.92,-14.24},{-18,-14.24},{-18,26.8},{28.4,26.8}},
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
  connect(Q_Demand, Storage.Q_Demand) annotation (Line(
      points={{0,100},{0,37.7},{59.3,37.7}},
      color={162,29,33},
      pattern=LinePattern.Dash));

 // Model statistics:
 heat_CHP_output.flowCollector.unit_flow = cHP.Q_CHP_out;
 connect(heat_CHP_output.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.q_output_CHP]);

 elec_CHP_output.flowCollector.unit_flow = epp.P;
 connect(elec_CHP_output.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.el_output_CHP]);



  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Combination of storage tank, CHP unit, boiler and controller model into one system model with a connection to the electrical grid and the gas grid.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_demand</p>
<p>TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp</p>
<p>TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn</p>
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
end CHPSystem;

