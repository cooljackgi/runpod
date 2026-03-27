# RunPod Serverless - WAN 2.2 I2V

ComfyUI-basierter Worker fuer WAN 2.2 Image-to-Video.

## Setup

### 1. Network Volume befuellen

Einmalig einen Pod mit gemountetem `/workspace` starten und ausfuehren:

```bash
bash /usr/local/bin/models.sh
```

Oder im Repo:

```bash
bash models.sh
```

### 2. Serverless / Pod Mount

| Einstellung | Wert |
|---|---|
| Network Volume | auf `/workspace` mounten |
| Port | `8188/http` |
| GPU | kompatibel fuer den aktuellen Torch-Stack, z. B. `L40S`, `L40`, `A40`, `H100` |

### 3. Reset / Faststart

Nach Pod-Reset oder wenn der Laufzeitstand inkonsistent wirkt:

```bash
bash /usr/local/bin/repair_and_start_comfy.sh
```

Das Skript:
- zieht Comfy auf aktuellen `master`
- installiert `requirements.txt`
- installiert `comfyui-frontend-package` und `comfyui-workflow-templates`
- setzt die vier Modell-Symlinks auf `/workspace/models/...`
- startet Comfy auf `0.0.0.0:8188`

## Erwartete Dateien

- `diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors`
- `diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors`
- `text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors`
- `vae/wan_2.1_vae.safetensors`
- `loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors`
- `loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors`

## Hinweis

Nicht per UI auf einem funktionierenden Pod updaten. Updates besser auf einem frischen Test-Pod pruefen.
