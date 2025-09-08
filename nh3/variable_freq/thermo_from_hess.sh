#!/usr/bin/env bash
set -euo pipefail

# ===== USER SETTINGS =====
ORCA_BIN="${ORCA_BIN:-orca}"                 # z.B. /opt/orca/orca
INP_SOURCE="${INP_SOURCE:-job.inp}"          # vorhandenes ORCA-Input (mit * xyz ... oder * xyzfile ...)
HESS="${HESS:-job.hess}"                     # zugehörige Hessian
JOBTAG="${JOBTAG:-thermo}"                   # Basistag für erzeugte Jobs
ORCA_HEADER="${ORCA_HEADER:-! PrintThermoChem}"
DEBUG="${DEBUG:-0}"

# ===== CHECKS =====
[[ -f "$INP_SOURCE" ]] || { echo "Fehler: INP '$INP_SOURCE' nicht gefunden."; exit 1; }
[[ -f "$HESS"       ]] || { echo "Fehler: HESS '$HESS' nicht gefunden."; exit 1; }
command -v "$ORCA_BIN" >/dev/null 2>&1 || { echo "Fehler: ORCA '$ORCA_BIN' nicht im PATH."; exit 1; }

INP_DIR="$(cd "$(dirname "$INP_SOURCE")" && pwd)"
INP_BASENAME="$(basename "$INP_SOURCE")"
TMPDIR="$(mktemp -d)"; trap 'rm -rf "$TMPDIR"' EXIT

to_unix() { tr -d '\r'; }

# ===== Quelle normieren =====
INP_NORM="$TMPDIR/inp.norm"
to_unix < "$INP_SOURCE" > "$INP_NORM"

# ===== Geometrie + CHARGE/MULT extrahieren =====
CHARGE="${CHARGE:-}"
MULT="${MULT:-}"
GEOM_XYZ="$TMPDIR/geom.xyz"

# --- 1) bevorzugt: * xyzfile ---
line_xyzfile="$(grep -i -m1 '^[[:space:]]*\*[[:space:]]*xyzfile' "$INP_NORM" || true)"
if [[ -n "$line_xyzfile" ]]; then
  [[ "$DEBUG" == "1" ]] && { echo ">> DEBUG: xyzfile-Zeile: $line_xyzfile"; }

  # charge/mult NACH 'xyzfile' holen
  read -r CHARGE MULT < <(
    echo "$line_xyzfile" | awk '{
      il=tolower($0);
      # Position hinter "xyzfile"
      if (match(il,/^[[:space:]]*\*[[:space:]]*xyzfile[[:space:]]*/)) {
        rest=substr($0, RSTART+RLENGTH);
        n=split(rest,a,/[[:space:]]+/);
        c=""; m="";
        for(i=1;i<=n;i++){
          if (a[i] ~ /^[+-]?[0-9]+$/){ if(c==""){c=a[i]} else {m=a[i]; break} }
        }
        if(c!="" && m!=""){ print c, m }
      }
    }'
  )
  [[ -n "${CHARGE:-}" && -n "${MULT:-}" ]] || { echo "Fehler: Konnte charge/mult aus '* xyzfile' nicht lesen."; exit 1; }

  # xyz-Datei finden (erstes Token, das auf .xyz endet)
  XYZ_SRC="$(echo "$line_xyzfile" | awk '{
    for(i=1;i<=NF;i++){ if($i ~ /\.xyz([[:space:]]|$)/){ print $i; exit } }
  }')"
  [[ -n "$XYZ_SRC" ]] || { echo "Fehler: Konnte XYZ-Datei aus '* xyzfile' nicht bestimmen."; exit 1; }
  [[ "$XYZ_SRC" = /* ]] || XYZ_SRC="$INP_DIR/$XYZ_SRC"
  [[ -f "$XYZ_SRC" ]] || { echo "Fehler: XYZ '$XYZ_SRC' nicht gefunden."; exit 1; }

  to_unix < "$XYZ_SRC" > "$GEOM_XYZ"

  # Falls die Kopfzeilen fehlen → gültiges XYZ erzeugen
  if ! head -n1 "$GEOM_XYZ" | grep -qE '^[[:space:]]*[0-9]+'; then
    grep -E '^[[:space:]]*[A-Za-z]([[:space:]]+[+-]?[0-9]*\.?[0-9]+){3}([[:space:]]+.*)?$' "$GEOM_XYZ" > "$TMPDIR/coords.clean"
    N_ATOMS=$(wc -l < "$TMPDIR/coords.clean")
    [[ "$N_ATOMS" -gt 0 ]] || { echo "Fehler: Keine Atomzeilen in '$XYZ_SRC'."; exit 1; }
    { echo "$N_ATOMS"; echo "Extracted from xyzfile in $INP_BASENAME"; cat "$TMPDIR/coords.clean"; } > "$GEOM_XYZ"
  fi

else
  # --- 2) Fallback: * xyz (inline) ---
  line_xyz_inline="$(grep -i -m1 '^[[:space:]]*\*[[:space:]]*xyz[[:space:]]' "$INP_NORM" | grep -vi 'xyzfile' || true)"
  [[ -n "$line_xyz_inline" ]] || { echo "Fehler: Weder '* xyzfile' noch '* xyz' gefunden."; exit 1; }
  [[ "$DEBUG" == "1" ]] && { echo ">> DEBUG: xyz-inline-Zeile: $line_xyz_inline"; }

  # charge/mult EXPLIZIT nach 'xyz' parsen (erste zwei Integers NACH dem Wort 'xyz')
  read -r CHARGE MULT < <(
    echo "$line_xyz_inline" | awk '{
      il=tolower($0);
      if (match(il,/^[[:space:]]*\*[[:space:]]*xyz[[:space:]]*/)) {
        rest=substr($0, RSTART+RLENGTH);
        n=split(rest,a,/[[:space:]]+/);
        c=""; m="";
        for(i=1;i<=n;i++){
          if (a[i] ~ /^[+-]?[0-9]+$/){ if(c==""){c=a[i]} else {m=a[i]; break} }
        }
        if(c!="" && m!=""){ print c, m }
      }
    }'
  )
  if [[ -z "${CHARGE:-}" || -z "${MULT:-}" ]]; then
    echo "Fehler: Konnte charge/mult aus '* xyz' nicht lesen."
    echo "Hinweis: Du kannst CHARGE und MULT auch direkt setzen, z.B.: CHARGE=0 MULT=1 ..."
    exit 1
  fi

  # Koordinatenblock extrahieren (bis zur nächsten Zeile mit nur '*')
  awk '
    {
      line=$0; il=tolower(line)
      if (grab==0 && il ~ /^[[:space:]]*\*[[:space:]]*xyz([[:space:]]|$)/ && il !~ /xyzfile/) { grab=1; next }
      if (grab==1) {
        if (line ~ /^[[:space:]]*\*[[:space:]]*$/) { exit }
        print line
      }
    }
  ' "$INP_NORM" | to_unix > "$TMPDIR/coords.raw"

  grep -E '^[[:space:]]*[A-Za-z]([[:space:]]+[+-]?[0-9]*\.?[0-9]+){3}([[:space:]]+.*)?$' "$TMPDIR/coords.raw" > "$TMPDIR/coords.clean"
  N_ATOMS=$(wc -l < "$TMPDIR/coords.clean")
  [[ "$N_ATOMS" -gt 0 ]] || { echo "Fehler: Keine Atomzeilen im * xyz Block."; exit 1; }
  { echo "$N_ATOMS"; echo "Extracted inline geometry from $INP_BASENAME"; cat "$TMPDIR/coords.clean"; } > "$GEOM_XYZ"
