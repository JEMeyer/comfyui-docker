# ComfyUI Docker Publisher

This repository automatically publishes Docker images for the [ComfyUI](https://github.com/comfyanonymous/ComfyUI) project whenever updates are pushed to its master branch.

## Images

Two Docker images are published to the GitHub Container Registry for each update:

- `ghcr.io/jemeyer/comfyui:latest` - Image tagged with `latest` pointing to the most recent commit.
- `ghcr.io/jemeyer/comfyui:COMMIT_HASH` - Image tagged with the specific commit hash of the ComfyUI repository.

## Usage

### Docker Run

To use the most recent ComfyUI image, pull the `latest` tag:

```bash
docker run -p 8188:8188 ghcr.io/jemeyer/comfyui
```

This will start ComfyUI and make it accessible at <http://localhost:8188>.

#### GPU Configuration

If you have an NVIDIA GPU and want to use it with ComfyUI, you can pass the --gpus flag to docker run:

- To use all available GPUs:

```bash
docker run --gpus all -p 8188:8188 ghcr.io/jemeyer/comfyui
```

- To use a specific number of GPUs:

```bash
docker run --gpus 2 -p 8188:8188 ghcr.io/jemeyer/comfyui
```

- To use a specific GPU by its device ID (e.g., GPU 2):

```bash
docker run --gpus device=2 -p 8188:8188 ghcr.io/jemeyer/comfyui
```

Note that you need to have the NVIDIA Container Toolkit installed on your host for GPU passthrough to work.

### Docker Compose

You can also use ComfyUI with Docker Compose. Here's an example docker-compose.yml file:

```yaml
services:
  comfyui:
    image: ghcr.io/jemeyer/comfyui:latest
    ports: - 8188:8188
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

This configuration will start a ComfyUI container using the latest image and make it accessible at <http://localhost:8188>. It also configures the container to use 1 GPU.

To use a specific GPU, you can use the device_ids property instead of count:

```yaml
reservations:
  devices:
    - driver: nvidia
      device_ids: ["2"]
      capabilities: [gpu]
```

To use all available GPUs, set count to `all`.

Start the container with:

```bash
docker-compose up -d
```

## Update Schedule

This repository checks for updates to the ComfyUI master branch on a daily basis. If a new commit is detected, and an image for that commit doesn't already exist, a new Docker image will be built and published.

You can also manually trigger the workflow to check for updates immediately.

## Contributing

If you encounter any issues with the published Docker images, please open an issue in this repository.

Pull requests to improve the Docker image build process or the GitHub Actions workflow are welcome!

## License

This project is licensed under the TBD License - see the LICENSE file for details.
