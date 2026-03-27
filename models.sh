#!/bin/bash
set -euo pipefail

# Einmalig auf einem Pod mit gemountetem /workspace-Volume ausfuehren.
# Laedt nur den aktuellen WAN-14B-I2V-Minimalsatz.

BASE="${BASE:-https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files}"
DEST="${DEST:-/workspace/models}"

mkdir -p "$DEST/diffusion_models" "$DEST/text_encoders" "$DEST/vae" "$DEST/loras"

download_if_missing() {
  local relative_path="$1"
  local target="$DEST/$relative_path"
  local source="$BASE/$relative_path"
  if [ -s "$target" ]; then
    echo "Schon da: $target"
    return
  fi
  echo "Lade: $relative_path"
  wget --show-progress -O "$target" "$source"
}

download_if_missing "diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors"
download_if_missing "diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors"
download_if_missing "text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"
download_if_missing "vae/wan_2.1_vae.safetensors"
download_if_missing "loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors"
download_if_missing "loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors"

echo
echo "Fertig. Inhalte:"
find "$DEST" -maxdepth 2 -type f | sort
