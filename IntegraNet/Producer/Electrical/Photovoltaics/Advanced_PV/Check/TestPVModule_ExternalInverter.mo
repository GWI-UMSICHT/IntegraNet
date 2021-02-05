within IntegraNet.Producer.Electrical.Photovoltaics.Advanced_PV.Check;
model TestPVModule_ExternalInverter
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Basics.Icons.Checkmodel;

  // _____________________________________________
  //
  //                    Components
  // _____________________________________________

  inner SimCenter simCenter(redeclare Components.Boundaries.Ambient.AmbientConditions_Koeln_TRY ambientConditions)
                            annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner Statistics.Statistics_collector statistics_collector annotation (Placement(transformation(extent={{-54,80},{-34,100}})));

  PVModule_ExternalInverter pVModule(
    longitude_local=SI.Conversions.from_deg(123),
    slope=SI.Conversions.from_deg(0),
    reflectance_ground=0.25,
    use_input_data=true) annotation (Placement(transformation(extent={{-10,-8},{10,12}})));
  Modelica.Blocks.Sources.RealExpression ambientTemperature(y=simCenter.ambientConditions.temperature.value)  annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=0,
        origin={-48,17})));
  Modelica.Blocks.Sources.RealExpression wind(y=simCenter.ambientConditions.wind.value)  annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={-48,-20})));

  SinglePhasePVInverter PVInverter(P_PV=pVModule.P_inst) annotation (Placement(transformation(extent={{26,-12},{42,12}})));
  Components.Boundaries.Electrical.ApparentPower.Electric_Grid ElectricGrid annotation (Placement(transformation(extent={{54,-10},{74,10}})));

  Modelica.Blocks.Sources.RealExpression directSolarRadiation(y=simCenter.ambientConditions.directSolarRadiation.value)    annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=0,
        origin={-70,5})));
  Modelica.Blocks.Sources.RealExpression diffuseSolarRadiation(y=simCenter.ambientConditions.diffuseSolarRadiation.value)   annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={-58,-10})));

  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-26,80},{-6,100}})));
equation

  connect(ambientTemperature.y, pVModule.T_in) annotation (Line(points={{-37,17},{-26.5,17},{-26.5,10},{-12,10}},
                                                                                                                color={0,0,127}));
  connect(wind.y, pVModule.WindSpeed_in) annotation (Line(points={{-37,-20},{-22,-20},{-22,-6},{-12,-6}}, color={0,0,127}));
  connect(PVInverter.epp_DC, pVModule.epp) annotation (Line(
      points={{26.16,0},{16,0},{16,1.4},{9.3,1.4}},
      color={0,135,135},
      thickness=0.5));
  connect(PVInverter.epp_AC, ElectricGrid.epp) annotation (Line(
      points={{42,0},{54,0}},
      color={0,127,0},
      thickness=0.5));
  connect(directSolarRadiation.y, pVModule.DNI_in) annotation (Line(points={{-59,5},{-26.5,5},{-26.5,4.4},{-12,4.4}}, color={0,0,127}));
  connect(diffuseSolarRadiation.y, pVModule.DHI_in) annotation (Line(points={{-47,-10},{-26,-10},{-26,-0.6},{-12,-0.6}},
                                                                                                                       color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=8640000,
      Interval=3600,
      __Dymola_Algorithm="Dassl"));
end TestPVModule_ExternalInverter;

