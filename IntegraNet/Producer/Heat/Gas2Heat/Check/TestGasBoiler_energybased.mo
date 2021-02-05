within IntegraNet.Producer.Heat.Gas2Heat.Check;
model TestGasBoiler_energybased
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
  inner SimCenter simCenter(
    integrateElPower=true,
    integrateHeatFlow=true,
    calculateCost=true,
    integrateCDE=true)      annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,27})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    variable_m_flow=false,
    m_flow_const=100,
    T_const=60 + 273) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-58,28})));
  TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler.SimpleBoiler
                                                          gasBoiler annotation (Placement(transformation(extent={{-12,18},{8,38}})));
  Modelica.Blocks.Sources.Ramp ramp(
    startTime=3600,
    duration=900,
    height=-40e6,
    offset=-50e6)
    annotation (Placement(transformation(extent={{-58,46},{-38,66}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi gasSource annotation (Placement(transformation(extent={{-24,-14},{-4,6}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-62,80},{-42,100}})));
  SmallGasBoiler.GasBoiler_energybased gasBoiler_energybased(eta=0.95, Q_flow_n_boiler=360e6)
                                                             annotation (Placement(transformation(extent={{0,-74},{20,-54}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi gasSource1 annotation (Placement(transformation(extent={{-66,-88},{-46,-68}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    startTime=3600,
    duration=900,
    height=40e6,
    offset=50e6)
    annotation (Placement(transformation(extent={{-42,-54},{-22,-34}})));
equation
  connect(ramp.y, gasBoiler.Q_flow_set) annotation (Line(
      points={{-37,56},{-2,56},{-2,38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSource.gasPort, gasBoiler.gasIn) annotation (Line(
      points={{-4,-4},{-4,18},{-1.8,18}},
      color={255,255,0},
      thickness=0.75));
  connect(gasBoiler.outlet, sink.steam_a) annotation (Line(
      points={{8,28},{32,28},{32,27}},
      color={175,0,0},
      thickness=0.5));
  connect(gasBoiler.inlet, source.steam_a) annotation (Line(
      points={{-11.8,28},{-48,28}},
      color={175,0,0},
      thickness=0.5));
  connect(ramp1.y, gasBoiler_energybased.heatFlowRate) annotation (Line(points={{-21,-44},{10,-44},{10,-54.6}}, color={0,0,127}));
  connect(gasSource1.gasPort, gasBoiler_energybased.gasPortIn) annotation (Line(
      points={{-46,-78},{-36,-78},{-36,-94},{18,-94},{18,-73.6}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end TestGasBoiler_energybased;
