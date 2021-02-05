within IntegraNet.Producer.Electrical.Photovoltaics.Advanced_PV.Check;
model TestPVModule_simple_ExternalInverter
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

  PVModule_simple_ExternalInverter pVModule
                          annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Modelica.Blocks.Sources.RealExpression ambientTemperature(y=simCenter.ambientConditions.temperature.value)    annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=0,
        origin={-38,15})));

  Modelica.Blocks.Sources.CombiTimeTable radiationData(
    tableOnFile=true,
    tableName="default",
    fileName=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Ambient/Radiation_PVModule_TRY-Koeln_Az=0_Tilt=35.txt"))                                                    annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));

  Modelica.Blocks.Sources.RealExpression wind(y=simCenter.ambientConditions.wind.value)  annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={-38,-18})));

  SinglePhasePVInverter PVInverter(P_PV=pVModule.P_inst)
                                                   annotation (Placement(transformation(extent={{34,-12},{50,12}})));

  Components.Boundaries.Electrical.ApparentPower.Electric_Grid ElectricGrid annotation (Placement(transformation(extent={{64,-10},{84,10}})));

  inner Statistics.Statistics_collector statistics_collector annotation (Placement(transformation(extent={{-52,80},{-32,100}})));

  inner SimCenter simCenter annotation (Placement(transformation(extent={{-88,80},{-68,100}})));

equation

  connect(pVModule.radiation_in, radiationData.y[1]) annotation (Line(points={{-0.6,0},{-61,0}}, color={0,0,127}));
  connect(ambientTemperature.y, pVModule.T_in) annotation (Line(points={{-27,15},{-16.5,15},{-16.5,8},{-2,8}}, color={0,0,127}));
  connect(wind.y, pVModule.WindSpeed_in) annotation (Line(points={{-27,-18},{-12,-18},{-12,-8},{-2,-8}}, color={0,0,127}));
  connect(PVInverter.epp_DC, pVModule.epp) annotation (Line(
      points={{34.16,0},{19.5,0}},
      color={0,135,135},
      thickness=0.5));
  connect(PVInverter.epp_AC, ElectricGrid.epp) annotation (Line(
      points={{50,0},{64,0}},
      color={0,127,0},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestPVModule_simple_ExternalInverter;

