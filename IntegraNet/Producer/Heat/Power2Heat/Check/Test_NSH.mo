within IntegraNet.Producer.Heat.Power2Heat.Check;
model Test_NSH
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
  NightStorageHeating nightStorageHeating annotation (Placement(transformation(extent={{-12,-14},{16,14}})));
  IntegraNet.Components.Boundaries.Electrical.ApparentPower.Electric_Grid ElectricGrid
    annotation (Placement(transformation(
        extent={{-14,-15},{14,15}},
        rotation=180,
        origin={-56,0})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=3000) annotation (Placement(transformation(extent={{-68,30},{-48,50}})));
equation
  connect(ElectricGrid.epp, nightStorageHeating.epp) annotation (Line(
      points={{-42,-1.77636e-15},{-27,-1.77636e-15},{-27,0.4},{-11.6,0.4}},
      color={0,127,0},
      thickness=0.5));
  connect(realExpression.y, nightStorageHeating.Q_demand_sh) annotation (Line(points={{-47,40},{2.1,40},{2.1,9.5}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=3000,
      Interval=30,
      __Dymola_Algorithm="Dassl"));
end Test_NSH;
