within IntegraNet.EnergyConverter.Systems;
model PV_Boiler "PV + gas boiler"
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
   final gas_grid=true,
   medium1=FuelMedium);

  outer IntegraNet.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter String waterHeating="gas" annotation(Dialog(group="System setup"),choices(choice="electrical" "Electrical water heating with flow heater", choice="gas" "Water is heated by the gas boiler"),HideResult=true);
  parameter Boolean battery=false "Is there a PV battery installed?" annotation (Dialog(group="System setup"),choices(checkBox=true),HideResult=true);

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid FuelMedium=simCenter.gasModel1 "|Boiler Parameters|Fuel gas medium" annotation(HideResult=true);
  parameter SI.Efficiency eta=1.05 "|Boiler Parameters|Boiler's overall efficiency" annotation(HideResult=true);
  parameter SI.HeatFlowRate Q_flow_n_boiler=10000 "|Boiler Parameters|Nominal heating power of the gas boiler" annotation(HideResult=true);

  parameter Boolean referenceNCV = true "|Boiler Parameters|true, if heat calculations shall be in respect to NCV, false will give GCV" annotation(HideResult=true);
  // parameter Real lambda=1.2 "|Boiler Parameters|Combustion air ratio" annotation(HideResult=true);

  parameter Modelica.SIunits.Power P_inst=5000 "|PV Parameters|Combined installed power" annotation(HideResult=true);
  parameter Modelica.SIunits.Power Pmpp=200 "|PV Parameters|Peak power of one module" annotation(HideResult=true);
  parameter Modelica.SIunits.Area Area=1.18 "|PV Parameters|Area of one complete module" annotation(HideResult=true);
  parameter Real Strings=1 "|PV Parameters|Choose amount of strings" annotation(HideResult=true);

  parameter Real GroundCoverageRatio=0.3 "|PV Parameters|Ratio of covered ground of modules to area of modules" annotation(HideResult=true);
  parameter Real LossesDC=4.44 "|PV Parameters|Losses in % through connections, wiring, tracking error and mismatches" annotation(HideResult=true);

  parameter Real Eff_inverter=0.98 "|Inverter Parameters|Efficiency of the inverter" annotation(HideResult=true);
  parameter SI.PowerFactor PF_inverter=1 "|Inverter Parameters|Operating power factor of the inverter" annotation(HideResult=true);
  parameter SI.Power P_inverter=5000 "|Inverter Parameters|Rated power of the inverter" annotation(HideResult=true);
  parameter Real XL=0.1 "|Inverter Parameters|Decoupling Inductor" annotation(HideResult=true);
  parameter Real Losses_AC=0.04 "|Inverter Parameters|AC side losses not included in the inverter efficiency" annotation(HideResult=true);

  parameter TransiEnt.Storage.Electrical.Specifications.LithiumIon params(P_max_load=3000, P_max_unload=3000, E_max=3000*3*3600)   "Record of generic storage parameters" annotation (Dialog(group="Battery Parameters"),choicesAllMatching,HideResult=true);

  parameter TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.Generic_Characteristics_PVModule PVModuleCharacteristics=TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.PVModule_Characteristics_Sanyo_HIT_200_BA3() "|PV Parameters|Characteristics of PV Module" annotation (choicesAllMatching,HideResult=true);

  parameter SI.Angle longitude_local=SI.Conversions.from_deg(10) "longitude of the local position, east positive, 10 East for Hamburg";
  parameter SI.Angle longitude_standard=SI.Conversions.from_deg(15) "needed for calculation of coordinated universal time (utc), 15 for central european time, 30 for central european summer time";
  parameter SI.Conversions.NonSIunits.Time_day totaldays=365 "total days of the year, standard=365, leap year=366";
  parameter SI.Angle latitude=SI.Conversions.from_deg(53.55) "latitude of the local position, north posiive, 53,55 North for Hamburg";

  parameter Real Soiling=5 "|Radiation Parameters|Average annual losses of radiation in % due to soiling";

