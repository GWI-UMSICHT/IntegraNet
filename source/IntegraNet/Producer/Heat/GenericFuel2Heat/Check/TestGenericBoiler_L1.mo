within IntegraNet.Producer.Heat.GenericFuel2Heat.Check;
model TestGenericBoiler_L1
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
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-62,80},{-42,100}})));
  GenericBoiler gasBoiler(FuelType=IntegraNet.Basics.Types.FuelType.Gas,
                                          eta=0.95) annotation (Placement(transformation(extent={{30,14},{50,34}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    startTime=3600,
    duration=900,
    height=40e6,
    offset=50e6)
    annotation (Placement(transformation(extent={{-72,24},{-52,44}})));
  GenericBoiler oilBoiler(FuelType=IntegraNet.Basics.Types.FuelType.Oil,
                                          eta=0.95) annotation (Placement(transformation(extent={{34,-32},{54,-12}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    startTime=3600,
    duration=900,
    height=40e6,
    offset=50e6)
    annotation (Placement(transformation(extent={{-72,-22},{-52,-2}})));
  GenericBoiler biomassBoiler(FuelType=IntegraNet.Basics.Types.FuelType.Pellets,
                                                  eta=0.95) annotation (Placement(transformation(extent={{32,-76},{52,-56}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    startTime=3600,
    duration=900,
    height=40e6,
    offset=50e6)
    annotation (Placement(transformation(extent={{-68,-70},{-48,-50}})));
  inner Statistics.Statistics_collector statistics_collector annotation (Placement(transformation(extent={{-34,80},{-14,100}})));

equation

  connect(ramp1.y, gasBoiler.Q_Demand) annotation (Line(points={{-51,34},{-42,34},{-42,42},{40,42},{40,34}}, color={0,0,127}));
  connect(ramp2.y, oilBoiler.Q_Demand) annotation (Line(points={{-51,-12},{-36,-12},{-36,-4},{44,-4},{44,-12}}, color={0,0,127}));
  connect(ramp3.y, biomassBoiler.Q_Demand) annotation (Line(points={{-47,-60},{-38,-60},{-38,-52},{42,-52},{42,-56}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), experiment(StopTime=6000, __Dymola_Algorithm="Dassl"));
end TestGenericBoiler_L1;
