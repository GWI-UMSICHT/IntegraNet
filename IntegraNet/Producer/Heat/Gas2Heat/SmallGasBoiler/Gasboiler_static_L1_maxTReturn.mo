﻿within IntegraNet.Producer.Heat.Gas2Heat.SmallGasBoiler;
model Gasboiler_static_L1_maxTReturn "Fully modulating gasboiler, static model with splitted ideal combustion and ideal heat-transfer"
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
// This component is a modification of model Gasboiler_static_L1_maxTReturn        //
// from TransiEnt Library, version: 1.0.0                                          //
//

// Changes to TransiEnt model:
// Addition of boiler switch-off due to high return temperatures

// _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends IntegraNet.Producer.Heat.Gas2Heat.SmallGasBoiler.Base.PartialGasboiler_maxTReturn;

  // _____________________________________________
  //
  //         Instances of other Classes
  // _____________________________________________
protected
  ClaRa.Components.BoundaryConditions.PrescribedHeatFlowScalar prescribedHeatFlow annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-36})));
  TransiEnt.Components.Heat.HEX_ideal hex(Delta_p=Delta_p_nom) annotation (Placement(transformation(extent={{-10,-78},{10,-58}})));

equation
  // _____________________________________________
  //
  //            Characteristic equations
  // _____________________________________________
  if holdTemperature then
    Q_flow_set_internal = waterPortIn.m_flow * cp_water * (T_supply_set_internal - temperatureWaterIn.T);
  end if;

  // _____________________________________________
  //
  //            Connect statements
  // _____________________________________________

  connect(prescribedHeatFlow.port, hex.heatport) annotation (Line(
      points={{0,-46},{0,-58.2}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(limiter.y, prescribedHeatFlow.Q_flow) annotation (Line(
      points={{12.6,88},{1.77636e-015,88},{1.77636e-015,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(waterPortIn, hex.waterPortIn) annotation (Line(
      points={{-40,-120},{-40,-120},{-40,-70},{-40,-68},{-10,-68}},
      color={175,0,0},
      thickness=0.5));
  connect(hex.waterPortOut, waterPortOut) annotation (Line(
      points={{10,-68},{22,-68},{40,-68},{40,-120}},
      color={175,0,0},
      thickness=0.5));
  annotation (defaultComponentName="gasBoiler",
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Simple static, full modulating gas boiler model with splitted heat generation, emission (CO2) calculation and switch-off due to high return temperatures</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>By default, a given heat duty <i>Q</i><sub>flow,set</sub> is set (limited) to the boilers characteristica (<i>Q</i><sub>flow,n</sub>, <i>Q</i><sub>flow,min</sub>) and then set to a static ideal heat exchanger. For the given heat carrier supply temperature the required heat carrier mass flow is calulated. For the operational mode the supply temperature can also be left variable.</p>
<p>In HoldTemperature-mode the boiler needs no heat flow set-input and will heat the carrier to the given temperature within its limits of power.</p>
<p>From the part load of the boiler and the return flow temperature, the boiler efficiency and fuel heat input is calculated with characteristical lines.</p>
<p><br><img src=\"modelica://TransiEnt/Images/BoilerCharLinePartLoad.png\"/> <img src=\"modelica://TransiEnt/Images/BoilerCharLineReturnTemp.png\"/></p>
<p>Depending on the users preference (set by the parameter <i>referenceNCV</i>), efficiencies and power calculations in this model are based on either the net or the gross calorific value (NCV or GCV, respectively). With a function for dynamic HV calculation the required fuel mass flow as an output-value is generated.</p>
<h4><span style=\"color: #008000\">3. Limits of validity</span></h4>
<p>A constant air ratio to be chosen is asumed.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Q_flow_set_internal - heat duty input (only in default mode) </p>
<p>T_supply_set_internal - temperature input in K</p>
<p>gasPortIn/Out - port for fuelgas at the inlet and exhaustgas at the outlet </p>
<p>waterPortIn/Out - ports for the heat carrier (water) </p>
<p>m_flow_fuel_req - output of required fuel mass flow rate </p>
<p>m_flow_HC - output of heat carrier mass flow rate </p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b> </p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b> </p>
<p>(no remarks) </p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>(no elements) </p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b> </p>
<p>(no validation or testing necessary) </p>
<p><b><span style=\"color: #008000;\">9. References</span></b> </p>
<p>(no remarks) </p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b> </p>
<p>Model created by Paul Kernstock (paul.kernstock@tu-harburg.de) July 2015 </p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Aug 2015</p>
<p>Modification by Anne Hagemeier, Fraunhofer UMSICHT, 2017</p>
</html>"),         Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}})));
end Gasboiler_static_L1_maxTReturn;

