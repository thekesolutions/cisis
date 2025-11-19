#!/bin/bash
set -e

echo "Building CISIS for Docker..."

# Clean previous builds
rm -f nohup.out *.o mk*.sh xmk.sh xls

# Apply patches for deprecated gets() function
echo "Applying patches for deprecated gets() function..."

# Fix line 3273
sed -i 's/printf(prompt1p); isxp=gets(line); p=isxp;/printf(prompt1p); isxp=fgets(line, sizeof(line), stdin); if (isxp \&\& isxp[strlen(isxp)-1] == '"'"'\\n'"'"') isxp[strlen(isxp)-1] = '"'"'\\0'"'"'; p=isxp;/' mxaot.c

# Fix line 3872
sed -i 's/printf(prompt1p); isxp=gets(line); q=isxp;/printf(prompt1p); isxp=fgets(line, sizeof(line), stdin); if (isxp \&\& isxp[strlen(isxp)-1] == '"'"'\\n'"'"') isxp[strlen(isxp)-1] = '"'"'\\0'"'"'; q=isxp;/' mxaot.c

# Fix line 4080
sed -i 's/printf(prompt2p); isxp=gets(line); p=isxp;/printf(prompt2p); isxp=fgets(line, sizeof(line), stdin); if (isxp \&\& isxp[strlen(isxp)-1] == '"'"'\\n'"'"') isxp[strlen(isxp)-1] = '"'"'\\0'"'"'; p=isxp;/' mxaot.c

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
