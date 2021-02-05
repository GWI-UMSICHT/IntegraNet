within IntegraNet.EnergyConverter.Systems;
model CHP_Boiler_Storage "CHP unit, thermal storage and gas boiler"
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
  // ___________________________________________________________________________
  //
  //          Imports and Class Hierarchy
  // ___________________________________________________________________________

  extends Base.Systems(
  final DHN=false,
  final el_grid=true,
  final gas_grid=true,
   medium1=FuelMedium);

   //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________

  SI.Temperature T_s_max=353.15  "|Storage|Maximum Temperature of Storage" annotation(HideResult=true, Dialog(group="Storage"));
  SI.Temperature T_s_min=333.15 "|Storage|Minimum storage temperature"
                                                                      annotation(HideResult=true, Dialog(group="Storage"));

  parameter Modelica.SIunits.HeatCapacity cp_Storage=4180  "|Storage|Heat capacity of Water" annotation(HideResult=true);
  parameter Modelica.SIunits.Volume V_Storage=0.5 "|Storage|Volume of heat storage" annotation(HideResult=true);
  parameter SI.Height height=1.3 "|Storage|Height of heat storage" annotation(HideResult=true, Dialog(group="Geometry"));
  parameter SI.Diameter d=sqrt(V_Storage/height*4/Modelica.Constants.pi) "|Storage|Diameter of heat storage" annotation(HideResult=true, Dialog(group="Geometry"));
  parameter SI.Temp_C T_amb=15 "|Storage|Assumed constant ambient temperature" annotation(HideResult=true, Dialog(group="Calculation of losses"));
  parameter SI.SurfaceCoefficientOfHeatTransfer k=0.08 "|Storage|Coefficient of heat Transfer" annotation(HideResult=true, Dialog(group="Calculation of losses"));
                                    //According to BINE-Waermespeicher

  parameter Modelica.SIunits.Density rho_Water=977  "|Storage|Density of Water" annotation(HideResult=true);

  parameter Real eta_Boiler=0.8 "|Boiler|Efficiency of the boiler" annotation(HideResult=true);
  parameter Modelica.SIunits.Power Q_Boiler=6000  "|Boiler|Nominal heat output of Boiler" annotation(HideResult=true);

  parameter Boolean referenceNCV = true "true, if heat calculations shall be in respect to NCV, false will give GCV" annotation(HideResult=true);

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid  FuelMedium= simCenter.gasModel1 "Medium to be used for fuel gas" annotation(HideResult=true);

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
      GCVIn=0) "Calorific value of fuel" annotation(HideResult=true);

  SI.MassFraction xi_fuel[FuelMedium.nc] "[CH4, C2H6, C3H8, C4H10, N2, CO2, H2] Fuel gas mass fractions" annotation(HideResult=true);

  // __________________________________________________________________________
  //
  //                   Complex Components
  // ___________________________________________________________________________

  IntegraNet.Storage.Heat.HeatStorage_energybased Storage(
    V_Storage=V_Storage,
    rho_Water=rho_Water,
    cp_Storage=cp_Storage,
    T_s_max=T_s_max,
    T_s_min=T_s_min,
    d=d,
    height=height,
    T_amb=T_amb,
    k=k) annotation (Placement(transformation(extent={{58,22},{78,42}})));

IntegraNet.Producer.Combined.SmallScaleCHP.CHP_simple cHP(
  Q_CHP=Q_CHP,
  P_CHP=P_CHP,
  eta_total=eta_total,
  CalorificValue=CalorificValue) annotation (Placement(transformation(extent={{-6,-20},{14,0}})));

  replaceable IntegraNet.Producer.Combined.SmallScaleCHP.Control_CHP_boiler_storage.heat_driven controller constrainedby IntegraNet.Producer.Combined.SmallScaleCHP.Control_CHP_boiler_storage.Base.Controller_Base(Q_Boiler=Q_Boiler) "Choose a control strategy" annotation (choicesAllMatching=true, Placement(transformation(extent={{-70,-20},{-52,-2}})));

  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower apparentPower(useInputConnectorQ=false, useInputConnectorP=true)  annotation (Placement(transformation(extent={{-44,68},{-28,84}})));

