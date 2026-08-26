FROM --platform=linux/amd64 ubuntu:24.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    apt-transport-https \
    software-properties-common \
    wget \
    ca-certificates \
    gnupg \
    lsb-release \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install PowerShell 7 (latest)
RUN wget -q https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell

# Install Az and Microsoft.Graph PowerShell modules
RUN pwsh -Command "Install-Module -Name Az -Force -AllowClobber -Scope AllUsers" \
    && pwsh -Command "Install-Module -Name Microsoft.Graph -Force -AllowClobber -Scope AllUsers"

# Set PowerShell as the default shell
SHELL ["pwsh", "-Command"]