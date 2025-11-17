#!/usr/bin/env bash
set -euo pipefail

# === Settings ===
ORCA_BIN="${ORCA_BIN:-orca}"
JOBTAG="${JOBTAG:-thermo}"
ORCA_HEADER="${ORCA_HEADER:-! PrintThermoChem}"
XYZ_FILE="${XYZ_FILE:-}"   # Optional: feste XYZ-Datei setzen

# Temperatur/Druck Raster
T_START=100; T_END=1000; T_STEP=100
P_LIST=(1 10 20 30 40 50 60 70 80 90 100)

# === Eingaben abfragen ===
read -rp "Ladung = " CHARGE
read -rp "Multiplizität = " MULT
# Minimal-Validierung
if [[ -z "${MULT//[0-9]/}" && "${MULT}" -lt 1 ]]; then
  echo "Hinweis: Multiplizität < 1 ist unphysikalisch. Setze auf 1 (Singulett)."
  MULT=1
fi

# === Dateien suchen ===
shopt -s nullglob
hess=( *.hess )
if [[ -z "${XYZ_FILE}" ]]; then
  xyzs=( *.xyz )
else
  xyzs=( "$XYZ_FILE" )
fi
shopt -u nullglob

[[ ${#xyzs[@]} -gt 0 ]] || { echo "Fehler: keine *.xyz gefunden (oder XYZ_FILE ungültig)"; exit 1; }
[[ ${#hess[@]}  -gt 0 ]] || { echo "Fehler: keine *.hess gefunden"; exit 1; }

XYZ_SOURCE="${xyzs[0]}"
HESS_SOURCE="${hess[0]}"
echo "XYZ-Datei: $XYZ_SOURCE"
echo "HESS-Datei: $HESS_SOURCE"

# === ORCA vorhanden? ===
command -v "$ORCA_BIN" >/dev/null 2>&1 || { echo "Fehler: ORCA '$ORCA_BIN' nicht im PATH"; exit 1; }

# === Hilfsfunktionen ===
read_first_nonempty_line() {
  awk 'NF{print; exit}' -- "$1"
}

is_orca_style() {
  # true, wenn erste nicht-leere Zeile wie "* xyz ..." aussieht
  local line
  line="$(read_first_nonempty_line "$1" | tr '[:upper:]' '[:lower:]')"
  [[ "$line" =~ ^[[:space:]]*\*[[:space:]]*xyz([[:space:]]|$) ]]
}

extract_orca_coords() {
  # nimmt Inhalt zwischen Header "* xyz ..." und schließender "*" (nur Stern) auf
  awk '
    BEGIN{inblock=0}
    NF==0{ if(inblock){print} next }
    /^[[:space:]]*\*[[:space:]]*xyz([[:space:]]|$)/I {inblock=1; next}
    /^[[:space:]]*\*[[:space:]]*$/ {if(inblock){exit} }
    { if(inblock){print} }
  ' -- "$1"
}

extract_xyz_coords() {
  # Standard-XYZ: Zeile 1 = N, Zeile 2 = Kommentar, dann N Zeilen Koordinaten
  local N
  N="$(head -n1 -- "$1" | awk '{print $1}')"
  [[ "$N" =~ ^[0-9]+$ ]] || { echo "Fehler: erste Zeile von $1 ist keine Zahl (Standard-XYZ erwartet)"; exit 1; }
  tail -n +3 -- "$1" | head -n "$N"
}

count_lines() { awk 'END{print NR}' ; }

# === Koordinaten extrahieren ===
coords=""
if is_orca_style "$XYZ_SOURCE"; then
  coords="$(extract_orca_coords "$XYZ_SOURCE")"
  # optional: vorhandene q/m im Header ignorieren, da wir User-Eingabe verwenden
else
  coords="$(extract_xyz_coords "$XYZ_SOURCE")"
fi

# Minimalcheck
num_lines="$(printf "%s\n" "$coords" | count_lines)"
if [[ "$num_lines" -lt 1 ]]; then
  echo "Fehler: keine Koordinaten aus $XYZ_SOURCE gelesen"; exit 1
fi

# === Raster laufen lassen ===
for (( T=T_START; T<=T_END; T+=T_STEP )); do
  for P in "${P_LIST[@]}"; do
    DIR="T${T}_P${P}atm"
    mkdir -p "$DIR"
    cp -f -- "$HESS_SOURCE" "$DIR/hessian.hess"

    INP="${DIR}/${JOBTAG}_T${T}_P${P}.inp"
    OUT="${DIR}/${JOBTAG}_T${T}_P${P}.out"

    {
      echo "$ORCA_HEADER"
      echo
      echo "%geom"
      echo "  InHessName \"$(pwd)/$DIR/hessian.hess\""
      echo "end"
      echo
      echo "%freq"
      echo "  Temp $T"
      echo "  Pressure $P"
      echo "end"
      echo
      echo "* xyz $CHARGE $MULT"
      printf "%s\n" "$coords"
      echo "*"
    } > "$INP"

    echo ">> ORCA: T=${T} K, p=${P} atm"
    "$ORCA_BIN" "$INP" > "$OUT"
  done
done

echo "Fertig. Ergebnisse in ./T*_P*atm/"
