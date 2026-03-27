# RunPod ImagePod

ComfyUI-basierter Worker fuer Bildgenerierung mit persistenten Modellen auf dem RunPod-Volume.

## Setup

### 1. Pod Mount

| Einstellung | Wert |
|---|---|
| Network Volume | auf `/workspace` mounten |
| Port | `8188/http` |
| GPU | kompatibel fuer den aktuellen Torch-Stack, z. B. `4090`, `3090`, `A40`, `A5000` |

### 2. Reset / Faststart

Nach Pod-Reset oder wenn der Laufzeitstand inkonsistent wirkt:

```bash
bash /usr/local/bin/repair_and_start_comfy.sh
```

Das Skript:
- zieht Comfy auf aktuellen `master`
- installiert `requirements.txt` ohne die aktuell kaputten Frontend-Pakete hart zu erzwingen
- versucht `comfyui-frontend-package` und `comfyui-workflow-templates` optional
- setzt die Bild-Modell-Symlinks auf `/workspace/models/...`
- startet Comfy auf `0.0.0.0:8188`

## Erwartete Dateien

- `checkpoints/*.safetensors`
- `loras/*.safetensors`
- `embeddings/*`
- `controlnet/*`
- `clip/*`
- `vae/wan_2.1_vae.safetensors`
- `clip_vision/*`
- `ipadapter/*`
- `insightface/*`

## Hinweis

Nicht per UI auf einem funktionierenden Pod updaten. Updates besser auf einem frischen Test-Pod pruefen.
