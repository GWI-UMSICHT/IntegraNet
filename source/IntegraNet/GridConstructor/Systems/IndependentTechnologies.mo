within IntegraNet.GridConstructor.Systems;
model IndependentTechnologies
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

  extends IntegraNet.GridConstructor.Systems.Base.Systems_Base(onlyElectric=false);
  outer IntegraNet.SimCenter simCenter;


  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

   parameter Real cosphi_boundary=1 annotation (HideResult=true);
  //parameter TILMedia.VLEFluidTypes.BaseVLEFluid Medium= simCenter.fluid1 "Medium model" annotation (HideResult=true);

  //Boiler parameters
  parameter SI.Efficiency eta_boiler=0.9 "Efficiency of the gas boiler" annotation (HideResult=true);

  //Oil Boiler parameters
  parameter SI.Efficiency eta_oil = 0.78 "Efficiency of the oil boiler" annotation (HideResult=true);

  //Biomass Boiler parameters
  parameter SI.Efficiency eta_biomass = 0.98 "Efficiency of the oil boiler" annotation (HideResult=true);

  //PV parameters
  parameter SI.Power P_inst_PV=200 "Combined installed PV power" annotation (HideResult=true);
  parameter Real Tilt_PV=0 "Inclination of surface of PV modules" annotation (HideResult=true);
  parameter Real Azimuth_PV=0 "Gyration of PV surface; Orientation: +90=West, -90=East, 0=South" annotation (HideResult=true);
  parameter String PVModuleCharacteristics="Sanyo_HIT_200_BA3" annotation (HideResult=true);

  parameter Real phi_PV=53.63 "degree of latitude of location" annotation (HideResult=true);
  parameter Real lambda_PV=10 "degree of longitude of location" annotation (HideResult=true);
  parameter Real timezone_PV=1 "timezone of location (UTC+) - for Hamburg timezone=1" annotation (HideResult=true);
  parameter SI.Energy E_max_PV=0 "Maximum capacity of the battery" annotation (HideResult=true);
  parameter SI.Energy E_min_PV=0 "Maximum capacity of the battery" annotation (HideResult=true);
  parameter SI.Power P_load_PV=2000 "Charging/discharging power of the battery" annotation (HideResult=true);
  parameter Real eta_load_battery_PV=0.95 "Conversion efficiency while loading" annotation (HideResult=true);
  parameter SI.Frequency selfDischargeRate_battery=4e-9 "E.g. 0.5/3600 = 50% discharge per hour, used if no detailed staionary loss model is available" annotation (HideResult=true);
  parameter TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.Generic_Characteristics_PVModule ModuleCharacteristics=if PVModuleCharacteristics=="Sanyo_HIT_200_BA3" then TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.PVModule_Characteristics_Sanyo_HIT_200_BA3() else TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.PVModule_Characteristics_Sanyo_HIT_200_BA3() "Characteristics of PV Module" annotation (HideResult=true);

  parameter TransiEnt.Storage.Electrical.Specifications.LithiumIon params(E_max=E_max_PV, E_min=E_min_PV, P_max_load=P_load_PV, P_max_unload=P_load_PV, eta_load=eta_load_battery_PV, eta_unload=eta_load_battery_PV, selfDischargeRate=selfDischargeRate_battery)    "Record of generic storage parameters" annotation (Dialog(group="Battery Parameters"),choicesAllMatching,HideResult=true);


  //CHP parameters
  parameter Real eta_CHP=0.9 "Total efficiency of CHP as sum of thermal and electrical efficiency" annotation (HideResult=true);
  parameter SI.Power Q_CHP=4000 "Heat output of CHP" annotation (HideResult=true);
  parameter SI.Power P_CHP=8000 "Electric power output of CHP" annotation (HideResult=true);
  parameter SI.Efficiency eta_boiler_CHP=1.05 "Boiler's overall efficiency" annotation (HideResult=true);
  parameter SI.Temperature T_s_max_CHP=363.15 "Maximum storage temperature" annotation (HideResult=true);
  parameter SI.Temperature T_s_min_CHP=303.15 "Minimum storage temperature" annotation (HideResult=true);
  parameter SI.Volume V_s_CHP=0.5 "Volume of the Storage" annotation (HideResult=true);
  parameter SI.Height h_s_CHP=1.3 "Height of heat storage" annotation (HideResult=true);
  parameter SI.Temp_C T_s_amb_CHP=15 "Assumed constant temperature in tank installation room" annotation (HideResult=true);
  parameter SI.SurfaceCoefficientOfHeatTransfer k_s_CHP=0.08 "Coefficient of heat Transfer" annotation (HideResult=true);

  //Solar heating parameters
  parameter Boolean SpaceHeating=true "Does the solar heating system provide energy for space heating?" annotation (HideResult=true);
  parameter SI.Temperature T_set_ST=348.15 "Temperature set point for controller" annotation (HideResult=true);
  parameter SI.Temperature T_max_ST=273.15 + 95 "maximum input temperature for collector switch-off" annotation (HideResult=true);
  parameter SI.Area area_ST=5 "Aperture area" annotation (HideResult=true);
  parameter SI.Volume V_ST=2 "Volume of the storage tank" annotation (HideResult=true);
  parameter SI.Temperature T_return_ST=308.15 "Return temperature of the heating system" annotation (HideResult=true);
  parameter Real eta_Boiler_ST=0.9 "efficiency of the boiler for the solar thermal system" annotation (HideResult=true);

  parameter SI.Angle slope_ST=53.55 "slope of the tilted surface, assumption" annotation (HideResult=true);
  parameter SI.Angle azimuth_ST=0 "surface azimuth angle" annotation (HideResult=true);

  parameter SI.Angle latitude_ST=53.55 "latitude of the local position, north posiive, 53,55 North for Hamburg" annotation (HideResult=true);
  parameter SI.Angle longitude_standard_ST=15 "needed for calculation of coordinated universal time (utc), 15 for central european time, 30 for central european summer time" annotation (HideResult=true);
  parameter SI.Angle longitude_local_ST=10 "longitude of the local position, east positive, 10 East for Hamburg" annotation (HideResult=true);
  parameter SI.Temperature T_set_boiler_ST=60 + 273.15 "Temperature setpoint of the boiler" annotation (HideResult=true);
 // parameter IntegraNet.Basics.Types.FuelType fuel_ST=IntegraNet.Basics.Types.FuelType.Gas "choice of fuel";


  //Heat pump parameters
  parameter SI.HeatFlowRate Q_flow_n_HP=3.5e3 "Nominal heat flow of heat pump at nominal conditions according to EN14511" annotation (HideResult=true);
  parameter Real COP_n_HP=3.7 "Heat pump coefficient of performance at nominal conditions according to EN14511" annotation (HideResult=true);
  parameter SI.Temperature T_s_min_HP=313.15 "Minimum storage temperature of heat pump system" annotation (HideResult=true);
  parameter SI.Temperature T_s_max_HP=303.15 "Minimum storage temperature of heat pump system" annotation (HideResult=true);
  parameter SI.Volume V_s_HP=0.2 "Volume of the storage of heat pump system" annotation (HideResult=true);
  parameter SI.Height h_s_HP=0.5 "Height of heat storage in heat pump system" annotation (HideResult=true);
  parameter SI.Temp_C T_s_amb_HP=15 "Assumed constant temperature in tank installation room in heat pump system" annotation (HideResult=true);
  parameter SI.SurfaceCoefficientOfHeatTransfer k_s_HP=0.08 "Coefficient of heat transfer through tank surface in heat pump system" annotation (HideResult=true);
  parameter String T_source_type_HP "Temperature of heat source" annotation (HideResult=true);
  SI.Temperature T_source_HP "Temperature of heat source" annotation (HideResult=true);
  SI.Temperature T_source_ground=simCenter.T_ground+273.15  "Temperature of ground as heat source" annotation (Dialog(group="Heat pump"));
  SI.Temperature T_source_ambient=simCenter.ambientConditions.temperature.value+273.15  "Temperature of ambient air as heat source" annotation (Dialog(group="Heat pump"));
  SI.Temperature T_source_constant=283.15 "Constant heat source temperature" annotation (Dialog(group="Heat pump"));
  SI.Temperature T_source_other=283.15 "Other heat source temperature" annotation (Dialog(group="Heat pump"));
  parameter SI.Power P_el_backup_HP=10e3 "Nominal electric power of the backup heater" annotation (HideResult=true);
  // _____________________________________________
  //
  //          Complex Components
  // _____________________________________________


  Components.Boundaries.Electrical.ApparentPower.Electric_Consumer Electric_Consumer(cosphi_boundary=cosphi_boundary) if El_Consumer==1    annotation (Placement(transformation(extent={{-68,52},{-52,68}})));

  Modelica.Blocks.Math.Sum sum(nin=2) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=-90,
        origin={26,60})));

  //PV
