within IntegraNet.Consumer.Consumer_combined.Data;
model Demand_3Tables "Three seperate tables for load profile data: electrical demand, heat demand for heating, heat demand for hot water"
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

  extends IntegraNet.Consumer.Consumer_combined.Base.Demand_combined;
  extends TransiEnt.Basics.Icons.TableIcon;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer IntegraNet.SimCenter simCenter;

  // _____________________________________________
  //
  //              Parameters
  // _____________________________________________

  parameter Real heatDemand=1 "scaling factor for space heating demand of the consumer";

  parameter Real waterDemand=1 "scaling factor for warm water demand of the consumer";

  parameter Real electricityDemand=1 "scaling factor for electricity demand of the consumer";

  parameter String fileName_el=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Electricity_20Consumers_HTWBerlin_3-4MWh_3600s.csv")
                                    annotation(choices(choice=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Electricity_20Consumers_HTWBerlin_3-4MWh_3600s.csv")
                                                                                                                                                                                           "Measured electric load profiles from HTW Berlin with 3-4MWh/a",
                                                       choice=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Electricity_20Consumers_HTWBerlin_4-5MWh_3600s.csv")
                                                                                                                                                                                           "Measured electric load profiles from HTW Berlin with 4-5MWh/a",
                                                       choice=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Electricity_20Consumers_HTWBerlin_5-6MWh_3600s.csv") "Measured electric load profiles from HTW Berlin with 4-6 MWh/a"));

  parameter String fileName_q_heating=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Heating_20Consumers_6MWh_3600s.csv") annotation(choices(
                                               choice=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Heating_SLP_TMY-Hamburg_HEF_10MWh_3600s.txt") "SLP with TMY Hamburg weather data and 10 MWh yearly heating demand",
                                               choice=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Heating_SLP_TMY-Hamburg_HMF_35MWh_3600s.txt") "SLP with TMY Hamburg weather data and 35 MWh yearly heating demand",
                                               choice=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Heating_20Consumers_6MWh_3600s.csv") "Simulated heating demand with 6MWh yearly demand"));

  parameter String fileName_q_water=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/HotWater_VDI4655_60s.txt") annotation(choices(choice=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/HotWater_VDI4655.txt") "Hot water profile from VDI 4655",
                                               choice=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/HotWater_20Consumers_VEDIS_1.5MWh_60s.txt") "Stochastic profile from VEDIS tool, 1.5 MWh yearly demand",
                                               choice=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/HotWater_20Consumers_VEDIS_3MWh_60s.txt") "Stochastic profile from VEDIS tool, 3 MWh yearly demand"));

  parameter Boolean tableOnFile=true "= true, if table is defined on file";

  parameter String tableName="default";

  parameter Integer columns[:]={consumer_count+1} "Columns of table to be interpolated";

  parameter Modelica.Blocks.Types.Smoothness smoothness=simCenter.tableInterpolationSmoothness
    "Smoothness of table interpolation";

  parameter Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints
    "Extrapolation of data outside the definition range";

  final parameter String complete_relative_path_el=
      Modelica.Utilities.Files.fullPathName(fileName_el);
  final parameter String complete_relative_path_q_heating=
      Modelica.Utilities.Files.fullPathName(fileName_q_heating);
  final parameter String complete_relative_path_q_water=
      Modelica.Utilities.Files.fullPathName(fileName_q_water);

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    tableOnFile=tableOnFile,
    smoothness=smoothness,
    offset={0},
    startTime=0,
    tableName=tableName,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    fileName=complete_relative_path_el,
    columns=columns)
    annotation (Placement(transformation(extent={{-92,44},{-48,88}})));

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable1(
    tableOnFile=tableOnFile,
    smoothness=smoothness,
    offset={0},
    startTime=0,
    tableName=tableName,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    fileName=complete_relative_path_q_heating,
    columns=columns)
    annotation (Placement(transformation(extent={{-92,-20},{-48,24}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable2(
    tableOnFile=tableOnFile,
    smoothness=smoothness,
    offset={0},
    startTime=0,
    tableName=tableName,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    fileName=complete_relative_path_q_water,
    columns=columns)
    annotation (Placement(transformation(extent={{-92,-82},{-48,-38}})));
  Modelica.Blocks.Math.Gain gain(k=waterDemand) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-24,-60})));
  Modelica.Blocks.Math.Gain gain1(k=heatDemand) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-22,2})));
  Modelica.Blocks.Math.Gain gain2(k=electricityDemand) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-20,66})));
equation
 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________

  connect(combiTimeTable.y[1], gain2.u) annotation (Line(points={{-45.8,66},{-32,66}}, color={0,0,127}));
  connect(gain2.y, demand[1]) annotation (Line(points={{-9,66},{0,66},{0,-97.3333}}, color={0,0,127}));
  connect(combiTimeTable1.y[1], gain1.u) annotation (Line(points={{-45.8,2},{-34,2}}, color={0,0,127}));
  connect(demand[2], gain1.y) annotation (Line(points={{0,-104},{0,2},{-11,2}}, color={0,0,127}));
  connect(combiTimeTable2.y[1], gain.u) annotation (Line(points={{-45.8,-60},{-36,-60}}, color={0,0,127}));
  connect(gain.y, demand[3]) annotation (Line(points={{-13,-60},{0,-60},{0,-110.667}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Contains three different tables for load profile data for electricity, space heating and drinking hot water demand. Load profiles can be scaled using the scaling factors. The model can be used in the Basic_Grid_Element.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created during IntegraNet </span></p>
</html>"));
end Demand_3Tables;

