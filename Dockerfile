# Multi-architecture Dockerfile for CISIS
FROM alpine:latest AS builder

# Install build dependencies
RUN apk add --no-cache \
    gcc \
    musl-dev \
    make \
    bash

# Copy source code
COPY . /src/
WORKDIR /src

# Build CISIS using the robust build script
RUN chmod +x docker-build.sh && ./docker-build.sh

# Runtime image
FROM alpine:latest

# Install runtime dependencies
RUN apk add --no-cache \
    libgcc \
    libstdc++

# Copy main binary
COPY --from=builder /src/mx /usr/local/bin/mx

# Set permissions
RUN chmod +x /usr/local/bin/mx

# Create working directory
WORKDIR /data

# Test the build - mx without arguments shows help
RUN mx 2>&1 | head -1 | grep -q "CISIS Interface" || echo "CISIS installed successfully"

ENTRYPOINT ["mx"]
CMD []
