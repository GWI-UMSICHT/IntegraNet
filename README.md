### Basisdaten
**Projektname:** ```IntegraNet```

**Projektbeschreibung:**
> ...

**Projektstart:** ...

**Abgabedatum:** ...

**Projektstatus:** ...

___
### UMSICHT-Sicht
**Projektleitung:** ...

**Stellv. Projektleitung:** ...

___
### GWI-Sicht

**Projektleitung:** ...

**Stellv. Projektleitung:** ...

___
### Projekt-Sicht
**Programmierer:** ...

**Abhängigkeiten:**
Die Integranet-Bibliothek verwendet Komponenten folgender Bibliotheken:
* TransiEnt 1.0.0
* ClaRa 1.2.1
* TILMedia

**Entwicklungsumgebung:** Dymola 2017 (FD01)

**Programmiersprache:** Modelica

**Produktivumgebung:** ...

**Einrichtung der Entwicklungsumgebung:**
1. Installation der TransiEnt-Bibliothek in Dymola:
    1. Herunterladen der ClaRa-Bibliothek, der loadTransiEnt.mos und Readme.txt vom Projektserver
    2. Bibliothek und Dateien unter $DYMOLA\Modelica\Library ablegen
    3. In denselben Ordner das Transient-Repository klonen
       URL: https://gitlab-extern.umsicht.fraunhofer.de/IntegraNet/TransiEnt.git
    4. Installation der TransiEnt-Bibliothek anhand der mitgelieferten Readme-Datei
2. Anpassung des TransiEnt-Startskripts "loadTransiEnt.mos":
	1. repopath auf Bibliotheksordner setzen
z.B. repopath="C:/Program Files (x86)/Dymola 2017 FD01/Modelica/Library";
	2. resultpath auf result-Ordner des Integranet-Repositories setzen
z.B. resultpath="D:/IntegraNet/results";
    3. "TransiEnt 1.0.0" in den Dateipfaden durch "TransiEnt" ersetzen
3. Anpassung des Dymola-Startskripts "$DYMOLA\insert\dymola.mos":
	1. Aufruf des TransiEnT-Startskripts "loadTransiEnt.mos" mit RunScript einfügen
    Zum Beispiel:

    //Load TransiEnt Library
    RunScript("C:\Program Files (x86)\Dymola 2017 FD01\Modelica\Library\loadTransiEnt.mos", true);

	2. Aufruf des IntegraNet-Startskripts "loadIntegraNet.mos" mit RunSkript einfügen
    (Das Skript ist im Repository auf oberster Ebene hinterlegt)
    Zum Beispiel:

    //Load IntegraNet Library
    RunScript("D:\IntegraNet\loadIntegraNet.mos", true);
4. Anpassung der Dymola-Konfigurationsdatei "$DYMOLA\insert\dymodraw.ini":
    Änderung der Speichereinstellung von neuen Packages, damit diese in einer Ordnerstruktur statt in einer Datei gespeichert werden
    Neue Einstellung:

    Dymola5StoreOnOneFile 0
    \# Dymola5StoreOnOneFile 1
	
	In neuerer Dymola-Version entferne Häckchen unter Edit -> Options -> Flags... -> Advanced -> File -> DefaultStoreAsOneFile
5. Setze Max line length in verwendeter Dymola-Version auf 1000 (Options -> Text Editor -> Max line length)