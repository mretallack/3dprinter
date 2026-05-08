FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv \
    ninja-build gcc-13 g++-13 \
    cmake git make pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Set gcc-13 as default
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 100 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 100

# Install Conan
RUN pip install --break-system-packages conan==2.7.1

# Configure Conan
RUN conan config install https://github.com/ultimaker/conan-config.git \
    && conan profile detect --force

# Clone CuraEngine
RUN git clone --depth 1 https://github.com/Ultimaker/CuraEngine.git /CuraEngine
WORKDIR /CuraEngine

# Build
RUN conan install . --build=missing --update
RUN cmake --preset conan-release
RUN cmake --build --preset conan-release

# Copy printer definitions from Cura repo
RUN git clone --depth 1 https://github.com/Ultimaker/Cura.git /tmp/Cura \
    && cp -r /tmp/Cura/resources/definitions /definitions \
    && cp -r /tmp/Cura/resources/extruders /extruders \
    && rm -rf /tmp/Cura

ENTRYPOINT ["/CuraEngine/build/Release/CuraEngine"]
