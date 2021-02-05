within IntegraNet.Producer.Heat.SolarThermal.Check;
model TestSolarThermalSystem
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



  inner IntegraNet.Statistics.Statistics_collector statistics_collector;
  // inner IntegraNet.ModelStatistics modelStatistics   annotation (Placement(transformation(extent={{-44,78},{-24,98}})));

  inner IntegraNet.SimCenter simCenter(ambientConditions(
      redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY globalSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DNI_Hamburg_3600s_2012_TMY directSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DHI_Hamburg_3600s_2012_TMY diffuseSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Berlin_3600s_2012 temperature,
      redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_3600s_TMY wind))
    annotation (Placement(transformation(extent={{-84,78},{-64,98}})));



  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________


  SolarThermalSystem_10LayerStorage solarThermalSystem_10LayerStorage
                                                                    annotation (Placement(transformation(extent={{-20,-22},{2,-2}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi gasSource annotation (Placement(transformation(extent={{48,-60},{32,-44}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    startTime=3600,
    duration=36000,
    height=2e3,
    offset=5e3)
    annotation (Placement(transformation(extent={{-74,6},{-54,26}})));

  Modelica.Blocks.Sources.Constant
                               const(k=2e3)
    annotation (Placement(transformation(extent={{2,30},{22,50}})));

equation

  connect(gasSource.gasPort, solarThermalSystem_10LayerStorage.gasPortIn) annotation (Line(
      points={{32,-52},{-0.566667,-52},{-0.566667,-21.7692}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp1.y, solarThermalSystem_10LayerStorage.Q_demand_heating) annotation (Line(points={{-53,16},{-11.1267,16},{-11.1267,-3.92308}}, color={0,0,127}));
  connect(const.y, solarThermalSystem_10LayerStorage.Q_demand_hotwater) annotation (Line(points={{23,40},{44,40},{44,10},{-5.26,10},{-5.26,-3.92308}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=864000));
end TestSolarThermalSystem;
