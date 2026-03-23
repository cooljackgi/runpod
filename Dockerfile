FROM runpod/worker-comfyui:5.1.0-base

# ComfyUI auf neueste Version updaten (für Wan22ImageToVideoLatent u.a.)
RUN cd /comfyui && git fetch origin master && git reset --hard origin/master \
    && pip install -r requirements.txt

# extra_model_paths.yaml nach git reset wiederherstellen (zeigt auf Network Volume)
COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml

# ffmpeg + Video Helper Suite
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*
RUN cd /comfyui/custom_nodes \
    && git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git \
    && pip install -r ComfyUI-VideoHelperSuite/requirements.txt
