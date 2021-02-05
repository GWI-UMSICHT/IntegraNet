within IntegraNet.EnergyConverter.Systems;
model HeatPump "HeatPump with thermal storage"
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

  extends Base.Systems(
    final DHN=false,
    final el_grid=true,
    final gas_grid=false);

  outer IntegraNet.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter Boolean hotwater=true "Does the heat pump provide energy for the hot water? (if false: water is heated electrically)" annotation (HideResult=true, Dialog(group="System setup"),choices(checkBox=true));
  parameter Boolean heating=true "Does the heat pump provide energy for the space heating? (if false: space heating not accounted for)" annotation (HideResult=true, Dialog(group="System setup"),choices(checkBox=true));


  parameter SI.TemperatureDifference Delta_T_internal=5 "|Heat pump|Temperature difference between refrigerant and source/sink temperature" annotation(HideResult=true);
  parameter SI.TemperatureDifference Delta_T_db=2 "|Heat pump|Deadband of hysteresis control" annotation(HideResult=true);
  parameter SI.HeatFlowRate Q_flow_n=3.5e3 "|Heat pump|Nominal heat flow of heat pump at nominal conditions according to EN14511" annotation(HideResult=true);
  parameter Real COP_n=3.7 "|Heat pump|Coefficient of performance at nominal conditions according to EN14511" annotation(HideResult=true);

  parameter SI.Power P_el_n=10e3 "|Heat pump|Nominal electric power of the backup heater" annotation(HideResult=true);
  parameter SI.Efficiency eta_Heater=0.95   "|Heat pump|Efficiency of the backup heater" annotation(HideResult=true);


  parameter SI.Temperature T_s_max=65+273.15 "|Storage|Maximum storage temperature" annotation(HideResult=true);
  parameter SI.Temperature T_s_min=55+273.15 "|Storage|Minimum storage temperature" annotation(HideResult=true);
  parameter SI.Volume V_Storage=0.5 "|Storage|Volume of the Storage" annotation(HideResult=true);
  parameter SI.Height height=1.3 "|Storage|Height of heat storage" annotation(HideResult=true);
  parameter SI.Diameter d=sqrt(heatStorage.V_Storage/heatStorage.height*4/Modelica.Constants.pi) "|Storage|Diameter of heat storage" annotation(HideResult=true);
  parameter SI.Temp_C T_amb=15 "|Storage|Assumed constant ambient temperature" annotation(HideResult=true);
  parameter SI.SurfaceCoefficientOfHeatTransfer k=0.08 "|Storage|Coefficient of heat transfer through tank surface" annotation(HideResult=true);
  parameter SI.Temperature T_s_max_start=60+273.15 "Start value of maximum storage temperature" annotation (HideResult=true, Dialog(group="Storage"));


  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  SI.Power P "consumed or produced electric power";
  SI.Temperature T_source=simCenter.ambientConditions.temperature.value+273.15 "Temperature of heat source" annotation(Dialog(group="Heat pump"));

  // _____________________________________________
  //
  //                   Complex Components
  // _____________________________________________

  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower apparentPower(useInputConnectorQ=false, useInputConnectorP=true)
                                                                                       annotation (Placement(transformation(extent={{-60,-76},{-44,-60}})));
  Producer.Heat.Power2Heat.Components.HeatPump_L0_externalController heatPump(
    Delta_T_internal=Delta_T_internal,
    Delta_T_db=Delta_T_db,
    Q_flow_n=Q_flow_n,
    COP_n=COP_n,
    T_source=T_source) annotation (Placement(transformation(extent={{16,-22},{38,0}})));

  Storage.Heat.HeatStorage_energybased heatStorage(
    T_s_max=T_s_max,
    T_s_min=T_s_min,
    V_Storage=V_Storage,
    height=height,
    d=d,
    T_amb=T_amb,
    k=k,
    T_s_max_start=T_s_max_start) annotation (Placement(transformation(extent={{60,-2},{80,20}})));

  replaceable IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump.ControlStaticHeatPump_heatDriven Controller constrainedby IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump.Base.Controller(T_set=heatStorage.T_s_max, P_HP_el_n=heatPump.P_el_n) "Control mode of the heat pump" annotation (
    Dialog(group="System setup"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-62,-26},{-40,-4}})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{-14,-62},{-30,-46}})));

  Modelica.Blocks.Math.Add add1 if
                                  heating and hotwater annotation (Placement(transformation(extent={{30,48},{46,64}})));
  Modelica.Blocks.Math.Add add2 if not hotwater annotation (Placement(transformation(extent={{8,-8},{-8,8}},
        rotation=90,
        origin={-52,50})));
  Producer.Heat.Power2Heat.ElectricBoiler_noFluidPorts electricHeater(P_el_n=P_el_n, eta=eta_Heater) annotation (Placement(transformation(extent={{12,-66},{32,-46}})));
  Modelica.Blocks.Math.Add add3 annotation (Placement(transformation(extent={{46,-32},{62,-16}})));