Modelica.Blocks.Math.Add addGeneration annotation (Placement(transformation(extent={{30,14},{46,30}})));
IntegraNet.Producer.Heat.Gas2Heat.SmallGasBoiler.GasBoiler_energybased gasBoiler_energybased(
  FuelMedium=FuelMedium,
  CalorificValue=CalorificValue,
  eta=eta_Boiler,
  Q_flow_n_boiler=Q_Boiler) annotation (Placement(transformation(extent={{-32,-46},{-12,-26}})));
Modelica.Blocks.Math.Add addDemand annotation (Placement(transformation(extent={{12,58},{28,74}})));
  parameter SI.Power Q_CHP=4000 "|CHP|Heat output of CHP";
  parameter SI.Power P_CHP=8000 "|CHP|Electric power output of CHP";
  parameter Real eta_total=0.9 "|CHP|Total efficiency of CHP as sum of thermal and electrical efficiency";
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

  connect(gasPortIn, gasPortIn) annotation (Line(
      points={{80,-96},{78,-96},{78,-96},{80,-96}},
      color={255,255,0},
      thickness=1.5));
  connect(cHP.gasPortIn, gasPortIn) annotation (Line(
      points={{15.2,-18.2},{80,-18.2},{80,-96}},
      color={255,255,0},
      thickness=1.5));
  connect(controller.to_CHP, cHP.OnOffSignal) annotation (Line(points={{-51.64,-7.4},{-6.2,-7.4},{-6.2,-9.4}}, color={255,0,255}));
  connect(controller.SoC,Storage.SoC)  annotation (Line(points={{-70.18,-11.36},{-76,-11.36},{-76,48},{96,48},{96,32},{86,32},{86,32.4},{78.7,32.4}},
                                                                                                                                         color={0,0,127}));
  connect(cHP.epp, epp) annotation (Line(
      points={{15.1,-12.9},{15.1,-14},{20,-14},{36,-14},{36,-60},{-80,-60},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(apparentPower.epp, epp) annotation (Line(
      points={{-44,76},{-80,76},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(apparentPower.P_el_set, demand[1]) annotation (Line(points={{-40.8,85.6},{-40.8,92},{0,92},{0,104},{0,108}},
                                                           color={0,0,127}));
  connect(controller.to_Boiler, gasBoiler_energybased.heatFlowRate) annotation (Line(
      points={{-50.92,-14.24},{-50.92,-14},{-22,-14},{-22,-18},{-22,-26.6}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(gasBoiler_energybased.gasPortIn, gasPortIn) annotation (Line(
      points={{-14,-45.6},{-4,-45.6},{-4,-70},{80,-70},{80,-96}},
      color={255,255,0},
      thickness=1.5));
  connect(controller.to_Boiler, addGeneration.u1) annotation (Line(
      points={{-50.92,-14.24},{-18,-14.24},{-18,26.8},{28.4,26.8}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(demand[2], addDemand.u1) annotation (Line(points={{0,100},{0,100},{0,70.8},{10.4,70.8}}, color={0,127,127}));
  connect(demand[3], addDemand.u2) annotation (Line(points={{0,92},{0,92},{0,61.2},{10.4,61.2}}, color={0,127,127}));
  connect(Storage.Q_Demand, addDemand.y) annotation (Line(
      points={{59.3,37.7},{36,37.7},{36,66},{28.8,66}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(Storage.Q_Generation, addGeneration.y) annotation (Line(
      points={{59.4,27.8},{58,27.8},{58,28},{54,28},{48.8,28},{48.8,22},{46.8,22}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(cHP.Q_CHP_out, addGeneration.u2) annotation (Line(
      points={{16.6,-2},{20,-2},{20,17.2},{28.4,17.2}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  annotation (Icon(graphics={      Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,100},{100,-100}}),
        Rectangle(
          extent={{-78,28},{-40,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-2,42.0001},{2,-25.9999}},
        lineColor={0,0,0},
        fillColor={175,175,175},
        fillPattern=FillPattern.VerticalCylinder,
        origin={-46.0001,2},
        rotation=-90),
        Bitmap(
          extent={{-6,30},{84,-88}},
          imageSource="iVBORw0KGgoAAAANSUhEUgAAATkAAAE5CAMAAADcP6fDAAAACXBIWXMAABcSAAAXEgFnn9JSAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAYZQTFRFAAAAAAD/Dw//Hx//Ly//Pz8/Pz//T0//X19fX1//b2//f39/j4//n5+fn5//v7+/v7//z8//39//7+//////////////////////////////////////////////////////////////////AAAAAAD/DAwMDgECDwsDDw8PDw//GRkZHQMEHxYHHx8fHx//JiYmLAUGLyELLy8vLy//MzMzOwcJPiwOPz8/Pz//SggLTExMTjcST09PT0//WAoNWVlZXkIWX19fX1//ZmZmZwwPbU0Zb29vb2//cnJydg4SfVgdf39/f3//hQ8UjIyMjWMhj4+Pj4//lBEWmZmZnG4kn5+fn5//ohMYpaWlrHkor6+vr6//sRUbsrKyvIQsv7+/v7//wBYdy48vzMzMzxgfz8/Pz8//25oz3hoh39/f39//66U37Rwk7+/v7+//+7A7/wAA/w8P/x8f/y8v/z8//09P/19f/29v/39//4+P/5+f/6+v/7+//8/P/9/f/+/v////kIefhAAAACR0Uk5TAAAAAAAAAAAAAAAAAAAAAAAAAAAADx8vP09fb3+Pn6+/z9/v4vdPWQAAFjRJREFUeNrtnftf20a2wJvu3b13d7t72638fiBbYxeb2KaAsZ0ACTYFUuwGSLALgdguKaQ2wdA23d32blv951fyQxppJFmPkayHzw/99COTwfpyzpzHnJn54APbSCAYikbjJElStFgSzNNoNBIM+j6YCyQMsbgELmlJkAxBv+eZ+UPRhSStR8hYJOhRaL5gVLWeyepfPBzwGLVQLEFjEmoh4hV6wSg2ahy9eNjtM58vHKdocyQRDbgY2wJtqiRjgTm2ObyxhCzBNoYXdc2c549RtLVCht3ALUzSMxAq5nDF80UpelZCOjjH8MfpmUrSoUYbJOmZCxX1zbl5hJ1duDmNnZ24OYldwGbcRuzm/tStfnaW8Zuj47tQkrazxO063flJ2uZCRWwJLko7QBL2K0IFk7QzJGYvk/XFaMdIMjhXOMernZMUzlZqF0jQzhM75BQR2pGSmHXN2EfSDhVqtulYkKKd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"),
        Rectangle(
          extent={{-9,13},{9,-13}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={175,175,175},
          origin={-21,5},
          rotation=90),
        Rectangle(
          extent={{-16,16},{-10,14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,0,0}),
        Rectangle(
          extent={{-32,-4},{-26,-6}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,0,0}),
        Rectangle(
          extent={{-16,-4},{-10,-6}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,0,0}),
        Text(
          extent={{-30,10},{-10,-2}},
          lineColor={0,0,0},
          fillColor={19,202,77},
          fillPattern=FillPattern.Solid,
          textString="G",
          textStyle={TextStyle.Bold}),
        Rectangle(
          extent={{-62,34},{-58,28}},
          fillColor={215,215,215},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-82,62},{-78,42}},
          fillColor={215,215,215},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-78,46},{-74,42}},
          fillColor={215,215,215},
          fillPattern=FillPattern.HorizontalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-72,58},{-68,46}},
          fillColor={255,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-72,62},{-4,58}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,0,0},
          lineColor={0,0,0}),
        Rectangle(
          extent={{-56,38},{-40,34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,128,0}),
        Rectangle(
          extent={{-76,48},{-56,34}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,20},{-22,16}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,0,255},
          lineColor={0,0,0}),
        Rectangle(
          extent={{-34,38},{-30,22}},
          fillColor={255,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-22,52},{-26,20}},
          fillColor={0,0,255},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-22,52},{-4,48}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,0,255},
          lineColor={0,0,0}),
        Rectangle(
          extent={{-40,46},{-20,32}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-20,46},{-40,32}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-40,26},{-30,22}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,0,0},
          lineColor={0,0,0}),
        Line(
          points={{-76,48},{-56,34}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-90,24},{-46,22}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,0},
          lineColor={0,0,0})}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Combination of CHP and boiler models to be used in the energyConverter.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>IntegraNet.Basics.Interfaces.General.PowerIn <b>demand</b></p>
<p><i>Conditional interfaces depending on the technologies selected:</i></p>
<p>TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort <b>epp - connection to electrical grid</b></p>
<p>TransiEnt.Basics.Interfaces.Gas.RealGasPortIn <b>gasPortIn - connection to gas grid</b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model contains models for a CHP unit, a thermal storage tank, a gas boiler and a controller for the operation of the CHP unit and the boiler. Different control modes can be selected. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end CHP_Boiler_Storage;

