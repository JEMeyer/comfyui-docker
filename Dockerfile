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

# Set up virtual environment and install shared dependencies
RUN python -m venv /venv && \
    /venv/bin/pip install --no-cache-dir -r requirements.txt simpleeval

# Add virtual environment to PATH
ENV PATH="/venv/bin:$PATH"

# Use the NVIDIA CUDA image for AMD64
FROM nvidia/cuda:12.3.2-devel-ubuntu22.04 AS amd64

# Copy application and shared Python environment from base
COPY --from=base /app /app
COPY --from=base /venv /venv

# Add virtual environment to PATH
ENV PATH="/venv/bin:$PATH"

# Install PyTorch with CUDA support for NVIDIA GPUs
RUN pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121

# Expose the ComfyUI port
EXPOSE 8188

# Set the entrypoint to run ComfyUI
ENTRYPOINT ["python", "/app/main.py", "--listen"]

# Use the official Python image from the Docker Hub for ARM64
FROM --platform=$BUILDPLATFORM python:3.10-slim AS arm64

# Copy application and shared Python environment from base
COPY --from=base /app /app
COPY --from=base /venv /venv

# Add virtual environment to PATH
ENV PATH="/venv/bin:$PATH"

# Install PyTorch with CPU support for ARM64
RUN pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/nightly/cpu

# Expose the ComfyUI port
EXPOSE 8188

# Set the entrypoint to run ComfyUI
ENTRYPOINT ["python", "/app/main.py", "--listen"]
