within IntegraNet;
model SimCenter "SimCenter for global parameters, ambient conditions and collecting statistics"

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
// This component is a modification of Model SimCenter from the TransiEnt Library, //
// version: 1.0.0                                                                  //
//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends IntegraNet.SimCenter_TransiEnt(tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1);
  extends TransiEnt.Basics.Icons.Grids;

  // _____________________________________________
  //
  //                   Components
  // _____________________________________________

  inner replaceable TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions
    constrainedby TransiEnt.Components.Boundaries.Ambient.AmbientConditions  "Click book icon to edit" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{-8,-8},{12,12}})),
    Dialog(tab="Ambience", group="Varying ambient conditions"));

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  //Location parameters

  parameter Real lambda=10 "degree of longitude of location" annotation(Dialog(tab="Ambience", group="Location parameters"));
  parameter Real phi=53.63 "degree of latitude of location" annotation(Dialog(tab="Ambience", group="Location parameters"));
  parameter Real timezone=1 "timezone of location (UTC+) - for Hamburg timezone=1" annotation(Dialog(tab="Ambience", group="Location parameters"));

  // ===== General ====

  parameter Boolean isExpertmode = true "False, show only basic parameters and variables" annotation (choices(__Dymola_checkBox=true));
  parameter Real k_H2_fraction=0.10 "Fuel fraction of hydrogen mixed with natural gas in gas turbine (Q_flow_H2/Q_flow_methane)";
  parameter Boolean isLeapYear = false "true if the observed year is a leap year" annotation (choices(__Dymola_checkBox=true));
  final parameter Modelica.SIunits.Time lengthOfAYear = if isLeapYear then 31622400 else 31536000 "Length of one year";
  parameter Modelica.SIunits.Pressure p_amb_const=1.013e5 "Ambient pressure" annotation (Dialog(tab="Ambience", group="Ambience parameters")); //Hamburg average 2012 (DWD, monthly average data, 11m)
  parameter Modelica.SIunits.Temperature T_amb_const=282.48 "Ambient temperature" annotation (Dialog(tab="Ambience", group="Ambience parameters")); //Hamburg average 2012 (DWD, monthly average data, 11m)
  parameter SI.Temperature T_ground = 282.48 "|Ambience|Ambience parameters|Ground temperature"; //same as T_amb_const in average
  parameter Boolean variable_T_ground = false "Use variable Temperature profile?"
                                                                                 annotation (choicesAllMatching=true,Dialog(tab="Ambience",tab="Ambience parameters"));

  replaceable model Ground_Temperature =
     IntegraNet.Basics.Tables.Ambient.Temperature_Luedinghousen_3600s_TMY  constrainedby TransiEnt.Components.Boundaries.Ambient.Base.PartialTemperature
                                               "Profile for the ground Temperature" annotation (choicesAllMatching=true,Dialog(tab="Ambience",tab="Ambience parameters"));
  Ground_Temperature Variable_Ground_Temperature;


  // ==== Media ===

  parameter SI.SpecificEnthalpy HeatingValue_Oil=43e6 "Heating value for heating oil"  annotation (Dialog(tab="Media and Materials", group="Other fuel types"),
   choices( choice=43e6 "Upper heating value of heating oil",
            choice=42.8e6 "Lower heating valie of heating oil",
            choice=41.8e6 "Upper heating valie of heavy oil",
            choice=39e6 "Lower heating valie of heavy oil"));

  parameter Modelica.SIunits.SpecificEnthalpy HeatingValue_Wood=17.03e6 "Heating value for wood pellets" annotation (Dialog(tab="Media and Materials", group="Other fuel types"),
  choices( choice=9.42e6 "Heating value of wood with a moisture content of 45%",
           choice=17.03e6 "Heating value of wood pellets with a moisture content of 10%"));

  parameter Boolean referenceNCV=false "true, if heat calculations shall be in respect to NCV, false will give GCV" annotation (Dialog(tab="Media and Materials", group="Fundamental definitions"));

  // ==== Gas grid ===
  parameter SI.Length K_gas = 0.0001 "Roughness (average height of surface asperities)";


  // ==== Electric grid ====

  parameter SI.Voltage upper_range_vd = 242 "Upper Voltage boundary for which a voltage deviation is registered"
                                                                                                                annotation(Dialog(tab="Electric Grid", group="Optional"));
  parameter SI.Voltage lower_range_vd = 219 "Lower Voltage boundary for which a voltage deviation is registered"
                                                                                                                annotation(Dialog(tab="Electric Grid", group="Optional"));


  parameter Real cosphi=1 "Reactive power factor"  annotation(Dialog(tab="Electric Grid", group="Optional"));

  //Electricity selling prices time series in EUR/kWh
  replaceable IntegraNet.Basics.Tables.ElectricGrid.ElectricityPrices_EPEX_DayAhead_2011 electricityPrice constrainedby IntegraNet.Basics.Tables.ElectricGrid.ElectricityPrices_Partial "Electricity market prices in EUR per kWh" annotation (Dialog(tab="PricesAndSubsidies"), choicesAllMatching);


  // ==== District heating grid ====
  parameter Integer activate_consumer_pipes= 0 "Activate / Deactivate house pipes for faster simulation. 1 = house pipes activated" annotation (Dialog(tab="District Heating Grid", group="Simulation"));
  parameter Boolean activate_volumes= false "Activate / Deactivate volumes to better represent delayed temperatrue changes due to heat capacity effects" annotation (Dialog(tab="District Heating Grid", group="Simulation"));
  parameter Boolean calc_initial_dstrb = true "Activates the calculation of a initial temperature distribution inside the pipes" annotation (Dialog(tab="District Heating Grid", group="Simulation"));

  parameter SI.Temperature T_supply= 90 + 273.15 "Temperature of the fluid at start in supply"
                                                                                              annotation (Dialog(tab="District Heating Grid", group="Initialisation"));
  parameter SI.Temperature T_return= 50 + 273.15 "Temperature of the fluid at start in return"
                                                                                              annotation (Dialog(tab="District Heating Grid", group="Initialisation"));
  parameter Real dT = 20 "Target temperature difference"
                                                        annotation (Dialog(tab="District Heating Grid", group="Operation"));
  parameter SI.MassFlowRate m_flow_min = 0.0001 "Minimum mass flow rate in substation"
                                                                                      annotation (Dialog(tab="District Heating Grid", group="Operation"));
  parameter SI.Velocity v_nom = 1 "Design Velocity of the pipes used."
                                                                      annotation (Dialog(tab="District Heating Grid", group="Operation"));
  parameter SI.ThermalConductivity lambda_ground = 1.2 "Heat-Transfer Coefficient of the ground surrounding the pipes" annotation (Dialog(tab="District Heating Grid", group="Pipe Data"));
  parameter SI.Length K = 0.000045 "average height of surface asperities" annotation (Dialog(tab="District Heating Grid", group="Pipe Data"));
  parameter SI.SpecificHeatCapacity pipe_wall_capacity = 450 "HeatCapacity of the pipe wall material" annotation (Dialog(tab="District Heating Grid", group="Pipe Data"));
  parameter SI.Density pipe_wall_d = 7850 "Density of the pipe wall material" annotation (Dialog(tab="District Heating Grid", group="Pipe Data"));

 replaceable model DHN_Pipe_Manufacturer = IntegraNet.GridConstructor.DataRecords.DHN_Pipes.DN_IsoPlus
    constrainedby IntegraNet.GridConstructor.DataRecords.DHN_Pipes.DN_table_base  "Type of DN-Data to be used" annotation(choicesAllMatching=true,Dialog(tab="District Heating Grid", group="Pipe Data"));
 final parameter Real DNmat[:,:] = DHN_Pipe_Manufacturer.DNmat;

  Modelica.Blocks.Interfaces.RealOutput T_ground_var(value=if variable_T_ground then Variable_Ground_Temperature.value else T_ground)  "Diffuse solar radiation (from component ambientConditions)";


   annotation ( defaultComponentName="simCenter",
    defaultComponentPrefixes="inner",
    missingInnerMessage=
        "Your model is using an outer \"simCenter\" but it does not contain an inner \"simCenter\" component. Drag model TransiEnt.SimCenter into your model to make it work.", Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Global parameters for all models depending TransiEnt core library and Clara library.</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>(no equations)</p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no validation or testing necessary)</p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
<p>Model created by Lisa Andresen (andresen@tuhh.de) on Mon Aug 18 2014</p>
<p>Modified by Philipp Huismann, 2019</p>
</html>"));
end SimCenter;
