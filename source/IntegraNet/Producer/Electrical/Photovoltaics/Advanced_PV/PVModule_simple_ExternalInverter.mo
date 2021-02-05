within IntegraNet.Producer.Electrical.Photovoltaics.Advanced_PV;
model PVModule_simple_ExternalInverter "Simple PV model with inclined radiation as input instead of angle calculations"
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
// This component is a modification of model Advanced_PV.DNIDHI_Input.PVModule     //
// from TransiEnt Library, version: 1.3.0                                          //
//

  //Modified model from TransiEnt library: equations for the inverter were removed from the model
  //Problem: calculation of costs and emissions. Calculation based on output power from the inverter in TransiEnt library

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.SolarElectricalModel;
  import Modelica.SIunits.Conversions.*;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer IntegraNet.Statistics.Statistics_collector statistics_collector;
  outer TransiEnt.ModelStatistics modelStatistics;
  outer IntegraNet.SimCenter simCenter;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Power P_inst=200 "Combined installed power";
  parameter Modelica.SIunits.Power Pmpp=200 "Peak power of one module";
  parameter Modelica.SIunits.Area Area=1.18 "Area of one complete module";

  parameter Real Strings=1 "Choose amount of strings";

  parameter Real GroundCoverageRatio=0.3 "Ratio of covered ground of modules to area of modules";
  parameter Real LossesDC=4.44 "Losses in % through connections, wiring, tracking error and mismatches";

  parameter Real Soiling=5 "Average annual losses of radiation in % due to soiling";
  parameter Real Albedo=0.25 "Value for albedo - e.g. 0.25 is a common value for green grass";

  replaceable model ProducerCosts =
       TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PV
      constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PV
                                                 annotation (Dialog(group="Statistics"),
       __Dymola_choicesAllMatching=true);

public
  parameter TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.Generic_Characteristics_PVModule PVModuleCharacteristics=TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.PVModule_Characteristics_Sanyo_HIT_200_BA3()
                                                                                                                                                                                                      "Characteristics of PV Module" annotation (choicesAllMatching);
  parameter Real lambda=10 "degree of longitude of location" annotation(Dialog(tab="Tracking and Mounting", group="Location parameters"));
  parameter Real phi=53.63 "degree of latitude of location" annotation(Dialog(tab="Tracking and Mounting",group="Location parameters"));
  parameter Real timezone=1 "timezone of location (UTC+) - for Hamburg timezone=1" annotation(Dialog(tab="Tracking and Mounting",group="Location parameters"));
  parameter String Tracking="No Tracking" "choose if sun position is tracked by tracking device" annotation(Dialog(tab="Tracking and Mounting",group="Tracking"),choices(choice="No Tracking",choice="Biaxial Tracking"));
  parameter Real Tilt=0 "inclination of surface" annotation(Dialog(tab="Tracking and Mounting",group="parameters for fixed mounting"));
  parameter Real Azimuth=0 "gyration of surface; Orientation: +90=West, -90=East, 0=South" annotation(Dialog(tab="Tracking and Mounting",group="parameters for fixed mounting"));
  parameter String IncidenceAngleModification="yes" "choose if decrease of irradiance due to reflexion depending of the angle of incidence is calculated"
                                                                                                    annotation(Dialog(tab="Tracking and Mounting"),choices(choice="Yes",choice="No"));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  //variables dependend on irradiation and temperature:
  Modelica.SIunits.Power POA_Irradiation(min=0) "plane of array irradiation usable for PV generation";
  Modelica.SIunits.Temperature T_module "module temperature";
  Modelica.SIunits.Temperature T_cell "cell temperature";

  //output variables:
  Modelica.SIunits.Power P_DC "DC input power for inverter";
  Modelica.SIunits.Energy E_dc(stateSelect=StateSelect.prefer)     "accumulated DC energy";
  Modelica.SIunits.Energy E(stateSelect=StateSelect.prefer)    "accumulated AC energy";

  //statistics
   Modelica.SIunits.Time FLH(displayUnit="h") "Full load hours";

  //other
  Modelica.SIunits.Area Area_demand;
  Real ModulesPerString "Choose amount of modules per string";

  Modelica.SIunits.Power aux_losses "Losses through connections, wiring, tracking error and mismatches";

  //input variables:
  Modelica.Blocks.Interfaces.RealInput T_in "ambient temperature in Celcius" annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-80,120}), iconTransformation(extent={{-140,60},{-100,100}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput WindSpeed_in "wind speed in m/s" annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=270,
        origin={-80,-120}), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,-80})));

  // _____________________________________________
  //
  //                    Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp "power output" annotation (Placement(transformation(extent={{88,-8},{108,12}}), iconTransformation(extent={{78,-16},{112,16}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.PowerPlantCost collectCosts_PowerProducer(
    P_el_is=P_DC,
    P_n=Pmpp,
    redeclare model PowerPlantCostModel = ProducerCosts) annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

