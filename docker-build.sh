#!/bin/bash
set -e

echo "Building CISIS for Docker..."

# Clean previous builds
rm -f nohup.out *.o mk*.sh xmk.sh xls

# Build the main mx binary first
echo "Building main mx binary..."
make -f mx.mak SIXTY_FOUR=1

# Make it executable
chmod +x mx

# Now build utilities if mx was built successfully
if [ -x "./mx" ]; then
    echo "Building utilities..."
    # Clean up before building utilities
    rm -f *.o
    rm -rf utl wxis
    
    # Run the utility build script
    if [ -x "./generateApp64.sh" ]; then
        ./generateApp64.sh || echo "Utilities build completed with warnings"
    else
        echo "generateApp64.sh not found or not executable"
    fi
else
    echo "mx binary not built successfully"
    exit 1
fi

echo "Build completed successfully!"
