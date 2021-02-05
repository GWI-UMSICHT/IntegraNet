within IntegraNet.Components.Heat.VolumesValvesFittings.Check;
model TestSinglePipe
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

  SinglePipe_LX     singlePipe_LX(
    T_start=333.15,
    m_flow_start=0.1,
    activate_volumes=true,
    length=100,
    calc_initial_dstrb=true,
    diameter_i(displayUnit="m"),
    z_in=2,
    z_out=1)                          annotation (Placement(transformation(extent={{-5,-16},{33,16}})));
  inner SimCenter simCenter(
    activate_volumes=true,
    calc_initial_dstrb=true,
    v_nom=0.18,
    lambda_ground=1.2)      annotation (Placement(transformation(extent={{58,54},{68,64}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow(
    variable_m_flow=false,
    variable_T=true,
    m_flow_const=0.1,                                                                             T_const(displayUnit="degC") = 363.15) annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_ground(T=simCenter.T_ground)
    annotation (Placement(transformation(extent={{-76,40},{-56,60}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_supply_in(unitOption=2) annotation (Placement(transformation(extent={{-36,10},{-16,30}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_supply_out(unitOption=2) annotation (Placement(transformation(extent={{39,10},{69,30}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi1(p_const=simCenter.p_nom[1], T_const(displayUnit="degC") = 363.15)
                                                                                                  annotation (Placement(transformation(extent={{94,-10},{74,10}})));
  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=60 + 273.15,
    startTime=5000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-76,-40})));
equation
  connect(T_supply_in.port, boundaryVLE_Txim_flow.steam_a) annotation (Line(
      points={{-26,10},{-26,6},{-46,6},{-46,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(T_supply_out.port, boundaryVLE_pTxi1.steam_a) annotation (Line(
      points={{54,10},{54,6},{74,6},{74,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_Txim_flow.steam_a, singlePipe_LX.waterPortIn) annotation (Line(
      points={{-46,0},{-5,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(singlePipe_LX.waterPortOut, boundaryVLE_pTxi1.steam_a) annotation (Line(
      points={{33,0},{74,0}},
      color={175,0,0},
      thickness=0.5));
  connect(T_ground.port, singlePipe_LX.heat) annotation (Line(points={{-56,50},{14,50},{14,16}},
                                                                                               color={191,0,0}));
  connect(step.y, boundaryVLE_Txim_flow.T) annotation (Line(points={{-76,-29},{-76,0},{-68,0}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10000, Interval=60));
end TestSinglePipe;

