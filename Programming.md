<script>
MathJax = {
  tex: {
    inlineMath: [['$', '$'], ['\\(', '\\)']]
  }
};
</script>
<script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>

## Plotten und Auswerten mit Python

Im Github Repository des Praktikums finden sie im Ordner `additional_notebooks` verschiedene Jupyter Notebooks, welche Ihnen den Einstieg in die Datenanalyse und das Plotten mit Python erleichtern sollen.

Die Notebooks können Sie lokal auf Ihrem Rechner oder im Praktikumsraum ausführen. Um Python und Jupyter Notebooks zu verwenden, empfehlen wir die Installation von [Anaconda](https://www.anaconda.com/products/distribution), welches eine Python-Distribution mit vielen nützlichen Paketen für Wissenschaftliches Rechnen und Datenanalyse ist.

Im Github-Repository finden Sie eine `enviroment.yml` Datei, welche die wichtigsten Pakete für klassische Datenanalyse in Python enthält. Sie können diese Datei verwenden um eine neue Anaconda-Umgebung zu erstellen:

```bash
conda env create -f environment.yml
```

