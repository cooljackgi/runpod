# RunPod Serverless — WAN 2.2 I2V

ComfyUI-basierter Serverless Worker für WAN 2.2 Image-to-Video Generierung.

## Setup

### 1. Network Volume befüllen

Einmalig einen günstigen Pod (z.B. RTX 3090) mit dem Network Volume mounten
und `models.sh` ausführen:

```bash
bash models.sh
```

Benötigter Speicher: ~40 GB

### 2. Serverless Endpoint einrichten

| Einstellung | Wert |
|---|---|
| GPU | L40S (48 GB) empfohlen, RTX 4090 für kurze Clips |
| Min Workers | 0 |
| Max Workers | 3 |
| Execution Timeout | **1800s** |
| FlashBoot | **ON** |
| Network Volume | auf `/runpod-volume` mounten |
| Container Disk | 20 GB |

### 3. Input-Format

```json
{
  "input": {
    "workflow": { "...ComfyUI API Workflow JSON..." },
    "images": [
      { "name": "input.png", "image": "base64-encoded-png" }
    ]
  }
}
```

### 4. Output-Format

```json
{
  "output": {
    "images": [
      { "filename": "output_00001_.mp4", "type": "base64", "data": "..." }
    ]
  }
}
```

## Modelle

Alle Modelle von `Comfy-Org/Wan_2.2_ComfyUI_Repackaged` auf HuggingFace:

| Datei | Pfad |
|---|---|
| `wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors` | `models/diffusion_models/` |
| `wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors` | `models/diffusion_models/` |
| `umt5_xxl_fp8_e4m3fn_scaled.safetensors` | `models/text_encoders/` |
| `wan_2.1_vae.safetensors` | `models/vae/` |
| `wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors` | `models/loras/` |
| `wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors` | `models/loras/` |
