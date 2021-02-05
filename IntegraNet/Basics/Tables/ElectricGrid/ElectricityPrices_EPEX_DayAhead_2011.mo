within IntegraNet.Basics.Tables.ElectricGrid;
model ElectricityPrices_EPEX_DayAhead_2011
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

    extends IntegraNet.Basics.Tables.ElectricGrid.ElectricityPrices_Partial;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter String fileName=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/EnergyPrices/DayAhead_EPEX_Spot_2011.txt");

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    fileName=fileName,
    tableOnFile=true,
    tableName="default",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)    annotation (Placement(transformation(extent={{-18,-18},
            {18,18}})));

  Modelica.Blocks.Interfaces.RealOutput price  "Connector of Real output signals"  annotation (Placement(transformation(extent={{92,-8},{112,12}})));

equation

  connect(combiTimeTable.y[1], price)
    annotation (Line(points={{19.8,0},{102,0},{102,2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Table to read electricity price data from EPEX Spot 2011 .</p>
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
<p>EPEX Spot </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), June 2018</p>
</html>"));
end ElectricityPrices_EPEX_DayAhead_2011;

