#!/bin/bash

set -e

#############################################
# KPIT EV HMI Deployment Script
#############################################

INSTALL=false
CLEAN=false
RUN=true
AUTOSTART=false
HELP=false

SERVICE_NAME="evhmi.service"

#############################################
# Parse Arguments
#############################################

for arg in "$@"; do
    case "$arg" in
        --install)
            INSTALL=true
            ;;
        --clean)
            CLEAN=true
            ;;
        --no-run)
            RUN=false
            ;;
        --autostart)
            AUTOSTART=true
            ;;
        -h|--help)
            HELP=true
            ;;
        *)
            echo "Unknown option: $arg"
            HELP=true
            ;;
    esac
done

#############################################
# Help Menu
#############################################

if [ "$HELP" = true ]; then
    echo ""
    echo "KPIT EV HMI Deployment Tool"
    echo ""
    echo "Usage:"
    echo "  ./scripts/deploy.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --install      Install required packages"
    echo "  --clean        Delete build directory before building"
    echo "  --no-run       Build only"
    echo "  --autostart    Install systemd service"
    echo "  -h, --help     Show this help menu"
    echo ""
    exit 0
fi

#############################################
# Locate Project Root
#############################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo ""
echo "==========================================="
echo "      KPIT EV HMI Deployment"
echo "==========================================="

#############################################
# Install Dependencies
#############################################

if [ "$INSTALL" = true ]; then

    echo ""
    echo "[1/5] Installing dependencies..."

    sudo apt update
    sudo apt upgrade -y

    sudo apt install -y \
        build-essential \
        cmake \
        git \
        pkg-config \
        qt6-base-dev \
        qt6-base-dev-tools \
        qt6-declarative-dev \
        qt6-tools-dev \
        qt6-tools-dev-tools \
        qt6-multimedia-dev \
        qt6-networkauth-dev \
        qt6-wayland \
        qt6-serialport-dev \
        libxcb-cursor0 \
        antimicrox

fi

#############################################
# Clean Build
#############################################

if [ "$CLEAN" = true ]; then

    echo ""
    echo "[2/5] Cleaning build..."

    rm -rf build

fi

#############################################
# Build
#############################################

echo ""
echo "[3/5] Building..."

mkdir -p build

cd build

cmake ..

cmake --build . --parallel $(nproc)

#############################################
# Install Desktop Autostart
#############################################

if [ "$AUTOSTART" = true ]; then

    echo ""
    echo "[4/6] Configuring desktop autostart..."

    EXECUTABLE="$PROJECT_ROOT/build/EV_HMI"

    AUTOSTART_DIR="$HOME/.config/autostart"
    mkdir -p "$AUTOSTART_DIR"

    cat > "$AUTOSTART_DIR/evhmi.desktop" << EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=KPIT EV HMI
Comment=Launch KPIT EV Dashboard

Exec=/bin/bash -c '
if command -v antimicrox >/dev/null 2>&1; then
    pgrep -x antimicrox >/dev/null || antimicrox >/dev/null 2>&1 &
    sleep 2
fi
exec "$EXECUTABLE"
'

Terminal=false
X-GNOME-Autostart-enabled=true
EOF

    echo "Desktop autostart configured."
    echo "The HMI will automatically launch after login."

fi 

#############################################
# Run
#############################################

if [ "$RUN" = true ]; then

    echo ""

    #############################################
    # Launch AntiMicroX (if installed)
    #############################################

    if command -v antimicrox >/dev/null 2>&1; then

        if pgrep -x "antimicrox" >/dev/null; then
            echo "[5/6] AntiMicroX already running."
        else
            echo "[5/6] Starting AntiMicroX (PS3 Controller)..."
            antimicrox >/dev/null 2>&1 &
            sleep 2
        fi

    else
        echo "[5/6] AntiMicroX not found. Skipping controller support."
    fi

    echo ""
    echo "[6/6] Launching EV_HMI..."

    ./EV_HMI

else

    echo ""
    echo "Build completed."

fi