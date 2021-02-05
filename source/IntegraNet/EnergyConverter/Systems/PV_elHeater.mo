within IntegraNet.EnergyConverter.Systems;
model PV_elHeater "PV, gas boiler and electrical heater"
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
    final gas_grid=true);

  outer IntegraNet.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter String waterHeating="gas" annotation(Dialog(group="System setup"),choices(choice="electrical" "Electrical water heating with flow heater", choice="gas" "Water is heated by the gas boiler"));

  parameter SI.Power P_el_n=3e3 "|Heater|Nominal electric power of the electric heater" annotation(HideResult=true);
  parameter SI.Efficiency eta_Heater=0.95 "|Heater|Efficiency of the electric heater" annotation(HideResult=true);

  parameter SI.Temperature T_s_max=323.15 "|Storage|Maximum storage temperature" annotation(HideResult=true);
  parameter SI.Temperature T_s_min=303.15 "|Storage|Minimum storage temperature" annotation(HideResult=true);
  parameter SI.Volume V_Storage=0.2 "|Storage|Volume of the Storage" annotation(HideResult=true);
  parameter SI.Height height=1.3 "|Storage|Height of heat storage" annotation(HideResult=true);
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

  parameter TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.Generic_Characteristics_PVModule PVModuleCharacteristics=TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.PVModule_Characteristics_Sanyo_HIT_200_BA3() "|PV parameters|Characteristics of PV Module" annotation (HideResult=true,choicesAllMatching);
  parameter SI.Angle longitude_local=SI.Conversions.from_deg(10) "longitude of the local position, east positive, 10 East for Hamburg";
  parameter SI.Angle longitude_standard=SI.Conversions.from_deg(15) "needed for calculation of coordinated universal time (utc), 15 for central european time, 30 for central european summer time";
  parameter SI.Conversions.NonSIunits.Time_day totaldays=365 "total days of the year, standard=365, leap year=366";
  parameter SI.Angle latitude=SI.Conversions.from_deg(53.55) "latitude of the local position, north posiive, 53,55 North for Hamburg";

 // parameter String Tracking="No Tracking" "|Radiation Parameters|choose if sun position is tracked by tracking device" annotation(HideResult=true, Dialog(tab="General",group="Radiation Parameters"),choices(choice="No Tracking",choice="Biaxial Tracking"));
  parameter SI.Angle Tilt=SI.Conversions.from_deg(0) "|Radiation Parameters|inclination of surface" annotation(HideResult=true, Dialog(tab="Tracking and Mounting",group="parameters for fixed mounting"));
  parameter SI.Angle Azimuth=SI.Conversions.from_deg(0) "|Radiation Parameters|gyration of surface; Orientation: +90=West, -90=East, 0=South" annotation(HideResult=true, Dialog(tab="Tracking and Mounting",group="parameters for fixed mounting"));

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid  FuelMedium= simCenter.gasModel1 "Medium to be used for fuel gas" annotation(HideResult=true);
  parameter Boolean referenceNCV = true "true, if heat calculations shall be in respect to NCV, false will give GCV" annotation(HideResult=true);

  parameter SI.Efficiency eta_Boiler=1.05 "|Boiler|Boiler's overall efficiency" annotation(HideResult=true);
  parameter SI.HeatFlowRate Q_flow_n_Boiler=20000 "|Boiler|Nominal heating power of the gas boiler" annotation(HideResult=true);


  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  SI.Power P "consumed or produced electric power";

  SI.SpecificEnthalpy CalorificValue=if referenceNCV then TransiEnt.Basics.Functions.GasProperties.getRealGasNCV_xi(
      FuelMedium,
      xi_in=xi_fuel[1:FuelMedium.nc - 1],
      NCVIn=0) else TransiEnt.Basics.Functions.GasProperties.getRealGasGCV_xi(
      FuelMedium,
      xi_in=xi_fuel[1:FuelMedium.nc - 1],
      GCVIn=0) "Calorific value of fuel" annotation(HideResult=true);

  SI.MassFraction xi_fuel[FuelMedium.nc] "[CH4, C2H6, C3H8, C4H10, N2, CO2, H2] Fuel gas mass fractions" annotation(HideResult=true);

  // _____________________________________________
  //
  //                   Complex Components
  // _____________________________________________

  Storage.Heat.HeatStorage_energybased heatStorage(
    T_s_max=T_s_max,
    T_s_min=T_s_min,
    V_Storage=V_Storage,
    height=height,
    d=d,
    T_amb=T_amb,
    k=k) annotation (Placement(transformation(extent={{66,-10},{86,12}})));

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
  Producer.Electrical.Photovoltaics.Advanced_PV.PVModule_ExternalInverter pVModule(
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
        extent={{10,-8},{-10,8}},
        rotation=90,
        origin={-90,32})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower apparentPower1(
                                                                                       useInputConnectorQ=false, useInputConnectorP=true)  annotation (Placement(transformation(extent={{-70,-40},{-54,-24}})));

  Modelica.Blocks.Math.Add add if waterHeating=="gas" annotation (Placement(transformation(extent={{18,34},{34,50}})));
  Modelica.Blocks.Math.Add add1 if waterHeating=="electrical" annotation (Placement(transformation(extent={{-14,34},{-30,50}})));
  Producer.Heat.Power2Heat.ElectricBoiler_noFluidPorts electricHeater(P_el_n=P_el_n, eta=eta_Heater) annotation (Placement(transformation(extent={{2,-34},
            {22,-14}})));

  Modelica.Blocks.Math.Add add2 annotation (Placement(transformation(extent={{42,-24},
            {58,-8}})));
  Producer.Heat.Gas2Heat.SmallGasBoiler.GasBoiler_energybased gasBoiler(CalorificValue=CalorificValue, Q_flow_n_boiler=Q_flow_n_Boiler, eta=eta_Boiler, FuelMedium=FuelMedium)  annotation (Placement(transformation(extent={{60,-58},{80,-38}})));
  replaceable Control_elHeater.ElectricHeater_PV_oriented controller(Threshold=
        P_el_n,                                                      P_elHeater=P_el_n) constrainedby IntegraNet.EnergyConverter.Systems.Control_elHeater.Base.Controller_elHeater annotation (
    Dialog(group="System setup"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-34,-10},{-14,10}})));
  Modelica.Blocks.Sources.RealExpression excessPV(y=pVModule.P_DC - apparentPower1.epp.P)  annotation (Placement(transformation(
        extent={{8,-6},{-8,6}},
        rotation=0,
        origin={-18,18})));

