﻿within IntegraNet.Producer.Gas;
model PEMElectrolyzer_L1 "Proton exchange membrane electrolyzer"

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
// This component is a modification of model PEMElectrolyzer_L1 from TransiEnt     //
// Library, version: 1.0.0                                                         //
//

// CHANGES:
// Electric_Consumer model was added to the TransiEnt PEM-Electrolyzer model
// -> PEM Electrolyzer can be regarded as an electric consumer and directly connected to the electric grid
// No efficiency-charline is used -> Constant eta is assumed by using replaceable charline model ElectrolyzerEfficiencyCharline_constant_eta

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import TransiEnt;
  import SI = Modelica.SIunits;
  extends TransiEnt.Basics.Icons.Electrolyser2;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  constant SI.MassFraction xi_out[medium.nc-1]=zeros(medium.nc-1);
  constant SI.SpecificEnergy GCV_H2=141.79e6 "Gross calorific value of hydrogen at 25 C and 1 bar";
  final parameter TransiEnt.Basics.Types.TypeOfResource typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer
    "Type of energy resource for global model statistics";

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel3 "Medium model" annotation(Dialog(group="Fundamental Definitions"));

  parameter Boolean useHomotopy=simCenter.useHomotopy "true if homotopy method is used during initialization" annotation(Dialog(group="Fundamental Definitions"));

  parameter SI.Temperature T_out=283.15 "Hydrogen output temperature" annotation(Dialog(group="Fundamental Definitions"));

  parameter SI.ActivePower P_el_n=1e6 "Nominal power of the electrolyzer" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.ActivePower P_el_max=3*P_el_n "Maximum power of the electrolyzer" annotation(Dialog(group="Fundamental Definitions"));
  parameter Real specificWaterConsumption=10 "Mass of water per mass of hydrogen" annotation(Dialog(group="Fundamental Definitions")); //Stolzenburg, K. et al.: Integration von Wind-Wasserstoff-Systemen in das Energiesystem: Abschlussbericht, 2014

  parameter SI.Efficiency eta_n(
    min=0,
    max=1)=0.75 "Nominal efficiency refering to the GCV (min = 0, max = 1)" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.Efficiency eta_scale(
    min=0,
    max=1)=0 "Sets a with increasing input power linear degrading efficiency coefficient (min=0,max=1)" annotation(Dialog(group="Fundamental Definitions"));
  parameter Integer whichInput=1 "use P_el_set or m_flow_H2_set as input" annotation(Dialog(group="Fundamental Definitions"),choices(__Dymola_radioButtons=true, choice=1 "P_el_set", choice=2 "m_flow_H2_set"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el=simCenter.Cspec_demAndRev_free "Specific demand-related cost per electric energy" annotation (Dialog(group="Statistics"));
  parameter Real Cspec_demAndRev_other=simCenter.Cspec_demAndRev_other_free "Specific demand-related cost per cubic meter water" annotation (Dialog(group="Statistics"));

  // _____________________________________________
  //
  //              Variable Declarations
  // _____________________________________________

protected
  SI.MassFlowRate m_flow_H2 "H2 mass flow rate out of electrolyzer";
  SI.Mass mass_H2(start=0, fixed=true) "produced H2 mass";
  SI.MassFlowRate m_flow_water "water mass flow rate into the electrolyzer";
  SI.Power P_el "Electric power consumed by the electrolyzer";
  SI.Efficiency eta(min=0,max=1)=charline.eta "Efficiency of the electrolyzer";
  SI.SpecificEnthalpy h0 = TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(simCenter.gasModel3, 1e5, 298.15) "Specific enthalpy at 25 C and 1 bar";
  model Outline
    extends TransiEnt.Basics.Icons.Record;
    input SI.Power P_el "Consumed electric power";
    input SI.Energy W_el "Consumed electric energy";
    input SI.Mass mass_H2 "Produced hydrogen mass";
    input SI.Efficiency eta "Efficiency";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    Outline outline;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    TransiEnt.Basics.Records.Costs costs;
  end Summary;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

public
  outer IntegraNet.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;
  replaceable model CostSpecsGeneral =
      TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty                        constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs
                                                                                                                                                                                             "General Cost Record" annotation(Dialog(group="Statistics"),choicesAllMatching);
public
  replaceable model Dynamics =
      TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder                                 constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerDynamics        "Dynamic behavior of electrolyser" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true, Placement(transformation(extent={{-30,-10},{-10,10}})));

  replaceable model Charline =
      TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200                                 constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerEfficiencyCharline
                                                                                                                                                                                                      "Calculate the efficiency" annotation (Dialog(group="Fundamental Definitions"), Placement(transformation(extent={{10,-10},{30,10}})), choicesAllMatching=true);
  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput P_el_set(
    final quantity="Power",
    displayUnit="W",
    final unit="W") if whichInput==1 annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,120})));
  Modelica.Blocks.Interfaces.RealInput m_flow_H2_set(
    final quantity="MassFlowRate",
    displayUnit="kg/s",
    final unit="kg/s") if whichInput==2 annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,120})));

  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
