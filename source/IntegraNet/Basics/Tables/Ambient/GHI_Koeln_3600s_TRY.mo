within IntegraNet.Basics.Tables.Ambient;
model GHI_Koeln_3600s_TRY "GHI Koeln TRY, 1 h resolution, Source: DWD"
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

  extends TransiEnt.Components.Boundaries.Ambient.Base.PartialGlobalSolarRadiation;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                 Parameters
  // _____________________________________________

    parameter String fileName = Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Ambient/Koeln_3600s_TRY.txt") annotation(choices(choice=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Ambient/Temperature_Hamburg_3600s_TMY.txt")));

    parameter Boolean tableOnFile=true    "= true, if table is defined on file";

    parameter String tableName="tab1";

    parameter Integer columns[:]={4}    "Columns of table to be interpolated";

    parameter Modelica.Blocks.Types.Smoothness smoothness=simCenter.tableInterpolationSmoothness    "Smoothness of table interpolation";

    parameter Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints    "Extrapolation of data outside the definition range";

    final parameter String complete_relative_path = Modelica.Utilities.Files.fullPathName(fileName);

  // _____________________________________________
  //
  //                 Instances of other Classes
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

  Modelica.Blocks.Interfaces.RealOutput y1 annotation (Placement(transformation(
          extent={{100,-10},{120,10}}),
                                      iconTransformation(extent={{100,-10},{120,
            10}})));
equation

  connect(combiTimeTable.y[1], value) annotation (Line(points={{53.2,0},{88,0},{88,0}}, color={0,0,127}));
  connect(value, y1) annotation (Line(points={{88,0},{98,0},{98,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Table to read in diffuse horizontal irradiation data for a test reference year for Koeln.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Source: BBR, DWD 2017: <i>Ortsgenaue Testreferenzjahre f&uuml;r Deutschland f&uuml;r mittlere, extreme und zuk&uuml;nftige Witterungsverh&auml;ltnisse</i></p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), Nov 2019</p>
</html>"));
end GHI_Koeln_3600s_TRY;

