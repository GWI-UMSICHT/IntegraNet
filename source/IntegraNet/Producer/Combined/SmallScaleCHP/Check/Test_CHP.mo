within IntegraNet.Producer.Combined.SmallScaleCHP.Check;
model Test_CHP

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
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-110,60},{-90,80}})));
  inner SimCenter simCenter(
    integrateElPower=true,
    integrateHeatFlow=true, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1,
    calculateCost=true,
    integrateCDE=true)                                                                             annotation (Placement(transformation(extent={{-110,82},{-90,102}})));

  CHP_simple cHP_simple annotation (Placement(transformation(extent={{-24,-16},{10,18}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage grid(Use_input_connector_f=false, Use_input_connector_v=false) annotation (Placement(transformation(extent={{38,-8},{66,20}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi Gas_Source(p_const=simCenter.p_amb_const + simCenter.p_eff_1)  annotation (Placement(transformation(extent={{68,-58},{38,-28}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(width=50, period=86400) annotation (Placement(transformation(extent={{-106,-18},{-80,8}})));

equation

  connect(grid.epp, cHP_simple.epp) annotation (Line(
      points={{38,6},{25.95,6},{25.95,-3.93},{11.87,-3.93}},
      color={0,127,0},
      thickness=0.5));
  connect(Gas_Source.gasPort, cHP_simple.gasPortIn) annotation (Line(
      points={{38,-43},{26,-43},{26,-12.94},{12.04,-12.94}},
      color={255,255,0},
      thickness=1.5));
  connect(booleanPulse.y, cHP_simple.OnOffSignal) annotation (Line(points={{-78.7,-5},{-54,-5},{-54,2.02},{-24.34,2.02}}, color={255,0,255}));
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
end Test_CHP;

