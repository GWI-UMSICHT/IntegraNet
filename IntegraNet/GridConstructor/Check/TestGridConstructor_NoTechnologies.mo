﻿within IntegraNet.GridConstructor.Check;
model TestGridConstructor_NoTechnologies
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

public
  inner SimCenter            simCenter(
    ambientConditions(
      redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY globalSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DNI_Hamburg_3600s_2012_TMY directSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DHI_Hamburg_3600s_2012_TMY diffuseSolarRadiation,
      redeclare Basics.Tables.Ambient.Temperature_Hamburg_3600s_TMY temperature),
    T_ground=278.15,
    p_eff_1=5000)
    annotation (Placement(transformation(extent={{-84,74},{-56,100}})));
  Components.Boundaries.Electrical.ApparentPower.Electric_Grid            ElectricGrid
    annotation (Placement(transformation(
        extent={{-12,-13},{12,13}},
        rotation=180,
        origin={-84,-29})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi
                                            Gas_Source(p_const=simCenter.p_amb_const + simCenter.p_eff_1)
    annotation (Placement(transformation(extent={{-96,34},{-70,60}})));
  Grid_Constructor grid(
    gas_out=false,
    el_out=false,
    dhn_in_s=false,
    dhn_out_s=false,
    dhn_in_r=false,
    dhn_out_r=false,
    n_elements=2,
    second_row=true,
    Technologies_1={IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(Boiler=1),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),
        IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix()},
    Technologies_2={IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(Boiler=1),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),
        IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix()},
    second_Consumer={true,true},
    redeclare model Systems_Consumer_1 = Systems.NoTechnologies,
    redeclare model Systems_Consumer_2 = Systems.NoTechnologies)                                                                                                                                                                                                         annotation (Placement(transformation(extent={{-38,-12},{40,48}})));
  inner Statistics.Statistics_collector statistics_collector annotation (Placement(transformation(extent={{-42,76},{-22,96}})));
equation
  connect(Gas_Source.gasPort, grid.gasPortIn) annotation (Line(
      points={{-70,47},{-42,47},{-42,33},{-38,33}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid.epp, grid.epp_p) annotation (Line(
      points={{-72,-29},{-40,-29},{-40,3},{-38,3}},
      color={0,127,0},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(points={{22,-16},{22,-58},{106,-58}},
                                                 color={28,108,200}),
        Text(
          extent={{24,-42},{104,-64}},
          lineColor={28,108,200},
          textString="Total Number of Consumers"),
        Line(points={{-24,-16},{-24,-82},{64,-82}},color={28,108,200}),
        Text(
          extent={{-20,-66},{60,-88}},
          lineColor={28,108,200},
          textString="Number of grid elements")}),
    experiment(
      StopTime=3600,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end TestGridConstructor_NoTechnologies;
