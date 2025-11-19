# CISIS Multi-Architecture Builds

This repository includes GitHub Actions workflows for building CISIS on multiple architectures.

## Supported Platforms

- **Linux AMD64** (Intel/AMD x86_64)
- **Linux ARM64** (ARM64v8, AWS Graviton, Apple Silicon)
- **macOS Intel** (x86_64)
- **macOS Apple Silicon** (ARM64)

## Automated Builds

### Continuous Integration
- Builds triggered on push to `main`/`master`
- Builds triggered on pull requests
- Artifacts uploaded for each platform

### Releases
- Create a tag: `git tag v1.0.0 && git push --tags`
- Automatic release with binaries for all platforms
- Docker images pushed to GitHub Container Registry

## Manual Build

### Local Build
```bash
# Standard build
./generateApp64.sh

# Cross-compilation (Linux ARM64)
export CC=aarch64-linux-gnu-gcc
./generateApp64.sh
```

### Docker Build
```bash
# Multi-architecture build
docker buildx build --platform linux/amd64,linux/arm64 -t cisis:latest .

# Single architecture
docker build -t cisis:latest .
```

## Download Binaries

### From Releases
1. Go to [Releases](../../releases)
2. Download the appropriate binary:
   - `cisis-linux-amd64.tar.gz` - Linux Intel/AMD
   - `cisis-linux-arm64.tar.gz` - Linux ARM64
   - `cisis-darwin-amd64.tar.gz` - macOS Intel
   - `cisis-darwin-arm64.tar.gz` - macOS Apple Silicon

### From Docker
```bash
# Pull multi-arch image
docker pull ghcr.io/username/cisis:latest

# Run CISIS in container
docker run --rm -v $(pwd):/data ghcr.io/username/cisis:latest
```

## GitHub Actions Workflows

- **`.github/workflows/build.yml`** - CI builds for all platforms
- **`.github/workflows/release.yml`** - Release binaries on tags
- **`.github/workflows/docker.yml`** - Multi-arch Docker images

## Architecture Detection

The build system automatically detects the target architecture and uses appropriate compilation flags for optimal performance on each platform.
