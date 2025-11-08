<script>
MathJax = {
  tex: {
    inlineMath: [['$', '$'], ['\\(', '\\)']]
  }
};
</script>
<script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>

## Quantenmechanik Teil

Jedem Praktikumsteilnehmer wird in diesem Teil eine Reaktion zugewiesen, welche im Verlauf des Praktikums näher untersucht wird. Dazu werden verschiedene Quantenchemische-Rechnungen und Methoden angewandt, um Eigenschaften der Moleküle zu bestimmen.


+ **Aufgabe 1** [Optimierung der Molekülgeometrie](Optimierung.html)
+ **Aufgabe 2** [Untersuchung der Potential-Hyperfläche](Potentialhyperflaeche.html)
+ **Aufgabe 3** [Frequenzberechnung (Schwingungsspektroskopie, Infrarot)](Frequenzberechnung.html)
+ **Aufgabe 4** [Thermodynamik](Thermodynamik.html)
+ **Linux Tutorial** [Linux Tutorial](Linux-Tutorial.html)
+ **Orca Tipps** [Orca Tipps](Orca_Tipps.html) 
+ **Plotten und Auswerten mit Python** [Plotten und Auswerten mit Python](Programming.html)

### Grundlagen Orca 

Orca ist ein Quantenchemie-Paket, welches verschiedene Methoden im Bereich der Elektronenstrukturtheorie implementiert hat. Die Software ist für akademische Zwecke frei verfügbar und wird im Rahmen des Praktikums verwendet. Unter [https://www.faccts.de/docs/orca/6.1/tutorials/](https://www.faccts.de/docs/orca/6.1/tutorials/) finden sich verschiedene Tutorials und Beispiele für die Anwendung von Orca.

**Grundlegende Struktur eines Inputfiles**

Folgendes Beispiel gibt die grundlegende Struktur eines Inputfiles wieder:

```text
!HF DEF2-SVP
%SCF
   MAXITER 500
END
* xyz 0 1
O   0.0000   0.0000   0.0626
H  -0.7920   0.0000  -0.4973
H   0.7920   0.0000  -0.4973
*
``` 

Das `!` startet den __Main Input__, spezifische Optionen können mit `%` angegeben werden. Wichtig ist hierbei, dass der Input-Reader nicht case-sensitiv ist. Man kann also sowohl Groß- als auch Kleinbuchstaben verwenden.

In der **Structure-Section** nach dem Main-Input wird die Molekülgeometrie angegeben. Dies wird durch ein `*` separiert, xyz steht hierbei für kartesische Koordinaten, die erste Zahl ist die Gesamtladung des Moleküls, die zweite die Spinmultiplizität $(2S+1)$ des Systems.

**Starten einer Orca Rechnung**

Im Praktikumsraum können Sie die Orca Rechnung direkt über die Kommandozeile starten. Für unser Wassermolekül mit dem Inputfile `water.inp` geben Sie folgenden Befehl ein:

```bash
orca water.inp > water.out &
```

Der `&` am Ende des Befehls sorgt dafür, dass die Rechnung im Hintergrund läuft und Sie die Kommandozeile weiter verwenden können. Mittels des `>`Symbols wird die Ausgabe der Rechnung in die Datei `water.out` umgeleitet.




**Beispiel einer Single-Point Energieberechung von Wasser**

Im folgenden Beispiel wird eine Single-Point Energie für ein Wassermolekül mit der HF-SCF-Methode berechnet. Hierbei wird ein 6-311G(d,p) Basissatz verwendet. 

Bei HF-SCF wird die Roothan-Hall Gleichung $\mathbb{F}C = SCE$ iterativ gelöst. Ein typischer SCF-Ablauf hat die folgenden Schritte:

1. Berechnung von Ein- und Zwei-Elektronen Integralen
2. Erzeugung von MO-Koeffizienten
3. Aufbau der Dichte-Matrix
4. Bildung der Fock-Matrix
5. Diagonalisierung der Fock-Matrix. Als Ergebnis erhält man die Eigenvektoren als neue MO-Koeffizienten und die Eigenwerte als Orbitalenergien.
6. Bildung der neuen Dichte-Matrix und Iteration bis zur Konvergenz

Orca verwendet das SHARK Integral Package welches die Berechnung von Integralen und den Aufbau der Fock-Matrix übernimmt. 

```text

----------------------
SHARK INTEGRAL PACKAGE
----------------------

Number of atoms                             ...      3
Number of basis functions                   ...     30
Number of shells                            ...     16
Maximum angular momentum                    ...      2
Integral batch strategy                     ... SHARK/LIBINT Hybrid
RI-J (if used) integral strategy            ... SPLIT-RIJ (Revised 2003 algorithm where possible)
Printlevel                                  ...      1
Contraction scheme used                     ... SEGMENTED contraction
Prescreening option                         ... SCHWARTZ
   Thresh                                   ... 1.000e-10
   Tcut                                     ... 1.000e-11
   Tpresel                                  ... 1.000e-11 
Coulomb Range Separation                    ... NOT USED
Exchange Range Separation                   ... NOT USED
Multipole approximations                    ... NOT USED
Finite Nucleus Model                        ... NOT USED
CABS basis                                  ... NOT available
Auxiliary Coulomb fitting basis             ... NOT available
Auxiliary J/K fitting basis                 ... NOT available
Auxiliary Correlation fitting basis         ... NOT available
Auxiliary 'external' fitting basis          ... NOT available

Checking pre-screening integrals            ... done (  0.0 sec) Dimension = 16
   => SHARK Basis and OBASIS are compatible. Storing Pre-screening
Shell pair information
Shell pair cut-off parameter TPreSel        ...   1.0e-11
Total number of shell pairs                 ...       136
Shell pairs after pre-screening             ...       136
Total number of primitive shell pairs       ...       462
Primitive shell pairs kept                  ...       412
          la=0 lb=0:     55 shell pairs
          la=1 lb=0:     50 shell pairs
          la=1 lb=1:     15 shell pairs
          la=2 lb=0:     10 shell pairs
          la=2 lb=1:      5 shell pairs
          la=2 lb=2:      1 shell pairs

Checking whether 4 symmetric matrices of dimension 30 fit in memory
:Max Core in MB      =   4096.00
 MB in use           =      1.33
 MB left             =   4094.67
 MB needed           =      0.01
 Data fit in memory  = YES
Calculating Nuclear repulsion               ... done (  0.0 sec) ENN=      4.948484244558 Eh

Diagonalization of the overlap matrix:
Smallest eigenvalue                        ... 9.229e-02
Time for diagonalization                   ...    0.000 sec
Threshold for overlap eigenvalues          ... 1.000e-07
Number of eigenvalues below threshold      ... 0
Time for construction of square roots      ...    0.000 sec
Total time needed                          ...    0.000 sec
``` 

Nach dem Initial Guess der Dichte-Matrix startet der SCF-Zyklus:

```text

-------------------------------------------------------------------------------------------
                                      ORCA LEAN-SCF
                              memory conserving SCF solver
-------------------------------------------------------------------------------------------

----------------------------------------D-I-I-S--------------------------------------------
Iteration    Energy (Eh)           Delta-E    RMSDP     MaxDP     DIISErr   Damp  Time(sec)
-------------------------------------------------------------------------------------------
               ***  Starting incremental Fock matrix formation  ***
                              *** Initializing SOSCF ***
---------------------------------------S-O-S-C-F--------------------------------------
Iteration    Energy (Eh)           Delta-E    RMSDP     MaxDP     MaxGrad    Time(sec)
--------------------------------------------------------------------------------------
    1    -75.6711022519212833     0.00e+00  2.81e-06  2.69e-05  3.75e-06     0.0
               *** Restarting incremental Fock matrix formation ***
    2    -75.6711022560086661    -4.09e-09  1.98e-06  2.51e-05  1.92e-05     0.0
    3    -75.6711022570074192    -9.99e-10  1.61e-06  1.68e-05  5.11e-06     0.0
                 **** Energy Check signals convergence ****

               *****************************************************
               *                     SUCCESS                       *
               *           SCF CONVERGED AFTER   3 CYCLES          *
               *****************************************************
``` 

Hier sieht man die einzelnen Iterationen des SCF-Zyklus mit Änderung der Energie dem Gradienten der Dichte-Matrix und der Zeit pro Iteration. DIIS steht hierbei für **Direct Inversion in the Iterative Subspace** und ist eine Extrapolationsmethode um die Konvergenz des SCF-Zyklus zu beschleunigen. Am Ende der Rechnung wird dann die Totale SCF-Energie sowie die einzelnen Beiträge ausgegeben:

```text
----------------
TOTAL SCF ENERGY
----------------

Total Energy       :        -75.67110225725240 Eh           -2059.11538 eV

Components:
Nuclear Repulsion  :          4.94848424455810 Eh             134.65510 eV
Electronic Energy  :        -80.61958650181050 Eh           -2193.77048 eV
One Electron Energy:       -114.72652604113830 Eh           -3121.86749 eV
Two Electron Energy:         34.10693953932780 Eh             928.09701 eV

Virial components:
Potential Energy   :       -150.64383457679941 Eh           -4099.22714 eV
Kinetic Energy     :         74.97273231954702 Eh            2040.11176 eV
Virial Ratio       :          2.00931498581016
``` 