public
  Producer.Electrical.Photovoltaics.Advanced_PV.PVModule_ExternalInverter                        pVModule(
    P_inst=P_inst_PV,
    PVModuleCharacteristics=ModuleCharacteristics,
    longitude_local=SI.Conversions.from_deg(lambda_PV),
    longitude_standard=SI.Conversions.from_deg(timezone_PV*15),
    latitude=SI.Conversions.from_deg(phi_PV),
    slope=SI.Conversions.from_deg(Tilt_PV),
    surfaceAzimuthAngle=SI.Conversions.from_deg(Azimuth_PV)) if
                              PV==1 annotation (Placement(transformation(extent={{-40,8},{-24,24}})));
  Modelica.Blocks.Sources.RealExpression ambientTemperature(y=simCenter.ambientConditions.temperature.value) if PV==1    annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=0,
        origin={-64,29})));
  Modelica.Blocks.Sources.RealExpression directSolarRadiation(y=simCenter.ambientConditions.directSolarRadiation.value) if  PV==1
    annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=0,
        origin={-64,19})));
  Modelica.Blocks.Sources.RealExpression diffuseSolarRadiation(y=simCenter.ambientConditions.diffuseSolarRadiation.value) if  PV==1
    annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={-64,10})));
  Modelica.Blocks.Sources.RealExpression wind(y=simCenter.ambientConditions.wind.value) if PV==1
    annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={-64,2})));

  Modelica.Blocks.Sources.RealExpression PVPower(y=pVModule.P_DC) if PV==1 and E_max_PV>0  annotation (Placement(transformation(
        extent={{-7,-6},{7,6}},
        rotation=0,
        origin={-71,-8})));

  Producer.Electrical.Photovoltaics.Advanced_PV.SinglePhasePVInverter PVInverter(P_PV=P_inst_PV) if PV==1 annotation (Placement(transformation(extent={{-32,-66},{-48,-42}})));

  TransiEnt.Storage.Electrical.LithiumIonBattery battery(use_PowerRateLimiter=false, StorageModelParams=params) if PV==1 and E_max_PV>0 annotation (Placement(transformation(extent={{-48,-40},{-32,-24}})));

  Modelica.Blocks.Math.Add add(k2=-1) if PV==1 and E_max_PV>0  annotation (Placement(transformation(extent={{-56,-18},{-44,-6}})));

 //Heat pump
 Producer.Heat.Power2Heat.HeatPumpSystem HeatPumpSystem(
    Q_flow_n=Q_flow_n_HP,
    COP_n=COP_n_HP,
    T_set=T_s_max_HP,
    T_s_min=T_s_min_HP,
    V_Storage=V_s_HP,
    height=h_s_HP,
    T_amb=T_s_amb_HP,
    k=k_s_HP,
    T_source=T_source_HP,
    P_el_n=P_el_backup_HP) if
                HeatPump==1 annotation (Placement(transformation(extent={{8,12},{-14,34}})));

  //CHP
  Producer.Combined.SmallScaleCHP.CHPSystem CHPSystem(
    eta_total=eta_CHP,
    Q_CHP=Q_CHP,
    P_CHP=P_CHP,
    eta=eta_boiler_CHP,
    T_s_max=T_s_max_CHP,
    T_s_min=T_s_min_CHP,
    V_Storage=V_s_CHP,
    height=h_s_CHP,
    T_amb=T_s_amb_CHP,
    k=k_s_CHP) if   CHP==1 annotation (Placement(transformation(extent={{76,-2},{96,18}})));

  //Solar heating
  Producer.Heat.SolarThermal.SolarThermalSystem_5LayerStorage solarThermalSystem(
    SpaceHeating=SpaceHeating,
    T_return=T_return_ST,
    T_set=T_set_ST,
    T_max=T_max_ST,
    area=area_ST,
    Volume_tank=V_ST,
    eta=eta_Boiler_ST,
    longitude_standard=SI.Conversions.from_deg(longitude_standard_ST),
    latitude=SI.Conversions.from_deg(latitude_ST),
    slope=SI.Conversions.from_deg(slope_ST),
    surfaceAzimuthAngle=SI.Conversions.from_deg(azimuth_ST),
    longitude_local=SI.Conversions.from_deg(longitude_local_ST),
    T_boiler=T_set_boiler_ST,
    fuel=fuel_ST) if             ST==1 annotation (Placement(transformation(extent={{40,10},
            {62,30}})));


