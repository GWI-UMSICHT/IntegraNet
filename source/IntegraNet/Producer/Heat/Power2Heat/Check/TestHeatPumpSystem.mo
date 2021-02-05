within IntegraNet.Producer.Heat.Power2Heat.Check;
model TestHeatPumpSystem
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
    P=heatPumpSystem.heatPump.Heat_output)
                                     annotation (Placement(transformation(extent={{-102,-88},{-82,-68}})));
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
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_storageloss(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=heatPumpSystem.heatStorage.Q_flow_loss)
                                   annotation (Placement(transformation(extent={{-70,-88},{-50,-68}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage grid(Use_input_connector_f=false, Use_input_connector_v=false) annotation (Placement(transformation(extent={{-136,-82},{-150,-68}})));
  IntegraNet.Producer.Heat.Power2Heat.HeatPumpSystem heatPumpSystem(
    T_set=333.15,
    T_s_min=323.15,
    redeclare IntegraNet.Producer.Heat.Power2Heat.Components.Control_HeatPump.ControlStaticHeatPump_priceoriented controller) annotation (Placement(transformation(
        extent={{16,-16},{-16,16}},
        rotation=0,
        origin={-68,12})));
equation
    connect(T_amb.port,wall_a. port_a) annotation (Line(points={{114,52},{114,52},{120,52}},
                                                                                          color={191,0,0}));
    connect(wall_a.port_b,Room. port) annotation (Line(points={{140,52},{146,52},{146,-8},{136,-8}},
                                                                                                   color={191,0,0}));
    connect(T_amb_deg_C.y,T_amb. T) annotation (Line(points={{84,52},{84,52},{92,52}},  color={0,0,127}));
  connect(FloorHeatingBdry.port,Room. port) annotation (Line(points={{124,-8},{136,-8}},   color={191,0,0}));
  connect(T_room_is.port,Room. port) annotation (Line(points={{136,-66},{146,-66},{146,-8},{136,-8}},
                                                                                              color={191,0,0}));
  connect(ctrlFloorHeating.y,FloorHeatingBdry. Q_flow) annotation (Line(points={{95,-32},{95,-32},{98,-32},{98,-8},{100,-8},{104,-8}},    color={0,0,127}));
  connect(ctrlFloorHeating.u_m,T_room_is. T) annotation (Line(points={{84,-44},{84,-66},{116,-66}}, color={0,0,127}));
  connect(T_room_set.y,ctrlFloorHeating. u_s) annotation (Line(points={{60,-32},{60,-32},{68,-32},{72,-32}},          color={0,0,127}));
  connect(heatPumpSystem.epp, grid.epp) annotation (Line(
      points={{-75.36,-3.68},{-75.36,-26},{-136,-26},{-136,-75}},
      color={0,127,0},
      thickness=0.5));
  connect(heatPumpSystem.Q_Demand, FloorHeatingBdry.Q_flow) annotation (Line(
      points={{-52.8,11.84},{66,11.84},{66,-8},{104,-8}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,100}})), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,100}})));
end TestHeatPumpSystem;