public
    Modelica.Blocks.Interfaces.RealInput radiation_in "Radiation on module in W/m^2" annotation (Placement(transformation(extent={
            {-126,-20},{-86,20}}), iconTransformation(extent={{-126,-20},{-86,20}})));


  // _____________________________________________
  //
  //                    Components
  // _____________________________________________

  Modelica.Blocks.Tables.CombiTable1Ds PowerCurve_PV_Irradiation(
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    table=PVModuleCharacteristics.MPP_dependency_on_irradiation_fixedTemperature,
    columns={2,2})
                  "Dependency of MPP on irradiation with fixed temperature" annotation (Placement(transformation(extent={{-10,66},{10,86}})));
  Modelica.Blocks.Tables.CombiTable1Ds PowerCurve_PV_Temp(
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    table=PVModuleCharacteristics.MPP_dependency_on_Temp_fixedIrradiation,
    columns={2,2})
                  "Dependency of MPP on temperature with fixed irradiation" annotation (Placement(transformation(extent={{-10,36},{10,56}})));

  Statistics.LocalCollector PV_collector(typeOfResource=IntegraNet.Statistics.TypeOfResource.el_output_Photovoltaic) "Collects power supplied by PV" annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Statistics.LocalCollector PV_losses(typeOfResource=IntegraNet.Statistics.TypeOfResource.el_output_Photovoltaic) "Collects power supplied by PV" annotation (Placement(transformation(extent={{40,80},{60,100}})));

   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Renewable,
                                                                                                                                       is_setter=true)
                                                                                                                                                     annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  //Input irradiation
  POA_Irradiation=radiation_in;

  //calculation of module temperature
  T_module = 273.15 + T_in + POA_Irradiation * (exp(-3.47 - 0.0594 * WindSpeed_in)); //https://pvpmc.sandia.gov/modeling-steps/2-dc-module-iv/module-temperature/sandia-module-temperature-model/

  //calculation of cell temperature
  T_cell = T_module; //simplification

  //output power and Energy
  PowerCurve_PV_Irradiation.u=POA_Irradiation;
  PowerCurve_PV_Temp.u=Modelica.SIunits.Conversions.to_degC(T_cell);

  if (PowerCurve_PV_Irradiation.y[1] *  PowerCurve_PV_Temp.y[1] / Pmpp) > 0 then
    P_DC =             PowerCurve_PV_Irradiation.y[1] *  PowerCurve_PV_Temp.y[1] / Pmpp * (100 - LossesDC) / 100 * P_inst / Pmpp;
    aux_losses =P_DC - PowerCurve_PV_Irradiation.y[1] *  PowerCurve_PV_Temp.y[1] / Pmpp * (100 - 0)        / 100 * P_inst / Pmpp;
  else
    P_DC = 0;
    aux_losses = 0;
    end if;

  der(E_dc)=P_DC;
  der(E)=P_DC;

  //full load hours
  if ( time>0) then
    FLH=E/(P_inst);
  else
    FLH=0;
  end if;

  //area demand
  Area_demand=GroundCoverageRatio*Area*Strings*ModulesPerString;

  //Arrangement of modules
  ModulesPerString=P_inst/(Pmpp*Strings);

  //Connection to output
  epp.P=-P_DC;


  //Statistics
  collectElectricPower.powerCollector.P=epp.P;



  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  // Model statistics:
  PV_collector.flowCollector.unit_flow = -epp.P;
  connect(PV_collector.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.el_output_Photovoltaic]);

  PV_losses.flowCollector.unit_flow = aux_losses;
  connect(PV_losses.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.el_Losses_Photovoltaic_aux]);

  connect(modelStatistics.costsCollector, collectCosts_PowerProducer.costsCollector);
  connect(modelStatistics.powerCollector[TransiEnt.Basics.Types.TypeOfResource.Renewable],collectElectricPower.powerCollector);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The purpose of this model is to calculate the power of a photovoltaic (PV) module or several modules from precalculated radiation on the tilted surface.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model is based on empiric equations and PV manufacturers data. Optical losses are being consideres due to loss factors for soiling and refraction and reflexion (contained in the incidence angle modification). Degradation of the modules and inverter consumption is not included in the model. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model has been validated with System Advisor Model simulation results [1] for fixed PV arrays without shading influences. The results are best with Tilt angle of ~30&deg;.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model has not been entirely validated for sun tracking. Disabling Incidence Angle Modifications seems to improve results with tracking enabled.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Input: </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">radiation_in</span></b> for total irradiation on the tilted surface </p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">T_in</span></b> for ambient temperature</p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">WindSpeed_in</span></b> for wind speed</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Output: </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">epp</span></b> for dc connection, e.g. to an inverter</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">See parameter and variable descriptions in the code.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6.1. Plane of Array (POA) Irradiation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The POA irradiation is being calculated in IrradianceOnATiltedSurface model.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6.2. Module Temperature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The module temperature <b>T_module </b>is estimated following [2]:</span></p>
