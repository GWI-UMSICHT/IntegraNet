within IntegraNet.EnergyConverter.Systems;
model DHN_Substation "Substation for district hot water"
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

  extends Base.Systems(
    final DHN=true,
    final el_grid=true,
    final gas_grid=false);

    import TIL = TILMedia.VLEFluidFunctions;
  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________


  parameter SI.SpecificHeatCapacityAtConstantPressure cp = TIL.specificIsobaricHeatCapacity_pTxi(simCenter.fluid1,simCenter.p_nom[2],T_start,{1,0,0});
  parameter SI.MassFlowRate m_flow_min = 0.0001 "Minimum massflow rate";
  parameter SI.Temperature T_start=90 + 273.15 "Temperature at start of the simulation" annotation (Dialog(group="Temperature"));
  parameter Real dT = 20  "Constant Temperature Difference between supply and return" annotation (Dialog(group="Temperature"));
  // _____________________________________________
  //
  //          Variables
  // _____________________________________________


  // _____________________________________________
  //
  //                   Complex Components
  // _____________________________________________

  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower apparentPower(useInputConnectorQ=false, useInputConnectorP=true)
                                                                                       annotation (Placement(transformation(extent={{-76,-30},{-56,-10}})));

  Producer.Heat.Heat2Heat.Substation_indirect_noStorage_L1 substation_indirect_noStorage_L1_1(
    T_start=T_start,
    dT=dT,
    m_flow_min=m_flow_min)                                                                    annotation (Placement(transformation(extent={{-14,8},{14,28}})));
equation



  connect(apparentPower.P_el_set, demand[1]) annotation (Line(points={{-72,-8},{-72,81.8},{0,81.8},{0,108}},        color={0,0,127}));
  connect(apparentPower.epp, epp) annotation (Line(
      points={{-76,-20},{-76,-20},{-80,-20},{-80,-98}},
      color={0,127,0},
      thickness=0.5));

  connect(demand[2], substation_indirect_noStorage_L1_1.Q_demand_rh) annotation (Line(points={{0,100},{-12,100},{-12,27},{-11,27}}, color={0,127,127}));
  connect(demand[3], substation_indirect_noStorage_L1_1.Q_demand_dhw) annotation (Line(points={{0,92},{10,92},{10,27},{11,27}}, color={0,127,127}));
  connect(substation_indirect_noStorage_L1_1.waterPortIn, waterPortIn) annotation (Line(
      points={{-6,8},{-20,8},{-20,-98}},
      color={175,0,0},
      thickness=0.5));
  connect(substation_indirect_noStorage_L1_1.waterPortOut, waterPortOut) annotation (Line(
      points={{6.1,7.9},{20,7.9},{20,-98}},
      color={175,0,0},
      thickness=0.5));
  annotation (Icon(graphics={      Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,102},{100,-98}}),
        Rectangle(
          extent={{-28,4},{24,-68}},
          lineColor={127,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-28,-68},{-28,4},{24,4},{-28,-68}},
          lineColor={127,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,4},{0,58},{28,58}},
          color={255,0,0}),
        Line(
          points={{24,-32},{72,-32},{72,58},{62,58},{58,58}},
          color={0,0,255}),
        Ellipse(
          extent={{28,70},{58,42}},
          lineColor={127,0,0}),
        Line(
          points={{-26,-32},{-54,-32},{-54,-78}},
          color={255,0,0}),
        Line(
          points={{2,-80},{2,-68},{2,-96},{2,-96}},
          color={255,0,0})}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Model of a DHN substation to be used in the energyConverter.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>IntegraNet.Basics.Interfaces.General.PowerIn <b>demand</b></p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortIn <b>waterPortIn</b></p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortOut <b>waterPortOut - connection to district heating grid</b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modification by Philipp Huismann, Gas- und W&auml;rme-Institut e.V. in 2020</span></p>
</html>"));
end DHN_Substation;

