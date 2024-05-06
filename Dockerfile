FROM nvidia/cuda:12.3.2-devel-ubuntu22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip

# Clone the ComfyUI repo
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /app

# Set the working directory
WORKDIR /app

# Install Python dependencies
RUN pip3 install -r requirements.txt

# Install PyTorch with CUDA support for NVIDIA GPUs
RUN pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121

# Expose the ComfyUI port
EXPOSE 8188

# Set the entrypoint to run ComfyUI
ENTRYPOINT ["python3", "main.py", "--listen"]
