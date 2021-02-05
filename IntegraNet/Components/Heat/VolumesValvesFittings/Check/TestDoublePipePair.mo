within IntegraNet.Components.Heat.VolumesValvesFittings.Check;
model TestDoublePipePair
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

  extends TransiEnt.Basics.Icons.Checkmodel;

  DoublePipePair_LX doublePipePair_LX(
    p_start_supply=simCenter.p_nom[2],
    T_start_supply=363.15,
    p_start_return=simCenter.p_nom[1],
    T_start_return=343.15,
    m_flow_start=0.35,
    length=100,
    DN=50,
    calc_initial_dstrb=true)          annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  inner SimCenter simCenter(calc_initial_dstrb=false, v_nom=0.07)
                            annotation (Placement(transformation(extent={{44,84},{54,94}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow(
    variable_m_flow=false,
    m_flow_const=0.35,                                                                            T_const(displayUnit="degC") = 363.15) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi(p_const=simCenter.p_nom[1], T_const(displayUnit="degC") = 343.15)
                                                                                                  annotation (Placement(transformation(extent={{-80,-38},{-60,-18}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_ground(T=simCenter.T_ground)
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_supply_in(unitOption=2) annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_supply_out(unitOption=2) annotation (Placement(transformation(extent={{45,40},{75,60}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_return_out(unitOption=2) annotation (Placement(transformation(extent={{-70,-40},{-50,-60}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi1(p_const=simCenter.p_nom[1], T_const(displayUnit="degC") = 363.15)
                                                                                                  annotation (Placement(transformation(extent={{80,20},{60,40}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow1(
    variable_m_flow=false,
    m_flow_const=0.35,
    T_const(displayUnit="degC") = 343.15)                                                                                               annotation (Placement(transformation(extent={{80,-40},{60,-20}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_return_in(unitOption=2) annotation (Placement(transformation(extent={{50,-40},{70,-60}})));
  inner Statistics.Statistics_collector statistics_collector annotation (Placement(transformation(extent={{-148,74},{-128,94}})));
equation
  connect(boundaryVLE_Txim_flow.steam_a, doublePipePair_LX.waterPortIn_supply) annotation (Line(
      points={{-60,30},{-40,30},{-40,4},{-10,4}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(doublePipePair_LX.waterPortOut_return,boundaryVLE_pTxi. steam_a) annotation (Line(
      points={{-10,-4},{-40,-4},{-40,-28},{-60,-28}},
      color={175,0,0},
      thickness=0.5));
  connect(T_ground.port, doublePipePair_LX.heat_supply) annotation (Line(points={{-70,80},{0,80},{0,10}}, color={191,0,0}));
  connect(T_ground.port, doublePipePair_LX.heat_return) annotation (Line(points={{-70,80},{-26,80},{-26,-38},{0,-38},{0,-10}}, color={191,0,0}));
  connect(T_supply_in.port, boundaryVLE_Txim_flow.steam_a) annotation (Line(
      points={{-60,40},{-60,30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(T_supply_out.port, boundaryVLE_pTxi1.steam_a) annotation (Line(
      points={{60,40},{60,30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(doublePipePair_LX.waterPortOut_supply, boundaryVLE_pTxi1.steam_a) annotation (Line(
      points={{10,4},{40,4},{40,30},{60,30}},
      color={175,0,0},
      thickness=0.5));
  connect(boundaryVLE_Txim_flow1.steam_a, doublePipePair_LX.waterPortIn_return) annotation (Line(
      points={{60,-30},{40,-30},{40,-4},{10.2,-4}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(T_return_out.port, boundaryVLE_pTxi.steam_a) annotation (Line(
      points={{-60,-40},{-60,-28}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(T_return_in.port, boundaryVLE_Txim_flow1.steam_a) annotation (Line(
      points={{60,-40},{60,-30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=10000,
      Interval=300,
      __Dymola_Algorithm="Dassl"));
end TestDoublePipePair;

