within IntegraNet.Consumer.Consumer_combined;
model domestic_hot_water "Modell to gather data about domestic hot water usage"
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

 import SI = Modelica.SIunits;
 outer IntegraNet.Statistics.Statistics_collector statistics_collector;

 parameter Integer NSH = 0;
 parameter Real cosphi_boundary=1;

  Modelica.Blocks.Interfaces.RealInput demand annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,108})));

  IntegraNet.Statistics.LocalCollector
                            TWW_collector(typeOfResource=IntegraNet.Statistics.TypeOfResource.tww_demand) annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Interfaces.RealOutput electrical_dhw_deman annotation (Placement(transformation(
        extent={{-21,-21},{21,21}},
        rotation=270,
        origin={1,-111})));
  IntegraNet.Components.Boundaries.Electrical.ApparentPower.Electric_Consumer
                                                                   Electric_Consumer_dhw(cosphi_boundary=cosphi_boundary) if
                                                                                                                         NSH==1 annotation (Placement(transformation(extent={{-8,-8},{8,8}})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp if                                                        NSH==1 annotation (
      Placement(transformation(extent={{-44,-106},{-24,-86}}),
        iconTransformation(extent={{-118,-16},{-84,14}})));
  IntegraNet.Statistics.LocalCollector El_collector_DHW(typeOfResource=IntegraNet.Statistics.TypeOfResource.el_dhw_supply) annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
equation

 TWW_collector.flowCollector.unit_flow = -demand;
 connect(TWW_collector.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.tww_demand]);

 El_collector_DHW.flowCollector.unit_flow = -demand * NSH;
 connect(El_collector_DHW.flowCollector,statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.el_dhw_supply]);

 if NSH == 1 then
   electrical_dhw_deman = demand;
  else
   electrical_dhw_deman = 0;
 end if;

  connect(Electric_Consumer_dhw.P_el_set, demand) annotation (Line(points={{-4.8,9.6},{-4.8,76},{0,76},{0,108}}, color={0,0,127}));
  connect(Electric_Consumer_dhw.epp, epp) annotation (Line(
      points={{-8.08,-0.08},{-34,-0.08},{-34,-96}},
      color={0,127,0},
      thickness=0.5));
  annotation (Icon(graphics={      Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-98,-100},{102,100}}),
        Rectangle(
          extent={{-44,-78},{-34,56}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-40,50},{34,42}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{22,44},{32,36}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{22,32},{32,-12}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-16},{32,-30}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-34},{32,-44}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-48},{32,-58}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}));
end domestic_hot_water;
