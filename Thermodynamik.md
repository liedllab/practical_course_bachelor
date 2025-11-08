<script>
MathJax = {
  tex: {
    inlineMath: [['$', '$'], ['\\(', '\\)']]
  }
};
</script>
<script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>


## Thermodynamik

Nachdem man in ORCA die harmonischen Frequenzen berechnet hat, bekommt man Zugang auf die thermodynamischen Funktionen des Systems. 

Wir erinnern uns hier zurück an die Zustandsfunktionen der Thermodynamik. Ein allgemeines thermodynamisches System wird durch verschiedene Parameter wie Temperatur, Volumen oder Druck beschrieben welche nicht zwingend unabhängig voneinander sind. 

**Innere Energie $U$**

Die innere Energie $U$ ist die für thermodynamische Arbeit verfügbare Energie des Systems. Diese Energie ändert sich, wenn das System mit seiner Umgebung Wärme oder Arbeit austauscht. Die Änderung $\Delta U$ der inneren Energie ist gleich der Summe aus der dem System zugeführten Wärme $Q$ und der Arbeit $W$, die am System verrichtet wird.

$$\Delta U = Q + W$$


**Enthalpie $H$**

Die Enthalpie $H$ ist die Summe der inneren Energie und dem Produkt aus Druck und Volumen:

$$H = U + pV$$

Die Enthalpie ist eine extensive Größe, damit ist die Enthalpie eines Gesamtsystems die Summe der Enthalpien seiner Teilsysteme.

**Helmholtz freie Energie $A$**

Die freie Energie $A$ ist eine weitere extensive Größe definiert als:

$$A = U - TS$$

wobei $T$ die absolute Temperatur und $S$ die Entropie des Systems ist. Die Helmholtz freie Energie ist die Energie, die in einem System bei konstantem Volumen und konstanter Temperatur für Arbeit zur Verfügung steht.

**Gibbs freie Energie $G$**

Die Gibbs Energie eines Systewms ist definiert als:

$$G = H - TS$$

Die Gibbs-Energie kann hierbei als Gleichgewichtskriterium verwendet werden. Beschränkt man sich auf Prozesse bei konstantem Druck und konstanter Temperatur, so nimmt die Gibbs-Energie in einem abgeschlossenen System bei spontanen Prozessen immer ab. Somit gilt für isotherme und isobare Reaktionen:

+ Ist die Gibbs-Energie der Reaktionsprodukte kleiner als die Gibbs-Energie der Ausgangsstoffe ($\Delta G < 0$ ), so läuft die Reaktion freiwillig ab.
+ Ist die Gibbs-Energie der Reaktionsprodukte größer als die Gibbs-Energie der Ausgangsstoffe ($\Delta G > 0$ ), so läuft die Reaktion nicht freiwillig ab.
+ Ist die Gibbs-Energie der Reaktionsprodukte gleich der Gibbs-Energie der Ausgangsstoffe ($\Delta G = 0$ ), so befindet sich das System im Gleichgewicht.

### Zusammenhang mit statistischer Thermodynamik

Für ein kanonisches Ensemble ($N, V, T$ konstant) ist die Zustandssumme $Q$ definiert als:

$$ Q = \sum_i g_i e^{-\frac{E_i}{k_B T}} $$

Diese Zustandssumme kann man mit den thermodynamischen Funktionen in Verbindung bringen:

$$ A = -k_B T \ln(Q) $$

$$S = k_B \ln(Q) + k_B T \left(\frac{\partial \ln(Q)}{\partial T}\right)_{N,V} $$

$$E = k_B T^2 \left(\frac{\partial \ln(Q)}{\partial T}\right)_{N,V} $$

Für ein mehratomiges Gas kann man die Zustandssumme näherungsweise über den Zusammenhang,

$$Q = \frac{(q_{trans} + q_{rot} + q_{vib} + q_{elec})^N}{N!}$$

beschrieben werden. Trifft man die Annahme das die Kernwellenfunktion während der chemischen Reaktion nicht verändert wird so ist die Kernzustandssumme $q_{nuc} = 1$. Die elektronische Zustandssumme $q_{elec}$ wird über folgenden Zusammenhang bestimmt:

$$q_{elec} = e^{\frac{D_e}{k_B T}} (w_{e_1} + w_{e_2} e^{-\frac{\Delta E_{12}}{k_B T}} + w_{e_3} e^{-\frac{\delta E_{13}}{k_B T}} + ...)$$

Hier ist $D_e$ die elektronische Grundszustandsenergie in Bezug auf isolierte Kerne und Elektronen und $w_{e_i}$ die Entartung des elektronischen Zustands mit $i$ der Spinmultiplizität und $\Delta E_{ij}$ die Energieunterschiede zwischen den elektronischen Zuständen.

