#!/bin/bash
set -euo pipefail

COMFY_DIR="${COMFY_DIR:-/comfyui}"
WORKSPACE_MODELS="${WORKSPACE_MODELS:-/workspace/models}"
RUNPOD_MODELS="${RUNPOD_MODELS:-/runpod-volume/models}"
PYTHON_BIN="${PYTHON_BIN:-/opt/venv/bin/python}"
HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-8188}"

resolve_models_root() {
  if [ -d "$WORKSPACE_MODELS" ]; then
    printf '%s\n' "$WORKSPACE_MODELS"
    return
  fi
  if [ -d "$RUNPOD_MODELS" ]; then
    printf '%s\n' "$RUNPOD_MODELS"
    return
  fi
  printf '%s\n' "$WORKSPACE_MODELS"
}

MODELS_ROOT="$(resolve_models_root)"

cd "$COMFY_DIR"
git fetch origin master
git reset --hard origin/master

"$PYTHON_BIN" -m pip install -r "$COMFY_DIR/requirements.txt"
"$PYTHON_BIN" -m pip install comfyui-frontend-package comfyui-workflow-templates

mkdir -p \
  "$MODELS_ROOT/diffusion_models" \
  "$MODELS_ROOT/text_encoders" \
  "$MODELS_ROOT/vae" \
  "$MODELS_ROOT/loras"

rm -rf \
  "$COMFY_DIR/models/diffusion_models" \
  "$COMFY_DIR/models/text_encoders" \
  "$COMFY_DIR/models/vae" \
  "$COMFY_DIR/models/loras"

ln -s "$MODELS_ROOT/diffusion_models" "$COMFY_DIR/models/diffusion_models"
ln -s "$MODELS_ROOT/text_encoders" "$COMFY_DIR/models/text_encoders"
ln -s "$MODELS_ROOT/vae" "$COMFY_DIR/models/vae"
ln -s "$MODELS_ROOT/loras" "$COMFY_DIR/models/loras"

echo "Verwende Modellpfad: $MODELS_ROOT"
echo "Verifiziere Modelle:"
find "$MODELS_ROOT" -maxdepth 2 -type f | sort

pkill -f "python main.py" || true
exec "$PYTHON_BIN" "$COMFY_DIR/main.py" --listen "$HOST" --port "$PORT"
