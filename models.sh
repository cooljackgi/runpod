#!/bin/bash
# Modelle ins Network Volume laden
# Einmalig ausführen auf einem Pod mit gemountem Volume (/runpod-volume)
# Voraussetzung: huggingface-cli installiert, HF_TOKEN gesetzt falls nötig

BASE="https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files"
DEST="/runpod-volume/models"

mkdir -p "$DEST/diffusion_models" "$DEST/text_encoders" "$DEST/vae" "$DEST/loras"

echo "→ Downloading diffusion models (FP8, ~10 GB each)..."
wget -q --show-progress -O "$DEST/diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors" \
  "$BASE/diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors"

wget -q --show-progress -O "$DEST/diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors" \
  "$BASE/diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors"

echo "→ Downloading text encoder (~5 GB)..."
wget -q --show-progress -O "$DEST/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors" \
  "$BASE/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"

echo "→ Downloading VAE..."
wget -q --show-progress -O "$DEST/vae/wan_2.1_vae.safetensors" \
  "$BASE/vae/wan_2.1_vae.safetensors"

echo "→ Downloading LightX2V LoRAs (Turbo, 4 Steps)..."
wget -q --show-progress -O "$DEST/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors" \
  "$BASE/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors"

wget -q --show-progress -O "$DEST/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors" \
  "$BASE/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors"

echo "✓ Fertig. Alle Modelle in $DEST"
du -sh "$DEST"
