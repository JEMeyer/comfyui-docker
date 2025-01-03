# Use the official Python image from the Docker Hub for AMD64
FROM --platform=$BUILDPLATFORM python:3.10-slim AS base

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone the ComfyUI repo
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /app
# Set the working directory
WORKDIR /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# For https://github.com/jags111/efficiency-nodes-comfyui, which is for https://github.com/StableCanvas/comfyui-client
RUN pip install simpleeval

# Use the NVIDIA CUDA image for AMD64
FROM nvidia/cuda:12.3.2-devel-ubuntu22.04 AS amd64

# Copy base image contents
COPY --from=base /app /app

# Install PyTorch with CUDA support for NVIDIA GPUs
RUN pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121

# Expose the ComfyUI port
EXPOSE 8188

# Set the entrypoint to run ComfyUI
ENTRYPOINT ["python3", "/app/main.py", "--listen"]

# Use the official Python image from the Docker Hub for ARM64
FROM --platform=$BUILDPLATFORM python:3.10-slim AS arm64

# Copy base image contents
COPY --from=base /app /app

# Install PyTorch with CPU support for ARM64
RUN pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/nightly/cpu

# Expose the ComfyUI port
EXPOSE 8188

# Set the entrypoint to run ComfyUI
ENTRYPOINT ["python3", "/app/main.py", "--listen"]