protected
  Dynamics dynamics(final useHomotopy=useHomotopy, final P_el_n=P_el_n, final eta_n=eta_n) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Charline charline(final P_el_n=P_el_n, final eta_n=eta_n, final eta_scale=eta_scale) annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  TILMedia.VLEFluid_pT vleFluidH2(
    vleFluidType=medium,
    deactivateTwoPhaseRegion=true,
    p=gasPortOut.p,
    T=T_out,
    xi=xi_out) annotation (Placement(transformation(extent={{60,-12},{80,8}})));

  Modelica.Blocks.Sources.Constant P_el_set_(k=0) if not whichInput==1;
  Modelica.Blocks.Sources.Constant m_flow_H2_set_(k=0) if not whichInput==2;

  TransiEnt.Producer.Gas.Electrolyzer.Base.GetInputsElectrolyzer getInputs annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={0,60})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=typeOfResource) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts(
    redeclare model CostRecordGeneral = CostSpecsGeneral,
    der_E_n=P_el_n,
    E_n=0,
    Cspec_demAndRev_el=Cspec_demAndRev_el,
    Cspec_demAndRev_other=Cspec_demAndRev_other,
    P_el=P_el,
    other_flow=m_flow_water) annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
public
  inner Summary summary(
    outline(
      P_el=P_el,
      W_el=collectCosts.W_el_demand,
      mass_H2=mass_H2,
      eta=eta),
    gasPortOut(
      mediumModel=medium,
      xi=vleFluidH2.xi,
      x=vleFluidH2.x,
      m_flow=-gasPortOut.m_flow,
      T=vleFluidH2.T,
      p=gasPortOut.p,
      h=vleFluidH2.h,
      rho=vleFluidH2.d),
    costs(
      costs=collectCosts.costsCollector.Costs,
      investCosts=collectCosts.costsCollector.InvestCosts,
      demandCosts=collectCosts.costsCollector.DemandCosts,
      oMCosts=collectCosts.costsCollector.OMCosts,
      otherCosts=collectCosts.costsCollector.OtherCosts,
      revenues=collectCosts.costsCollector.Revenues)) annotation (Placement(transformation(extent={{-58,-100},{-38,-80}})));

  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

   // Electric_Consumer model
  Components.Boundaries.Electrical.ApparentPower.Electric_Consumer PEM(
      useCosPhi=false)
    annotation (Placement(transformation(extent={{-78,-10},{-58,10}})));
  TransiEnt.Basics.Blocks.Sources.PowerExpression powerExpression(y=P_el)
    annotation (Placement(transformation(extent={{-90,26},{-70,46}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //ElectricPowerPort
 // epp.P = P_el;
  //GasPortOut
  gasPortOut.xi_outflow=xi_out;
  gasPortOut.h_outflow=vleFluidH2.h;
  gasPortOut.m_flow = -m_flow_H2;

  if whichInput==1 then
    P_el=getInputs.P_el_set;
  else
    m_flow_H2=getInputs.m_flow_H2_set;
  end if;

  der(mass_H2)=m_flow_H2;
  m_flow_water=specificWaterConsumption*m_flow_H2;

  //Dynamics
  dynamics.H_flow_H2 = m_flow_H2 * (GCV_H2 + (vleFluidH2.h - h0));
  dynamics.P_el=P_el;
  dynamics.eta=eta;

  //Charline
  charline.P_el=P_el;

  //Collectors
  collectElectricPower.powerCollector.P=epp.P;

  // _____________________________________________
  //
  //           Connect Statements
  // _____________________________________________

  connect(modelStatistics.powerCollector[typeOfResource],collectElectricPower.powerCollector);
  connect(modelStatistics.costsCollector, collectCosts.costsCollector);

  connect(P_el_set_.y, getInputs.P_el_set);
  connect(m_flow_H2_set_.y, getInputs.m_flow_H2_set);
  connect(P_el_set, getInputs.P_el_set) annotation (Line(points={{-40,120},{-40,80},{-4,80},{-4,72}}, color={0,0,127}));
  connect(getInputs.m_flow_H2_set, m_flow_H2_set) annotation (Line(points={{4,72},{4,80},{40,80},{40,120}}, color={0,0,127}));
  connect(epp, PEM.epp) annotation (Line(
      points={{-100,0},{-88,0},{-88,-0.1},{-78.1,-0.1}},
      color={0,127,0},
      thickness=0.5));
  connect(powerExpression.y, PEM.P_el_set) annotation (Line(
      points={{-69,36},{-64,36},{-64,28},{-64,12},{-74,12}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  annotation(defaultComponentName="electrolyzer",
  Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>This is a model for an electrolyzer with a replaceable efficiency curve and replaceable dynamic behavior. </p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>The efficiency curve, the dynamic behaviour and the wanted input (electric power or hydrogen mass flow) can be chosen. The water consumption is calculated using a constant factor. </p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks) </p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b></p>
<p>epp: electric apparent power port </p>
<p>gasPortOut: hydrogen outlet </p>
<p>P_el_set: input for electric power </p>
<p>m_flow_H2_set: input for hydrogen mass flow </p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>The hydrogen mass flow or the electric power is calculated depending on the given input and chosen efficiency curve and dynamic behavior. </p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(no remarks) </p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no remarks) </p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>Based on the model PEMElectrolyzer_L1&nbsp;from&nbsp;TransiEnt&nbsp;1.0.0</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
<p>Modified during IntegraNet, 2018. Adapted to use the ApparentPowerPort.</p>
</html>"));
end PEMElectrolyzer_L1;