Die Vibtrationszustandssumme $q_{vib}$ ist gegeben über:

$$q_{vib} = \prod_i^\lambda \frac{e^{-\frac{\Theta_{v_j}}{2T}}}{1 - e^{-\frac{\Theta_{v_j}}{T}}}$$

wobei die charakteristische Temperatur $\Theta_{v_j}$ definiert ist als:

$$\Theta_{v_j} = \frac{h \nu_j}{k_B}$$

Zur Notation: Hier ist $j$ der Index für de Schwingung mit Frequenz $\nu_j$ und $\lambda$ die Anzahl der Schwingungsfreiheitsgrade. Die Vibrationsenergie ist gequantelt und für die Nullpunktsschwingung $T=0$ exestiert eine Nullpunktsenergie (ZPE).

Die Rotationszustandssumme $q_{rot}$ ist gegeben durch:

$$q_{rot} = \frac{\sqrt{\pi}}{\sigma} \left(\frac{T^{3/2}}{\Theta_{r_A} \Theta_{r_B} \Theta_{r_C}}\right)^{1/2}$$

Hierbei sind $\Theta_{r_i}$ die charakteristischen Rotations-Temperaturen definiert als:

$$\Theta_{r_i} = \frac{h^2}{8 \pi^2 I_i k_B}$$

In der Formel sind $I_A,I_B,I_C$ die Hauptträgheitsmomente die sich als Eigenwerte des Trgäheitstensors bestimmen lassen. Zuletzt ergibt sich die Translationszustandssumme als:

$$q_{trans} = \left(\frac{2 \pi M k_B T}{h^2} \right)^{3/2} V$$

Hierbei ist $M$ die Masse des Moleküls und $V$ das Volumen des Systems. Für Chemiker ist der isotherme-isobare Fall ($N,T,p$ konstant) von größerem Interesse hier gilt:

$$H = E + pV = E + nRT$$

und damit $G = A + nRT$. In der klassischen Thermodynamik ergibt sich die Gleichgewichtskonstante $K_p$ aus:

$$\Delta G^0 = -RT \ln(K_p)$$

## Analyse der Thermodynamik in Orca

Nach einer Frequenzberechnung erhält man die thermodynamischen Funktion wie die Enthalpie $H$ die Entropy $S$ und die Gibbs Energie $G$ im Output-File.

```text
! MP2 6-311G(d,p) OPT FREQ NUMFREQ
* xyz 0 1
 O  0.000000  0.000000  0.000000
  H  0.758602  0.000000  0.504284
  H  0.758602  0.000000  -0.504284
*
```

Der Input-File oben ist ein beispiel für eine Geometrieoptimierung gefolgt von einer Frequenzberechnung. Hier wurde die **MP2** Methode mit dem **6-311G(d,p)** Basissatz verwendet. 

Im Output-File findet man nach Block über das IR-Spectrum den Abschnitt zur Thermochemie

```text
--------------------------
THERMOCHEMISTRY AT 298.15K
--------------------------

Temperature         ...   298.15 K
Pressure            ...     1.00 atm
Total Mass          ...    18.02 AMU
Quasi RRHO          ...     True
Cut-Off Frequency   ...     1.00 cm^-1

Throughout the following assumptions are being made:
  (1) The electronic state is orbitally nondegenerate
  (2) There are no thermally accessible electronically excited states
  (3) Hindered rotations indicated by low frequency modes are not
      treated as such but are treated as vibrations and this may
      cause some error
  (4) All equations used are the standard statistical mechanics
      equations for an ideal gas
  (5) All vibrations are strictly harmonic

freq.    1666.81  E(vib)   ...       0.00 
freq.    3904.64  E(vib)   ...       0.00 
freq.    4012.16  E(vib)   ...       0.00 
````

In dieser ersten Section sieht man die Temperatur, den Druck und die Gesamtmasse des Systems, sowie die Annahmen die bei der Berechnung der thermodynamischen Funktionen getroffen wurden.


```text
------------
INNER ENERGY
------------

The inner energy is: U= E(el) + E(ZPE) + E(vib) + E(rot) + E(trans)
    E(el)   - is the total energy from the electronic structure calculation
              = E(kin-el) + E(nuc-el) + E(el-el) + E(nuc-nuc)
    E(ZPE)  - the the zero temperature vibrational energy from the frequency calculation
    E(vib)  - the the finite temperature correction to E(ZPE) due to population
              of excited vibrational states
    E(rot)  - is the rotational thermal energy
    E(trans)- is the translational thermal energy

