within IntegraNet.Producer.Electrical.Photovoltaics;
model PV_Radiation "Radiation data as input for PV_simple"

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

  extends TransiEnt.Basics.Icons.TableIcon;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

    parameter String fileName=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Ambient/Radiation_PVModule_TRY-Koeln_Az=0_Tilt=35.txt") annotation(choices(
    choice=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Ambient/Radiation_PVModule_TRY-Koeln_Az=0_Tilt=35.txt")));

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
    annotation (Placement(transformation(extent={{-62,-56},{42,48}})));

  Modelica.Blocks.Interfaces.RealOutput y[combiTimeTable.nout] annotation (Placement(transformation(extent={{86,-14},{106,6}})));

equation
 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________

  connect(combiTimeTable.y, y)
    annotation (Line(points={{47.2,-4},{96,-4}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model can be used to read radiation data into a model. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica RealOutput: electric radatation on an inclined surface</p>
<p>Modelica RealOutput: y[MSL_combiTimeTable.nout]</p>
<p>Modelica RealOutput: y1</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end PV_Radiation;

