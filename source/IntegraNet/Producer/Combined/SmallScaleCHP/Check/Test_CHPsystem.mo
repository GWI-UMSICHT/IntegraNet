within IntegraNet.Producer.Combined.SmallScaleCHP.Check;
model Test_CHPsystem

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
  //inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-110,60},{-90,80}})));
  inner IntegraNet.Statistics.Statistics_collector statistics_collector annotation (Placement(transformation(extent={{-428,264},{-408,284}})));
  inner SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1) annotation (Placement(transformation(extent={{-108,80},{-88,100}})));


  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage grid(Use_input_connector_f=false, Use_input_connector_v=false) annotation (Placement(transformation(extent={{-82,-52},{-108,-26}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi
                                            Gas_Source(p_const=simCenter.p_amb_const + simCenter.p_eff_1)
    annotation (Placement(transformation(extent={{90,-56},{60,-26}})));
  CHPSystem cHPSystem annotation (Placement(transformation(extent={{-50,-14},{-6,20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=8*3600,
    startTime=3600,
    height=5000,
    offset=5000)    annotation (Placement(transformation(extent={{28,48},{8,68}})));
equation
  connect(grid.epp, cHPSystem.epp) annotation (Line(
      points={{-82,-39},{-45.82,-39},{-45.82,-14.85}},
      color={0,127,0},
      thickness=0.5));
  connect(cHPSystem.gasPortIn, Gas_Source.gasPort) annotation (Line(
      points={{-11.06,-15.19},{-11.06,-41},{60,-41}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp.y, cHPSystem.Q_Demand) annotation (Line(points={{7,58},{-27.78,58},{-27.78,19.49}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-120,-100},{120,100}})),
    Icon(coordinateSystem(extent={{-120,-100},{120,100}})),
    experiment(
      StopTime=86400,
      Interval=900,
      Tolerance=1e-006),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end Test_CHPsystem;