public
  Producer.Heat.Heat2Heat.Substation_indirect_noStorage_L1 substation_indirect_noStorage(
    T_start=simCenter.T_supply,
    dT=simCenter.dT,
    m_flow_min=simCenter.m_flow_min) if DHN ==1 annotation (Placement(transformation(extent={{-8,-24},{20,-4}})));



  // nightstorage

  Producer.Heat.GenericFuel2Heat.GenericBoiler oilBoiler(FuelType=IntegraNet.Basics.Types.FuelType.Oil, eta=eta_oil) if
                                                        Oil == 1 annotation (Placement(transformation(extent={{16,-58},{36,-38}})));
  Producer.Heat.GenericFuel2Heat.GenericBoiler pellet(FuelType=IntegraNet.Basics.Types.FuelType.Pellets) if
                                 Biomass==1 annotation (Placement(transformation(extent={{36,-58},{56,-38}})));
  Producer.Heat.Gas2Heat.SmallGasBoiler.GasBoiler_energybased GasBoiler(eta=eta_boiler) if           Boiler==1 and ST==0 annotation (Placement(transformation(extent={{62,-58},{82,-38}})));
  Producer.Heat.Power2Heat.NightStorageHeating nightStorageHeating if
                                                                 NSH ==1 annotation (Placement(transformation(extent={{-32,28},{-12,48}})));
  IntegraNet.Consumer.Consumer_combined.domestic_hot_water domestic_hot_water1(NSH=NSH, cosphi_boundary=cosphi_boundary) annotation (Placement(transformation(extent={{-20,54},{-4,70}})));
  Modelica.Blocks.Math.Add add_dhw(k2=+1) if
                                         PV==1 and E_max_PV>0 annotation (Placement(transformation(extent={{-76,-28},{-64,-16}})));
