within IntegraNet.Producer.Heat.SolarThermal.Check;
model TestSolarThermalSystem_noGasPort
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

  SolarThermalSystem_5LayerStorage_noGasPort
                                   solarThermalSystem_5LayerStorage_noGasPort
                                                                    annotation (Placement(transformation(extent={{-20,-22},{0,-2}})));
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

  connect(ramp1.y, solarThermalSystem_5LayerStorage_noGasPort.Q_demand_heating) annotation (Line(points={{-53,16},{-13.9,16},{-13.9,-2.5}}, color={0,0,127}));
  connect(const.y, solarThermalSystem_5LayerStorage_noGasPort.Q_demand_hotwater) annotation (Line(points={{23,40},{44,40},{44,10},{-5.9,10},{-5.9,-2.5}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=864000));
end TestSolarThermalSystem_noGasPort;
