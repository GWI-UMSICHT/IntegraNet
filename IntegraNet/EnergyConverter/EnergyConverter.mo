within IntegraNet.EnergyConverter;
model EnergyConverter
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


  outer IntegraNet.SimCenter simCenter;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

 final parameter Boolean DHN=systems.DHN annotation(HideResult=true);
 final parameter Boolean el_grid=systems.el_grid annotation(HideResult=true);
 final parameter Boolean gas_grid=systems.gas_grid annotation(HideResult=true);

  // _____________________________________________
  //
  //          Variables
  // _____________________________________________

  // _____________________________________________
  //
  //          Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp if el_grid annotation (Placement(transformation(extent={{-88,-70},{-68,-50}}), iconTransformation(extent={{-88,-70},{-68,-50}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=simCenter.gasModel1) if gas_grid annotation (Placement(transformation(extent={{68,-70},{88,-50}}), iconTransformation(extent={{70,-68},{88,-50}})));
  Basics.Interfaces.General.PowerIn demand[3] annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={0,100}), iconTransformation(
        extent={{-9,-9},{9,9}},
        rotation=270,
        origin={1,31})));

  // _____________________________________________
  //
  //          Complex Components
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=simCenter.fluid1) if  DHN annotation (Placement(transformation(extent={{-26,-70},{-6,-50}}), iconTransformation(extent={{-26,-70},{-6,-50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=simCenter.fluid1) if  DHN annotation (Placement(transformation(extent={{8,-70},{28,-50}}), iconTransformation(extent={{8,-70},{28,-50}})));
  replaceable IntegraNet.EnergyConverter.Systems.HeatPump systems constrainedby Systems.Base.Systems annotation (choicesAllMatching=true, Placement(transformation(extent={{-10,20},{10,40}})));

equation

  connect(systems.epp, epp) annotation (Line(
      points={{-8,20.2},{-46,20.2},{-46,-60},{-78,-60}},
      color={0,127,0},
      thickness=0.5));
  connect(systems.waterPortIn, waterPortIn) annotation (Line(
      points={{-2,20.2},{-2,-16.9},{-16,-16.9},{-16,-60}},
      color={175,0,0},
      thickness=0.5));
  connect(systems.waterPortOut, waterPortOut) annotation (Line(
      points={{2,20.2},{2,20.2},{2,-60},{18,-60}},
      color={175,0,0},
      thickness=0.5));
  connect(systems.gasPortIn, gasPortIn) annotation (Line(
      points={{8,20.4},{42,20.4},{42,-60},{78,-60}},
      color={255,255,0},
      thickness=1.5));
  connect(systems.demand, demand) annotation (Line(points={{0,40},{0,40},{0,100}}, color={0,127,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,40},{100,-60}},
          lineColor={0,0,0},
          fillColor={255,198,164},
          fillPattern=FillPattern.Solid)}),                      Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Model based on the energy hub concept to allow for flexible change of technologies that supply a consumer with electricity, heat for space heating and for domestic hot water.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>IntegraNet.Basics.Interfaces.General.PowerIn <b>demand</b></p>
<p><i>Conditional interfaces depending on the technologies selected:</i></p>
<p>TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort <b>epp - connection to electrical grid</b></p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortIn <b>waterPortIn</b></p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortOut <b>waterPortOut - connection to district heating grid</b></p>
<p>TransiEnt.Basics.Interfaces.Gas.RealGasPortIn <b>gasPortIn - connection to gas grid</b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model contains a replaceable technology model with that different predefined technology combinations to supply the consumer can be selected.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end EnergyConverter;

