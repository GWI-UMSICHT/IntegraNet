#Dokumentation
##Auswahl von Wetterdaten
Die Wetterdaten werden zentral im `simCenter` im Reiter `Ambience`definiert. Dort kann das Modell `ambientConditions` redeklariert werden, in dem die Wetterdaten (Globalstrahlung, Direktstrahlung, Diffusstrahlung, Temperatur, Windgeschwindigkeit) spezifiziert sind.  
  
In der TransiEnt-Bibliothek sind bisher keine Modelle hinterlegt, die von dem Basismodell erben, sodass über das Dropdown-Menü nur das Basismodell `ambientConditions` ausgewählt werden kann. Über das Edit-Icon können dann die Strahlungs-, Temperatur- und Winddaten ausgewählt werden. Vorausgewählt sind jeweils leere Modelle.  

Da es mühsam und fehleranfällig ist, alle Strahlungs-, Temperatur- und Winddaten getrennt auszuwählen, bietet es sich an, Modelle zu erstellen, die vom Basismodell `ambientConditions` erben und darin die Strahlungs-, Temperatur- und Winddaten für eine Region und ein bestimmtes Jahr vorzudefinieren.  
  
Um eigene Modelle in IntegraNet zu definieren, wurden in der IntegraNet-Ordnerstruktur dieselben Ordner angelegt, wie sie auch in der TransiEnt-Bibliothek zu finden sind.
Unter `IntegranNet\Basics\Tables\Ambient` können die Tabellen für Strahlungs-, Temperatur- und Winddaten hinterlegt werden. Hier wurde bisher die TMY-Temperaturen für Hamburg hinterlegt, da in der TransiEnt-Bibliothek zwar TMY-Strahlungs- und Winddaten, jedoch keine Temperaturen hinterlegt waren. So kann nun ein einheitlicher TMY-Datensatz für Hamburg definiert werden. 
Bei den Strahlungsdaten müssen die diffuse und globale horizontale Strahlung und die direkte normale  Strahlung hinterlegt werden.
  
Unter `IntegraNet\Components\Boundaries\Ambient` können die Modelle, die im simCenter auswählbar sind und die einzelnen Daten bündeln, erstellt werden.