//  parameter String Tracking="No Tracking" "|Radiation Parameters|Choose if sun position is tracked by tracking device" annotation(Dialog(tab="General",group="Radiation Parameters"),choices(choice="No Tracking",choice="Biaxial Tracking"),HideResult=true);
  parameter SI.Angle Tilt=SI.Conversions.from_deg(0) "|Radiation Parameters|Inclination of surface" annotation(Dialog(tab="Tracking and Mounting",group="parameters for fixed mounting"),HideResult=true);
  parameter SI.Angle Azimuth=SI.Conversions.from_deg(0) "|Radiation Parameters|Gyration of surface; Orientation: +90=West, -90=East, 0=South" annotation(Dialog(tab="Tracking and Mounting",group="parameters for fixed mounting"),HideResult=true);

  parameter Real Albedo=0.25 "|Radiation Parameters|Average annual losses of radiation in % due to soiling" annotation(HideResult=true);

  parameter SI.Temperature T_s_max=363.15 "|Storage Parameters|Maximum storage temperature" annotation(HideResult=true);
  parameter SI.Temperature T_s_min=303.15 "|Storage Parameters|Minimum storage temperature" annotation(HideResult=true);
  parameter SI.Volume V_Storage=0.5 "|Storage Parameters|Volume of the Storage" annotation(HideResult=true);
  parameter SI.Height height=1.3 "|Storage Parameters|Height of heat storage" annotation(HideResult=true);
  parameter SI.Temp_C T_amb=15 "|Storage Parameters|Assumed constant temperature in tank installation room" annotation(HideResult=true);
  parameter SI.SurfaceCoefficientOfHeatTransfer k=0.08 "|Storage Parameters|Coefficient of heat Transfer" annotation(HideResult=true);

  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_gas_fuel=simCenter.Cfue_GasBoiler "|Statistics|Specific demand-related cost per gas energy" annotation(HideResult=true);
  parameter TransiEnt.Basics.Types.TypeOfResource TypeOfResource1=TransiEnt.Basics.Types.TypeOfResource.Conventional "|Statistics|Type of resource for boiler" annotation(HideResult=true);
  parameter TransiEnt.Basics.Types.TypeOfResource TypeOfResource2=TransiEnt.Basics.Types.TypeOfResource.Renewable "|Statistics|Type of resource for PV" annotation(HideResult=true);
  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat TypeOfEnergyCarrierHeat=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas "|Statistics|Type of energy carrier" annotation(HideResult=true);




  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  SI.HeatFlowRate Q_flow_gen "Generated heat";
  SI.MassFlowRate m_flow_CDE_PV = -fuelSpecificCO2Emissions_PV.m_flow_CDE_per_Energy*Q_flow_gen "PV CDE mass flow rate";
  SI.Power P_gen=-pVModule.epp.P "Generated electrical power";
  SI.Power P_grid "Electricity supplied from the grid";
  SI.Power P_feedIn "Electricity fed into the grid";
  SI.Energy E_gen "Generated electrical energy";
  SI.Energy E_grid "Electrical energy supplied from the grid";
  SI.Energy E_feedIn "Electrical energy fed into the grid";
  SI.Energy E_con "Electrical energy consumed by the household";
  Real p_selfconsumption "ratio of self-consumed electricity to generated electricity";
  Real p_selfsufficiency "proportion of self-consumed electricity to consumed electricity";

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

    replaceable model ProducerCosts =
      TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PV
      constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PV "|Statistics|PV Cost Specification"
                                                 annotation (Dialog(group="Statistics"),
       __Dymola_choicesAllMatching=true);

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Renewable)
                                                                                                         annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsElectric collectGwpEmissions_PV(typeOfEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Solar)
                                                                                                                annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
protected
  TransiEnt.Components.Statistics.Functions.GetFuelSpecificCO2Emissions fuelSpecificCO2Emissions_PV(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Solar);

