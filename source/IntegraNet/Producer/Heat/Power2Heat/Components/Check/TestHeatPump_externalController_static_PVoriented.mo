within IntegraNet.Producer.Heat.Power2Heat.Components.Check;
model TestHeatPump_externalController_static_PVoriented
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
  inner IntegraNet.SimCenter
                  simCenter(redeclare IntegraNet.Components.Boundaries.Ambient.AmbientConditions_Hamburg_TMY ambientConditions)
                            annotation (Placement(transformation(extent={{-148,78},{-128,98}})));
  parameter TransiEnt.Producer.Heat.Power2Heat.Components.HeatpumpSystemProperties     params(HPInitStatus=2)
                                                                                              annotation (Placement(transformation(extent={{-76,80},{-56,100}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_Heatpump(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=heatPump.Heat_output)          annotation (Placement(transformation(extent={{-102,-88},{-82,-68}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_heatingdemand(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=heatBdryWaterHeatingDeload.port.Q_flow)
                             annotation (Placement(transformation(extent={{-48,-88},{-28,-68}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor Storage(C=params.V_stor_fh*1e3*4.2e3, T(start=params.T_stor_fh_start, fixed=true)) annotation (Placement(transformation(extent={{16,6},{36,26}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatBdryWaterHeatingDeload annotation (Placement(transformation(extent={{58,-18},{38,2}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{84,14},{70,28}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor wall_stor(G=0.5)  "Taken from Knop page 48, Viessmann Vitocell 100-W (200l, 2,2kWh loss per 24h at Delta T 45K)"
                                                                                                    annotation (Placement(transformation(extent={{8,44},{28,64}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_storageloss(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=wall_stor.port_b.Q_flow)     annotation (Placement(transformation(extent={{-74,-88},{-54,-68}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                           heatBdryPeakloadFH1
                                                                              annotation (Placement(transformation(extent={{-22,44},{-2,64}})));
  HeatPump_L0_externalController heatPump annotation (Placement(transformation(extent={{-64,-30},{-44,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heating_heatPump annotation (Placement(transformation(extent={{-28,-32},{-10,-14}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T_stor_is annotation (Placement(transformation(extent={{-8,4},{-28,24}})));
  IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump.ControlStaticHeatPump_PV_oriented controller(
    control_SoC=false,
    P_elHeater=0,
    summer_start=0,
    t_min_on_HP=0,
    t_min_off_HP=0,
    Threshold=1000,
    TLow_HP=332.15,
    THigh_HP=336.15,
    THigh2_HP=334.15,
    TLow2_HP=330.15,
    TLow_Heater=328.15,
    THigh_Heater=330.15) annotation (Placement(transformation(extent={{-110,8},{-90,30}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower apparentPower1(useInputConnectorQ=false, useInputConnectorP=true)
                                                                                       annotation (Placement(transformation(extent={{-114,-34},{-98,-18}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage grid(Use_input_connector_f=false, Use_input_connector_v=false) annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-129,-55})));
  IntegraNet.Producer.Electrical.Photovoltaics.Advanced_PV.PVModule_ExternalInverter                        pVModule(P_inst=3000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-142,28})));
  IntegraNet.Producer.Electrical.Photovoltaics.Advanced_PV.SinglePhasePVInverter inverter(P_PV=pVModule.P_inst)
                                                                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-142,-16})));
public
  Modelica.Blocks.Sources.RealExpression ambientTemperature(y=simCenter.ambientConditions.temperature.value) annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=270,
        origin={-117,57})));
  Modelica.Blocks.Sources.RealExpression directSolarRadiation(y=simCenter.ambientConditions.directSolarRadiation.y1)  annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=270,
        origin={-131,59})));
  Modelica.Blocks.Sources.RealExpression diffuseSolarRadiation(y=simCenter.ambientConditions.diffuseSolarRadiation.y1) annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=270,
        origin={-145,61})));
  Modelica.Blocks.Sources.RealExpression wind(y=simCenter.ambientConditions.wind.y1) annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=270,
        origin={-157,63})));
  Modelica.Blocks.Sources.RealExpression P_PV(y=-inverter.epp_AC.P) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-71,62})));
  IntegraNet.Consumer.Consumer_combined.Data.WaterHeatingDemand_Table waterHeatingDemand_Table annotation (Placement(transformation(extent={{178,-26},{198,-6}})));
  IntegraNet.Consumer.Consumer_combined.Data.WaterHeatingDemand_Table waterHeatingDemand_Table1(fileName=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/HotWater_20Consumers_VEDIS_3MWh_60s.txt")) annotation (Placement(transformation(extent={{110,56},{130,76}})));
  Modelica.Blocks.Sources.RealExpression roomTemperature(y=15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-43,78})));
  inner IntegraNet.Statistics.Statistics_collector statistics_collector annotation (Placement(transformation(extent={{-116,78},{-96,98}})));
protected
  Modelica.Blocks.Continuous.Integrator integrator2 annotation (Placement(transformation(extent={{82,82},{94,94}})));
  Modelica.Blocks.Sources.Sine sine(freqHz=0.0005)
                                                 annotation (Placement(transformation(extent={{62,82},{74,94}})));
equation
  connect(heatBdryWaterHeatingDeload.port,Storage. port) annotation (Line(points={{38,-8},{32,-8},{26,-8},{26,6}},
                                                                                                    color={191,0,0}));
  connect(gain.y,heatBdryWaterHeatingDeload. Q_flow) annotation (Line(points={{69.3,21},{64,21},{64,8},{64,-8},{58,-8}},          color={0,0,127}));
  connect(Storage.port,wall_stor. port_b) annotation (Line(points={{26,6},{30,6},{36,6},{36,54},{28,54}},            color={191,0,0}));
    connect(heatBdryPeakloadFH1.port,wall_stor. port_a) annotation (Line(points={{-2,54},{8,54}},  color={191,0,0}));
  connect(heatPump.Heat_output, heating_heatPump.Q_flow) annotation (Line(
      points={{-42.8,-20},{-42,-20},{-42,-23},{-28,-23}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(heating_heatPump.port,heatBdryWaterHeatingDeload. port) annotation (Line(points={{-10,-23},{8,-23},{8,-8},{38,-8}}, color={191,0,0}));
  connect(T_stor_is.port,heatBdryWaterHeatingDeload. port) annotation (Line(points={{-8,14},{14,14},{14,-8},{38,-8}}, color={191,0,0}));
  connect(heatPump.P_set_el, controller.P_set_HP) annotation (Line(points={{-64.4,-22.2},{-78,-22.2},{-78,19.11},{-89.5,19.11}}, color={0,127,127}));
  connect(controller.T_set_HP, heatPump.T_set) annotation (Line(points={{-89.3,27.25},{-72,27.25},{-72,-17},{-64.4,-17}}, color={0,0,127}));
  connect(apparentPower1.epp, grid.epp) annotation (Line(
      points={{-114,-26},{-114,-27.04},{-129,-27.04},{-129,-48}},
      color={0,127,0},
      thickness=0.5));
  connect(apparentPower1.P_el_set, controller.P_set_HP) annotation (Line(points={{-110.8,-16.4},{-110.8,-8},{-84,-8},{-84,19.11},{-89.5,19.11}}, color={0,0,127}));
  connect(T_stor_is.T, controller.T) annotation (Line(points={{-28,14},{-28,40},{-116,40},{-116,19},{-110.2,19}}, color={0,0,127}));
  connect(pVModule.epp, inverter.epp_DC) annotation (Line(
      points={{-142.6,18.7},{-141.35,18.7},{-141.35,-6.2},{-142,-6.2}},
      color={0,135,135},
      thickness=0.5));
  connect(inverter.epp_AC, grid.epp) annotation (Line(
      points={{-142,-26},{-142,-48},{-129,-48}},
      color={0,127,0},
      thickness=0.5));
  connect(pVModule.T_in, ambientTemperature.y) annotation (Line(points={{-134,40},{-134,47.1},{-117,47.1}}, color={0,0,127}));
  connect(pVModule.WindSpeed_in, wind.y) annotation (Line(points={{-150,40},{-152,40},{-152,53.1},{-157,53.1}}, color={0,0,127}));
  connect(pVModule.DNI_in, directSolarRadiation.y) annotation (Line(points={{-139.6,40},{-140,40},{-140,49.1},{-131,49.1}}, color={0,0,127}));
  connect(pVModule.DHI_in, diffuseSolarRadiation.y) annotation (Line(points={{-144.6,40},{-146,40},{-146,51.1},{-145,51.1}}, color={0,0,127}));
  connect(P_PV.y, controller.PV_excess) annotation (Line(points={{-71,51},{-71,36},{-109,36},{-109,30.44}}, color={0,0,127}));
  connect(waterHeatingDemand_Table1.waterHeatingDemand, gain.u) annotation (Line(
      points={{120,56},{120,18},{85.4,18},{85.4,21}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(roomTemperature.y, heatBdryPeakloadFH1.T) annotation (Line(points={{-43,67},{-43,54},{-24,54}}, color={0,0,127}));
  connect(sine.y,integrator2. u) annotation (Line(points={{74.6,88},{80.8,88}},        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,100}})), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,100}})));
end TestHeatPump_externalController_static_PVoriented;

