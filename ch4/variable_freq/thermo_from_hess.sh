#!/usr/bin/env bash
set -euo pipefail

# === Settings ===
ORCA_BIN="${ORCA_BIN:-orca}"
JOBTAG="${JOBTAG:-thermo}"
ORCA_HEADER="${ORCA_HEADER:-! PrintThermoChem}"

# Temperatur/Druck Raster
T_START=100; T_END=1000; T_STEP=100
P_LIST=(1 10 20 30 40 50 60 70 80 90 100)

# === Findet .inp und .hess im aktuellen working directory ===
shopt -s nullglob
inps=( *.inp );  [[ ${#inps[@]}  -gt 0 ]] || { echo "Fehler: keine *.inp gefunden";  exit 1; }
hess=( *.hess ); [[ ${#hess[@]} -gt 0 ]] || { echo "Fehler: keine *.hess gefunden"; exit 1; }
INP_SOURCE="${inps[0]}"
HESS_SOURCE="${hess[0]}"
shopt -u nullglob

# === Inline-*xyz*-Block aus dem .inp extrahieren ===
geom_start_line="$(grep -n -Ei '^[[:space:]]*\*[[:space:]]*xyz([[:space:]]|$)' -- "$INP_SOURCE" | grep -vi 'xyzfile' | head -n1 | cut -d: -f1 || true)"
[[ -n "$geom_start_line" ]] || { echo "Fehler: keine inline '* xyz' Geometrie im INP gefunden"; exit 1; }

geom_block="$(tail -n +${geom_start_line} -- "$INP_SOURCE" | awk '
  {
    print $0
    if ($0 ~ /^[[:space:]]*\*[[:space:]]*$/) exit
  }')"

# === Abfrage Orca geladen ===
command -v "$ORCA_BIN" >/dev/null 2>&1 || { echo "Fehler: ORCA '"$ORCA_BIN"' nicht im PATH"; exit 1; }

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
      printf "%s\n" "$geom_block"
    } > "$INP"

    echo ">> ORCA: T=${T} K, p=${P} atm"
    "$ORCA_BIN" "$INP" > "$OUT"
  done
done

echo "Fertig. Ergebnisse in ./T*_P*atm/"