public
  Modelica.Blocks.Sources.RealExpression ambientTemperature(y=simCenter.ambientConditions.temperature.value) annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-73,45})));

  Modelica.Blocks.Sources.RealExpression directSolarRadiation(y=simCenter.ambientConditions.directSolarRadiation.value)
                                                                                                                      annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-73,31})));

  Modelica.Blocks.Sources.RealExpression diffuseSolarRadiation(y=simCenter.ambientConditions.diffuseSolarRadiation.value)
                                                                                                                       annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-73,17})));

  Modelica.Blocks.Sources.RealExpression wind(y=simCenter.ambientConditions.wind.value)
                                                                                     annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-73,5})));

  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower apparentPower(useInputConnectorQ=false, useInputConnectorP=true) annotation (Placement(transformation(extent={{-4,2},{16,22}})));

  Producer.Electrical.Photovoltaics.Advanced_PV.SinglePhasePVInverter inverter(
    Eff_inverter=Eff_inverter,
    PF_inverter=PF_inverter,
    P_inverter=P_inverter,
    XL=XL,
    Losses_AC=Losses_AC,
    P_PV=P_inst)         annotation (Placement(transformation(extent={{-28,-64},{-50,-48}})));

  Modelica.Blocks.Math.Add add if waterHeating=="electrical" annotation (Placement(transformation(extent={{-14,48},{-28,62}})));

  Storage.Heat.HeatStorage_energybased heatStorage(
    T_s_max=T_s_max,
    T_s_min=T_s_min,
    V_Storage=V_Storage,
    height=height,
    T_amb=T_amb,
    k=k) annotation (Placement(transformation(extent={{62,12},{82,32}})));

  Producer.Heat.Gas2Heat.SmallGasBoiler.GasBoiler_energybased gasBoiler_energybased(
    FuelMedium=FuelMedium,
    eta=eta,
    CalorificValue=CalorificValue,
    Q_flow_n_boiler=Q_flow_n_boiler)  annotation (Placement(transformation(extent={{8,-40},{28,-20}})));

  Modelica.Blocks.Math.Add add1 if  waterHeating=="gas" annotation (Placement(transformation(extent={{20,62},{34,48}})));

  Modelica.Blocks.Continuous.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMin=0,
    yMax=Q_flow_n_boiler,
    k=Q_flow_n_boiler*10) annotation (Placement(transformation(extent={{52,-16},{38,-2}})));

  Modelica.Blocks.Sources.RealExpression setpoint(y=0.9) annotation (Placement(transformation(
        extent={{6,-5},{-6,5}},
        rotation=0,
        origin={68,-9})));

  TransiEnt.Storage.Electrical.LithiumIonBattery pV_battery(use_PowerRateLimiter=false, StorageModelParams(selfDischargeRate=4e-9) = params) if
                                                                                                                          battery annotation (Placement(transformation(extent={{-38,-42},{-20,-24}})));


  replaceable IntegraNet.EnergyConverter.Systems.Control_Battery.MaxSelfConsumption controller if  battery
     constrainedby Control_Battery.Base.Controller "Operation strategy of the battery" annotation (
    Dialog(group="Battery Parameters"),
    choicesAllMatching=true, Placement(transformation(extent={{-66,-26},{-50,-10}})));

  Modelica.Blocks.Sources.RealExpression p_PV(y=pVModule.P_DC)     annotation (Placement(transformation(extent={{-92,-22},{-76,-4}})));

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
    use_input_data=true) annotation (Placement(transformation(extent={{-48,12},{-28,32}})));

