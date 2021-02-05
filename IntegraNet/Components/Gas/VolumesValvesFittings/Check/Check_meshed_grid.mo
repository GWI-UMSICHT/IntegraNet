within IntegraNet.Components.Gas.VolumesValvesFittings.Check;
model Check_meshed_grid
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

 // Simple structure for validation of gas grid loop
 extends TransiEnt.Basics.Icons.Checkmodel;

  Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe1(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    diameter_i=0.1,
    length=100,
    redeclare model PressureLoss =
        Components.Gas.VolumesValvesFittings.Base.dp_phy_simple,
    h_nom=ones(1)*(20700),
    useHomotopy=true)
    annotation (Placement(transformation(extent={{-40,20},{-18,28}})));
  Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe4(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    diameter_i=0.1,
    length=100,
    redeclare model PressureLoss =
        Components.Gas.VolumesValvesFittings.Base.dp_phy_simple,
    h_nom=ones(1)*(20700),
    useHomotopy=true)
    annotation (Placement(transformation(extent={{-40,-26},{-18,-18}})));
  Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe2(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    diameter_i=0.1,
    length=100,
    redeclare model PressureLoss =
        Components.Gas.VolumesValvesFittings.Base.dp_phy_simple,
    h_nom=ones(1)*(20700),
    useHomotopy=true)
    annotation (Placement(transformation(extent={{20,20},{42,28}})));
  Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe3(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    diameter_i=0.1,
    length=100,
    redeclare model PressureLoss =
        Components.Gas.VolumesValvesFittings.Base.dp_phy_simple,
    h_nom=ones(1)*(20700),
    useHomotopy=true)
    annotation (Placement(transformation(extent={{20,-26},{42,-18}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow
                            Consumer_1(variable_m_flow=false, m_flow_const=
        0.007) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={2,54})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow
                            Consumer_3(variable_m_flow=false, m_flow_const=
        0.007) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={2,-52})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow
                            Consumer_2(variable_m_flow=false, m_flow_const=
        0.007) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,0})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi
                                            Gas_Source(p_const=simCenter.p_amb_const
         + simCenter.p_eff_1, variable_p=false)
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
equation
  connect(pipe1.gasPortOut,pipe2. gasPortIn) annotation (Line(
      points={{-18,24},{-18,24},{20,24}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe4.gasPortOut,pipe3. gasPortIn) annotation (Line(
      points={{-18,-22},{20,-22}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe2.gasPortOut,pipe3. gasPortOut) annotation (Line(
      points={{42,24},{48,24},{48,-22},{42,-22}},
      color={255,255,0},
      thickness=1.5));
  connect(Consumer_1.gasPort, pipe2.gasPortIn) annotation (Line(
      points={{2,44},{2,44},{2,24},{20,24}},
      color={255,255,0},
      thickness=1.5));
  connect(Consumer_3.gasPort, pipe3.gasPortIn) annotation (Line(
      points={{2,-42},{2,-22},{20,-22}},
      color={255,255,0},
      thickness=1.5));
  connect(Consumer_2.gasPort, pipe3.gasPortOut) annotation (Line(
      points={{60,0},{48,0},{48,-22},{42,-22}},
      color={255,255,0},
      thickness=1.5));
  connect(Gas_Source.gasPort, pipe1.gasPortIn) annotation (Line(
      points={{-68,0},{-58,0},{-48,0},{-48,24},{-40,24}},
      color={255,255,0},
      thickness=1.5));
  connect(Gas_Source.gasPort, pipe4.gasPortIn) annotation (Line(
      points={{-68,0},{-48,0},{-48,-22},{-40,-22}},
      color={255,255,0},
      thickness=1.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}})),                                  Diagram(coordinateSystem(preserveAspectRatio=false, extent={
            {-120,-120},{120,120}}),
        graphics={
        Ellipse(extent={{-2,20},{6,28}},lineColor={28,108,200}),
        Ellipse(extent={{44,-4},{52,4}},    lineColor={28,108,200}),
        Ellipse(extent={{-2,-26},{6,-18}}, lineColor={28,108,200}),
        Text(
          extent={{-6,10},{12,20}},
          lineColor={28,108,200},
          textString="K2",
          fontSize=16),
        Text(
          extent={{30,-6},{48,4}},
          lineColor={28,108,200},
          textString="K3",
          fontSize=16),
        Text(
          extent={{-6,-18},{12,-8}},
          lineColor={28,108,200},
          textString="K4",
          fontSize=16),
        Text(
          extent={{-38,28},{-20,38}},
          lineColor={28,108,200},
          fontSize=16,
          textString="R1"),
        Text(
          extent={{22,28},{40,38}},
          lineColor={28,108,200},
          textString="R2",
          fontSize=16),
        Text(
          extent={{24,-40},{42,-30}},
          lineColor={28,108,200},
          textString="R3",
          fontSize=16),
        Text(
          extent={{-38,-40},{-20,-30}},
          lineColor={28,108,200},
          textString="R4",
          fontSize=16),
        Ellipse(extent={{-52,-4},{-44,4}},
                                        lineColor={28,108,200}),
        Text(
          extent={{-46,-4},{-28,6}},
          lineColor={28,108,200},
          textString="K1",
          fontSize=16)}),
    experiment(
      StopTime=1000,
      Interval=1,
      __Dymola_Algorithm="Dassl"));
end Check_meshed_grid;