equation

 // _____________________________________________
 //
 //            Characteristic equations
 // _____________________________________________


 P=epp.P;

 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________

  if heating and hotwater then
    connect(add1.y, heatStorage.Q_Demand) annotation (Line(points={{46.8,56},{54,56},{54,15.27},{61.3,15.27}}, color={0,0,127}));
  elseif  heating then
    connect(demand[2], heatStorage.Q_Demand) annotation (Line(points={{0,100},{0,100},{0,14},{32,14},{32,15.27},{61.3,15.27}},
                                                                                                                       color={0,127,127}));
  else
  connect(demand[3], heatStorage.Q_Demand) annotation (Line(points={{0,92},{-2,92},{-2,15.27},{61.3,15.27}}, color={0,127,127}));
  end if;


 if  hotwater then
    connect(demand[1], add.u1) annotation (Line(points={{0,108},{0,108},{0,-48},{0,-49.2},{-12.4,-49.2}},    color={0,127,127}));
 else
    connect(add2.y, add.u1) annotation (Line(points={{-52,41.2},{-52,41.2},{-52,36},{-52,16},{-8,16},{-8,-49.2},{-12.4,-49.2}},
                                                                                                     color={0,0,127}));
 end if;

  connect(apparentPower.epp, epp) annotation (Line(
      points={{-60,-68},{-60,-66.04},{-80,-66.04},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(heatStorage.SoC, Controller.SoC) annotation (Line(points={{80.7,9.44},{80.7,6},{94,6},{94,30},{-76,30},{-76,-15},{-61.78,-15}},        color={0,0,127}));
  connect(Controller.T_set_HP, heatPump.T_set) annotation (Line(points={{-39.23,-6.75},{-34,-6.75},{-34,-6},{4,-6},{4,-8},{15.56,-8},{15.56,-7.7}},   color={0,0,127}));
  connect(Controller.P_set_HP, heatPump.P_set_el) annotation (Line(
      points={{-39.45,-15.11},{-12.945,-15.11},{-12.945,-13.42},{15.56,-13.42}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(Controller.P_set_HP, add.u2) annotation (Line(
      points={{-39.45,-15.11},{2,-15.11},{2,-58.8},{-12.4,-58.8}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(demand[1], add2.u1) annotation (Line(points={{0,108},{0,75},{-56.8,75},{-56.8,59.6}}, color={0,127,127}));
  connect(demand[3], add2.u2) annotation (Line(points={{0,92},{0,92},{0,74},{-48,74},{-48,59.6},{-47.2,59.6}},
                                                                                                 color={0,127,127}));
  connect(demand[2], add1.u1) annotation (Line(points={{0,100},{0,76},{22,76},{22,62},{28.4,62},{28.4,60.8}},
                                                                                              color={0,127,127}));
  connect(demand[3], add1.u2) annotation (Line(points={{0,92},{0,92},{0,51.2},{28.4,51.2}},   color={0,127,127}));


  connect(apparentPower.P_el_set, add.y) annotation (Line(points={{-56.8,-58.4},{-37.4,-58.4},{-37.4,-54},{-30.8,-54}}, color={0,0,127}));
  connect(heatStorage.Q_Generation, add3.y) annotation (Line(
      points={{61.4,4.38},{61.4,-9.81},{62.8,-9.81},{62.8,-24}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(heatPump.Heat_output, add3.u1) annotation (Line(
      points={{39.32,-11},{39.32,-14.5},{44.4,-14.5},{44.4,-19.2}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(electricHeater.Heat_output, add3.u2) annotation (Line(
      points={{33.2,-56.4},{40,-56.4},{40,-28.8},{44.4,-28.8}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(Controller.P_set_electricHeater, electricHeater.P_set) annotation (Line(
      points={{-39.45,-23.47},{-6.725,-23.47},{-6.725,-46},{22,-46}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(electricHeater.epp, epp) annotation (Line(
      points={{22,-66},{-38,-66},{-38,-98},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(heatStorage.T, Controller.T) annotation (Line(points={{80.7,10.76},{94,10.76},{94,30},{-76,30},{-76,-15},{-61.78,-15}}, color={0,0,127}));
  annotation (Icon(graphics={      Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,100},{100,-100}}),
        Rectangle(
          extent={{-40,50},{40,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,12},{-32,12},{-40,0},{-32,-12},{-48,-12},{-40,0},{-48,12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,58},{20,42}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-42},{20,-58}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{32,-10},{40,10},{50,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{28,10},{54,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,12},{-32,12},{-40,0},{-32,-12},{-48,-12},{-40,0},{-48,12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{32,-10},{40,10},{50,-10}},
          color={0,0,0},
          smooth=Smooth.None)}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Combination of heatpump, electric heater and thermal storage models to be used in the energyConverter.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>IntegraNet.Basics.Interfaces.General.PowerIn <b>demand</b></p>
<p>TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort <b>epp - connection to electrical grid</b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model contains models for a heat pump, an electric heater, a thermal storage tank and a controller for the operation of the heat pump and the electrical heater. Different control modes can be selected. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end HeatPump;

