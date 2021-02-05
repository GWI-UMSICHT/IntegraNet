within IntegraNet.Storage.Heat;
model HeatStorage_energybased "Simple energy-based thermal storage model"
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
  outer IntegraNet.Statistics.Statistics_collector statistics_collector;
  extends TransiEnt.Basics.Icons.ThermalStorageBasic;

   //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________

  Modelica.SIunits.Temperature T_s_max= 363.15 "Maximum storage temperature" annotation(Dialog(group="Temperatures"));
  Modelica.SIunits.Temperature T_s_min= 303.15 "Minimum storage temperature" annotation(Dialog(group="Temperatures"));

  parameter Modelica.SIunits.Temperature T_s_max_start= 363.15 "Start value of maximum storage temperature" annotation(Dialog(group="Temperatures"));

  parameter Modelica.SIunits.Volume  V_Storage=0.5 "Volume of the Storage" annotation(Dialog(group="Geometry"));
  parameter Modelica.SIunits.Density  rho_Water=977.7 "|Material properties|Density of Water";
  parameter Modelica.SIunits.SpecificHeatCapacity cp_Storage=4180 "|Material properties|HeatCapacity of Water";

  parameter SI.Height height=1.3 "Height of heat storage" annotation(Dialog(group="Geometry"));
  parameter SI.Diameter d=sqrt(V_Storage/height*4/Modelica.Constants.pi) "Diameter of heat storage" annotation(Dialog(group="Geometry"));

  parameter SI.Temp_C T_amb=15 "Assumed constant temperature in tank installation room" annotation(Dialog(group="Calculation of losses"));

  parameter SI.SurfaceCoefficientOfHeatTransfer k=0.08 "Coefficient of heat Transfer" annotation(Dialog(group="Calculation of losses"));
                                    //According to BINE-Waermespeicher

protected
  parameter SI.Area A=d*Modelica.Constants.pi*height+2*d^2/4*Modelica.Constants.pi;

 //___________________________________________________________________________
   //
   //                      Variables
   //___________________________________________________________________________

public
  Modelica.SIunits.Energy E_max;
  Modelica.SIunits.Energy E_min;
  Modelica.SIunits.Energy E(start=T_s_max_start*V_Storage*cp_Storage*rho_Water);

  SI.HeatFlowRate Q_flow_loss "surface losses";
  Modelica.SIunits.Temperature T_s "Storage temperature";

   // __________________________________________________________________________
   //
   //                   Interfaces
   // ___________________________________________________________________________

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_Generation annotation (Placement(transformation(extent={{-114,-36},{-86,-8}}),
                                                                                                                                    iconTransformation(extent={{-100,-56},{-72,-28}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_Demand annotation (Placement(transformation(
          extent={{-114,24},{-86,52}}),  iconTransformation(extent={{-100,44},{-74,70}})));

  Modelica.Blocks.Interfaces.RealOutput T=T_s annotation (Placement(transformation(extent={{94,-34},{122,-6}}), iconTransformation(extent={{92,-2},{122,34}})));
  Modelica.Blocks.Interfaces.RealOutput  SoC annotation (Placement(transformation(extent={{94,-6},{122,22}}),  iconTransformation(extent={{92,-14},{122,22}})));
  // ___________________________________________________________________________
  //
  //            Characteristic equations
  // ___________________________________________________________________________

  Statistics.LocalCollector E_Storage_output(typeOfResource=IntegraNet.Statistics.TypeOfResource.q_LoadStatus_Storage) annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Statistics.LocalCollector loss_storage(typeOfResource=IntegraNet.Statistics.TypeOfResource.Heat_loss_Storage) annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation

  E_Storage_output.flowCollector.unit_flow = Q_Generation - Q_Demand - Q_flow_loss;
  connect(E_Storage_output.flowCollector, statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.q_LoadStatus_Storage]);

  loss_storage.flowCollector.unit_flow = -Q_flow_loss;
  connect(loss_storage.flowCollector, statistics_collector.flowCollector[IntegraNet.Statistics.TypeOfResource.Heat_loss_Storage]);


   E_max=T_s_max*V_Storage*cp_Storage*rho_Water;
   E_min=T_s_min*V_Storage*cp_Storage*rho_Water;

   der(E)=Q_Generation - Q_Demand - Q_flow_loss;

   SoC =(E-E_min)/(E_max-E_min);

   T_s=E/(V_Storage*cp_Storage*rho_Water);

   Q_flow_loss=k*A*(T_s-T_amb);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Simple energy balance model of a hot water storage without spatial discretisation. Thermodynamic properties are not calculated in dependance of the temperature. </p>
<p>Heat demand and heat production are entered directly into the model.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_Demand</p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_Generation</p>
<p>Modelica.Blocks.Interfaces.RealOutput SoC</p>
<p>Modelica.Blocks.Interfaces.RealOutput T</p>
<p><br><h4><span style=\"color: #008000\">5. Nomenclature</span></h4></p>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created in project IntegraNet in 2017</p>
</html>"));
end HeatStorage_energybased;

