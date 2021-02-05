within IntegraNet.Producer.Heat.Power2Heat.Components.Check;
model TestHeatPump_externalController_static
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
    P=T_amb.port.Q_flow/1e3) annotation (Placement(transformation(extent={{-36,-88},{-16,-68}})));
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
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor Storage(C=params.V_stor_fh*1e3*4.2e3, T(start=params.T_stor_fh_start, fixed=true)) annotation (Placement(transformation(extent={{18,6},{38,26}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatBdryFloorHeatingDeload annotation (Placement(transformation(extent={{60,-18},{40,2}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{84,14},{70,28}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor wall_stor(G=4.58) "Taken from Knop page 48, Viessmann Vitocell 100-W (200l, 2,2kWh loss per 24h at Delta T 45K)"
                                                                                                    annotation (Placement(transformation(extent={{10,44},{30,64}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_storageloss(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=wall_stor.port_b.Q_flow/1e3) annotation (Placement(transformation(extent={{-70,-88},{-50,-68}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                           heatBdryPeakloadFH1
                                                                              annotation (Placement(transformation(extent={{-20,44},{0,64}})));
  HeatPump_L0_externalController heatPump annotation (Placement(transformation(extent={{-86,-28},{-66,-8}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heating annotation (Placement(transformation(extent={{-26,-32},{-8,-14}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T_stor_is annotation (Placement(transformation(extent={{-6,4},{-26,24}})));
  IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump.ControlStaticHeatPump_heatDriven controller(
    control_SoC=false,
    TLow_HP(displayUnit="degC") = 300.15,
    THigh_HP(displayUnit="degC") = 302.15,
    TLow_Heater(displayUnit="degC") = 293.15,
    THigh_Heater(displayUnit="degC") = 298.15,
    P_elHeater=0) annotation (Placement(transformation(extent={{-138,12},{-118,32}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower apparentPower(useInputConnectorQ=false, useInputConnectorP=true)
                                                                                       annotation (Placement(transformation(extent={{-130,-52},{-114,-36}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage grid(Use_input_connector_f=false, Use_input_connector_v=false) annotation (Placement(transformation(extent={{-136,-82},{-150,-68}})));
equation
    connect(T_amb.port,wall_a. port_a) annotation (Line(points={{114,52},{114,52},{120,52}},
                                                                                          color={191,0,0}));
    connect(wall_a.port_b,Room. port) annotation (Line(points={{140,52},{146,52},{146,-8},{136,-8}},
                                                                                                   color={191,0,0}));
    connect(T_amb_deg_C.y,T_amb. T) annotation (Line(points={{84,52},{84,52},{92,52}},  color={0,0,127}));
  connect(FloorHeatingBdry.port,Room. port) annotation (Line(points={{124,-8},{136,-8}},   color={191,0,0}));
  connect(T_room_is.port,Room. port) annotation (Line(points={{136,-66},{146,-66},{146,-8},{136,-8}},
                                                                                              color={191,0,0}));
  connect(heatBdryFloorHeatingDeload.port,Storage. port) annotation (Line(points={{40,-8},{28,-8},{28,6}},
                                                                                                    color={191,0,0}));
  connect(gain.y,heatBdryFloorHeatingDeload. Q_flow) annotation (Line(points={{69.3,21},{64,21},{64,-8},{60,-8}},                 color={0,0,127}));
  connect(ctrlFloorHeating.y,FloorHeatingBdry. Q_flow) annotation (Line(points={{95,-32},{95,-32},{98,-32},{98,-8},{100,-8},{104,-8}},    color={0,0,127}));
  connect(ctrlFloorHeating.y,gain. u) annotation (Line(points={{95,-32},{98,-32},{98,21},{85.4,21}},           color={0,0,127}));
  connect(ctrlFloorHeating.u_m,T_room_is. T) annotation (Line(points={{84,-44},{84,-66},{116,-66}}, color={0,0,127}));
  connect(T_room_set.y,ctrlFloorHeating. u_s) annotation (Line(points={{60,-32},{60,-32},{68,-32},{72,-32}},          color={0,0,127}));
  connect(Storage.port,wall_stor. port_b) annotation (Line(points={{28,6},{36,6},{36,54},{30,54}},                   color={191,0,0}));
    connect(heatBdryPeakloadFH1.port,wall_stor. port_a) annotation (Line(points={{0,54},{10,54}},  color={191,0,0}));
    connect(T_room_is.T,heatBdryPeakloadFH1. T) annotation (Line(points={{116,-66},{108,-66},{108,-82},{156,-82},{156,82},{-38,82},{-38,54},{-22,54}},        color={0,0,127}));
  connect(heatPump.Heat_output, heating.Q_flow) annotation (Line(
      points={{-64.8,-18},{-48,-18},{-48,-23},{-26,-23}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(heating.port, heatBdryFloorHeatingDeload.port) annotation (Line(points={{-8,-23},{8,-23},{8,-8},{40,-8}},  color={191,0,0}));
  connect(T_stor_is.port, heatBdryFloorHeatingDeload.port) annotation (Line(points={{-6,14},{14,14},{14,-8},{40,-8}}, color={191,0,0}));
  connect(heatPump.P_set_el, controller.P_set_HP) annotation (Line(points={{-86.4,-20.2},{-98,-20.2},{-98,21.9},{-117.5,21.9}}, color={0,127,127}));
  connect(controller.T_set_HP, heatPump.T_set) annotation (Line(points={{-117.3,29.5},{-92,29.5},{-92,-15},{-86.4,-15}}, color={0,0,127}));
  connect(controller.P_set_HP, apparentPower.P_el_set) annotation (Line(
      points={{-117.5,21.9},{-106,21.9},{-106,-24},{-126.8,-24},{-126.8,-34.4}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(grid.epp, apparentPower.epp) annotation (Line(
      points={{-135.93,-75.07},{-135.93,-44.08},{-130.08,-44.08}},
      color={0,127,0},
      thickness=0.5));
  connect(T_stor_is.T, controller.T) annotation (Line(points={{-26,14},{-42,14},{-42,16},{-62,16},{-62,52},{-150,52},{-150,22},{-137.8,22}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,100}})), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,100}})));
end TestHeatPump_externalController_static;

