within IntegraNet.Producer.Heat.SolarThermal.Check;
model TestCollector_energybased
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

  //Check-Model analogous to TransiEnt.Producer.Heat.SolarThermal.Check.TestCollectorFluidCycle
  // to compare solarCollector_energybased with TransiEnt model for SolarCollector_L1

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Basics.Icons.Checkmodel;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  inner IntegraNet.SimCenter simCenter(ambientConditions(
      redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY
        globalSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DNI_Hamburg_3600s_2012_TMY
        directSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DHI_Hamburg_3600s_2012_TMY
        diffuseSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Berlin_3600s_2012
        temperature,
      redeclare
        TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012
        wind),
    integrateHeatFlow=true,
    calculateCost=true,
    integrateCDE=true)
    annotation (Placement(transformation(extent={{-84,78},{-64,98}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-54,78},{-34,98}})));
  IntegraNet.Producer.Heat.SolarThermal.solarCollector_energybased
    solarCollector_energybased(
    Q_flow_n=2e3,
    area=2.33,
    eta_0=0.793,
    a1=4.04,
    a2=0.0182,
    c_eff=5000,
    G_min=controller.G_min,
    redeclare model Skymodel =
        TransiEnt.Producer.Heat.SolarThermal.Base.Skymodel_isotropicDiffuse)
    annotation (Placement(transformation(extent={{-18,-76},{2,-56}})));
  TransiEnt.Producer.Heat.SolarThermal.Control.ControllerPumpSolarCollectorTandG
                                                  controller(
    G_min=150,
    eta_mech=0.98,
    T=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=1000,
    initType_PID=Modelica.Blocks.Types.InitPID.InitialOutput,
    y_start_PID=10,
    T_set=358.15,
    m_flow_min=0.0047,
    Delta_p=15000,
    rho_m=1000,
    P_drive_min(k=controller.m_flow_min))
                annotation (Placement(transformation(extent={{50,0},{80,24}})));
  Modelica.Blocks.Sources.RealExpression Temp_stor(y=20 + 273.15) annotation (Placement(transformation(extent={{-72,-38},{-52,-18}})));
  Modelica.Blocks.Math.Gain P_drive2m_flow(k=-1)
    annotation (Placement(transformation(extent={{24,30},{0,54}})));
equation
  connect(controller.G_total, solarCollector_energybased.G)
    annotation (Line(points={{52,5},{0.8,5},{0.8,-57.4}},   color={0,0,127}));
  connect(solarCollector_energybased.T_out, controller.T_out)
    annotation (Line(points={{-1.8,-57.4},{-1.8,10},{52,10}},
                                                            color={0,0,127}));
  connect(solarCollector_energybased.T_in, Temp_stor.y) annotation (Line(points={{-15.6,-57.2},{-15.6,-28},{-51,-28}}, color={0,0,127}));
  connect(controller.T_stor, Temp_stor.y) annotation (Line(points={{52,0},{-40,0},{-40,-28},{-51,-28}}, color={0,0,127}));
  connect(controller.T_in, Temp_stor.y) annotation (Line(points={{52,14.4},{-44,14.4},{-44,-28},{-51,-28}}, color={0,0,127}));
  connect(controller.P_drive, P_drive2m_flow.u) annotation (Line(points={{52,18},{40,18},{40,42},{26.4,42}},
                                      color={0,0,127}));
  connect(P_drive2m_flow.y, solarCollector_energybased.m_flow) annotation (
      Line(points={{-1.2,42},{-18,42},{-18,-57.4},{-17.8,-57.4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=31536000, __Dymola_Algorithm="Dassl"));
end TestCollector_energybased;
