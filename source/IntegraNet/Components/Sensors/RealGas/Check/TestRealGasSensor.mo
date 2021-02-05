within IntegraNet.Components.Sensors.RealGas.Check;
model TestRealGasSensor "Test model for real gas sensor"

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

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sourceNGH2(variable_xi=true, m_flow_const=-4) annotation (Placement(transformation(extent={{-64,34},{-44,54}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sinkNGH2 annotation (Placement(transformation(extent={{62,34},{42,54}})));
  TransiEnt.Components.Boundaries.Gas.RealGasCompositionByWtFractions_stepVariation realGasCompositionByWtFractions_stepVariation(
    xiNumber=7,
    period=10,
    stepsize=0.01) annotation (Placement(transformation(extent={{-92,28},{-72,48}})));

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sourceH2(
    m_flow_const=-4,
    variable_xi=false,
    xi_const=zeros(sourceH2.medium.nc - 1)) annotation (Placement(transformation(extent={{-66,-28},{-46,-8}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sinkH2 annotation (Placement(transformation(extent={{64,-28},{44,-8}})));

  inner SimCenter simCenter annotation (Placement(transformation(extent={{-128,78},{-108,98}})));
  Sensor sensorNGH2 annotation (Placement(transformation(extent={{-16,44},{6,64}})));
  Sensor sensorH2 annotation (Placement(transformation(extent={{-14,-18},{8,2}})));
equation
  connect(sourceNGH2.xi, realGasCompositionByWtFractions_stepVariation.xi) annotation (Line(points={{-66,38},{-72,38}},             color={0,0,127}));
  connect(sourceNGH2.gasPort, sensorNGH2.gasPortIn) annotation (Line(
      points={{-44,44},{-16,44}},
      color={255,255,0},
      thickness=1.5));
  connect(sensorNGH2.gasPortOut, sinkNGH2.gasPort) annotation (Line(
      points={{6,44},{42,44}},
      color={255,255,0},
      thickness=1.5));
  connect(sourceH2.gasPort, sensorH2.gasPortIn) annotation (Line(
      points={{-46,-18},{-14,-18}},
      color={255,255,0},
      thickness=1.5));
  connect(sensorH2.gasPortOut, sinkH2.gasPort) annotation (Line(
      points={{8,-18},{44,-18}},
      color={255,255,0},
      thickness=1.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
    experiment(StopTime=1000, Interval=1));
end TestRealGasSensor;

