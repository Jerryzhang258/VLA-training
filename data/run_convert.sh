#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
[[ -f ".venv/bin/activate" ]] && source .venv/bin/activate
export XLA_PYTHON_CLIENT_PREALLOCATE="${XLA_PYTHON_CLIENT_PREALLOCATE:-false}"
usage() {
  echo "Usage:"
  echo "  bash data/run_convert.sh --help-converter"
  echo "  bash data/run_convert.sh --in <zarr> --out <out_dir> --name <dataset_name>"
}
if [[ "${1:-}" == "--help-converter" ]]; then
  python scripts/convert_zarr_to_lerobot.py --help
  exit 0
fi
IN=""; OUT=""; NAME=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --in) IN="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    --name) NAME="$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *) echo "[ERROR] Unknown arg: $1"; usage; exit 2;;
  esac
done
[[ -z "$IN" || -z "$OUT" || -z "$NAME" ]] && { echo "[ERROR] Missing args"; usage; exit 2; }
[[ ! -e "$IN" ]] && { echo "[ERROR] Input not found: $IN"; exit 2; }
mkdir -p "$OUT"
python scripts/convert_zarr_to_lerobot.py --in "$IN" --out "$OUT" --name "$NAME"
echo "[OK] done -> $OUT/$NAME"
