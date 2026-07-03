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
# Install systemd service
#############################################

if [ "$AUTOSTART" = true ]; then

    echo ""
    echo "[4/6] Installing autostart service..."

    EXECUTABLE="$PROJECT_ROOT/build/EV_HMI"

    cat << EOF | sudo tee /etc/systemd/system/$SERVICE_NAME > /dev/null
[Unit]
Description=KPIT EV HMI
After=graphical.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$PROJECT_ROOT/build
ExecStart=/bin/bash -c '
if command -v antimicrox >/dev/null 2>&1; then
    pgrep -x antimicrox >/dev/null || antimicrox >/dev/null 2>&1 &
    sleep 2
fi
exec "$EXECUTABLE"
'
Restart=always
RestartSec=2
Environment=QT_QPA_PLATFORM=wayland

[Install]
WantedBy=graphical.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable "$SERVICE_NAME"

    echo "Autostart enabled."

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