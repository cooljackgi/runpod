#!/bin/bash
set -euo pipefail

COMFY_DIR="${COMFY_DIR:-/comfyui}"
WORKSPACE_MODELS="${WORKSPACE_MODELS:-/workspace/models}"
PYTHON_BIN="${PYTHON_BIN:-/opt/venv/bin/python}"
HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-8188}"

cd "$COMFY_DIR"
git fetch origin master
git reset --hard origin/master

"$PYTHON_BIN" -m pip install -r "$COMFY_DIR/requirements.txt"
"$PYTHON_BIN" -m pip install comfyui-frontend-package comfyui-workflow-templates

mkdir -p \
  "$WORKSPACE_MODELS/diffusion_models" \
  "$WORKSPACE_MODELS/text_encoders" \
  "$WORKSPACE_MODELS/vae" \
  "$WORKSPACE_MODELS/loras"

rm -rf \
  "$COMFY_DIR/models/diffusion_models" \
  "$COMFY_DIR/models/text_encoders" \
  "$COMFY_DIR/models/vae" \
  "$COMFY_DIR/models/loras"

ln -s "$WORKSPACE_MODELS/diffusion_models" "$COMFY_DIR/models/diffusion_models"
ln -s "$WORKSPACE_MODELS/text_encoders" "$COMFY_DIR/models/text_encoders"
ln -s "$WORKSPACE_MODELS/vae" "$COMFY_DIR/models/vae"
ln -s "$WORKSPACE_MODELS/loras" "$COMFY_DIR/models/loras"

echo "Verifiziere Modelle:"
find "$WORKSPACE_MODELS" -maxdepth 2 -type f | sort

pkill -f "python main.py" || true
exec "$PYTHON_BIN" "$COMFY_DIR/main.py" --listen "$HOST" --port "$PORT"