equation

  // _____________________________________________
  //
  //            Characteristic equations
  // _____________________________________________

   Q_flow_gen=min(demand[2]+demand[3]);

   P_grid= if noEvent(epp.P>0) then epp.P else 0;
   P_feedIn= if noEvent(epp.P<0) then -epp.P else 0;

   der(E_gen)=P_gen;
   der(E_grid)=P_grid;
   der(E_feedIn)=P_feedIn;
   der(E_con)=demand[1];

   p_selfconsumption=(E_gen-E_feedIn)/(E_gen+0.0001);
   p_selfsufficiency=(E_gen-E_feedIn)/(E_con+0.0001);

    //Write generated heat and emissions to statistical collectors
  collectElectricPower.powerCollector.P=-P_gen;
  collectGwpEmissions_PV.gwpCollector.m_flow_cde = -fuelSpecificCO2Emissions_PV.m_flow_CDE_per_Energy*pVModule.POA_Irradiation;


  xi_fuel[1:FuelMedium.nc - 1] = inStream(gasPortIn.xi_outflow);
  xi_fuel[end] = 1-sum(xi_fuel[1:FuelMedium.nc - 1]);

 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________

  if waterHeating=="electrical" then
    connect(add.y, apparentPower.P_el_set) annotation (Line(points={{-28.7,55},{-32,55},{-32,50},{-32,40},{0,40},{0,24}},                     color={0,0,127}));
    connect(demand[2], heatStorage.Q_Demand) annotation (Line(points={{0,100},{0,100},{0,44},{24,44},{24,28},{63.3,28},{63.3,27.7}},
                                                                                                                       color={0,127,127}));
  else
    connect(add1.y, heatStorage.Q_Demand) annotation (Line(points={{34.7,55},{56,55},{56,27.7},{63.3,27.7}}, color={0,0,127}));
    connect(demand[1], apparentPower.P_el_set) annotation (Line(points={{0,108},{0,24}},           color={0,127,127}));
  end if;

  connect(modelStatistics.powerCollector[TypeOfResource2],collectElectricPower.powerCollector);
  connect(modelStatistics.gwpCollector[TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Solar], collectGwpEmissions_PV.gwpCollector);

  connect(apparentPower.epp, epp) annotation (Line(
      points={{-4,12},{-4,14},{-8,14},{-10,14},{-10,-78},{-80,-78},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(inverter.epp_AC, epp) annotation (Line(
      points={{-50,-56},{-80,-56},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(demand[3], add.u1) annotation (Line(points={{0,92},{2,92},{2,59.2},{-12.6,59.2}},
                                                                                          color={0,127,127}));
  connect(demand[1], add.u2) annotation (Line(points={{0,108},{0,90},{-2,90},{-2,72},{-2,50},{-12.6,50},{-12.6,50.8}},
                                                                                           color={0,127,127}));

  connect(gasBoiler_energybased.gasPortIn, gasPortIn) annotation (Line(
      points={{26,-39.6},{82,-39.6},{82,-96},{80,-96}},
      color={255,255,0},
      thickness=1.5));
  connect(demand[2], add1.u1) annotation (Line(points={{0,100},{0,100},{0,50.8},{18.6,50.8}},   color={0,127,127}));
  connect(demand[3], add1.u2) annotation (Line(points={{0,92},{2,92},{2,84},{2,60},{18.6,60},{18.6,59.2}},
                                                                                              color={0,127,127}));

  connect(setpoint.y, PID.u_s) annotation (Line(points={{61.4,-9},{61.4,-9},{53.4,-9}}, color={0,0,127}));

  connect(gasBoiler_energybased.heatFlowRate, heatStorage.Q_Generation) annotation (Line(
      points={{18,-20.6},{18,-20.6},{18,17.8},{63.4,17.8}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(gasBoiler_energybased.heatFlowRate, PID.y) annotation (Line(
      points={{18,-20.6},{18,-20.6},{18,-8},{18,-9},{37.3,-9}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(heatStorage.SoC, PID.u_m) annotation (Line(points={{82.7,22.4},{92,22.4},{92,-24},{45,-24},{45,-17.4}}, color={0,0,127}));
  connect(pV_battery.epp, inverter.epp_DC) annotation (Line(
      points={{-20,-33},{-14,-33},{-14,-56},{-28.22,-56}},
      color={0,135,135},
      thickness=0.5));
  connect(controller.P_set_battery, pV_battery.P_set) annotation (Line(points={{-50,-18},{-42,-18},{-29,-18},{-29,-24.54}}, color={0,0,127}));
  connect(p_PV.y, controller.P_PV) annotation (Line(points={{-75.2,-13},{-75.5,-13},{-75.5,-13.2},{-65.52,-13.2}}, color={0,0,127}));

  connect(controller.P_Consumer, demand[1]) annotation (Line(points={{-65.36,-22.8},{-94,-22.8},{-94,72},{-2,72},{-2,90},{0,90},{0,108}}, color={0,0,127}));
  connect(pVModule.epp, inverter.epp_DC) annotation (Line(
      points={{-28.7,21.4},{-12,21.4},{-12,-56},{-28.22,-56}},
      color={0,135,135},
      thickness=0.5));
  connect(ambientTemperature.y, pVModule.T_in) annotation (Line(points={{-63.1,45},{-63.1,38.5},{-50,38.5},{-50,30}}, color={0,0,127}));
  connect(directSolarRadiation.y, pVModule.DNI_in) annotation (Line(points={{-63.1,31},{-57.55,31},{-57.55,24.4},{-50,24.4}}, color={0,0,127}));
  connect(diffuseSolarRadiation.y, pVModule.DHI_in) annotation (Line(points={{-63.1,17},{-57.55,17},{-57.55,19.4},{-50,19.4}}, color={0,0,127}));
  connect(pVModule.WindSpeed_in, wind.y) annotation (Line(points={{-50,14},{-56,14},{-56,5},{-63.1,5}}, color={0,0,127}));
  annotation (Icon(graphics={      Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,100},{100,-100}}),
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
          smooth=Smooth.None),
        Bitmap(
          extent={{2,54},{92,-64}},
          imageSource="iVBORw0KGgoAAAANSUhEUgAAATkAAAE5CAMAAADcP6fDAAAACXBIWXMAABcSAAAXEgFnn9JSAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAYZQTFRFAAAAAAD/Dw//Hx//Ly//Pz8/Pz//T0//X19fX1//b2//f39/j4//n5+fn5//v7+/v7//z8//39//7+//////////////////////////////////////////////////////////////////AAAAAAD/DAwMDgECDwsDDw8PDw//GRkZHQMEHxYHHx8fHx//JiYmLAUGLyELLy8vLy//MzMzOwcJPiwOPz8/Pz//SggLTExMTjcST09PT0//WAoNWVlZXkIWX19fX1//ZmZmZwwPbU0Zb29vb2//cnJydg4SfVgdf39/f3//hQ8UjIyMjWMhj4+Pj4//lBEWmZmZnG4kn5+fn5//ohMYpaWlrHkor6+vr6//sRUbsrKyvIQsv7+/v7//wBYdy48vzMzMzxgfz8/Pz8//25oz3hoh39/f39//66U37Rwk7+/v7+//+7A7/wAA/w8P/x8f/y8v/z8//09P/19f/29v/39//4+P/5+f/6+v/7+//8/P/9/f/+/v////kIefhAAAACR0Uk5TAAAAAAAAAAAAAAAAAAAAAAAAAAAADx8vP09fb3+Pn6+/z9/v4vdPWQAAFjRJREFUeNrtnftf20a2wJvu3b13d7t72638fiBbYxeb2KaAsZ0ACTYFUuwGSLALgdguKaQ2wdA23d32blv951fyQxppJFmPkayHzw/99COTwfpyzpzHnJn54APbSCAYikbjJElStFgSzNNoNBIM+j6YCyQMsbgELmlJkAxBv+eZ+UPRhSStR8hYJOhRaL5gVLWeyepfPBzwGLVQLEFjEmoh4hV6wSg2ahy9eNjtM58vHKdocyQRDbgY2wJtqiRjgTm2ObyxhCzBNoYXdc2c549RtLVCht3ALUzSMxAq5nDF80UpelZCOjjH8MfpmUrSoUYbJOmZCxX1zbl5hJ1duDmNnZ24OYldwGbcRuzm/tStfnaW8Zuj47tQkrazxO063flJ2uZCRWwJLko7QBL2K0IFk7QzJGYvk/XFaMdIMjhXOMernZMUzlZqF0jQzhM75BQR2pGSmHXN2EfSDhVqtulYkKKd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")}),
      Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Combination of PV and boiler models to be used in the energyConverter.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>IntegraNet.Basics.Interfaces.General.PowerIn <b>demand</b></p>
<p>TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort <b>epp - connection to electrical grid</b></p>
<p>TransiEnt.Basics.Interfaces.Gas.RealGasPortIn <b>gasPortIn - connection to gas grid</b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model contains models for a PV module, a battery, an inverter, a gas boiler and a controller for the operation of the battery. Different control modes can be selected. If no battery is present in the system, the capacity can be set to zero.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end PV_Boiler;