<p><span style=\"font-family: Courier New;\">T_module = 273.15 + T_in + POA_Irradiation * (<span style=\"color: #ff0000;\">exp</span>(-3.47 - 0.0594 * WindSpeed_in))</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6.3. Direct Current Power output P_dc</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">P_dc</span></b> is calculated by:</p>
<p>P_dc = <span style=\"font-family: Courier New;\">PowerCurve_PV_Irradiation.y[1] * PowerCurve_PV_Temp.y[1] / Pmpp * (100 - LossesDC) / 100 * P_inst / Pmpp</span></p>
<p><b><span style=\"font-family: Courier New;\">PowerCurve_PV_Irradiation.y[1]</span></b> is the Maximum Power Point (MPP) power at the current Irradiation at reference temperature of the simulated module. <b>PowerCurve_PV_Temp.y[1]</b> is the MPP power at the current temperature at reference irradiation of the simulated module. <b>Pmpp</b> is the MPP power at reference conditions of the simulated module. <b>LossesDC</b> are the losses in &percnt; through Connections, Wiring, Tracking Error and Mismatches. <b>P_inst</b> is the cumulated installed power.</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>This model is a modification from the model TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.DNIDHI_Input.PVModule. Compared to the original model, the inverter efficiency as well as the calculation of the ac power have been removed. Therefore the output of the model is dc power. This way, the model can be combined with an external inverter and allows for the connection of the battery on the dc side.</p>
<p>The modification means that for model statistics, dc power is used instead of ac power, leading to a slight overestimation of produced PV power because not all losses are included.</p>
<p>Instead of the reading in radiation data from a weather data file, the radiation on the tilted surface of the module needs to be calculated beforehand and input into the model. This approach leads to lower calculation times, especially in larger models.</p>
<p><br><br><span style=\"font-family: MS Shell Dlg 2;\">For the calculation of the output power, manufacturer datasheets are to be digitalized, e.g. with http://arohatgi.info/WebPlotDigitizer/. This is an example for a Sanyo HIT 200BA module [2]. Digitalize the following figures: </span></p>
<p><img src=\"modelica://TransiEnt/Images/Sanyo_HIT_200BA20_20C.jpg\"/>[2]</p>
<p><img src=\"modelica://TransiEnt/Images/Sanyo_HIT_200BA20_1000W.jpg\"/>[2]</p>
<p>After digitalization, calculate the MPP power of each curve and write those to a record as shown in TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics. For the above shown curves the record is:</p>
<p><span style=\"font-family: Courier New; color: #0000ff;\">record</span> PVModule_Characteristics_Sanyo_HIT_200_BA3</p>
<p><span style=\"font-family: Courier New; color: #0000ff;\">extends </span></span><span style=\"color: #ff0000;\">Generic_Characteristics_PVModule(</p>
<p><span style=\"font-family: Courier New;\">MPP_dependency_on_Temp_fixedIrradiation=[</span></p>
<p><span style=\"font-family: Courier New;\">0,214.3545548;</span></p>
<p><span style=\"font-family: Courier New;\">25,200.8472531;</span></p>
<p><span style=\"font-family: Courier New;\">50,187.3094253;</span></p>
<p><span style=\"font-family: Courier New;\">75,173.1095017],</span></p>
<p><span style=\"font-family: Courier New;\">MPP_dependency_on_irradiation_fixedTemperature=[</span></p>
<p><span style=\"font-family: Courier New;\">0,0;</span></p>
<p><span style=\"font-family: Courier New;\">200,37.69290789;</span></p>
<p><span style=\"font-family: Courier New;\">400,77.36493756;</span></p>
<p><span style=\"font-family: Courier New;\">600,117.7097234;</span></p>
<p><span style=\"font-family: Courier New;\">800,159.0501238;</span></p>
<p><span style=\"font-family: Courier New;\">1000,201.294124]);</span></p>
<p><span style=\"font-family: Courier New; color: #0000ff;\">annotation </span>(Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));</p>
<p><span style=\"font-family: Courier New; color: #0000ff;\">end </span>PVModule_Characteristics_Sanyo_HIT_200_BA3;</p>
<p><span style=\"font-family: Courier New;\">Hereby the firste table (MPP_dependency_on_Temp_fixedIrradiation) gives the MPP power (second column) for fixed irradiation and different temperatures (first column) and the second table (MPP_dependency_on_irradiation_fixedTemperature) gives the MPP power (second column) for fixed temperature and different irradiation (first column).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model has been validated with System Advisor Model simulation results [1] for bigger fixed PV arrays without shading influences.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">IWEC or TMY data was used in Hamburg, Munich and Miami.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: Courier New;\">[1] https://sam.nrel.gov/</span></p>
<p><span style=\"font-family: Courier New;\">[2] http://store.affordable-solar.com/site/doc/Doc_sanyo_specs_20061106173925.pdf</span></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: Courier New;\">Advanced_PV by Oliver Sch&uuml;lting and Ricardo Peniche, Technische Universit&auml;t Hamburg, Institut f&uuml;r Energietechnik, 2015</span></p>
<p><span style=\"font-family: Courier New;\">Revision by Tobias Becke, Technische Universit&auml;t Hamburg, Institut f&uuml;r Energietechnik, 2016</span></p>
<p><span style=\"font-family: Courier New;\">Modification by Saba AlSader, Fraunhofer UMSICHT, 2018</span></p>
<p><span style=\"font-family: Courier New;\">Modification by Anne Hagemeier, Fraunhofer UMSICHT, 2019</span></p>
</html>"));
end PVModule_simple_ExternalInverter;

