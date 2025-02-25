FROM ubuntu:24.04

WORKDIR /app

COPY . .

# Installing Intel GPU driver
# https://dgpu-docs.intel.com/driver/client/overview.html

# Install the Intel graphics GPG public key
RUN wget -qO - https://repositories.intel.com/gpu/intel-graphics.key | \
  sudo gpg --yes --dearmor --output /usr/share/keyrings/intel-graphics.gpg

# Configure the repositories.intel.com package repository
RUN echo "deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu noble unified" | \
  sudo tee /etc/apt/sources.list.d/intel-gpu-noble.list

# Update the package repository metadata
RUN sudo apt update

# Install the compute-related packages
RUN apt-get install -y libze-intel-gpu1 libze1 intel-opencl-icd clinfo intel-gsc

# Installing XPU Manager
RUN wget -O xpumanager.deb \
 https://github.com/intel/xpumanager/releases/download/V1.2.39/xpu-smi_1.2.39_20240906.085820.11f3c29a+deb10u1_amd64.deb

RUN apt install xpumanager.deb

ENTRYPOINT ["tail", "-f", "/dev/null"]