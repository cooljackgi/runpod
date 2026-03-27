FROM runpod/worker-comfyui:5.1.0-base

# Bild-Pod auf demselben stabilen worker-comfyui-Stack wie der WAN-Pod.
# Modelle liegen persistent auf /workspace/models oder /runpod-volume/models.
WORKDIR /workspace/chat+bild

COPY link_workspace_models.sh /usr/local/bin/link_workspace_models.sh
COPY repair_and_start_comfy.sh /usr/local/bin/repair_and_start_comfy.sh

RUN cd /comfyui \
    && git fetch origin master \
    && git reset --hard origin/master \
    && grep -v -E "comfyui-frontend-package|comfyui-workflow-templates" requirements.txt > /tmp/requirements-basic.txt \
    && pip install -r /tmp/requirements-basic.txt \
    && pip install comfyui-frontend-package comfyui-workflow-templates || true \
    && chmod +x /usr/local/bin/link_workspace_models.sh /usr/local/bin/repair_and_start_comfy.sh

RUN mkdir -p /workspace /runpod-volume \
    && rm -rf /workspace/models \
    && ln -s /runpod-volume/models /workspace/models \
    && /usr/local/bin/link_workspace_models.sh

EXPOSE 8188
CMD ["/usr/local/bin/repair_and_start_comfy.sh"]
