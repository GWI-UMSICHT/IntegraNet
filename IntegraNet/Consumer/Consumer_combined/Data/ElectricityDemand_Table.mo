within IntegraNet.Consumer.Consumer_combined.Data;
model ElectricityDemand_Table
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

  extends IntegraNet.Consumer.Consumer_combined.Base.ElectricityDemand;
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

    parameter String fileName=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Electricity_20Consumers_HTWBerlin_3-4MWh_3600s.csv")
                                    annotation(choices(choice=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Electricity_20Consumers_HTWBerlin_3-4MWh_3600s.csv")
                                                                                                                                                                                           "Measured electric load profiles from HTW Berlin with 3-4MWh/a",
                                                       choice=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Electricity_20Consumers_HTWBerlin_4-5MWh_3600s.csv")
                                                                                                                                                                                           "Measured electric load profiles from HTW Berlin with 4-5MWh/a",
                                                       choice=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Electricity_20Consumers_HTWBerlin_5-6MWh_3600s.csv") "Measured electric load profiles from HTW Berlin with 4-6 MWh/a"));

    parameter Boolean tableOnFile=true    "= true, if table is defined on file";

    parameter String tableName="default";

    parameter Integer columns[:]={2}    "Columns of table to be interpolated";

    parameter Modelica.Blocks.Types.Smoothness smoothness=simCenter.tableInterpolationSmoothness    "Smoothness of table interpolation";

    parameter Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints    "Extrapolation of data outside the definition range";

    final parameter String complete_relative_path = Modelica.Utilities.Files.fullPathName(fileName);

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

   Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    tableOnFile=tableOnFile,
    fileName=complete_relative_path,
    smoothness=smoothness,
    columns=columns,
    offset={0},
    startTime=0,
    tableName=tableName,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{-56,-52},{48,52}})));

equation
 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________

  connect(combiTimeTable.y[1], electricityDemand) annotation (Line(points={{53.2,0},{80,0},{80,-74},{80,-76},{0,-76},{0,-100}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Model to read in table data for electricity demand.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>IntegraNet.Basics.Interfaces.General.PowerOut demand</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end ElectricityDemand_Table;

