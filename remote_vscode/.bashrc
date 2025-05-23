# Set JAVA_HOME and add to PATH for Java
export JAVA_HOME=${JAVA_INSTALL_DIR}
export PATH="$JAVA_HOME/bin:$PATH"

script -f /var/log/devtool-logs.log -c "zsh"