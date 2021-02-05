within IntegraNet.EnergyConverter.Systems;
model PV_HeatPump "PV + Heatpump with thermal storage"
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

  parameter SI.Temperature T_s_max=343.15 "|Storage|Maximum storage temperature" annotation(HideResult=true);
  parameter SI.Temperature T_s_min=323.15 "|Storage|Minimum storage temperature" annotation(HideResult=true);
  parameter SI.Volume V_Storage=0.5 "|Storage|Volume of the Storage";
  parameter SI.Height height=1.3 "|Storage|Height of heat storage";
  parameter SI.Diameter d=sqrt(heatStorage.V_Storage/heatStorage.height*4/Modelica.Constants.pi) "|Storage|Diameter of heat storage" annotation(HideResult=true);
  parameter SI.Temp_C T_amb=15 "|Storage|Assumed constant ambient temperature" annotation(HideResult=true);
  parameter SI.SurfaceCoefficientOfHeatTransfer k=0.08 "|Storage|Coefficient of heat transfer through tank surface" annotation(HideResult=true);

  parameter Modelica.SIunits.Power P_inst=5000 "|PV parameters|combined installed power" annotation(HideResult=true);
  parameter Modelica.SIunits.Power Pmpp=200 "|PV parameters|peak power of one module" annotation(HideResult=true);
  parameter Modelica.SIunits.Area Area=1.18 "|PV parameters|area of one complete module" annotation(HideResult=true);
  parameter Real Strings=1 "|PV parameters|choose amount of strings" annotation(HideResult=true);

  parameter Real GroundCoverageRatio=0.3 "|PV parameters|ratio of covered ground of modules to area of modules" annotation(HideResult=true);
  parameter Real LossesDC=4.44 "|PV parameters|losses in % through connections, wiring, tracking error and mismatches" annotation(HideResult=true);

  parameter Real Eff_inverter=0.98 "|Inverter Parameters|Efficiency of the inverter" annotation(HideResult=true);
  parameter SI.PowerFactor PF_inverter=1 "|Inverter Parameters|Operating power factor of the inverter" annotation(HideResult=true);
  parameter SI.Power P_inverter=5000 "|Inverter Parameters|Rated power of the inverter" annotation(HideResult=true);
  parameter Real XL=0.1 "|Inverter Parameters|Decoupling Inductor" annotation(HideResult=true);
  parameter Real Losses_AC=0.04 "|Inverter Parameters|AC side losses not included in the inverter efficiency" annotation(HideResult=true);

  parameter Real Soiling=5 "|Radiation Parameters|Average annual losses of radiation in % due to soiling" annotation(HideResult=true);
  parameter Real Albedo=0.25 "|Radiation Parameters|Average annual losses of radiation in % due to soiling" annotation(HideResult=true);

  parameter SI.Angle longitude_local=SI.Conversions.from_deg(10) "longitude of the local position, east positive, 10 East for Hamburg";
  parameter SI.Angle longitude_standard=SI.Conversions.from_deg(15) "needed for calculation of coordinated universal time (utc), 15 for central european time, 30 for central european summer time";
  parameter SI.Conversions.NonSIunits.Time_day totaldays=365 "total days of the year, standard=365, leap year=366";
  parameter SI.Angle latitude=SI.Conversions.from_deg(53.55) "latitude of the local position, north posiive, 53,55 North for Hamburg";

  parameter TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.Generic_Characteristics_PVModule PVModuleCharacteristics=TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.PVModule_Characteristics_Sanyo_HIT_200_BA3() "|PV parameters|Characteristics of PV Module" annotation (HideResult=true, choicesAllMatching);

  parameter SI.Angle Tilt=SI.Conversions.from_deg(0) "|Radiation Parameters|inclination of surface" annotation(HideResult=true, Dialog(tab="Tracking and Mounting",group="parameters for fixed mounting"));
  parameter SI.Angle Azimuth=SI.Conversions.from_deg(0) "|Radiation Parameters|gyration of surface; Orientation: +90=West, -90=East, 0=South" annotation(HideResult=true, Dialog(tab="Tracking and Mounting",group="parameters for fixed mounting"));

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
                                                                                       annotation (Placement(transformation(extent={{-38,-70},{-22,-54}})));
  Producer.Heat.Power2Heat.Components.HeatPump_L0_externalController heatPump(
    Delta_T_internal=Delta_T_internal,
    Delta_T_db=Delta_T_db,
    Q_flow_n=Q_flow_n,
    COP_n=COP_n,
    T_source=T_source) annotation (Placement(transformation(extent={{26,-24},{48,-2}})));

  Storage.Heat.HeatStorage_energybased heatStorage(
    T_s_max=T_s_max,
    T_s_min=T_s_min,
    V_Storage=V_Storage,
    height=height,
    d=d,
    T_amb=T_amb,
    k=k) annotation (Placement(transformation(extent={{66,-2},{86,18}})));

  replaceable IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump.ControlStaticHeatPump_PV_oriented controller constrainedby IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump.Base.Controller_PV(T_set=heatStorage.T_s_max, P_HP_el_n=heatPump.P_el_n) annotation (
    Dialog(group="System setup"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-32,-24},{-12,-4}})));

  Modelica.Blocks.Sources.RealExpression ambientTemperature(y=simCenter.ambientConditions.temperature.value)
    annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=0,
        origin={-36,92})));
  Modelica.Blocks.Sources.RealExpression directSolarRadiation(y=simCenter.ambientConditions.directSolarRadiation.value)
    annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=0,
        origin={-36,80})));
  Modelica.Blocks.Sources.RealExpression diffuseSolarRadiation(y=simCenter.ambientConditions.diffuseSolarRadiation.value)
    annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=0,
        origin={-36,68})));
  Modelica.Blocks.Sources.RealExpression wind(y=simCenter.ambientConditions.wind.value)
    annotation (Placement(transformation(
        extent={{10,-7},{-10,7}},
        rotation=0,
        origin={-36,57})));
  Producer.Electrical.Photovoltaics.Advanced_PV.PVModule_ExternalInverter                        pVModule(
    P_inst=P_inst,
    Pmpp=Pmpp,
    Area=Area,
    Strings=Strings,
    GroundCoverageRatio=GroundCoverageRatio,
    LossesDC=LossesDC,
    Soiling=Soiling,
    longitude_local=longitude_local,
    longitude_standard=longitude_standard,
    totaldays=totaldays,
    latitude=latitude,
    slope=Tilt,
    surfaceAzimuthAngle=Azimuth,
    reflectance_ground=Albedo,
    use_input_data=true)                                       annotation (Placement(transformation(extent={{-68,64},{-88,84}})));
  Producer.Electrical.Photovoltaics.Advanced_PV.SinglePhasePVInverter inverter(
    Eff_inverter=Eff_inverter,
    PF_inverter=PF_inverter,
    P_inverter=P_inverter,
    XL=XL,
    Losses_AC=Losses_AC,
    P_PV=P_inst)         annotation (Placement(transformation(
        extent={{9,-7},{-9,7}},
        rotation=90,
        origin={-91,31})));

  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower apparentPower1(useInputConnectorQ=false, useInputConnectorP=true) annotation (Placement(transformation(extent={{-70,-40},{-54,-24}})));

  Modelica.Blocks.Sources.RealExpression excessPV(y=pVModule.P_DC - apparentPower1.epp.P)      annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-31,15})));
  Modelica.Blocks.Math.Add add if heating and hotwater annotation (Placement(transformation(extent={{18,36},{32,50}})));
  Modelica.Blocks.Math.Add add1 if not hotwater annotation (Placement(transformation(extent={{-14,36},{-28,50}})));
  Producer.Heat.Power2Heat.ElectricBoiler_noFluidPorts electricHeater(P_el_n=P_el_n, eta=eta_Heater) annotation (Placement(transformation(extent={{30,-76},{50,-56}})));
  Modelica.Blocks.Math.Add add3  annotation (Placement(transformation(extent={{64,-46},{78,-32}})));

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
     connect(add.y, heatStorage.Q_Demand) annotation (Line(points={{32.7,43},{54,43},{54,13.7},{67.3,13.7}},   color={0,0,127}));
  elseif heating then
     connect(demand[2], heatStorage.Q_Demand) annotation (Line(points={{0,100},{0,100},{0,14},{34,14},{34,13.7},{67.3,13.7}},
                                                                                                                       color={0,127,127}));
  else
     connect(demand[3], heatStorage.Q_Demand) annotation (Line(points={{0,92},{0,92},{0,14},{34,14},{34,13.7},{67.3,13.7}},
                                                                                                              color={0,127,127}));
  end if;

  if not hotwater then
     connect(add1.y, apparentPower1.P_el_set) annotation (Line(points={{-28.7,43},{-66,43},{-66,-22.4},{-66.8,-22.4}}, color={0,0,127}));
  else
     connect(demand[1], apparentPower1.P_el_set) annotation (Line(points={{0,108},{0,32},{-66.8,32},{-66.8,-22.4}}, color={0,127,127}));
  end if;

  connect(apparentPower.epp, epp) annotation (Line(
      points={{-38,-62},{-38,-62.04},{-80,-62.04},{-80,-98}},
      color={0,127,0},
      thickness=0.5));

  connect(heatStorage.SoC,controller. SoC) annotation (Line(points={{86.7,8.4},{86.7,6},{94,6},{94,26},{-44,26},{-44,-14},{-32.2,-14}},          color={0,0,127}));
  connect(ambientTemperature.y,pVModule. T_in) annotation (Line(points={{-47,92},{-50.55,92},{-50.55,82},{-66,82}},   color={0,0,127}));
  connect(directSolarRadiation.y,pVModule. DNI_in) annotation (Line(points={{-47,80},{-50.55,80},{-50.55,76.4},{-66,76.4}},
                                                                                                                          color={0,0,127}));
  connect(diffuseSolarRadiation.y,pVModule. DHI_in) annotation (Line(points={{-47,68},{-50.55,68},{-50.55,71.4},{-66,71.4}}, color={0,0,127}));
  connect(wind.y,pVModule. WindSpeed_in) annotation (Line(points={{-47,57},{-51.55,57},{-51.55,66},{-66,66}},     color={0,0,127}));
  connect(pVModule.epp, inverter.epp_DC) annotation (Line(
      points={{-87.3,73.4},{-87.3,72},{-90,72},{-90,39.82},{-91,39.82}},
      color={0,135,135},
      thickness=0.5));
  connect(inverter.epp_AC, epp) annotation (Line(
      points={{-91,22},{-90,22},{-90,-28},{-90,-62},{-80,-62},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(apparentPower1.epp, epp) annotation (Line(
      points={{-70,-32},{-70,-32},{-70,-32},{-72,-32},{-80,-32},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(demand[2], add.u2) annotation (Line(points={{0,100},{10,100},{10,38.8},{16.6,38.8}}, color={0,127,127}));
  connect(demand[3], add.u1) annotation (Line(points={{0,92},{10,92},{10,47.2},{16.6,47.2}}, color={0,127,127}));

  connect(demand[1], add1.u1) annotation (Line(points={{0,108},{0,108},{0,47.2},{-12.6,47.2}},color={0,127,127}));
  connect(demand[3], add1.u2) annotation (Line(points={{0,92},{0,92},{0,38.8},{-12.6,38.8}},color={0,127,127}));

  connect(controller.P_set_electricHeater, electricHeater.P_set) annotation (Line(
      points={{-11.5,-22.5},{0,-22.5},{0,-40},{0,-56},{40,-56}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(electricHeater.epp, epp) annotation (Line(
      points={{40,-76},{40,-76},{26,-76},{-62,-76},{-62,-98},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(electricHeater.Heat_output, add3.u2) annotation (Line(
      points={{51.2,-66.4},{52,-66.4},{52,-43.2},{62.6,-43.2}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(heatPump.Heat_output, add3.u1) annotation (Line(
      points={{49.32,-13},{54,-13},{54,-34.8},{62.6,-34.8}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(add3.y, heatStorage.Q_Generation) annotation (Line(points={{78.7,-39},{86,-39},{86,-16},{62,-16},{62,3.8},{67.4,3.8}},   color={0,0,127}));
  connect(controller.T_set_HP, heatPump.T_set) annotation (Line(points={{-11.3,-6.5},{5.315,-6.5},{5.315,-9.7},{25.56,-9.7}}, color={0,0,127}));
  connect(controller.P_set_HP, heatPump.P_set_el) annotation (Line(
      points={{-11.5,-13.9},{4.225,-13.9},{4.225,-15.42},{25.56,-15.42}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(controller.P_set_HP, apparentPower.P_el_set) annotation (Line(
      points={{-11.5,-13.9},{4,-13.9},{4,-36},{-34.8,-36},{-34.8,-52.4}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(excessPV.y, controller.PV_excess) annotation (Line(points={{-31,7.3},{-31,2.65},{-31,-3.6}}, color={0,0,127}));
  connect(heatStorage.T, controller.T) annotation (Line(points={{86.7,9.6},{90,9.6},{90,10},{94,10},{94,26},{-44,26},{-44,-14},{-32.2,-14}}, color={0,0,127}));
                                                                                                  annotation(HideResult=true, Dialog(tab="Tracking and Mounting"),choices(choice="Yes",choice="No"),
              Icon(graphics={      Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,102},{100,-98}}),
        Rectangle(
          extent={{12,10},{78,-54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{28,18},{68,2}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{28,-46},{68,-62}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{68,-14},{88,-34}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{6,-12},{18,-12},{12,-22},{18,-32},{6,-32},{12,-22},{6,-12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{72,-32},{78,-14},{84,-32}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{-52,56},{-86,24}},
          lineColor={255,128,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere),
        Polygon(
          points={{-38,48},{8,48},{-28,-22},{-74,-22},{-38,48}},
          smooth=Smooth.None,
          fillColor={0,96,141},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-22,48},{-58,-22}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{-12,48},{-48,-22}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{0,52},{-40,-24}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{-50,38},{10,38}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-52,28},{-2,28}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-62,8},{-10,8}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-108,-22},{-26,-22}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-68,-2},{-12,-2}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-76,-12},{-20,-12}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-26,58},{-66,-22}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{-56,18},{-6,18}},
          color={255,255,255},
          smooth=Smooth.None)}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Combination of PV, heatpump, electric heater and thermal storage models to be used in the energyConverter.</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">The model contains models for a heat pump, an electric heater, a thermal storage tank, a PV module, an inverter and a controller for the operation of the heat pump and the electrical heater. Different control modes can be selected. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end PV_HeatPump;

