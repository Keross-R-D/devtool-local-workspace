# Start from a minimal Debian image
FROM node:22-bullseye-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y curl git && \
    rm -rf /var/lib/apt/lists/*

# Download and install the latest version of code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN mkdir -p /workbench 


RUN mkdir -p /usr/local/lib/node_modules && \
    chown -R node:node /usr/local/lib/node_modules

RUN git clone https://github.com/Keross-R-D/IkonAdminToolV2.git && \
    cd IkonAdminToolV2 && \
    npm i && \
    npm run build &&\
    npm install -g . && \
    cd ..

# Expose the desired port
EXPOSE 8080

WORKDIR /workbench

RUN mkdir -p /temp
# COPY ikonextension-0.0.1.vsix /temp/ikonextension-0.0.1.vsix
# COPY ikon-next-preview-0.0.1.vsix /temp/ikon-next-preview-0.0.1.vsix


RUN code-server --install-extension dracula-theme.theme-dracula
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension eamodio.gitlens
RUN code-server --install-extension ms-azuretools.vscode-docker
# RUN code-server --install-extension /temp/ikonextension-0.0.1.vsix
# RUN code-server --install-extension /temp/ikon-next-preview-0.0.1.vsix

# Copy the custom settings.json into the config directory
COPY settings.json /root/.config/code-server/settings.json

# ENV VSCODE_PROXY_URI=http://localhost:{{port}}/
ENV CODE_SERVER_PROXY_DOMAIN=localhost
# Set code-server to run on port 8080
CMD ["code-server", "--bind-addr", "0.0.0.0:8080","--auth", "none","--proxy-domain", "localhost","/workspace"]