Summary of contributions to the inner energy U:
Electronic energy                ...    -76.26397189 Eh
Zero point energy                ...      0.02183308 Eh      13.70 kcal/mol
Thermal vibrational correction   ...      0.00000244 Eh       0.00 kcal/mol
Thermal rotational correction    ...      0.00141627 Eh       0.89 kcal/mol
Thermal translational correction ...      0.00141627 Eh       0.89 kcal/mol
-----------------------------------------------------------------------
Total thermal energy                    -76.23930382 Eh
````

Zuerst erfolgt die Berechnung der inneren ENergie $U$. Die elektronische Energie ist hierbei die letzte Single-Point Energie aus der Geometrieoptimierung. Der nächste Block zeigt dann die Berechnung der Enthalpie $H$:

```text
--------
ENTHALPY
--------

The enthalpy is H = U + kB*T
                kB is Boltzmann's constant
Total thermal energy              ...    -76.23930382 Eh 
Thermal Enthalpy correction       ...      0.00094421 Eh       0.59 kcal/mol
-----------------------------------------------------------------------
Total Enthalpy                    ...    -76.23835962 Eh
````
Final sieht man noch die Werte für die Entropie $S$ sowie die Gibbs Energie $G$:

```text
-------
ENTROPY
-------

The entropy contributions are T*S = T*(S(el)+S(vib)+S(rot)+S(trans))
     S(el)   - electronic entropy
     S(vib)  - vibrational entropy
     S(rot)  - rotational entropy
     S(trans)- translational entropy
The entropies will be listed as multiplied by the temperature to get
units of energy

Electronic entropy                ...      0.00000000 Eh      0.00 kcal/mol
Vibrational entropy               ...      0.00000274 Eh      0.00 kcal/mol
Rotational entropy                ...      0.00497245 Eh      3.12 kcal/mol
Translational entropy             ...      0.01644380 Eh     10.32 kcal/mol
-----------------------------------------------------------------------
Final entropy term                ...      0.02141899 Eh     13.44 kcal/mol


-------------------
GIBBS FREE ENERGY
-------------------

The Gibbs free energy is G = H - T*S

Total enthalpy                    ...    -76.23835962 Eh 
Total entropy correction          ...     -0.02141899 Eh    -13.44 kcal/mol
-----------------------------------------------------------------------
Final Gibbs free energy         ...    -76.25977861 Eh

For completeness - the Gibbs free energy minus the electronic energy
G-E(el)                           ...      0.00419328 Eh      2.63 kcal/mol
```
### Aufgabe 4
Um den Einfluss von Temperatur und Druck auf die Thermodynamik der Reaktion zu beurteilen,
müssen die thermodynamischen Größen für verschiedene Bedingungen berechnet werden konkret in einem Raster zwischen 100 und 1000 K und einen Druckbereich zwischen 1 und 100
atm betrachten. Um eine solche Aufgabe manuell abzuarbeiten, muss ein Überblick über sehr
viele Dateien behalten werden. Es bietet sich an die Aufgabe über ein script zu automatisieren.
Ein solches script führt Befehle in ähnlicher Weise aus, wie Sie es direkt in einer Konsole per
Tastatureingabe machen, jedoch automatisiert. Sie müssen im script lediglich im Vorhinein
bestimmen, welche Befehle auszuführen sind. In dieser Aufgabe werden sie ein script in der
bash Sprache schreiben. 

Ein solches Skript wird Ihnen von uns zur Verfügung gestellt, soll sie aber nicht davon abhalten es selber zu versuchen. Folgende Schritte sind im Skript enthalten:

- Lege das p/T Raster fest und erstelle für jeden Punkt einen Ordner.
- Erstelle aus dem zugehörigen .inp File für jeden Rasterpunkt eine Orcainput welcher mit dem zugehörigen .hess File die thermodynamischen Größen zu diesem Punkt errechnet.
- Lasse die Rechnungen aufsteigend laufen.
- Extrahiere die Bedingungen und die thermodynamischen Größen und übertrage sie in ein eigen .csv file. 

Die Auswertung erfolgt ähnlich zur Code-along session in einem Jupyter Notebook. Wenden Sie gerne ihr gewonnenes Wissen an um die Plots zu individualisieren. Um Ihnen bei der Übersicht zu helfen, ist das Notebook größtenteil(!) vorgefertigt.

### Verständnisfragen

+ Was sind die Definitionen der thermodynamischen Funktionen $U, H, A, G$?
+ Wie hängt die Gibbs Energie mit dem Gleichgewicht und der Aktivierungsenergie zusammen?


