within IntegraNet.Components.Gas.VolumesValvesFittings.Check;
model Check_PipeFlow_L4_Simple_varXi_dp_FM_density
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

  // Simple structure for comparison of different pressure loss models

  extends TransiEnt.Basics.Icons.Checkmodel;

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow
                            Consumer(variable_m_flow=false, m_flow_const=0.5)
    annotation (Placement(transformation(
        extent={{-27,-23},{27,23}},
        rotation=180,
        origin={67,-1})));

  Modelica.Blocks.Sources.Step step(
    offset=200000,
    height=300000,
    startTime=500)
    annotation (Placement(transformation(extent={{-60,80},{-80,100}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi
                                            Gas_Source(p_const=simCenter.p_amb_const
         + simCenter.p_eff_1, variable_p=true)
    annotation (Placement(transformation(extent={{-90,-24},{-40,22}})));
  PipeFlow_L4_Simple_varXi pipe(redeclare model PressureLoss = Base.dp_phy_FM_density, N_cv=3)
                                                                                       annotation (Placement(transformation(extent={{-20,-12},{22,10}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{100,98},{120,118}})));
equation
  connect(step.y, Gas_Source.p) annotation (Line(points={{-81,90},{-100,90},{-100,40},{-110,40},{-110,12.8},{-95,12.8}},
                                   color={0,0,127}));
  connect(Gas_Source.gasPort, pipe.gasPortIn) annotation (Line(
      points={{-40,-1},{-20,-1}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe.gasPortOut, Consumer.gasPort) annotation (Line(
      points={{22,-1},{40,-1}},
      color={255,255,0},
      thickness=1.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
    experiment(
      StopTime=1000,
      Interval=1,
      __Dymola_Algorithm="Dassl"));
end Check_PipeFlow_L4_Simple_varXi_dp_FM_density;