equation

  if T_source_type_HP=="T_ground" then
    T_source_HP=T_source_ground;
  elseif T_source_type_HP=="T_ambient" then
    T_source_HP=T_source_ambient;
  elseif T_source_type_HP=="T_constant" then
    T_source_HP=T_source_constant;
  else
    T_source_HP=T_source_other;
  end if;


  // _____________________________________________
  //
  //          Connect statements
  // _____________________________________________


  connect(q_Demand, sum.u[1]) annotation (Line(
      points={{1.77636e-015,94},{0,94},{0,74},{26,74},{26,69.6},{25.2,69.6}},
      color={162,29,33},
      pattern=LinePattern.Dash));


  connect(Electric_Consumer.epp, epp) annotation (Line(
      points={{-68.08,59.92},{-68.08,60},{-80,60},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(q_Demand_water, sum.u[2]) annotation (Line(
      points={{60,94},{60,74},{26,74},{26,72},{26.8,72},{26.8,69.6}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(ambientTemperature.y,pVModule. T_in) annotation (Line(points={{-53,29},{-48.65,29},{-48.65,22.4},{-41.6,22.4}}, color={0,0,127}));
  connect(directSolarRadiation.y,pVModule. DNI_in) annotation (Line(points={{-53,19},{-48.65,19},{-48.65,17.92},{-41.6,17.92}},
                                                                                                                              color={0,0,127}));
  connect(wind.y,pVModule. WindSpeed_in) annotation (Line(points={{-53,2},{-46,2},{-46,9.6},{-41.6,9.6}},         color={0,0,127}));
  connect(epp, HeatPumpSystem.epp) annotation (Line(
      points={{-80,-98},{-80,-98},{-80,-68},{-8,-68},{-8,-44},{-8.06,-44},{-8.06,12.22}},
      color={0,127,0},
      thickness=0.5));
  connect(CHPSystem.gasPortIn, gasIn_grid) annotation (Line(
      points={{93.7,-2.7},{93.7,-96},{80,-96}},
      color={255,255,0},
      thickness=1.5));
  connect(CHPSystem.epp, epp) annotation (Line(
      points={{77.9,-2.5},{60,-2.5},{60,-80},{-80,-80},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(sum.y, HeatPumpSystem.Q_Demand) annotation (Line(points={{26,51.2},{26,51.2},{26,22},{26,22.89},{7.45,22.89}}, color={0,0,127}));
  connect(sum.y, CHPSystem.Q_Demand) annotation (Line(points={{26,51.2},{26,51.2},{26,46},{86.1,46},{86.1,17.7}}, color={0,0,127}));
  connect(diffuseSolarRadiation.y,pVModule. DHI_in) annotation (Line(points={{-53,10},{-50,10},{-50,13.92},{-41.6,13.92}}, color={0,0,127}));
  connect(add.y, battery.P_set) annotation (Line(points={{-43.4,-12},{-40,-12},{-40,-24.48}}, color={0,0,127}));
  connect(PVPower.y, add.u1) annotation (Line(points={{-63.3,-8},{-57.2,-8},{-57.2,-8.4}}, color={0,0,127}));
  connect(battery.epp, PVInverter.epp_DC) annotation (Line(
      points={{-32,-32},{-26,-32},{-26,-54},{-32.16,-54}},
      color={0,135,135},
      thickness=0.5));
  connect(pVModule.epp, PVInverter.epp_DC) annotation (Line(
      points={{-24.56,15.52},{-18,15.52},{-18,-54},{-32.16,-54}},
      color={0,135,135},
      thickness=0.5));
  connect(PVInverter.epp_AC, epp) annotation (Line(
      points={{-48,-54},{-64,-54},{-80,-54},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(substation_indirect_noStorage.Q_demand_rh, q_Demand) annotation (Line(points={{-5,-5},{-5,2},{12,2},{12,44},{1.77636e-15,44},{1.77636e-15,94}},
                                                color={0,0,127}));
  connect(substation_indirect_noStorage.Q_demand_dhw, q_Demand_water)
    annotation (Line(points={{17,-5},{17,4},{32,4},{32,48},{60,48},{60,94}},
                                                                  color={0,0,127}));
  connect(substation_indirect_noStorage.waterPortIn, waterPortIn) annotation (Line(
      points={{0,-24},{0,-98},{-20,-98}},
      color={175,0,0},
      thickness=0.5));
  connect(substation_indirect_noStorage.waterPortOut, waterPortOut) annotation (Line(
      points={{12.1,-24.1},{12.1,-73.05},{20,-73.05},{20,-98}},
      color={175,0,0},
      thickness=0.5));


  connect(el_Demand, Electric_Consumer.P_el_set) annotation (Line(points={{-60,94},{-60,76},{-64,76},{-64,69.6},{-64.8,69.6}},
                                                                                                             color={0,127,127}));



  connect(q_Demand, solarThermalSystem.Q_demand_heating) annotation (Line(
      points={{0,94},{0,38},{46.1,38},{46.1,29.5}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(q_Demand_water, solarThermalSystem.Q_demand_hotwater) annotation (Line(
      points={{60,94},{60,38},{54.1,38},{54.1,29.5}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(gasIn_grid, solarThermalSystem.gasPortIn) annotation (Line(
      points={{80,-96},{58,-96},{58,-4},{57.5,-4},{57.5,10.1}},
      color={255,255,0},
      thickness=1.5));


  connect(oilBoiler.Q_Demand, sum.y) annotation (Line(points={{26,-38},{26,51.2}},                 color={0,0,127}));
  connect(pellet.Q_Demand, sum.y) annotation (Line(points={{46,-38},{46,-26},{26,-26},{26,51.2}}, color={0,0,127}));
  connect(sum.y, GasBoiler.heatFlowRate) annotation (Line(points={{26,51.2},{26,40},{72,40},{72,-38.6}}, color={0,0,127}));
  connect(GasBoiler.gasPortIn, gasIn_grid) annotation (Line(
      points={{80,-57.6},{94,-57.6},{94,-96},{80,-96}},
      color={255,255,0},
      thickness=1.5));
  connect(q_Demand, nightStorageHeating.Q_demand_sh) annotation (Line(
      points={{1.77636e-15,94},{0,94},{0,74},{-21.9286,74},{-21.9286,44.7857}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(nightStorageHeating.epp, epp) annotation (Line(
      points={{-31.7143,38.2857},{-80,38.2857},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(q_Demand_water, domestic_hot_water1.demand) annotation (Line(
      points={{60,94},{60,76},{-12,76},{-12,70.64}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(el_Demand, add_dhw.u1) annotation (Line(points={{-60,94},{-62,94},{-62,76},{-86,76},{-86,-18.4},{-77.2,-18.4}}, color={0,127,127}));
  connect(add_dhw.y, add.u2) annotation (Line(points={{-63.4,-22},{-60,-22},{-60,-15.6},{-57.2,-15.6}}, color={0,0,127}));
  connect(domestic_hot_water1.electrical_dhw_deman, add_dhw.u2) annotation (Line(points={{-11.92,53.12},{-11.92,50},{-90,50},{-90,-25.6},{-77.2,-25.6}}, color={0,0,127}));
  connect(domestic_hot_water1.epp, epp) annotation (Line(
      points={{-20.08,61.92},{-42,61.92},{-42,44},{-80,44},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Accommodates all available technologies that are connected to gas, electricity and district heating grid networks. </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created during IntegraNet I </span></p>
</html>"));
end IndependentTechnologies;
