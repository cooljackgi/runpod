FROM runpod/worker-comfyui:5.1.0-base

# ComfyUI auf neueste Version updaten (für Wan22ImageToVideoLatent u.a.)
RUN cd /comfyui && git fetch origin master && git reset --hard origin/master \
    && pip install -r requirements.txt

# Modell-Verzeichnisse als Symlinks auf das Network Volume zeigen lassen
RUN rm -rf /comfyui/models/vae \
           /comfyui/models/text_encoders \
           /comfyui/models/loras \
           /comfyui/models/diffusion_models \
    && ln -s /runpod-volume/models/vae             /comfyui/models/vae \
    && ln -s /runpod-volume/models/text_encoders   /comfyui/models/text_encoders \
    && ln -s /runpod-volume/models/loras           /comfyui/models/loras \
    && ln -s /runpod-volume/models/diffusion_models /comfyui/models/diffusion_models

# ffmpeg + Video Helper Suite
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*
RUN cd /comfyui/custom_nodes \
    && git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git \
    && pip install -r ComfyUI-VideoHelperSuite/requirements.txt
