within IntegraNet.Producer.Electrical.Photovoltaics.Check;
model Test_PV_Simple
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

  PV_Simple pV_Simple(PV_Radiation(fileName=fileName))
                      annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));
  Components.Boundaries.Electrical.ApparentPower.Electric_Grid ElectricGrid annotation (Placement(transformation(extent={{18,-10},{38,10}})));

  parameter String fileName=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Ambient/Radiation_PVModule_TRY-Koeln_Az=0_Tilt=35.txt");
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-86,78},{-66,98}})));
  inner Statistics.Statistics_collector statistics_collector annotation (Placement(transformation(extent={{-50,78},{-30,98}})));
equation

  connect(ElectricGrid.epp, pV_Simple.epp) annotation (Line(
      points={{18,0},{-26,0}},
      color={0,127,0},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=4320000,
      Interval=3600.00288,
      __Dymola_Algorithm="Dassl"));
end Test_PV_Simple;

