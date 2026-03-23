FROM runpod/worker-comfyui:5.1.0-base

# ComfyUI auf aktuellen Stand ziehen und die kritischen Pakete vorinstallieren,
# damit Pods nach Reset nicht in einen Mischzustand aus altem Checkout und
# neuem Manager / fehlenden Templates laufen.
RUN cd /comfyui \
    && git fetch origin master \
    && git reset --hard origin/master \
    && pip install -r requirements.txt \
    && pip install comfyui-frontend-package comfyui-workflow-templates

# Modell-Verzeichnisse standardmaessig auf das gemountete /workspace-Volume zeigen lassen.
RUN mkdir -p /workspace/models/diffusion_models /workspace/models/text_encoders /workspace/models/vae /workspace/models/loras \
    && rm -rf /comfyui/models/vae \
              /comfyui/models/text_encoders \
              /comfyui/models/loras \
              /comfyui/models/diffusion_models \
    && ln -s /workspace/models/vae               /comfyui/models/vae \
    && ln -s /workspace/models/text_encoders     /comfyui/models/text_encoders \
    && ln -s /workspace/models/loras             /comfyui/models/loras \
    && ln -s /workspace/models/diffusion_models  /comfyui/models/diffusion_models

# ffmpeg + Video Helper Suite
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*
RUN cd /comfyui/custom_nodes \
    && git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git \
    && pip install -r ComfyUI-VideoHelperSuite/requirements.txt

COPY models.sh /usr/local/bin/models.sh
COPY repair_and_start_comfy.sh /usr/local/bin/repair_and_start_comfy.sh
RUN chmod +x /usr/local/bin/models.sh /usr/local/bin/repair_and_start_comfy.sh
