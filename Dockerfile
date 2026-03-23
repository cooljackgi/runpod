FROM runpod/worker-comfyui:5.1.0-base

# Video Helper Suite (für VHS_VideoCombine Node in WAN 2.2 I2V Workflow)
RUN comfy-node-install comfyui-videohelpersuite
