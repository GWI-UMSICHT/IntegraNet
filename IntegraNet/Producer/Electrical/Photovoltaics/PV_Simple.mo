within IntegraNet.Producer.Electrical.Photovoltaics;
model PV_Simple "Simple model of a PV module, inclined radiation as input and not calculated in model"
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


 //
 // Generated power P is calculated by
 // P = Radiation on an inclined surface from table PV_Radiation  * efficiency of the PV system eta * surface of PV module A_module

 // _____________________________________________
 //
 //          Imports and Class Hierarchy
 // _____________________________________________

  import IntegraNet;
  import TransiEnt;
  extends TransiEnt.Basics.Icons.SolarElectricalModel;


  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.ModelStatistics modelStatistics;
  outer IntegraNet.Statistics.Statistics_collector statistics_collector;
  outer IntegraNet.SimCenter simCenter;


 // _____________________________________________
 //
 //                   Parameters
 // _____________________________________________

  parameter SI.Area A_module=37 "PV module surface";
  parameter SI.Efficiency eta=0.135 "Total efficiency of the whole PV system from radiation to power output (taking into account losses in DC cables and the inverter)";
  parameter String radiationData=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Ambient/Radiation_PVModule_TRY-Koeln_Az=0_Tilt=35.txt") annotation(choices(
    choice=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Ambient/Radiation_PVModule_TRY-Koeln_Az=0_Tilt=35.txt")));

  replaceable model ProducerCosts =
       TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PV
      constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PV
                                                 annotation (Dialog(group="Statistics"),
       __Dymola_choicesAllMatching=true);

 // _____________________________________________
 //
 //                Instances of other classes
 // _____________________________________________

 // Table containing the radiation data on a inclined PV surface
 // Table data is created by using the Calculate_InclinedPV_Radiation module, which is based on radiation_InclinedSurface model from the TransiEnt library

  IntegraNet.Producer.Electrical.Photovoltaics.PV_Radiation PV_Radiation(fileName=radiationData)  annotation (Placement(transformation(extent={{-56,-10},{-34,12}})));

 // Total efficiency and PV surface
  Modelica.Blocks.Math.Gain Conversion(k=-A_module*eta)  annotation (Placement(transformation(extent={{-8,-6},{8,10}})));

 // Power output into one phase of the grid
 // Power is fed into the grid through Electric_Consumer model by change of sign
 // By setting a cosphi and a respective sign reactive power is fed into or drawn from the grid
  IntegraNet.Components.Boundaries.Electrical.ApparentPower.Electric_Consumer
    ApparentPower_PV(
    useInputConnectorP=true,
    cosphi_boundary=0.95,
    useCosPhi=true)
    annotation (Placement(transformation(extent={{64,-10},{44,10}})));

    //Statistics
    TransiEnt.Components.Statistics.Collectors.LocalCollectors.PowerPlantCost collectCosts_PowerProducer(
    P_el_is=-epp.P,
    P_n=A_module*eta*1000,
    redeclare model PowerPlantCostModel = ProducerCosts,
    produces_Q_flow=false,
    consumes_H_flow=false)                               annotation (Placement(transformation(extent={{26,-100},{46,-80}})));

   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Renewable, is_setter=true)
                                                                                                                                                     annotation (Placement(transformation(extent={{66,-100},{86,-80}})));
   Statistics.LocalCollector PV_collector(typeOfResource=IntegraNet.Statistics.TypeOfResource.el_output_Photovoltaic) "Collects power supplied by PV" annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

 // _____________________________________________
 //
 //                   Interfaces
 // _____________________________________________

 // Electric connector to grid
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp annotation (Placement(transformation(extent={{90,-10},{110,10}})));


equation

    //Statistics
  PV_collector.flowCollector.unit_flow = epp.P;
  collectElectricPower.powerCollector.P=epp.P;

 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________

  connect(PV_Radiation.y[1], Conversion.u)
    annotation (Line(points={{-34.44,0.56},{-22.22,0.56},{-22.22,2},{-9.6,2}}, color={0,0,127}));
  connect(ApparentPower_PV.epp, epp) annotation (Line(
      points={{64.1,-0.1},{80.05,-0.1},{80.05,0},{100,0}},
      color={0,127,0},
      thickness=0.5));
  connect(Conversion.y, ApparentPower_PV.P_el_set)
    annotation (Line(points={{8.8,2},{36,2},{36,20},{60,20},{60,12}},        color={0,0,127}));

  connect(PV_collector.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.el_output_Photovoltaic]);

  connect(modelStatistics.powerCollector[TransiEnt.Basics.Types.TypeOfResource.Renewable],collectElectricPower.powerCollector);
  connect(modelStatistics.costsCollector,  collectCosts_PowerProducer.costsCollector);


  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-152,-109},{148,-149}},
          lineColor={0,134,134},
          textString="%PV_Simple")}), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Line(
          points={{-88,0},{-54,0}},
          color={95,95,95},
          smooth=Smooth.None,
          pattern=LinePattern.Dash,
          thickness=0.5)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Very simple PV model with constant efficiency and input of radiation data on the tilted PV surface</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">none.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">See parameter and variable descriptions in the code.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><br><img src=\"modelica://IntegraNet/Resources/Images/equations/equation-YdLr7eYY.png\" alt=\"P = A_module * eta\"/></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>Instead of the reading in radiation data from a weather data file, the radiation on the tilted surface of the module needs to be calculated beforehand and input into the model via a CombiTimeTable.</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">none</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><br><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: Courier New;\">Model created in project IntegraNet I, Gas- und W&auml;rme-Institut Essen e.V.</span></p>
</html>"));
end PV_Simple;

