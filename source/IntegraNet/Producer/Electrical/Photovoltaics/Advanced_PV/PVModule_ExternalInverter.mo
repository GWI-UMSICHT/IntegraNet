within IntegraNet.Producer.Electrical.Photovoltaics.Advanced_PV;
model PVModule_ExternalInverter "PV module with external calculation of inverter losses"
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
  outer TransiEnt.ModelStatistics modelStatistics;
  outer IntegraNet.Statistics.Statistics_collector statistics_collector;
  outer IntegraNet.SimCenter simCenter;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Power P_inst=200 "combined installed power";
  parameter Modelica.SIunits.Power Pmpp=200 "peak power of one module";
  parameter Modelica.SIunits.Area Area=1.18 "area of one complete module";

  parameter Real Strings=1 "choose amount of strings";

  parameter Real GroundCoverageRatio=0.3 "ratio of covered ground of modules to area of modules";
  parameter Real LossesDC=4.44 "losses in % through connections, wiring, tracking error and mismatches";
  parameter Real Soiling=5 "Average annual losses of radiation in % due to soiling";

  replaceable model ProducerCosts =
       TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PV
      constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PV
                                                 annotation (Dialog(group="Statistics"),
       __Dymola_choicesAllMatching=true);
  parameter TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.Generic_Characteristics_PVModule PVModuleCharacteristics=TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.PVModule_Characteristics_Sanyo_HIT_200_BA3() "Characteristics of PV Module" annotation (choicesAllMatching);

  //Skymodel
  parameter SI.Angle longitude_local=SI.Conversions.from_deg(10) "longitude of the local position, east positive, 10 East for Hamburg" annotation (Dialog(tab="Irradiance", group="Solartime"));
  parameter SI.Angle longitude_standard=SI.Conversions.from_deg(15) "needed for calculation of coordinated universal time (utc), 15 for central european time, 30 for central european summer time" annotation (Dialog(tab="Irradiance", group="Solartime"));
  SI.Conversions.NonSIunits.Time_day totaldays=365 "total days of the year, standard=365, leap year=366" annotation (Dialog(tab="Irradiance", group="Solartime"));

  //Parameters for ExtraterrestrialIrradiance
  parameter SI.Angle latitude=SI.Conversions.from_deg(53.55) "latitude of the local position, north posiive, 53,55 North for Hamburg" annotation (Dialog(tab="Irradiance", group="Extraterrestrial Irradiance"));
  parameter SI.Angle slope=SI.Conversions.from_deg(30) "slope of the tilted surface, assumption"  annotation (Dialog(tab="Irradiance", group="Extraterrestrial Irradiance"));
  parameter SI.Angle surfaceAzimuthAngle=0 "surface azimuth angle" annotation (Dialog(tab="Irradiance", group="Extraterrestrial Irradiance"));

  //Parameters for IAM
  parameter Integer kind(min=1, max=4)=1 "IAM for direct Irradiance" annotation(Dialog(tab="IAM", group="General"),choices(choice=1 "Constant IAM", choice=2 "IAM as function of b0", choice=3 "IAM by interpolation of record", choice=4 "IAM by representation of DeSoto2006"));
  parameter Real constant_iam_dir=1 "constant IAM for direct irradiation" annotation (Dialog(tab="IAM", group="General"));
  parameter Real constant_iam_diff=1 "constant IAM for diffuse irradiation" annotation (Dialog(tab="IAM", group="General"));
  parameter Real constant_iam_ground=1 "constant IAM for ground-reflected irradiation" annotation (Dialog(tab="IAM", group="General"));
  parameter Real b0=1 "assumption: constant b0-value for IAM=1-b0*(1/cos(theta)-1)" annotation (Dialog(tab="IAM", group="General"));
  parameter Real[8] iam_SRCC={1,1,1,1,1,1,1,1} "IAM for theta = 0, 10, 20, ..., 70" annotation (Dialog(tab="IAM", group="General"));
  parameter SI.Conversions.NonSIunits.Angle_deg[8] theta={0,10,20,30,40,50,60,70} annotation (Dialog(tab="IAM", group="General"));

  //Skymodel
  replaceable model Skymodel=TransiEnt.Producer.Heat.SolarThermal.Base.Skymodel_HDKR  constrainedby TransiEnt.Producer.Heat.SolarThermal.Base.SkymodelBase(
      longitude_local=longitude_local,
      longitude_standard=longitude_standard,
      latitude=latitude,
      slope=slope,
      surfaceAzimuthAngle=surfaceAzimuthAngle,
      reflectance_ground=reflectance_ground,
      direct_normal=direct_normal,
      totaldays=totaldays) "choose sky model" annotation (choicesAllMatching=true, Dialog(tab="Irradiance", group="Skymodel"));
  parameter Real reflectance_ground=0.2 "reflectance of the ground" annotation (Dialog(tab="Irradiance", group="Skymodel"));
  parameter Boolean direct_normal=true "Is the direct irradiance measured on a surface normal to irradiance?" annotation (Dialog(tab="Irradiance", group="Skymodel"));
  parameter Boolean use_input_data=true "choose if input data is given by inputs - if not, simCenter data is used" annotation (Dialog(tab="Irradiance", group="Skymodel"));
  parameter Boolean integratePowerDc=false "true if power shall be integrated";
  parameter Boolean integratePowerOut=false "true if output power shall be integrated";
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
  Modelica.SIunits.Energy E_dc "accumulated DC energy";
  Modelica.SIunits.Energy E "accumulated AC energy";

  //statistics
  Modelica.SIunits.Time FLH(displayUnit="h") "Full load hours";

  //other
  Modelica.SIunits.Area Area_demand;
  Real ModulesPerString "Choose amount of modules per string";

  Modelica.SIunits.Power aux_losses "Losses through connections, wiring, tracking error and mismatches";

  //input variables:
  TransiEnt.Basics.Interfaces.General.TemperatureCelsiusIn T_in "ambient temperature in Celcius" annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-80,120}), iconTransformation(extent={{-140,60},{-100,100}}, rotation=0)));
  TransiEnt.Basics.Interfaces.Ambient.VelocityIn WindSpeed_in "wind speed in m/s" annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=270,
        origin={-80,-120}), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,-80})));

  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp "power output" annotation (Placement(transformation(extent={{88,-8},{108,12}}), iconTransformation(extent={{76,-22},{110,10}})));

  // _____________________________________________
  //
  //                    Components
  // _____________________________________________

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.PowerPlantCost collectCosts_PowerProducer(
    P_el_is=-P_DC,
    P_n=Pmpp,
    redeclare model PowerPlantCostModel = ProducerCosts,
    produces_Q_flow=false,
    consumes_H_flow=false)                               annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

  TransiEnt.Producer.Heat.SolarThermal.Base.IAM IAM(
    kind=kind,
    constant_iam_dir=constant_iam_dir,
    constant_iam_diff=constant_iam_diff,
    constant_iam_ground=constant_iam_ground,
    b0=b0,
    iam_SRCC=iam_SRCC,
    theta=theta) annotation (Placement(transformation(extent={{14,-14},{34,6}})));
  inner TransiEnt.Producer.Heat.SolarThermal.Base.IrradianceOnATiltedSurface irradiance(use_input_data=use_input_data, redeclare model Skymodel = Skymodel)  annotation (Placement(transformation(extent={{-58,-18},{-28,10}})));

