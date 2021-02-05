within IntegraNet.Basics.Tables.HeatGrid;
package HeatingCurves "Tables of heating curves for heat grids, LA"
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
// This package is a partial copy of package HeatingCurves from TransiEnt Library, //
// version: 1.1.0                                                                  //
//

  extends TransiEnt.Basics.Icons.Package;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-52,60},{-2,-60}},
          lineColor={255,255,255},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Line(points={{-52,-60},{-52,60},{48,60},{48,-60},{-52,-60},{-52,-30},{48,
              -30},{48,0},{-52,0},{-52,30},{48,30},{48,60},{-2,60},{-2,-61}},
            color={0,0,0}),
        Polygon(
          points={{-72,90},{-80,68},{-64,68},{-72,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-72,68},{-72,-80}}, color={192,192,192}),
        Line(points={{-82,-70},{90,-70}}, color={192,192,192}),
        Polygon(
          points={{98,-70},{76,-62},{76,-78},{98,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-72,-30},{-4,-30},{24,-16},{66,0}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{-72,0},{-2,0}},
          color={255,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-2,0},{38,60},{54,60},{66,60}},
          color={255,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier)}));
end HeatingCurves;

