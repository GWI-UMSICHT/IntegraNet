within IntegraNet.Consumer.Consumer_combined.Data;
model Demand_Table_combined "Table with combined load profile data for consumer: y[1]=electrical demand, y[2]=heat demand for heating, y[3] = heat demand for hot water"
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

  parameter String fileName=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/DemandCombined_3Consumers_60s.csv") annotation (choices(
      choice=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/DemandCombined_3Consumers_60s.csv")  "Table with electrical, heating and hot water demand for 20 consumers"));

  parameter Boolean tableOnFile=true "= true, if table is defined on file";

  parameter String tableName="default";

  parameter Integer columns[:]={3*consumer_count-1,3*consumer_count,3*consumer_count+1} "Columns of table to be interpolated";

  parameter Modelica.Blocks.Types.Smoothness smoothness=simCenter.tableInterpolationSmoothness
    "Smoothness of table interpolation";

  parameter Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints
    "Extrapolation of data outside the definition range";

  final parameter String complete_relative_path=
      Modelica.Utilities.Files.fullPathName(fileName);

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    tableOnFile=tableOnFile,
    fileName=complete_relative_path,
    smoothness=smoothness,
    columns= columns,
    offset={0},
    startTime=0,
    tableName=tableName,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{-84,16},{-40,60}})));

  Modelica.Blocks.Math.Gain gain(k=waterDemand) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={48,-42})));
  Modelica.Blocks.Math.Gain gain1(k=heatDemand) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={4,-42})));
  Modelica.Blocks.Math.Gain gain2(k=electricityDemand) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-36,-44})));

equation

 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________

  connect(combiTimeTable.y[1], gain2.u) annotation (Line(points={{-37.8,38},{-32,38},{-32,-32},{-36,-32}}, color={0,0,127}));
  connect(combiTimeTable.y[2], gain1.u) annotation (Line(points={{-37.8,38},{4,38},{4,-30}}, color={0,0,127}));
  connect(combiTimeTable.y[3], gain.u) annotation (Line(points={{-37.8,38},{48,38},{48,-30}}, color={0,0,127}));
  connect(gain2.y, demand[1]) annotation (Line(points={{-36,-55},{-36,-68},{0,-68},{0,-97.3333},{0,-97.3333}}, color={0,0,127}));
  connect(gain1.y, demand[2]) annotation (Line(points={{4,-53},{4,-104},{0,-104}}, color={0,0,127}));
  connect(gain.y, demand[3]) annotation (Line(points={{48,-53},{48,-74},{12,-74},{12,-110.667},{0,-110.667}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Contains one combined table for load profile data for electricity, space heating and drinking hot water demand. Load profiles can be scaled using the three scaling factors. The model can be used in the Basic_Grid_Element.</p>
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
<p>The data in the given data-file has to have the following structure:</p>
<p>First coulumn contains the time vector. This vector is followed by groups of three columns. First column of these groups has to contain the electricity demand, second column the space heating demand and third column the drinking hot water demand, all of the same household.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created during IntegraNet </span></p>
</html>"));
end Demand_Table_combined;

