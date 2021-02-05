within IntegraNet.Producer.Heat.Power2Heat.Components;
model HeatPump_L0_externalController "Simple heatpump model that calculates the heat output from the externally specified electric output"
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
// This component is a modification of model Producer.Heat.Power2Heat.StaticHeatPump //
// from TransiEnt Library, version: 1.0.0                                          //
//

//Changes to TransiEnt model
//- control removed from model, so that easier replaceable

 outer TransiEnt.SimCenter simCenter;
 outer TransiEnt.ModelStatistics modelStatistics;


   //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________

  //parameter Boolean use_T_source_input_K = false "False, use outer ambient conditions" annotation(Dialog(group="Heat pump parameters"));
  parameter Modelica.SIunits.TemperatureDifference Delta_T_internal = 5 "Temperature difference between refrigerant and source/sink temperature" annotation(Dialog(group="Heat pump parameters"));
  parameter Modelica.SIunits.TemperatureDifference Delta_T_db = 2 "Deadband of hysteresis control" annotation(Dialog(group="Heat pump parameters"));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_n = 3.5e3 "Nominal heat flow of heat pump at nominal conditions according to EN14511" annotation(Dialog(group="Heat pump parameters"));
  parameter Real COP_n = 3.7 "Coefficient of performance at nominal conditions according to EN14511" annotation(Dialog(group="Heat pump parameters"));

  final parameter Real eta_HP = COP_n/((273.15+40)/(40-2));
  final parameter Modelica.SIunits.Power P_el_n = Q_flow_n / COP_n;

  Modelica.SIunits.Temperature T_source=simCenter.ambientConditions.temperature.value+273.15 "Temperature of heat source" annotation(Dialog(group="Heat pump parameters"));

  replaceable model ProducerCosts =
      TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.Empty
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs annotation (Dialog(group="Statistics"), __Dymola_choicesAllMatching=true);

   //___________________________________________________________________________
   //
   //                      Variables
   //___________________________________________________________________________

  Real COP_Carnot=(T_set + Delta_T_internal)/max(2*Delta_T_internal, T_set + 2*Delta_T_internal - T_source);

   //___________________________________________________________________________
   //
   //                      Interfaces
   //___________________________________________________________________________

  TransiEnt.Basics.Interfaces.General.TemperatureIn T_set "Setpoint value, e.g. Storage setpoint temperature" annotation (Placement(transformation(extent={{-124,10},{-84,50}})));


  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_set_el "Setpoint value, e.g. Storage setpoint temperature" annotation (Placement(transformation(extent={{-124,-42},{-84,-2}}), iconTransformation(extent={{-124,-42},{-84,-2}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Heat_output    "Setpoint value, e.g. Storage setpoint temperature"  annotation (Placement(transformation(extent={{92,-20},{132,20}}),
        iconTransformation(extent={{92,-20},{132,20}})));


   // __________________________________________________________________________
   //
   //                   Complex Components
   // __________________________________________________________________________

public
  Modelica.Blocks.Math.Product Q_flow annotation (Placement(transformation(extent={{38,-10},{58,10}})));
  Modelica.Blocks.Sources.RealExpression COP(y=COP_Carnot*eta_HP) annotation (Placement(transformation(extent={{10,18},{30,38}})));

  //Statistics
   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Generic) annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
   TransiEnt.Components.Statistics.Collectors.LocalCollectors.HeatingPlantCost heatingPlantCost(
    calculateCost=true,
    consumes_H_flow=false,
    Q_flow_n=Q_flow_n,
    Q_flow_is=-Q_flow.y,
    produces_m_flow_CDE=false,
    m_flow_CDE_is=0)                                                                             annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________


 collectElectricPower.powerCollector.P=P_set_el;
 collectHeatingPower.heatFlowCollector.Q_flow=Q_flow.y;

  connect(COP.y,Q_flow. u1) annotation (Line(points={{31,28},{32,28},{32,6},{36,6}}, color={0,0,127}));

  connect(P_set_el, Q_flow.u2) annotation (Line(points={{-104,-22},{36,-22},{36,-6}}, color={0,127,127}));
  connect(Q_flow.y, Heat_output)
    annotation (Line(points={{59,0},{86,0},{112,0}},
                                              color={0,0,127}));
  connect(Heat_output, Heat_output) annotation (Line(
      points={{112,0},{98,0},{112,0}},
      color={162,29,33},
      pattern=LinePattern.Dash));

  connect(modelStatistics.powerCollector[collectElectricPower.typeOfResource],collectElectricPower.powerCollector);
  connect(modelStatistics.heatFlowCollector[collectHeatingPower.typeOfResource],collectHeatingPower.heatFlowCollector);
  connect(modelStatistics.costsCollector, heatingPlantCost.costsCollector);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Rectangle(
          extent={{-38,40},{42,-48}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,8},{-44,8},{-30,8},{-38,-4},{-30,-14},{-48,-14},{-38,-4},{-48,8}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,48},{20,32}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,-40},{22,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,10},{56,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{34,-10},{42,10},{52,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-20,22},{-20,-24},{28,-24}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-20,-22},{-16,-14},{-4,4},{-2,6},{6,12},{16,16},{24,16}},
          color={0,0,255},
          smooth=Smooth.None)}),                                 Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Simple heat pump with power input specified externally</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Efficiency calculation based on Carnot efficiency. </p>
<p>Relative difference to Carnot efficiency at reference point kept at all operating points </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>&nbsp;&nbsp; TransiEnt.Basics.Interfaces.Thermal.TemperatureIn_K T_set</p>
<p>&nbsp;&nbsp; TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_set_el</p>
<p>&nbsp;&nbsp; TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Heat_output</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>COP_Carnot=(T_set+Delta_T_internal)/max(2*Delta_T_internal, T_set + 2*Delta_T_internal - T_source)</p>
<p>COP=COP_Carnot*eta_HP</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Energy based modeling without consideration of fluid flow. </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>not validated yet</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model from TransiEnt 1.1.0 modified by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), Jan 2019</p>
</html>"));
end HeatPump_L0_externalController;

