within IntegraNet.Producer.Heat.Power2Heat;
model ElectricBoiler_noFluidPorts "Electric Boiler with constant efficiency, spatial resolution can be chosen to be 0d or 1d"
  import TransiEnt;

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

// ++++++++                                                                        //
// This component is a modification of model ElectricBoiler from TransiEnt         //
// Library, version: 1.1.0                                                         //
//

//Changes to TransiEnt model:
// removal of fluid ports

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer IntegraNet.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Power P_el_n = 10e3 "Nominal electric power";
  parameter Modelica.SIunits.Efficiency eta=0.95;
  replaceable model ProducerCosts =
      TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.P2H
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs                                                                                       annotation (Dialog(group="Statistics"), __Dymola_choicesAllMatching=true);


  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort
                                                         epp annotation (Placement(transformation(extent={{-10,88},{10,108}}), iconTransformation(extent={{-10,-110},{10,-90}})));
  Modelica.Blocks.Interfaces.RealInput P_set "Setpoint for thermal heat, should be negative" annotation (Placement(transformation(extent={{-116,-12},{-92,12}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,100})));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower
                                                   powerBoundary(useInputConnectorQ=false, useCosPhi=false)
                                                                 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-18,30})));
  Modelica.Blocks.Math.Gain efficiency(k=eta)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

   TransiEnt.Components.Statistics.Collectors.LocalCollectors.HeatingPlantCost collectCosts_HeatProducer(
     redeclare model HeatingPlantCostModel = ProducerCosts,
     Q_flow_fuel_is=0,
     m_flow_CDE_is=0,
     Q_flow_n=P_el_n*eta,
     Q_flow_is=Heat_output,
     consumes_H_flow=false,
     produces_m_flow_CDE=false)
                          annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));


  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer);

public
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Heat_output    "Setpoint value, e.g. Storage setpoint temperature"
    annotation (Placement(transformation(extent={{100,-16},{132,16}}),
        iconTransformation(extent={{92,-24},{132,16}})));
equation

   collectElectricPower.powerCollector.P=epp.P;
   collectHeatingPower.heatFlowCollector.Q_flow = -Heat_output;

  // _____________________________________________
  //
  //                Connect Equations
  // _____________________________________________

   connect(modelStatistics.powerCollector[collectElectricPower.typeOfResource],collectElectricPower.powerCollector);
   connect(modelStatistics.heatFlowCollector[collectHeatingPower.typeOfResource],collectHeatingPower.heatFlowCollector);
   connect(modelStatistics.costsCollector, collectCosts_HeatProducer.costsCollector);

  connect(powerBoundary.epp, epp) annotation (Line(
      points={{-8,30},{0,30},{0,98}},
      color={0,0,0}));
  connect(P_set, efficiency.u) annotation (Line(points={{-104,0},{-42,0},{18,0}},     color={0,0,127}));
  connect(efficiency.y, Heat_output) annotation (Line(points={{41,0},{116,0}},                         color={0,0,127}));
  connect(P_set, powerBoundary.P_el_set) annotation (Line(points={{-104,0},{-78,0},{-78,24},{-78,60},{-12,60},{-12,42}}, color={0,0,127}));
                                                                                                                                      annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})),
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(
          extent={{-42,-50},{40,-92}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-42,52},{40,-74}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Ellipse(
          extent={{-42,74},{40,32}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Line(
          points={{0,-48},{0,-102}},
          color={0,134,134},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{0,0},{20,-8},{-18,-22},{18,-36},{0,-40},{0,-50}},
          thickness=0.5,
          smooth=Smooth.None,
          color={0,134,134})}),   Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of an electrode boiler using TransiEnt interfaces and TransiEnt.Statistics. Heat transfer is ideal, thermal losses are modeled using a constant efficiency.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarsk for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end ElectricBoiler_noFluidPorts;

