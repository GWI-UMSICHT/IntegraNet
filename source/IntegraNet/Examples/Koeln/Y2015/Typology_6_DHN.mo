within IntegraNet.Examples.Koeln.Y2015;
model Typology_6_DHN
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
  inner IntegraNet.SimCenter simCenter(redeclare IntegraNet.Components.Boundaries.Ambient.AmbientConditions_Koeln_TRY ambientConditions,
    p_nom={600000,1000000},
    redeclare model Ground_Temperature =
        IntegraNet.Basics.Tables.Ambient.Temperature_Duesseldorf_1m_3600s_TMY,                     calc_initial_dstrb=false,
    T_supply=363.15,
    T_return=343.15,
    K(displayUnit="mm") = 2e-5)
    annotation (Placement(transformation(extent={{-378,290},{-344,320}})));
  inner IntegraNet.Statistics.Statistics_collector statistics_collector annotation (Placement(transformation(extent={{-340,294},{-320,314}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi Grid_Return_Out(p_const(displayUnit="bar") = simCenter.p_nom[1],
                                                                                                                  T_const(displayUnit="degC") = 363.15) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-252,-58})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow Grid_Supply_In(m_flow_const=-10,
                                                                                           T_const(displayUnit="degC") = 363.15) annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-232,266})));
  IntegraNet.Components.Heat.VolumesValvesFittings.DoublePipePair_LX HL_1(
    p_start_supply=simCenter.p_nom[2],
    T_start_supply=363.15,
    p_start_return=simCenter.p_nom[1],
    T_start_return=343.15,                                                length=22,
    DN=150)                                                               annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-236,-20})));
  IntegraNet.Components.Heat.VolumesValvesFittings.DoublePipePair_LX HL_2(
    p_start_supply=simCenter.p_nom[2],
    T_start_supply=363.15,
    p_start_return=simCenter.p_nom[1],
    T_start_return=343.15,                                                length=22,
    DN=150)                                                               annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-238,68})));
  IntegraNet.Components.Heat.VolumesValvesFittings.DoublePipePair_LX HL_3(
    p_start_supply=simCenter.p_nom[2],
    T_start_supply=363.15,
    p_start_return=simCenter.p_nom[1],
    T_start_return=343.15,                                                length=22,
    DN=150)                                                               annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-237,132})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi Grid_Supply_Out(p_const(displayUnit="bar") = simCenter.p_nom[2],
                                                                                                            T_const(displayUnit="degC") = 363.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-226,-58})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow Grid_Return_In(m_flow_const=10, T_const(displayUnit="degC") = 343.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-252,264})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                         T_ground1          annotation (Placement(transformation(extent={{-420,200},{-400,220}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=simCenter.T_ground_var) annotation (Placement(transformation(extent={{-458,200},{-438,220}})));
  IntegraNet.Components.Heat.VolumesValvesFittings.DoublePipePair_LX HL_4(
    p_start_supply=simCenter.p_nom[2],
    T_start_supply=363.15,
    p_start_return=simCenter.p_nom[1],
    T_start_return=343.15,                                                length=22,
    DN=150)                                                               annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-237,208})));
  IntegraNet.Components.Boundaries.Electrical.ApparentPower.Electric_Grid ElectricGrid
    annotation (Placement(transformation(
        extent={{-14,-15},{14,15}},
        rotation=180,
        origin={-274,242})));
  IntegraNet.GridConstructor.Grid_Constructor GC_1(
    gas_in=false,
    gas_out=false,
    el_out=false,
    dhn_in_s=true,
    dhn_out_s=false,
    dhn_in_r=false,
    dhn_out_r=true,
    Technologies_1={IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),
        IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix()},
    Technologies_2={IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),
        IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix()},
    CablePipeParameters={IntegraNet.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.10,
        l_pipe=22,
        l_cable=22,
        losses=0.00007),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22,
        losses=0.00007),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),
        IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters()},
    redeclare model Systems_Consumer_1 = GridConstructor.Systems.IndependentTechnologies_noGasGrid,
    redeclare model Systems_Consumer_2 = GridConstructor.Systems.IndependentTechnologies_noGasGrid,
    redeclare model Demand_Consumer_1 = IntegraNet.Consumer.Consumer_combined.Data.Demand_3Tables (
        fileName_el=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/electricity/GC_1.csv"),
        fileName_q_heating=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/heat/GC_1.csv"),
        fileName_q_water=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/tww/GC_1.csv")),
    redeclare model Demand_Consumer_2 = IntegraNet.Consumer.Consumer_combined.Data.Demand_3Tables (
        fileName_el=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/electricity/GC_1.csv"),
        fileName_q_heating=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/heat/GC_1.csv"),
        fileName_q_water=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/tww/GC_1.csv")),
    start_c1=1,
    start_c2=3,
    second_Consumer={true,true},
    second_row=true,
    DHNParameters_Main={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_1={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_2={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    redeclare model HeatTransfer = IntegraNet.Components.Heat.VolumesValvesFittings.Base.HT_Single_Buried_LX,
    dhn_lambda_insulation={0.023,0.023},
    n_elements=2) annotation (Placement(transformation(extent={{-302,164},{-374,220}})));
  IntegraNet.GridConstructor.Grid_Constructor GC_4(
    gas_in=false,
    gas_out=false,
    el_out=false,
    dhn_in_s=true,
    dhn_out_s=false,
    dhn_in_r=false,
    dhn_out_r=true,
    Technologies_1={IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),
        IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix()},
    Technologies_2={IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),
        IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix()},
    CablePipeParameters={IntegraNet.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22,
        losses=0.00007),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22,
        losses=0.00007),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22,
        losses=0.00007),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22,
        losses=0.00007),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),
        IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters()},
    redeclare model Systems_Consumer_1 = GridConstructor.Systems.IndependentTechnologies_noGasGrid,
    redeclare model Systems_Consumer_2 = GridConstructor.Systems.IndependentTechnologies_noGasGrid,
    redeclare model Demand_Consumer_1 = IntegraNet.Consumer.Consumer_combined.Data.Demand_3Tables (
        fileName_el=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/electricity/GC_4.csv"),
        fileName_q_heating=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/heat/GC_4_noNSH.csv"),
        fileName_q_water=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/electricity/GC_4.csv")),
    redeclare model Demand_Consumer_2 = IntegraNet.Consumer.Consumer_combined.Data.Demand_3Tables (
        fileName_el=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/electricity/GC_4.csv"),
        fileName_q_heating=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/heat/GC_4_noNSH.csv"),
        fileName_q_water=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/tww/GC_4.csv")),
    start_c1=1,
    start_c2=5,
    second_Consumer={true,true,true,true},
    second_row=true,
    DHNParameters_Main={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_1={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_2={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    redeclare model HeatTransfer = IntegraNet.Components.Heat.VolumesValvesFittings.Base.HT_Single_Buried_LX,
    dhn_lambda_insulation={0.023,0.023,0.023,0.023},
    n_elements=4) annotation (Placement(transformation(extent={{-186,84},{-114,140}})));
  IntegraNet.GridConstructor.Grid_Constructor GC_6(
    gas_in=false,
    gas_out=false,
    el_out=false,
    dhn_in_s=true,
    dhn_out_s=false,
    dhn_in_r=false,
    dhn_out_r=true,
    Technologies_1={IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),
        IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix()},
    Technologies_2={IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),
        IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix()},
    CablePipeParameters={IntegraNet.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22,
        losses=0.00007),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22,
        losses=0.00007),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),
        IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters()},
    redeclare model Systems_Consumer_1 = GridConstructor.Systems.IndependentTechnologies_noGasGrid,
    redeclare model Systems_Consumer_2 = GridConstructor.Systems.IndependentTechnologies_noGasGrid,
    redeclare model Demand_Consumer_1 = IntegraNet.Consumer.Consumer_combined.Data.Demand_3Tables (
        fileName_el=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/electricity/GC_6.csv"),
        fileName_q_heating=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/heat/GC_6.csv"),
        fileName_q_water=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/tww/GC_6.csv")),
    redeclare model Demand_Consumer_2 = IntegraNet.Consumer.Consumer_combined.Data.Demand_3Tables (
        fileName_el=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/electricity/GC_6.csv"),
        fileName_q_heating=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/heat/GC_6.csv"),
        fileName_q_water=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/tww/GC_6.csv")),
    start_c1=1,
    start_c2=3,
    second_Consumer={true,true},
    second_row=true,
    DHNParameters_Main={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_1={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_2={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    redeclare model HeatTransfer = IntegraNet.Components.Heat.VolumesValvesFittings.Base.HT_Single_Buried_LX,
    dhn_lambda_insulation={0.023,0.023},
    n_elements=2) annotation (Placement(transformation(
        extent={{36,-28},{-36,28}},
        rotation=0,
        origin={-340,20})));
  IntegraNet.GridConstructor.Grid_Constructor GC_3(
    gas_in=false,
    gas_out=false,
    el_out=false,
    dhn_in_s=true,
    dhn_out_s=false,
    dhn_in_r=false,
    dhn_out_r=true,
    Technologies_1={IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),
        IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix()},
    Technologies_2={IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),
        IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix()},
    CablePipeParameters={IntegraNet.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22,
        losses=0.00007),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22,
        losses=0.00007),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),
        IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters()},
    redeclare model Systems_Consumer_1 = GridConstructor.Systems.IndependentTechnologies_noGasGrid,
    redeclare model Systems_Consumer_2 = GridConstructor.Systems.IndependentTechnologies_noGasGrid,
    redeclare model Demand_Consumer_1 = IntegraNet.Consumer.Consumer_combined.Data.Demand_3Tables (
        fileName_el=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/electricity/GC_3.csv"),
        fileName_q_heating=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/heat/GC_3.csv"),
        fileName_q_water=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/tww/GC_3.csv")),
    redeclare model Demand_Consumer_2 = IntegraNet.Consumer.Consumer_combined.Data.Demand_3Tables (
        fileName_el=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/electricity/GC_3.csv"),
        fileName_q_heating=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/heat/GC_3.csv"),
        fileName_q_water=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/tww/GC_3.csv")),
    start_c1=1,
    start_c2=3,
    second_Consumer={true,true},
    second_row=true,
    DHNParameters_Main={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_1={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_2={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    redeclare model HeatTransfer = IntegraNet.Components.Heat.VolumesValvesFittings.Base.HT_Single_Buried_LX,
    dhn_lambda_insulation={0.023,0.023},
    n_elements=2) annotation (Placement(transformation(extent={{-304,83},{-376,139}})));
  IntegraNet.GridConstructor.Grid_Constructor GC_5(
    gas_in=false,
    gas_out=false,
    el_out=false,
    dhn_in_s=true,
    dhn_out_s=false,
    dhn_in_r=false,
    dhn_out_r=true,
    Technologies_1={IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),
        IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix()},
    Technologies_2={IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),
        IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix()},
    CablePipeParameters={IntegraNet.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22,
        losses=0.00007),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22,
        losses=0.00007),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),
        IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters()},
    redeclare model Systems_Consumer_1 = GridConstructor.Systems.IndependentTechnologies_noGasGrid,
    redeclare model Systems_Consumer_2 = GridConstructor.Systems.IndependentTechnologies_noGasGrid,
    redeclare model Demand_Consumer_1 = IntegraNet.Consumer.Consumer_combined.Data.Demand_3Tables (
        fileName_el=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/electricity/GC_5.csv"),
        fileName_q_heating=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/heat/GC_5.csv"),
        fileName_q_water=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/tww/GC_5.csv")),
    redeclare model Demand_Consumer_2 = IntegraNet.Consumer.Consumer_combined.Data.Demand_3Tables (
        fileName_el=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/electricity/GC_5.csv"),
        fileName_q_heating=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/heat/GC_5.csv"),
        fileName_q_water=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/tww/GC_5.csv")),
    start_c1=1,
    start_c2=3,
    second_Consumer={true,true},
    second_row=true,
    DHNParameters_Main={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_1={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_2={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    redeclare model HeatTransfer = IntegraNet.Components.Heat.VolumesValvesFittings.Base.HT_Single_Buried_LX,
    dhn_lambda_insulation={0.023,0.023},
    n_elements=2) annotation (Placement(transformation(
        extent={{36,28},{-36,-28}},
        rotation=180,
        origin={-148,18})));
  IntegraNet.GridConstructor.Grid_Constructor GC_2(
    gas_in=false,
    gas_out=false,
    el_out=false,
    dhn_in_s=true,
    dhn_out_s=false,
    dhn_in_r=false,
    dhn_out_r=true,
    Technologies_1={IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),
        IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix()},
    Technologies_2={IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),
        IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix(),IntegraNet.GridConstructor.DataRecords.TechnologyMatrix()},
    CablePipeParameters={IntegraNet.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22,
        losses=0.00007),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22,
        losses=0.00007),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22,
        losses=0.00007),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22,
        losses=0.00007),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),
        IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters(),IntegraNet.GridConstructor.DataRecords.CablePipeParameters()},
    redeclare model Systems_Consumer_1 = GridConstructor.Systems.IndependentTechnologies_noGasGrid,
    redeclare model Systems_Consumer_2 = GridConstructor.Systems.IndependentTechnologies_noGasGrid,
    redeclare model Demand_Consumer_1 = IntegraNet.Consumer.Consumer_combined.Data.Demand_3Tables (
        fileName_el=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/electricity/GC_2.csv"),
        fileName_q_heating=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/heat/GC_2.csv"),
        fileName_q_water=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/tww/GC_2.csv")),
    redeclare model Demand_Consumer_2 = IntegraNet.Consumer.Consumer_combined.Data.Demand_3Tables (
        fileName_el=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/electricity/GC_2.csv"),
        fileName_q_heating=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/heat/GC_2.csv"),
        fileName_q_water=Modelica.Utilities.Files.loadResource("modelica://IntegraNet/Data/Demand/Typology_Profiles/Koeln/2015/T_6/tww/GC_2.csv")),
    start_c1=1,
    start_c2=5,
    second_Consumer={true,true,true,true},
    second_row=true,
    DHNParameters_Main={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_1={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_2={IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),
        IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters(),IntegraNet.GridConstructor.DataRecords.DHNParameters()},
    redeclare model HeatTransfer = IntegraNet.Components.Heat.VolumesValvesFittings.Base.HT_Single_Buried_LX,
    dhn_lambda_insulation={0.023,0.023,0.023,0.023},
    n_elements=4) annotation (Placement(transformation(extent={{-186,166},{-114,222}})));
equation
  connect(HL_1.waterPortIn_return, HL_2.waterPortOut_return) annotation (Line(
      points={{-240,-9.8},{-240,58},{-242,58}},
      color={175,0,0},
      thickness=0.5));
  connect(HL_2.waterPortIn_return, HL_3.waterPortOut_return) annotation (Line(
      points={{-242,78.2},{-242,122},{-241,122}},
      color={175,0,0},
      thickness=0.5));
  connect(HL_2.waterPortOut_supply, HL_3.waterPortIn_supply) annotation (Line(
      points={{-234,78},{-234,122},{-233,122}},
      color={175,0,0},
      thickness=0.5));
  connect(HL_1.waterPortOut_supply, HL_2.waterPortIn_supply) annotation (Line(
      points={{-232,-10},{-234,-10},{-234,58}},
      color={175,0,0},
      thickness=0.5));

  connect(T_ground1.T, realExpression.y) annotation (Line(points={{-422,210},{-437,210}}, color={0,0,127}));
  connect(T_ground1.port, HL_3.heat_return);
  connect(T_ground1.port, HL_3.heat_supply);
  connect(T_ground1.port, HL_2.heat_return);
  connect(T_ground1.port, HL_2.heat_supply);
  connect(T_ground1.port, HL_1.heat_return);
  connect(T_ground1.port, HL_1.heat_supply);
  connect(HL_3.waterPortIn_return, HL_4.waterPortOut_return) annotation (Line(
      points={{-241,142.2},{-241,198}},
      color={175,0,0},
      thickness=0.5));
  connect(HL_3.waterPortOut_supply, HL_4.waterPortIn_supply) annotation (Line(
      points={{-233,142},{-233,198}},
      color={175,0,0},
      thickness=0.5));
  connect(Grid_Return_Out.steam_a, HL_1.waterPortOut_return) annotation (Line(
      points={{-252,-48},{-252,-30},{-240,-30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Grid_Return_In.steam_a, HL_4.waterPortIn_return) annotation (Line(
      points={{-252,254},{-252,218.2},{-241,218.2}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(T_ground1.port, HL_4.heat_return);
  connect(T_ground1.port, HL_4.heat_supply);
  connect(GC_4.epp_p,ElectricGrid. epp) annotation (Line(
      points={{-186,98},{-234,98},{-234,242},{-260,242}},
      color={0,127,0},
      thickness=0.5));
  connect(GC_3.epp_p,ElectricGrid. epp) annotation (Line(
      points={{-304,97},{-234,97},{-234,242},{-260,242}},
      color={0,127,0},
      thickness=0.5));
  connect(GC_2.epp_p,ElectricGrid. epp) annotation (Line(
      points={{-186,180},{-234,180},{-234,242},{-260,242}},
      color={0,127,0},
      thickness=0.5));
  connect(GC_6.epp_p,ElectricGrid. epp) annotation (Line(
      points={{-304,6},{-234,6},{-234,242},{-260,242}},
      color={0,127,0},
      thickness=0.5));
  connect(GC_5.epp_p,ElectricGrid. epp) annotation (Line(
      points={{-184,4},{-234,4},{-234,242},{-260,242}},
      color={0,127,0},
      thickness=0.5));
  connect(GC_1.epp_p,ElectricGrid. epp) annotation (Line(
      points={{-302,178},{-234,178},{-234,242},{-260,242}},
      color={0,127,0},
      thickness=0.5));
  connect(HL_3.waterPortOut_supply, GC_1.waterPortIn_supply) annotation (Line(
      points={{-233,142},{-233,196.667},{-302,196.667}},
      color={175,0,0},
      thickness=0.5));
  connect(HL_3.waterPortOut_supply, GC_2.waterPortIn_supply) annotation (Line(
      points={{-233,142},{-236,142},{-236,198.667},{-186,198.667}},
      color={175,0,0},
      thickness=0.5));
  connect(GC_1.waterPortOut_return, HL_3.waterPortIn_return) annotation (Line(
      points={{-302,187.333},{-241,187.333},{-241,142.2}},
      color={175,0,0},
      thickness=0.5));
  connect(GC_2.waterPortOut_return, HL_3.waterPortIn_return) annotation (Line(
      points={{-186,189.333},{-194,189.333},{-194,187},{-241,187},{-241,142.2}},
      color={175,0,0},
      thickness=0.5));
  connect(GC_3.waterPortIn_supply, HL_2.waterPortOut_supply) annotation (Line(
      points={{-304,115.667},{-294,115.667},{-294,114},{-234,114},{-234,78}},
      color={175,0,0},
      thickness=0.5));
  connect(HL_2.waterPortIn_return, GC_3.waterPortOut_return) annotation (Line(
      points={{-242,78.2},{-242,106.333},{-304,106.333}},
      color={175,0,0},
      thickness=0.5));
  connect(GC_4.waterPortOut_return, HL_2.waterPortIn_return) annotation (Line(
      points={{-186,107.333},{-242,107.333},{-242,78.2}},
      color={175,0,0},
      thickness=0.5));
  connect(GC_4.waterPortIn_supply, HL_2.waterPortOut_supply) annotation (Line(
      points={{-186,116.667},{-234,116.667},{-234,78}},
      color={175,0,0},
      thickness=0.5));
  connect(GC_6.waterPortIn_supply, HL_1.waterPortOut_supply) annotation (Line(
      points={{-304,24.6667},{-232,24.6667},{-232,-10}},
      color={175,0,0},
      thickness=0.5));
  connect(GC_5.waterPortIn_supply, HL_1.waterPortOut_supply) annotation (Line(
      points={{-184,22.6667},{-232,22.6667},{-232,-10}},
      color={175,0,0},
      thickness=0.5));
  connect(GC_6.waterPortOut_return, HL_1.waterPortIn_return) annotation (Line(
      points={{-304,15.3333},{-280,15.3333},{-280,12},{-240,12},{-240,-9.8}},
      color={175,0,0},
      thickness=0.5));
  connect(HL_1.waterPortIn_return, GC_5.waterPortOut_return) annotation (Line(
      points={{-240,-9.8},{-240,13.3333},{-184,13.3333}},
      color={175,0,0},
      thickness=0.5));
  connect(HL_1.waterPortIn_supply, Grid_Supply_Out.steam_a) annotation (Line(
      points={{-232,-30},{-232,-48},{-226,-48}},
      color={175,0,0},
      thickness=0.5));
  connect(Grid_Supply_In.steam_a, HL_4.waterPortOut_supply) annotation (Line(
      points={{-232,256},{-234,256},{-234,218},{-233,218}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-480,-80},{100,320}}), graphics={
        Rectangle(
          extent={{-470,124},{-192,110}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-452,76},{-430,50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-452,106},{-410,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-452,48},{-430,22}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-452,-8},{-430,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-452,20},{-430,-6}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-424,-24},{-356,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-352,-24},{-330,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-232,76},{-210,50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-232,46},{-210,20}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-232,16},{-210,-22}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-406,106},{-380,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-376,106},{-350,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-348,106},{-306,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-302,106},{-260,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-256,106},{-210,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-470,-54},{-192,-68}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-470,122},{-456,-62}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-206,120},{-192,-64}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-326,-24},{-258,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-252,-24},{-210,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-192,286},{-470,300}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-430,226},{-452,252}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-410,256},{-452,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-430,198},{-452,224}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-430,126},{-452,168}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-430,170},{-452,196}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-358,126},{-426,152}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-330,126},{-352,152}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-210,226},{-232,252}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-210,196},{-232,222}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-210,154},{-232,192}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-380,256},{-406,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-350,256},{-376,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-306,256},{-348,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-260,256},{-302,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-210,256},{-256,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-192,108},{-470,122}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-456,114},{-470,298}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-192,112},{-206,296}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-258,126},{-326,152}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-210,126},{-252,152}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-206,124},{72,110}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-188,76},{-166,50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-188,106},{-146,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-188,48},{-166,22}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-188,-8},{-166,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-188,20},{-166,-6}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-162,-24},{-94,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-88,-24},{-66,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,76},{54,50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,46},{54,20}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,16},{54,-22}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-142,106},{-116,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-112,106},{-86,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-84,106},{-42,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,106},{4,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{8,106},{54,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-206,-54},{72,-68}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-206,122},{-192,-62}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{58,120},{72,-64}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,-24},{6,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,-24},{54,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{72,286},{-206,300}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-166,226},{-188,252}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-146,256},{-188,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-166,198},{-188,224}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-166,126},{-188,168}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-166,170},{-188,196}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,126},{-162,152}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-66,126},{-88,152}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,226},{32,252}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,196},{32,222}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,154},{32,192}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-116,256},{-142,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-86,256},{-112,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,256},{-84,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{4,256},{-38,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,256},{8,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{72,108},{-206,122}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-192,114},{-206,298}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{72,112},{56,296}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,126},{-62,152}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,126},{12,152}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-480,-80},{100,320}}), graphics={
        Text(
          extent={{-354,230},{-322,220}},
          lineColor={0,0,0},
          lineThickness=0.5,
          textString="22 m"),
        Text(
          extent={{-356,-30},{-324,-40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          textString="22 m"),
        Text(
          extent={{-164,-30},{-132,-40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          textString="22 m"),
        Text(
          extent={{-152,212},{-120,202}},
          lineColor={0,0,0},
          lineThickness=0.5,
          textString="22 m"),
        Text(
          extent={{-182,334},{-24,226}},
          lineColor={28,108,200},
          textString="Koeln 2015
"),     Text(
          extent={{-82,58},{100,-22}},
          lineColor={0,0,0},
          lineThickness=0.5,
          horizontalAlignment=TextAlignment.Left,
        textString="Block development typology:
inner city development of apartment buildings which 
together form street blocks and
were mainly created around the turn of the century (1900). 
Mainly in the metropolitan inner area with 
direct distance to the city centre. 
Grid-shaped Development with identical orientation of 
opposite building rows.

Cable type: 150 mm²
Avrg. Street Length: 22 m
Transformator: 630 kVA
Service Connections: 32"),
        Rectangle(
          extent={{-88,70},{96,-42}},
          lineColor={0,0,0},
          lineThickness=0.5)}),
    experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-07,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">1. Purpose of model</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of Settlement Topology 6 - Block development</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">2. Level of detail, physical effects considered, and physical insight</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">3. Limits of validity </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">4. Interfaces</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">5. Nomenclature</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">6. Governing Equations</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">7. Remarks for Usage</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">8. Validation</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">9. References</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">10. Version History</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created at GWI by Philipp Huismann (huismann@gwi.essen) on 26.03.2019</span></p>
</html>"),
    __Dymola_experimentSetupOutput(inputs=false, events=false));
end Typology_6_DHN;
