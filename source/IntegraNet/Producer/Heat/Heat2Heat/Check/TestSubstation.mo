within IntegraNet.Producer.Heat.Heat2Heat.Check;
model TestSubstation
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
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    medium=simCenter.fluid1,
    p_const=3e5,
    T_const=70 + 273.15)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-11})));
  Modelica.Blocks.Sources.Ramp RHW(
    startTime=3600,
    duration=900,
    height=-2e3,
    offset=10e3) annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-62,80},{-42,100}})));
  Substation_indirect_noStorage_L1 substation_indirect_noStorage_L1_1 annotation (Placement(transformation(extent={{-20,30},{8,50}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink1(
    medium=simCenter.fluid1,
    p_const=4e5,
    T_const=90 + 273.15)  annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,-11})));
  Modelica.Blocks.Sources.Ramp DHW(
    startTime=3600,
    duration=50,
    height=20e3,
    offset=0e3) annotation (Placement(transformation(extent={{60,50},{40,70}})));
  inner Statistics.Statistics_collector statistics_collector annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
equation
  connect(substation_indirect_noStorage_L1_1.waterPortOut, sink.steam_a) annotation (Line(
      points={{0.1,29.9},{0.1,-11},{60,-11}},
      color={175,0,0},
      thickness=0.5));
  connect(sink1.steam_a, substation_indirect_noStorage_L1_1.waterPortIn) annotation (Line(
      points={{-60,-11},{-12,-11},{-12,30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(RHW.y, substation_indirect_noStorage_L1_1.Q_demand_rh) annotation (Line(points={{-39,60},{-17,60},{-17,49}}, color={0,0,127}));
  connect(substation_indirect_noStorage_L1_1.Q_demand_dhw, DHW.y) annotation (Line(points={{5,49},{5,60},{39,60}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), experiment(
      StopTime=10000,
      Interval=60,
      __Dymola_Algorithm="Cvode"));
end TestSubstation;

