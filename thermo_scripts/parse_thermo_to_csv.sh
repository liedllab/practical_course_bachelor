#!/usr/bin/env bash
set -euo pipefail

# Ausgabe-Datei (Default)
OUT_CSV="${1:-thermo_grid_kJmol.csv}"

# Konstanten
EH_TO_KJ=2625.49962   # 1 Eh = 2625.49962 kJ/mol
KCAL_TO_KJ=4.184      # 1 kcal = 4.184 kJ
CAL_TO_KJ=0.004184    # 1 cal/mol*K = 0.004184 kJ/mol*K

# ---- Hilfsfunktionen --------------------------------------------------------

# letzte passende Zeile (case-insensitiv)
last_line() { grep -iE "$1" "$2" | tail -n 1 || true; }

# Zahl direkt VOR einem Einheitstoken (z. B. Eh, kcal/mol, cal/mol*K)
num_before_unit() {
  # $1=patterngrep, $2=unit-regex (z.B. '^Eh$' oder '^kcal'), $3=file
  grep -iE "$1" "$3" | \
  awk -v unitre="$2" '
    BEGIN{IGNORECASE=1}
    {
      for(i=2;i<=NF;i++){
        t=$i; gsub(/[(),:]/,"",t)
        tl=tolower(t)
        if (tl ~ unitre){
          x=$(i-1); gsub(/[^0-9eE+.\-]/,"",x)
          if (x ~ /^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$/){ print x; exit }
        }
      }
    }'
}

# H in kJ/mol
extract_H_kJ() {
  local f="$1" v
  v=$(num_before_unit 'Total[[:space:]]+Enthalpy' '(^eh$|^a[.]u[.]$|^au$|^hartree$)' "$f")
  if [[ -n "$v" ]]; then awk -v eh="$v" -v fac="$EH_TO_KJ" 'BEGIN{printf("%.6f", eh*fac)}'; return; fi
  v=$(num_before_unit 'Total[[:space:]]+Enthalpy' '^kcal' "$f")
  if [[ -n "$v" ]]; then awk -v kcal="$v" -v fac="$KCAL_TO_KJ" 'BEGIN{printf("%.6f", kcal*fac)}'; return; fi
  echo "NA"
}

# G in kJ/mol
extract_G_kJ() {
  local f="$1" v
  v=$(num_before_unit 'Final[[:space:]]+Gibbs[[:space:]]+free[[:space:]]+energy' '(^eh$|^a[.]u[.]$|^au$|^hartree$)' "$f")
  if [[ -n "$v" ]]; then awk -v eh="$v" -v fac="$EH_TO_KJ" 'BEGIN{printf("%.6f", eh*fac)}'; return; fi
  v=$(num_before_unit 'Final[[:space:]]+Gibbs[[:space:]]+free[[:space:]]+energy' '^kcal' "$f")
  if [[ -n "$v" ]]; then awk -v kcal="$v" -v fac="$KCAL_TO_KJ" 'BEGIN{printf("%.6f", kcal*fac)}'; return; fi
  echo "NA"
}

# T,p aus Pfad wie .../T100_P10atm/...
tp_from_path() {
  local path="$1" tag T P
  tag=$(echo "$path" | grep -o 'T[0-9]\+_P[0-9]\+atm' | head -n1 || true)
  if [[ -n "$tag" ]]; then
    T=$(sed -E 's/^T([0-9]+)_P([0-9]+)atm$/\1/' <<<"$tag")
    P=$(sed -E 's/^T([0-9]+)_P([0-9]+)atm$/\2/' <<<"$tag")
    echo "$T,$P"
  else
    echo "NA,NA"
  fi
}

# ---- Hauptteil --------------------------------------------------------------

header="T,p_atm,H_kJ,G_kJ"
TMP_DATA="$(mktemp)"
trap 'rm -f "$TMP_DATA"' EXIT

# Alle .out-Dateien einsammeln (Reihenfolge egal – wir sortieren nachher)
while IFS= read -r -d '' outf; do
  IFS=',' read -r T P <<< "$(tp_from_path "$outf")"

  # nur valide T/P (numerisch) übernehmen
  if [[ "$T" =~ ^[0-9]+$ && "$P" =~ ^[0-9]+$ ]]; then
    H_kJ=$(extract_H_kJ "$outf")
    G_kJ=$(extract_G_kJ "$outf")
    echo "$T,$P,$H_kJ,$G_kJ" >> "$TMP_DATA"
  fi
done < <(find . -type f -name "*.out" -print0)

# Sortierung: nach T (numerisch aufsteigend), dann P (numerisch aufsteigend)
# Hinweis: Willst du T absteigend, ersetze -k1,1n durch -k1,1nr
{
  echo "$header"
  LC_ALL=C sort -t',' -k1,1n -k2,2n "$TMP_DATA"
} > "$OUT_CSV"

echo "Fertig: $OUT_CSV"
