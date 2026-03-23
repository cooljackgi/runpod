FROM runpod/worker-comfyui:5.1.0-base

# ComfyUI auf neueste Version updaten (für Wan22ImageToVideoLatent u.a.)
RUN cd /comfyui && git fetch origin master && git reset --hard origin/master \
    && pip install -r requirements.txt

# Modell-Verzeichnisse als Symlinks auf das tatsaechliche RunPod-Volume zeigen lassen
RUN rm -rf /comfyui/models/vae \
           /comfyui/models/text_encoders \
           /comfyui/models/loras \
           /comfyui/models/diffusion_models \
    && ln -s /workspace/models/vae               /comfyui/models/vae \
    && ln -s /workspace/models/text_encoders     /comfyui/models/text_encoders \
    && ln -s /workspace/models/loras             /comfyui/models/loras \
    && ln -s /workspace/models/diffusion_models  /comfyui/models/diffusion_models

# ffmpeg + Video Helper Suite (build 2)
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*
RUN cd /comfyui/custom_nodes \
    && git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git \
    && pip install -r ComfyUI-VideoHelperSuite/requirements.txt
