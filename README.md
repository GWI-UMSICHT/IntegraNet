## IntegraNet Library, version 1.0.0

Licensed by Fraunhofer UMSICHT and GWI Essen e.V. under Modelica License 2.     
Copyright 2021, Fraunhofer UMSICHT and GWI Essen e.V.                           
                                                                                 
IntegraNet is a research project supported by the German                        
Federal Ministry of Economics and Energy (FKZ 0324027).                         
The IntegraNet Library research team consists of the following project partners:
Fraunhofer Institute for Environmental, Safety and Energy Technology UMSICHT,   
Gas- und Wärme-Institut Essen e.V.                                              
and is supported by XRG Simulation GmbH (Hamburg, Germany)                                          

___
### UMSICHT
**Project-Lead:** ...

___
### GWI

**Project-Lead:** ...

___
### Project

**Dependencies:**
The Integranet library uses components from the following Modelica libraries:
* TransiEnt 1.3.0
* ClaRa 1.5.0
* TILMedia

**Development environment:** Dymola

**Programming language:** Modelica

**Installation:**
Many models of the IntegraNet library build on models from the TransiEnt Library and will not work without simultaneously loading the TransiEnt library. You can download it under https://www.tuhh.de/transient-ee/


1. Copy the unzipped library files to your preferred folder
----------------------------------------
Currently, only DYMOLA provides full suppport of IntegraNet. The development team has tested all models carefully using DYMOLA 2019 FD01 and DYMOLA 2020x.



2. Open the Library
----------------------------------------
The TransiEnt library needs to be loaded via the mos script loadTransiEnt.mos which is provided with the TransiEnt download. 
Set the paths as described in the TransiEnt readme and add the following line to the script to open the IntegraNet library along with the TransiEnt library:

openModel("YOURPATH\IntegraNet\package.mo", changeDirectory=false);

Alternatively you can load the IntegraNet library manually after loading the TransiEnt library (in DYMOLA via File → Open and File → Load, respectively).




*******************************************
Contact:	
info@integranet.energy

  
