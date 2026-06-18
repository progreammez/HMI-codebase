# EV_HMI - Build Dependencies

## Supported Environment

* Ubuntu 24.04+ (Native or WSL2)
* CMake 3.16+
* GCC/G++ with C++17 support
* Qt 6.x

---

## Install Required Dependencies

### 1. Update System Packages


sudo apt update

sudo apt upgrade -y


### 2. Install Build Essentials

Required for compiling C++ applications and generating build files.


sudo apt install -y \
    build-essential \
    cmake


### 3. Install Qt 6 Development Packages

Required by the project's CMake configuration:


sudo apt install -y \
    qt6-base-dev \
    qt6-base-dev-tools \
    qt6-tools-dev \
    qt6-tools-dev-tools \
    qt6-multimedia-dev \
    qt6-networkauth-dev


The project uses the following Qt modules:

* Qt Core
* Qt Gui
* Qt QML
* Qt Quick
* Qt Multimedia
* Qt Network

---

### 4. Install Wayland/XCB Runtime Support

Required for running Qt Quick applications on modern Linux desktop environments and WSLg.


sudo apt install -y \
    qt6-wayland \
    libxcb-cursor0


---

## One-Line Installation


sudo apt update && sudo apt upgrade -y

sudo apt install -y \
    build-essential \
    cmake \
    qt6-base-dev \
    qt6-base-dev-tools \
    qt6-tools-dev \
    qt6-tools-dev-tools \
    qt6-multimedia-dev \
    qt6-networkauth-dev \
    qt6-wayland \
    libxcb-cursor0


---

## Build Instructions


mkdir build

cd build

cmake ..

make

./EV_HMI
```

---

## Notes

* The project currently requires Qt Quick, QML, Multimedia, and Network modules.
* Spotify API integration uses Qt Network.
* Wayland support is recommended when running under WSLg.
* If running inside WSL2 without WSLg, a display server (X11/Wayland) must be configured separately.
