<script>
MathJax = {
  tex: {
    inlineMath: [['$', '$'], ['\\(', '\\)']]
  }
};
</script>
<script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>

## Nomodeco - Normalmodenzerlegung

Das Standardverfahren zur quantenmechanischen Berechnung von Schwingungsfrequenzen basiert auf der **harmonischen Näherung**. Hierbei wird die Potentialfläche um die Minimumsgeometrie durch eine Taylor-Reihe bis zur zweiten Ableitung approximiert. Durch das Diagonalisieren der massengewichteten Hesse-Matrix erhält man die **Normalmoden** und die entsprechenden **Schwingungsfrequenzen**.

Für viele fortgeschrittene Anwendungen, z.b der anharmonischen Frequenzberechnung oder der Berechnung von multidimensionalen Potentialhyperflächen zeigen diese Normalmoden jedoch einige Einschränkungen:

+ Durch die harmonische Näherung ist die akkurate Beschreibung von **Schwingungsmoden nur in der Nähe des Minimums möglich**
+ Die Normalmoden sind **gekoppelt** und **delokalisiert** dies erschwert sowohl die Interpretation als auch Formulierung des zugehörigen Hamiltonoperators.

Wir verwenden in diesem Teil des Praktikums die Software `Nomodeco` welche durch einen Algorithmus optimale interne Koordinaten für ein gegebenes Molekül konstruiert. Diese sind **optimal** im Sinne von maximaler Entkopplung der Schwingungsmoden und des zugehörigen Vibrationsraums.

### Primitive Interne Koordinaten

> Primitive Interne Koordinaten (ICs) sind geometrische Parameter wie Änderungen in Bindungslängen, Bindungswinkel und Diederwinkel. Diese sind direkt mit der Molekülgeometrie verbunden und können über die kartesischen Koordinaten der Atomkerne berechnet werden.

Die folgende Abbildung zeig die verschiedenen internen Koordinaten welche in `Nomodeco` implementiert sind.

+ **Bonds:** Änderung der Bindungslänge $\vec{r}_{ab}$ 
+ **In-plane angles:** Änderung des Bindungswinkel $\phi$
+ **Linear angles:** Spezielle Winkelkoordinate für lineare Moleküle (zb $\text{CO}_2$) $\phi'$
+ **Dihedrals:** Änderung im Diederwinkel $\tau$
+ **Out-of-plane angles:** Änderung im Winkel der durch drei koplanare Atome definiert wird $\gamma$

![alt text](figures/prim_ic.png)

## Transformation zu Internen Koordinaten

Ein Molekül mit $N$ Atomen hat $3N$ kartesische und $S = 3N-6(5)$ interne Koordinaten $\vec{R}$. 

$$\vec{X} = (x_1,y_1,z_1,...,x_N,y_N,z_N)^T$$

$$\vec{R} = (r_1,...,r_S)^T$$

Die Transformation von **kartesischen** in **interne Koordinaten** erfolgt über die **Wilson B-Matrix**:

$$\vec{R} = \mathbf{B} \cdot \vec{X}$$

Die potentielle Energie eines Moleküls ergibt sich aus den Kraftkonstanten, welche die zweiten Ableitungen der potentiellen Energie nach den jeweiligen Koordinatern sind.

$$f_{ij} = \frac{\partial^2 E}{\partial x_i \partial x_j}$$

$$F_{ij} = \frac{\partial^2 E}{\partial r_i \partial r_j}$$

Durch die $\mathbf{B}$ Matrix kann man also durch eine Ähnlichkeitstransformation die 










