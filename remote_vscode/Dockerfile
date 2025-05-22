# Start from a minimal Debian image
FROM node:22-bullseye-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV JDK_VERSION_SPECIFIC=21.0.1+12
ENV JDK_TARBALL_NAME=OpenJDK21U-jdk_x64_linux_hotspot_21.0.1_12.tar.gz
ENV JDK_DOWNLOAD_URL=https://github.com/adoptium/temurin21-binaries/releases/download/jdk-${JDK_VERSION_SPECIFIC}/${JDK_TARBALL_NAME}
ENV JAVA_INSTALL_DIR=/opt/java

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y curl git docker.io snoopy rsyslog tar ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Download and install Eclipse Temurin JDK
RUN set -e; \
    echo "Downloading JDK from ${JDK_DOWNLOAD_URL} to /tmp/${JDK_TARBALL_NAME}..."; \
    curl -LfsSo /tmp/${JDK_TARBALL_NAME} ${JDK_DOWNLOAD_URL}; \
    curl_exit_code=$?; \
    if [ ${curl_exit_code} -ne 0 ]; then \
        echo "Curl failed with exit code ${curl_exit_code} while downloading the file."; \
        exit 1; \
    fi; \
    echo "Download complete. Extracting JDK..."; \
    mkdir -p ${JAVA_INSTALL_DIR}; \
    tar -xzf /tmp/${JDK_TARBALL_NAME} -C ${JAVA_INSTALL_DIR} --strip-components=1; \
    echo "Cleaning up downloaded tarball..."; \
    rm -f /tmp/${JDK_TARBALL_NAME}; \
    echo "JDK installation complete."

# Set JAVA_HOME environment variable
ENV JAVA_HOME=${JAVA_INSTALL_DIR}
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Ensure JAVA_HOME and PATH are set in .bashrc for interactive shells started by code-server
# This is a robust way to ensure the terminal in VS Codium gets the correct PATH.
RUN echo '' >> /root/.bashrc && \
    echo '# Set JAVA_HOME and add to PATH for Java' >> /root/.bashrc && \
    echo "export JAVA_HOME=${JAVA_INSTALL_DIR}" >> /root/.bashrc && \
    echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> /root/.bashrc

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

# Install VS Code extensions
RUN code-server --install-extension dracula-theme.theme-dracula && \
    code-server --install-extension esbenp.prettier-vscode && \
    code-server --install-extension eamodio.gitlens && \
    code-server --install-extension ms-azuretools.vscode-docker && \
    code-server --install-extension vscjava.vscode-java-pack && \
    code-server --install-extension vmware.vscode-spring-boot && \
    code-server --install-extension bradlc.vscode-tailwindcss
# RUN code-server --install-extension /temp/ikonextension-0.0.1.vsix
# RUN code-server --install-extension /temp/ikon-next-preview-0.0.1.vsix

# Copy the custom settings.json into the config directory
COPY settings.json /root/.config/code-server/settings.json

# ENV VSCODE_PROXY_URI=http://localhost:{{port}}/
ENV CODE_SERVER_PROXY_DOMAIN=localhost

# Setup scoopy and rsyslog
COPY ./snoopy/snoopy.ini /etc/snoopy.ini
RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf
COPY ./rsyslog/60-snoopy.conf /etc/rsyslog.d/60-snoopy.conf
RUN service rsyslog restart

# Create .so library to make sure snoppy captures log
RUN echo '/lib/x86_64-linux-gnu/libsnoopy.so' | tee /etc/ld.so.preload

# Set code-server to run on port 8080
CMD ["code-server", "--bind-addr", "0.0.0.0:8080","--auth", "none","--proxy-domain", "localhost","/workspace"]