fi

# ===== Koordinaten für Inline-*xyz* vorbereiten =====
if head -n1 "$GEOM_XYZ" | grep -qE '^[[:space:]]*[0-9]+'; then
  COORDS="$TMPDIR/coords.inline"
  tail -n +3 "$GEOM_XYZ" | to_unix > "$COORDS"
else
  COORDS="$GEOM_XYZ"
fi

[[ -n "$CHARGE" && -n "$MULT" ]] || { echo "Fehler: CHARGE oder MULT leer."; exit 1; }
[[ "$DEBUG" == "1" ]] && { echo ">> DEBUG: charge=$CHARGE mult=$MULT"; echo ">> DEBUG: erste 5 Koordinatenzeilen:"; head -n 5 "$COORDS"; }

# ===== Raster: T=100..1000 K (100er), p=1,10..100 atm =====
for T in $(seq 100 100 1000); do
  for P in 1 $(seq 10 10 100); do
    DIR="T${T}_P${P}atm"
    mkdir -p "$DIR"
    INP="${DIR}/${JOBTAG}_T${T}_P${P}.inp"
    OUT="${DIR}/${JOBTAG}_T${T}_P${P}.out"
    HLOCAL="${DIR}/hessian.hess"

    cp -f "$HESS" "$HLOCAL"

    {
      printf "%s\n\n" "$ORCA_HEADER"
      printf "%%geom\n  InHessName \"%s\"\nend\n\n" "$HLOCAL"
      printf "%%freq\n  Temp %d\n  Pressure %d\nend\n\n" "$T" "$P"
      printf "* xyz %s %s\n" "$CHARGE" "$MULT"
      cat "$COORDS"
      printf "*\n"
    } > "$INP"

    [[ "$DEBUG" == "1" ]] && { echo ">> DEBUG: schreibe $INP"; head -n 20 "$INP"; }

    echo ">> Running ORCA for T=${T} K, p=${P} atm ..."
    "$ORCA_BIN" "$INP" > "$OUT"
  done
done

echo "Fertig. Ergebnisse in ./T*_P*atm/"