equation

  P=epp.P;
  // _____________________________________________
  //
  //            Characteristic equations
  // _____________________________________________

  xi_fuel[1:FuelMedium.nc - 1] = inStream(gasPortIn.xi_outflow);
  xi_fuel[end] = 1-sum(xi_fuel[1:FuelMedium.nc - 1]);

  // _____________________________________________
  //
  //            Connect statements
  // _____________________________________________


  if waterHeating=="gas" then
     connect(add.y, heatStorage.Q_Demand) annotation (Line(points={{34.8,42},{54,42},{54,7.27},{67.3,7.27}},   color={0,0,127}));
     connect(demand[1], apparentPower1.P_el_set) annotation (Line(points={{0,108},{0,30},{-66.8,30},{-66.8,-22.4}}, color={0,127,127}));
  else
     connect(demand[2], heatStorage.Q_Demand) annotation (Line(points={{0,100},{0,100},{0,30},{34,30},{34,7.27},{67.3,7.27}},
                                                                                                                       color={0,127,127}));
     connect(add1.y, apparentPower1.P_el_set) annotation (Line(points={{-30.8,42},
            {-68,42},{-68,-22.4},{-66.8,-22.4}},                                                                       color={0,0,127}));
  end if;




  connect(ambientTemperature.y,pVModule. T_in) annotation (Line(points={{-47,92},{-50.55,92},{-50.55,82},{-66,82}},   color={0,0,127}));
  connect(directSolarRadiation.y,pVModule. DNI_in) annotation (Line(points={{-47,80},{-50.55,80},{-50.55,76.4},{-66,76.4}},
                                                                                                                          color={0,0,127}));
  connect(diffuseSolarRadiation.y,pVModule. DHI_in) annotation (Line(points={{-47,68},{-50.55,68},{-50.55,71.4},{-66,71.4}}, color={0,0,127}));
  connect(wind.y,pVModule. WindSpeed_in) annotation (Line(points={{-47,57},{-51.55,57},{-51.55,66},{-66,66}},     color={0,0,127}));
  connect(pVModule.epp, inverter.epp_DC) annotation (Line(
      points={{-87.3,73.4},{-87.3,74},{-90,74},{-90,41.8}},
      color={0,135,135},
      thickness=0.5));
  connect(inverter.epp_AC, epp) annotation (Line(
      points={{-90,22},{-90,22},{-90,-32},{-80,-32},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(apparentPower1.epp, epp) annotation (Line(
      points={{-70,-32},{-70,-32},{-70,-32},{-72,-32},{-80,-32},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(demand[2], add.u2) annotation (Line(points={{0,100},{0,100},{0,37.2},{16.4,37.2}},   color={0,127,127}));
  connect(demand[3], add.u1) annotation (Line(points={{0,92},{0,92},{0,46.8},{16.4,46.8}},   color={0,127,127}));

  connect(demand[1], add1.u1) annotation (Line(points={{0,108},{0,108},{0,46.8},{-12.4,46.8}},color={0,127,127}));
  connect(demand[3], add1.u2) annotation (Line(points={{0,92},{0,92},{0,37.2},{-12.4,37.2}},color={0,127,127}));

  connect(electricHeater.epp, epp) annotation (Line(
      points={{12,-34},{12,-48},{12,-48},{12,-62},{-62,-62},{-62,-98},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(gasBoiler.gasPortIn, gasPortIn) annotation (Line(
      points={{78,-57.6},{78,-57.6},{78,-96},{80,-96}},
      color={255,255,0},
      thickness=1.5));
  connect(add2.y, heatStorage.Q_Generation) annotation (Line(points={{58.8,-16},
          {64,-16},{64,-3.62},{67.4,-3.62}},
                                           color={0,0,127}));
  connect(electricHeater.Heat_output, add2.u2) annotation (Line(
      points={{23.2,-24.4},{32.6,-24.4},{32.6,-20.8},{40.4,-20.8}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(heatStorage.SoC, controller.SoC) annotation (Line(points={{86.7,1.44},{94,1.44},{94,26},{-42,26},{-42,0},{-34.4,0}},
                                                               color={0,0,127}));
  connect(controller.Q_flow_set_boiler, add2.u1) annotation (Line(
      points={{-13.9,4.3},{10,4.3},{10,4},{34,4},{34,-11.2},{40.4,-11.2}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(controller.Q_flow_set_boiler, gasBoiler.heatFlowRate) annotation (
      Line(
      points={{-13.9,4.3},{28,4.3},{28,-30},{70,-30},{70,-38.6}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(controller.P_set_electricHeater, electricHeater.P_set) annotation (
      Line(
      points={{-13.9,-4.3},{12,-4.3},{12,-14}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(excessPV.y, controller.PV_excess) annotation (Line(points={{-26.8,18},{-29,18},{-29,10.2}},
                                color={0,0,127}));
  annotation (Icon(graphics={      Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,102},{100,-98}}),
        Ellipse(
          extent={{-52,56},{-86,24}},
          lineColor={255,128,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere),
        Line(
          points={{-52,28},{-2,28}},
          color={255,255,255},
          smooth=Smooth.None),
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
          smooth=Smooth.None),
        Ellipse(
          extent={{20,-40},{68,-60}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{20,4},{68,-52}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Line(
          points={{34,-18},{62,-20},{32,-30},{56,-34},{44,-38},{44,-58}},
          thickness=0.5,
          smooth=Smooth.None,
          color={0,134,134}),
        Ellipse(
          extent={{20,16},{68,-6}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder)}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Combination of gas boiler, PV, electric heater and thermal storage models to be used in the energyConverter.</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">The model contains models for an electric heater, a thermal storage tank, a PV module, an inverter, a gas boiler and a controller for the operation of the electrical heater. The heater will be switched on in case of PV power exceeding the electrical demand of the household and if the storage tank is not full.</span></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end PV_elHeater;