public
    TransiEnt.Basics.Interfaces.Ambient.IrradianceIn DNI_in if  use_input_data==true "Direct Normal Irradiation in W/m^2" annotation (Placement(transformation(extent={{-140,4},{-100,44}}), iconTransformation(extent={{-140,4},{-100,44}})));
    TransiEnt.Basics.Interfaces.Ambient.IrradianceIn DHI_in if use_input_data==true "Diffuse Horizontal Irradiation in W/m^2" annotation (Placement(transformation(extent={{-140,-46},{-100,-6}}), iconTransformation(extent={{-140,-46},{-100,-6}})));

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

   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Renewable, is_setter=true)
                                                                                                                                                     annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  //Input irradiation
  POA_Irradiation=(IAM.iam_dir*irradiance.irradiance_direct_tilted + IAM.iam_diff*irradiance.irradiance_diffuse_tilted + IAM.iam_ground*irradiance.irradiance_ground_tilted)*(100-Soiling)/100;

  //calculation of module temperature
  T_module = 273.15 + T_in + POA_Irradiation * (exp(-3.47 - 0.0594 * WindSpeed_in)); //https://pvpmc.sandia.gov/modeling-steps/2-dc-module-iv/module-temperature/sandia-module-temperature-model/

  //calculation of cell temperature
  T_cell = T_module; //simplification

  //output power and Energy
  PowerCurve_PV_Irradiation.u=POA_Irradiation;
  PowerCurve_PV_Temp.u=Modelica.SIunits.Conversions.to_degC(T_cell);

  if (PowerCurve_PV_Irradiation.y[1] *  PowerCurve_PV_Temp.y[1] / Pmpp) > 0 then
    P_DC = PowerCurve_PV_Irradiation.y[1] *  PowerCurve_PV_Temp.y[1] / Pmpp * (100 - LossesDC) / 100 * P_inst / Pmpp;
    aux_losses =P_DC - PowerCurve_PV_Irradiation.y[1] *  PowerCurve_PV_Temp.y[1] / Pmpp * (100 - 0)        / 100 * P_inst / Pmpp;
  else
    P_DC = 0;
    aux_losses =0;
  end if;

