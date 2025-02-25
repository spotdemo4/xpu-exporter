FROM ubuntu:24.04

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg2

# Install the Intel graphics GPG public key
# https://dgpu-docs.intel.com/driver/client/overview.html
RUN wget -qO - https://repositories.intel.com/gpu/intel-graphics.key | \
    gpg --yes --dearmor --output /usr/share/keyrings/intel-graphics.gpg

# Configure the repositories.intel.com package repository
RUN echo "deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu noble unified" | \
    tee /etc/apt/sources.list.d/intel-gpu-noble.list

RUN apt-get update

# Installing XPU Manager
# https://github.com/intel/xpumanager
RUN curl -s https://api.github.com/repos/intel/xpumanager/releases/latest | \
    grep '"browser_download_url":' | \
    grep '24.04_amd64.deb' | \
    grep -vE '(\.pem|\.sig)' | \
    grep -vE 'xpu-smi' | \
    grep -o 'https://[^"]*' | \
    wget -qO /app/xpumanager.deb -i -

RUN apt-get install -y /app/xpumanager.deb

ENTRYPOINT ["xpumd"]