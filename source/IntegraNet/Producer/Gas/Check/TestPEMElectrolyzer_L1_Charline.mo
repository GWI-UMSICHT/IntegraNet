within IntegraNet.Producer.Gas.Check;
model TestPEMElectrolyzer_L1_Charline
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
  import TransiEnt;
  import SI = Modelica.SIunits;

protected
  function plotResult

  constant String resultFileName = "TestPEMElectrolyzer_L1_Charline.mat";

  output String resultFile;

  algorithm
    clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
    resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
    removePlots(false);
    createPlot(id=1, position={0, 0, 1563, 735}, x="electrolyzer100PowerIn.P_el", y={"electrolyzer100PowerIn.eta", "electrolyzer200PowerIn.eta"}, range={50000.0, 1500000.0, 0.1, 1.0}, grid=true, filename=resultFile, colors={{28,108,200}, {238,46,47}});
    createPlot(id=1, position={0, 0, 1563, 365}, x="electrolyzer100MFlowIn.P_el", y={"electrolyzer100MFlowIn.eta", "electrolyzer200MFlowIn.eta"}, range={50000.0, 1500000.0, 0.1, 1.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}});
  end plotResult;

public
  parameter SI.Power P_el_n=1e6 "Nominal electrical power of the electrolyzer";
  parameter SI.Power P_el_min=0.05*P_el_n "Minimal electrical power of the electrolyzer";
  parameter SI.Power P_el_max=1.0*P_el_n "Maximal electrical power of the electrolyzer";
  parameter SI.Temperature T_out=288.15 "Temperature of the produced hydrogen";
  parameter SI.Efficiency eta_n=0.75 "Nominal efficiency of the electrolyzer";
  parameter SI.Pressure p_out=50e5 "Pressure of the produced hydrogen";

  Modelica.Blocks.Sources.Ramp rampPower(
    height=P_el_max - P_el_min,
    offset=P_el_min,
    duration=30,
    startTime=10) annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  PEMElectrolyzer_L1                                     electrolyzer100PowerIn(
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer100) annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink100PowerIn(medium=simCenter.gasModel3,
                                                                          p_const=p_out) annotation (Placement(transformation(extent={{42,50},{22,70}})));
  PEMElectrolyzer_L1                                     electrolyzer200PowerIn(
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200) annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink200PowerIn(medium=simCenter.gasModel3,
                                                                          p_const=p_out) annotation (Placement(transformation(extent={{42,10},{22,30}})));
  PEMElectrolyzer_L1                                     electrolyzer100MFlowIn(
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    whichInput=2,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer100) annotation (Placement(transformation(extent={{-8,-74},{12,-54}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink100MFlowIn(medium=simCenter.gasModel3,
                                                                          p_const=p_out) annotation (Placement(transformation(extent={{74,-74},{54,-54}})));
  Modelica.Blocks.Sources.Ramp ramp100MFlow(
    duration=30,
    startTime=10,
    height=0.007042109,
    offset=0.000341591)
                       annotation (Placement(transformation(extent={{-80,-62},{-60,-42}})));
  PEMElectrolyzer_L1                                     electrolyzer200MFlowIn(
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    whichInput=2,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200) annotation (Placement(transformation(extent={{-8,-116},{12,-96}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink200MFlowIn(medium=simCenter.gasModel3,
                                                                          p_const=p_out) annotation (Placement(transformation(extent={{74,-116},{54,-96}})));
  Modelica.Blocks.Sources.Ramp ramp200MFlow(
    duration=30,
    startTime=10,
    height=0.0073267744,
    offset=7.18756e-5) annotation (Placement(transformation(extent={{-80,-104},{-60,-84}})));
  inner TransiEnt.ModelStatistics                                         modelStatistics annotation (Placement(transformation(extent={{80,80},{100,100}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensor100PowerIn(medium=simCenter.gasModel3)
                                                                                       annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensor200PowerIn(medium=simCenter.gasModel3)
                                                                                       annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensor100MFlowIn(medium=simCenter.gasModel3)
                                                                                       annotation (Placement(transformation(extent={{22,-64},{42,-44}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensor200MFlowIn(medium=simCenter.gasModel3)
                                                                                       annotation (Placement(transformation(extent={{22,-106},{42,-86}})));
  Components.Boundaries.Electrical.ApparentPower.Electric_Grid ElectricGrid100PowerIn annotation (Placement(transformation(extent={{-62,50},{-82,70}})));
  Components.Boundaries.Electrical.ApparentPower.Electric_Grid ElectricGrid200PowerIn annotation (Placement(transformation(extent={{-62,10},{-82,30}})));
  inner SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3) annotation (Placement(transformation(extent={{50,80},{70,100}})));
  PEMElectrolyzer_L1 electrolyzerConstantPowerIn(
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = ElectrolyzerEfficiencyCharline_constant_eta) annotation (Placement(transformation(extent={{-40,-28},{-20,-8}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sinkConstantPowerIn(medium=simCenter.gasModel3, p_const=p_out) annotation (Placement(transformation(extent={{42,-28},{22,-8}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensorConstantPowerIn(medium=simCenter.gasModel3) annotation (Placement(transformation(extent={{-10,-18},{10,2}})));
  Components.Boundaries.Electrical.ApparentPower.Electric_Grid ElectricGridConstantPowerIn annotation (Placement(transformation(extent={{-62,-28},{-82,-8}})));
  Components.Boundaries.Electrical.ApparentPower.Electric_Grid ElectricGrid100MFlowIn annotation (Placement(transformation(extent={{-28,-74},{-48,-54}})));
  Components.Boundaries.Electrical.ApparentPower.Electric_Grid ElectricGrid200MFlowIn annotation (Placement(transformation(extent={{-28,-116},{-48,-96}})));
  PEMElectrolyzer_L1 electrolyzerConstantMFlowIn(
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    whichInput=2,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = ElectrolyzerEfficiencyCharline_constant_eta) annotation (Placement(transformation(extent={{-8,-160},{12,-140}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sinkConstantMFlowIn(medium=simCenter.gasModel3, p_const=p_out) annotation (Placement(transformation(extent={{74,-160},{54,-140}})));
  Modelica.Blocks.Sources.Ramp rampConstantMFlow(
    duration=30,
    startTime=10,
    height=0.007042109,
    offset=0.000341591) annotation (Placement(transformation(extent={{-80,-148},{-60,-128}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensorConstantMFlowIn(medium=simCenter.gasModel3) annotation (Placement(transformation(extent={{22,-150},{42,-130}})));
  Components.Boundaries.Electrical.ApparentPower.Electric_Grid ElectricGridConstantMFlowIn annotation (Placement(transformation(extent={{-28,-160},{-48,-140}})));
equation
  connect(rampPower.y, electrolyzer100PowerIn.P_el_set) annotation (Line(points={{-59,90},{-50,90},{-50,72},{-34,72}},    color={0,0,127}));
  connect(rampPower.y, electrolyzer200PowerIn.P_el_set) annotation (Line(points={{-59,90},{-50,90},{-50,32},{-34,32}},    color={0,0,127}));
  connect(ramp100MFlow.y, electrolyzer100MFlowIn.m_flow_H2_set) annotation (Line(points={{-59,-52},{6,-52}},                       color={0,0,127}));
  connect(ramp200MFlow.y, electrolyzer200MFlowIn.m_flow_H2_set) annotation (Line(points={{-59,-94},{6,-94}},                       color={0,0,127}));
  connect(electrolyzer100PowerIn.gasPortOut, enthalpyFlowSensor100PowerIn.gasPortIn) annotation (Line(
      points={{-20,60},{-10,60}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensor100PowerIn.gasPortOut, sink100PowerIn.gasPort) annotation (Line(
      points={{10,60},{16,60},{22,60}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer100MFlowIn.gasPortOut, enthalpyFlowSensor100MFlowIn.gasPortIn) annotation (Line(
      points={{12,-64},{16,-64},{16,-62},{18,-62},{18,-66},{22,-66}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensor100MFlowIn.gasPortOut, sink100MFlowIn.gasPort) annotation (Line(
      points={{42,-64},{46,-64},{46,-62},{48,-62},{48,-66},{54,-66}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer200MFlowIn.gasPortOut, enthalpyFlowSensor200MFlowIn.gasPortIn) annotation (Line(
      points={{12,-106},{22,-106}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensor200MFlowIn.gasPortOut, sink200MFlowIn.gasPort) annotation (Line(
      points={{42,-106},{54,-106}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer200PowerIn.gasPortOut, enthalpyFlowSensor200PowerIn.gasPortIn) annotation (Line(
      points={{-20,20},{-15,20},{-10,20}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensor200PowerIn.gasPortOut, sink200PowerIn.gasPort) annotation (Line(
      points={{10,20},{16,20},{22,20}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid100PowerIn.epp, electrolyzer100PowerIn.epp) annotation (Line(
      points={{-62,60},{-40,60}},
      color={0,127,0},
      thickness=0.5));
  connect(ElectricGrid200PowerIn.epp, electrolyzer200PowerIn.epp) annotation (Line(
      points={{-62,20},{-40,20}},
      color={0,127,0},
      thickness=0.5));
  connect(electrolyzerConstantPowerIn.gasPortOut, enthalpyFlowSensorConstantPowerIn.gasPortIn) annotation (Line(
      points={{-20,-18},{-10,-18}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensorConstantPowerIn.gasPortOut, sinkConstantPowerIn.gasPort) annotation (Line(
      points={{10,-18},{22,-18}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGridConstantPowerIn.epp, electrolyzerConstantPowerIn.epp) annotation (Line(
      points={{-62,-18},{-40,-18}},
      color={0,127,0},
      thickness=0.5));
  connect(electrolyzerConstantPowerIn.P_el_set, rampPower.y) annotation (Line(points={{-34,-6},{-50,-6},{-50,90},{-59,90}}, color={0,0,127}));
  connect(ElectricGrid100MFlowIn.epp, electrolyzer100MFlowIn.epp) annotation (Line(
      points={{-28,-64},{-8,-64}},
      color={0,127,0},
      thickness=0.5));
  connect(ElectricGrid200MFlowIn.epp, electrolyzer200MFlowIn.epp) annotation (Line(
      points={{-28,-106},{-8,-106}},
      color={0,127,0},
      thickness=0.5));
  connect(rampConstantMFlow.y, electrolyzerConstantMFlowIn.m_flow_H2_set) annotation (Line(points={{-59,-138},{6,-138}}, color={0,0,127}));
  connect(electrolyzerConstantMFlowIn.gasPortOut, enthalpyFlowSensorConstantMFlowIn.gasPortIn) annotation (Line(
      points={{12,-150},{22,-150}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensorConstantMFlowIn.gasPortOut, sinkConstantMFlowIn.gasPort) annotation (Line(
      points={{42,-150},{54,-150}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGridConstantMFlowIn.epp, electrolyzerConstantMFlowIn.epp) annotation (Line(
      points={{-28,-150},{-8,-150}},
      color={0,127,0},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{100,100}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{100,100}}),
                                                                                                                      graphics={Text(
          extent={{50,42},{94,36}},
          lineColor={0,140,72},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="P_el_n=1 MW
P_el_min=0.05 MW
P_el_max=1 MW
eta_n=0.75
T_out=15 C
p_out=50 bar
no costs considered")}),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(executeCall=TransiEnt.Components.Convertor.Power2Gas.Check.TestPEMElectrolyzer_L1_Charline.plotResult() "Plot example results"));
end TestPEMElectrolyzer_L1_Charline;