//   if integratePowerDc then
  der(E_dc)=P_DC;
//   else
//     E_dc=0;
//   end if;

//   if integratePowerOut then
//   der(E)=P_out;
//   else
    E=0;
//   end if;

  //full load hours
  if time>0 then
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
  PV_collector.flowCollector.unit_flow = epp.P;
  PV_losses.flowCollector.unit_flow = aux_losses;
  collectElectricPower.powerCollector.P=epp.P;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

   if use_input_data then
     connect(DNI_in, irradiance.irradiance_direct_measured_input) annotation (Line(points={{-120,24},{-68,24},{-68,1.6},{-61,1.6}}, color={0,0,127}));
     connect(DHI_in, irradiance.irradiance_diffuse_horizontal_input) annotation (Line(points={{-120,-26},{-66,-26},{-66,-9.6},{-61,-9.6}}, color={0,0,127}));
   end if;

  connect(PV_collector.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.el_output_Photovoltaic]);
  connect(PV_losses.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.el_Losses_Photovoltaic_aux]);

  connect(modelStatistics.powerCollector[TransiEnt.Basics.Types.TypeOfResource.Renewable],collectElectricPower.powerCollector);
  connect(modelStatistics.costsCollector,  collectCosts_PowerProducer.costsCollector);

    annotation (Diagram(graphics,
                        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The purpose of this model is to calculate the power of a photovoltaic (PV) module or several modules.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model is based on empiric equations and PV manufacturers data. Optical losses are being consideres due to loss factors for soiling and refraction and reflexion (contained in the incidence angle modification). Degradation of the modules and inverter consumption is not included in the model. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model has been validated with System Advisor Model simulation results [1] for fixed PV arrays without shading influences. The results are best with Tilt angle of ~30&deg;.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model has not been entirely validated for sun tracking. Disabling Incidence Angle Modifications seems to improve results with tracking enabled.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Input: </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">DNI_in</span></b> for direct normal irradiation </p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">DHI_in</span></b> for diffuse horizontal irradiation</p>
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
<p><br><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>This model is a modification from the model TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.DNIDHI_Input.PVModule. Compared to the original model, the inverter efficiency as well as the calculation of the ac power have been removed. Therefore the output of the model is dc power. This way, the model can be combined with an external inverter and allows for the connection of the battery on the dc side.</p>
<p>The modification means that for model statistics, dc power is used instead of ac power, leading to a slight overestimation of produced PV power because not all losses are included.</p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">For the calculation of the output power, manufacturer datasheets are to be digitalized, e.g. with http://arohatgi.info/WebPlotDigitizer/. This is an example for a Sanyo HIT 200BA module [2]. Digitalize the following figures: </span></p>
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
<p><span style=\"font-family: Courier New;\">Revision by Anne Hagemeier, Fraunhofer UMSICHT, 2018</span></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-100,-102},{100,-140}},
          lineColor={0,134,134},
          textString="%name"),
        Text(
          extent={{-98,102},{-60,60}},
          lineColor={0,134,134},
          textString="T_in"),
        Text(
          extent={{-98,44},{-56,4}},
          lineColor={0,134,134},
          textString="DNI_in"),
        Text(
          extent={{-98,-62},{-60,-98}},
          lineColor={0,134,134},
          textString="WindSpeed_in"),
        Text(
          extent={{-98,-6},{-56,-46}},
          lineColor={0,134,134},
          textString="DHI_in")}));
end PVModule_ExternalInverter;

