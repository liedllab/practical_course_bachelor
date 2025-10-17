<script>
MathJax = {
  tex: {
    inlineMath: [['$', '$'], ['\\(', '\\)']]
  }
};
</script>
<script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>

# Orca Tipps

Folgende Seite präsentiert einige nützliche Tipps und Tricks für die Arbeit mit dem Quantenchemie-Paket Orca.

## Zur Struktur eines Inputfiles

```text
! HF def2-TZVP

%scf
   convergence tight
end

* xyz 0 1
C  0.0  0.0  0.0
O  0.0  0.0  1.13
*
```

In einem Orca-Input File werden die Keywords mit einem `!` eingeleitet. Dort kann man dann beispielsweise die Methode den Basisatz und verschiedene Algorithmen wie Geometrieoptimierung oder Frequenzberechnung angeben.

Mittels `%` und `end` können spezifische Optionen für verschiedene Module angebeben. So wird im obigen Biespiel die SCF-Konvergenz auf "tight" gesetzt. Man kann in einen Inputfile kommentare mit dem `#` Zeichen einfügen.

```text
# Dies ist ein Kommentar im Inputfile
```

Man hat die Möglichkeit folgende Blöcke mit `%` zu verwenden:

+ `%scf` - Optionen für das SCF-Modul
+ `%geom` - Optionen für Geometrieoptimierung
+ `%freq` - Optionen für Frequenzberechnung
+ `%pal` - Optionen für Multiprocessing
+ `%basis` - Definition von Basissätzen


## Überblick über die wichtigsten Methoden und und Runtypes

Folgende Aufzählung gibt einen Überblick über die wichtigsten Keywords welche mit `!` angegeben werden können:

+ `HF` - Hartree-Fock Methode
+ `DFT` - Dichtefunktionaltheorie
+ `MP2` - Møller-Plesset Störungstheorie zweiter Ordnung
+ `CCSD` - Coupled-Cluster mit Einzel- und Doppelanregungen
+ `CCSD(T)` - Coupled-Cluster mit Singles, Doubles und perturbativen Triples
+ `OPT` - Geometrieoptimierung mit redundant internal Coordinates
+ `FREQ` - Frequenzberechnung
+ `NUMFREQ` - Numerische Frequenzberechnung
+ `SP` - Single-Point Energie Berechnung

## Coordinaten Input in Orca

Koordinaten können entweder direkt im Input-File angegeben werden oder man lädt sie aus einer externen Datei. Man hat sowohl die Möglichkeit kartesische Koordinaten als auch Z-matrizen zu verwenden.

Die Kartesichen Koordinaten werden im `* xyz` Block angegeben hierzu hat man folgende Struktur:

```text
* xyz Charge Multiplicity
Atom1   x1  y1  z1
Atom2   x2  y2  z2
 ...
*
```

> **Note** Man gibt hier immer die Multiplizität des Systems an welche durch $2S+1$ definiert ist, mit $S$ als Gesamtspin des Systems. Möchte man beispielsweise $O_2$ im Triplett-Zustand berechnen (was dem Grundzustand entspricht) so gibt man `* xyz 0 3` an.



## Multiprocessing in Orca

In Orca kann man mehrere Prozessoren für eine Berechnung verwenden um die Rechenzeit zu verkürzen. Dies basiert auf OpenMPI welches ein Message Passing Interface ist und Routinen für die parallele Programmierung im High-Performance-Computing (HPC) bereitstellt. In Orca selbst kann man durch die Angabe von `%pal` im Input file die Anzahl der Prozessoren definieren. 

```text
!HF DEF2-SVP
%PAL NPROCS 28 END
```

Mit dieser Option muss man für die Ausführung von Orca den ganzen Pfad zum Programm angeben. Den File-Path bekommt man in Linux durch den Befehl `which orca`. Das Programm kann dan wie folgt gestartet werden:

```bash
$ ./full/path/to/orca input.inp > output.out
```

Grundsätzlich sind alle Hauptmodule in Orca paralellisiert, je nach Methode und Basissatz kann die Skalierung jedoch varrieren. Folgende Abbildung zeigt beispielsweise die Skalierung der Rechenzeit für eine Single-Point Energie Berechnung von der Aminosäure Alanin mit der Coupled-Cluster Methode CCSD und einen cc-pVDZ Basissatz.

![alt text](/figures/image.png)

## Global Memory Usage

Einige Module in Orca wie beispielsweise die korrelierte Methoden brauchen eine große Menge an Scratch Array. Dies wird ziemlich sicher im Rahmen des Praktikums keine Probleme bereiten man kann jedoch Global allen Modulen eine bestimmte Menge an Scratch Memory zuweisen. Dieses Limit wird dann für jeden Prozessor gesetzt:

```text 
%MaxCore 4000
````

Dies setzt zum Beispiel ein Limit von 4000 MB pro Prozessor.

