within IntegraNet.Producer.Heat.Power2Heat.Components.Check;
model TestHeatPump_externalController_modulating_with_Heater
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
                                                                                              annotation (Placement(transformation(extent={{-112,80},{-92,100}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor Room(C=params.C_room, T(start=params.T_room_start, fixed=true))
                                                                                              annotation (Placement(transformation(extent={{126,-8},{146,12}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor wall_a(G=params.G_loss)
                                                                            annotation (Placement(transformation(extent={{120,42},{140,62}})));
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature
                                                         T_amb annotation (Placement(transformation(extent={{94,42},{114,62}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_Heatpump(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=heatPump.Heat_output)          annotation (Placement(transformation(extent={{-102,-88},{-82,-68}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_heatingdemand(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=T_amb.port.Q_flow/1e3) annotation (Placement(transformation(extent={{-48,-88},{-28,-68}})));
  Modelica.Blocks.Sources.RealExpression T_amb_deg_C(y=simCenter.ambientConditions.temperature.value)       annotation (Placement(transformation(extent={{63,42},{83,62}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow FloorHeatingBdry annotation (Placement(transformation(extent={{104,-18},{124,2}})));
  Modelica.Blocks.Continuous.LimPID  ctrlFloorHeating(
    k=params.G_loss*(params.T_room_set - (273.15 - 12)),
    yMax=50e3,
    yMin=0,
    Ti=900,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput)                                                       annotation (Placement(transformation(extent={{74,-42},{94,-22}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T_room_is annotation (Placement(transformation(extent={{136,-76},{116,-56}})));
  Modelica.Blocks.Sources.Constant T_room_set(k=params.T_room_set) annotation (Placement(transformation(extent={{39,-42},{59,-22}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor Storage(C=params.V_stor_fh*1e3*4.2e3, T(start=params.T_stor_fh_start, fixed=true)) annotation (Placement(transformation(extent={{16,6},{36,26}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatBdryFloorHeatingDeload annotation (Placement(transformation(extent={{58,-18},{38,2}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{84,14},{70,28}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor wall_stor(G=4.58) "Taken from Knop page 48, Viessmann Vitocell 100-W (200l, 2,2kWh loss per 24h at Delta T 45K)"
                                                                                                    annotation (Placement(transformation(extent={{8,44},{28,64}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_storageloss(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=wall_stor.port_b.Q_flow/1e3) annotation (Placement(transformation(extent={{-74,-88},{-54,-68}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                           heatBdryPeakloadFH1
                                                                              annotation (Placement(transformation(extent={{-22,44},{-2,64}})));
  HeatPump_L0_externalController heatPump annotation (Placement(transformation(extent={{-86,-28},{-66,-8}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heating_heatPump annotation (Placement(transformation(extent={{-28,-32},{-10,-14}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T_stor_is annotation (Placement(transformation(extent={{-8,4},{-28,24}})));
  IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump.ControlModulatingHeatPump_heat_driven controller(
    control_SoC=false,
    P_HP_el_n=500,
    TSet_HP(displayUnit="degC") = 301.15,
    TLow_HP=300.15,
    THigh_HP=302.15,
    TLow_Heater=298.15,
    THigh_Heater=300.15) annotation (Placement(transformation(extent={{-138,10},{-118,32}})));
  IntegraNet.Producer.Heat.Power2Heat.ElectricBoiler_noFluidPorts electricBoiler_noFluidPorts annotation (Placement(transformation(extent={{-134,-42},{-114,-22}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heating_heater annotation (Placement(transformation(extent={{-26,-52},{-8,-34}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage grid(Use_input_connector_f=false, Use_input_connector_v=false) annotation (Placement(transformation(extent={{-136,-82},{-150,-68}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower apparentPower1(useInputConnectorQ=false, useInputConnectorP=true)
                                                                                       annotation (Placement(transformation(extent={{-154,-22},{-138,-6}})));
equation
    connect(T_amb.port,wall_a. port_a) annotation (Line(points={{114,52},{114,52},{120,52}},
                                                                                          color={191,0,0}));
    connect(wall_a.port_b,Room. port) annotation (Line(points={{140,52},{146,52},{146,-8},{136,-8}},
                                                                                                   color={191,0,0}));
    connect(T_amb_deg_C.y,T_amb. T) annotation (Line(points={{84,52},{84,52},{92,52}},  color={0,0,127}));
  connect(FloorHeatingBdry.port,Room. port) annotation (Line(points={{124,-8},{136,-8}},   color={191,0,0}));
  connect(T_room_is.port,Room. port) annotation (Line(points={{136,-66},{146,-66},{146,-8},{136,-8}},
                                                                                              color={191,0,0}));
  connect(heatBdryFloorHeatingDeload.port,Storage. port) annotation (Line(points={{38,-8},{32,-8},{26,-8},{26,6}},
                                                                                                    color={191,0,0}));
  connect(gain.y,heatBdryFloorHeatingDeload. Q_flow) annotation (Line(points={{69.3,21},{64,21},{64,8},{64,-8},{58,-8}},          color={0,0,127}));
  connect(ctrlFloorHeating.y,FloorHeatingBdry. Q_flow) annotation (Line(points={{95,-32},{95,-32},{98,-32},{98,-8},{100,-8},{104,-8}},    color={0,0,127}));
  connect(ctrlFloorHeating.y,gain. u) annotation (Line(points={{95,-32},{98,-32},{98,21},{85.4,21}},           color={0,0,127}));
  connect(ctrlFloorHeating.u_m,T_room_is. T) annotation (Line(points={{84,-44},{84,-66},{116,-66}}, color={0,0,127}));
  connect(T_room_set.y,ctrlFloorHeating. u_s) annotation (Line(points={{60,-32},{60,-32},{68,-32},{72,-32}},          color={0,0,127}));
  connect(Storage.port,wall_stor. port_b) annotation (Line(points={{26,6},{30,6},{36,6},{36,54},{28,54}},            color={191,0,0}));
    connect(heatBdryPeakloadFH1.port,wall_stor. port_a) annotation (Line(points={{-2,54},{8,54}},  color={191,0,0}));
    connect(T_room_is.T,heatBdryPeakloadFH1. T) annotation (Line(points={{116,-66},{116,-66},{108,-66},{108,-82},{156,-82},{156,82},{-38,82},{-38,54},{-24,54}},
                                                                                                                                                              color={0,0,127}));
  connect(heatPump.Heat_output, heating_heatPump.Q_flow) annotation (Line(
      points={{-64.8,-18},{-48,-18},{-48,-23},{-28,-23}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(heating_heatPump.port, heatBdryFloorHeatingDeload.port) annotation (Line(points={{-10,-23},{2,-23},{2,-8},{38,-8}}, color={191,0,0}));
  connect(T_stor_is.port, heatBdryFloorHeatingDeload.port) annotation (Line(points={{-8,14},{14,14},{14,-8},{38,-8}}, color={191,0,0}));
  connect(heatPump.P_set_el, controller.P_set_HP) annotation (Line(points={{-86.4,-20.2},{-98,-20.2},{-98,21.9},{-117.5,21.9}}, color={0,127,127}));
  connect(controller.T_set_HP, heatPump.T_set) annotation (Line(points={{-117.3,29.5},{-92,29.5},{-92,-15},{-86.4,-15}}, color={0,0,127}));
  connect(controller.P_set_electricHeater, electricBoiler_noFluidPorts.P_set) annotation (Line(
      points={{-117.5,14.3},{-117.5,-3.85},{-124,-3.85},{-124,-22}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(electricBoiler_noFluidPorts.Heat_output, heating_heater.Q_flow) annotation (Line(
      points={{-112.8,-32.4},{-70.4,-32.4},{-70.4,-43},{-26,-43}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(grid.epp, electricBoiler_noFluidPorts.epp) annotation (Line(
      points={{-135.93,-75.07},{-124,-75.07},{-124,-42}},
      color={0,127,0},
      thickness=0.5));
  connect(controller.P_set_HP, apparentPower1.P_el_set) annotation (Line(
      points={{-117.5,21.9},{-106,21.9},{-106,2},{-150.8,2},{-150.8,-4.4}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(apparentPower1.epp, grid.epp) annotation (Line(
      points={{-154.08,-14.08},{-154.08,-50},{-135.93,-50},{-135.93,-75.07}},
      color={0,127,0},
      thickness=0.5));
  connect(heating_heater.port, heatBdryFloorHeatingDeload.port) annotation (Line(points={{-8,-43},{4,-43},{4,-14},{38,-14},{38,-8}}, color={191,0,0}));
  connect(T_stor_is.T, controller.T) annotation (Line(points={{-28,14},{-44,14},{-44,12},{-72,12},{-72,54},{-146,54},{-146,22},{-137.8,22}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,100}})), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,100}})));
end TestHeatPump_externalController_modulating_with_Heater;

