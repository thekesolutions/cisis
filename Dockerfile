# Multi-architecture Dockerfile for CISIS
FROM --platform=$BUILDPLATFORM alpine:latest AS builder

# Install build dependencies
RUN apk add --no-cache \
    gcc \
    musl-dev \
    make \
    libc-dev

# Copy source code
COPY . /src/
WORKDIR /src

# Build CISIS
ARG TARGETARCH
RUN ./generateApp64.sh || make -f mx.mak

# Runtime image
FROM alpine:latest

# Install runtime dependencies
RUN apk add --no-cache \
    libc6-compat \
    libgcc \
    libstdc++

# Copy built binaries
COPY --from=builder /src/mx /usr/local/bin/
COPY --from=builder /src/utl/ /usr/local/bin/ 2>/dev/null || true

# Set permissions
RUN chmod +x /usr/local/bin/mx

# Create working directory
WORKDIR /data

# Test the build
RUN mx || echo "CISIS installed successfully"

ENTRYPOINT ["mx"]
CMD ["--help"]
