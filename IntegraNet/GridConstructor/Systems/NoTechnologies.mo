within IntegraNet.GridConstructor.Systems;
model NoTechnologies
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

  extends IntegraNet.GridConstructor.Systems.Base.Systems_Base(onlyElectric=false);
  outer IntegraNet.SimCenter simCenter;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter Real cosphi_boundary=1 annotation (HideResult=true);

  // _____________________________________________
  //
  //          Complex Components
  // _____________________________________________

  Components.Boundaries.Electrical.ApparentPower.Electric_Consumer Electric_Consumer(cosphi_boundary=cosphi_boundary) if El_Consumer==1    annotation (Placement(transformation(extent={{-70,34},
            {-54,50}})));

  Modelica.Blocks.Math.Sum sum(nin=2) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=-90,
        origin={26,50})));

  Producer.Heat.Gas2Heat.SmallGasBoiler.GasBoiler_energybased GasBoiler if Boiler==1 annotation (Placement(transformation(extent={{64,-58},{84,-38}})));

  Producer.Heat.Heat2Heat.Substation_indirect_noStorage_L1 substation_indirect_noStorage(
    T_start=simCenter.T_supply,
    dT=simCenter.dT,
    m_flow_min=simCenter.m_flow_min) if DHN ==1 annotation (Placement(transformation(extent={{-20,-18},{8,2}})));
  IntegraNet.Consumer.Consumer_combined.domestic_hot_water domestic_hot_water1(NSH=NSH, cosphi_boundary=cosphi_boundary) annotation (Placement(transformation(extent={{-38,34},{-22,50}})));
equation

  // _____________________________________________
  //
  //          Connect statements
  // _____________________________________________


  connect(q_Demand, sum.u[1]) annotation (Line(
      points={{1.77636e-15,94},{0,94},{0,74},{26,74},{26,59.6},{25.2,59.6}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(el_Demand, Electric_Consumer.P_el_set)
    annotation (Line(points={{-60,94},{-60,51.6},{-66.8,51.6}},
                                                          color={0,127,127}));
  connect(Electric_Consumer.epp, epp) annotation (Line(
      points={{-70.08,41.92},{-70.08,20},{-76,20},{-76,-98},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(q_Demand_water, sum.u[2]) annotation (Line(
      points={{60,94},{60,74},{26,74},{26,72},{26.8,72},{26.8,59.6}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(q_Demand, substation_indirect_noStorage.Q_demand_rh) annotation (Line(
      points={{1.77636e-15,94},{1.77636e-15,48},{-17,48},{-17,1}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(q_Demand_water, substation_indirect_noStorage.Q_demand_dhw) annotation (Line(
      points={{60,94},{60,20},{6,20},{6,1},{5,1}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(substation_indirect_noStorage.waterPortIn, waterPortIn) annotation (Line(
      points={{-12,-18},{-16,-18},{-16,-98},{-20,-98}},
      color={175,0,0},
      thickness=0.5));
  connect(substation_indirect_noStorage.waterPortOut, waterPortOut) annotation (Line(
      points={{0.1,-18.1},{0.1,-57.05},{20,-57.05},{20,-98}},
      color={175,0,0},
      thickness=0.5));
  connect(GasBoiler.heatFlowRate, sum.y) annotation (Line(
      points={{74,-38.6},{52,-38.6},{52,41.2},{26,41.2}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(GasBoiler.gasPortIn, gasIn_grid) annotation (Line(
      points={{82,-57.6},{82,-76},{82,-96},{80,-96}},
      color={255,255,0},
      thickness=1.5));
  connect(domestic_hot_water1.epp, epp) annotation (Line(
      points={{-38.08,41.92},{-38.08,42},{-46,42},{-46,12},{-76,12},{-76,-98},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(domestic_hot_water1.demand, q_Demand_water) annotation (Line(points={{-30,50.64},{-30,62},{60,62},{60,94}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Accommodates no technologies</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created during IntegraNet I </span></p>
</html>"));
end NoTechnologies;
