FROM debian:bookworm-slim

# Actualiza la lista de paquetes disponibles
RUN apt-get update \
    # Instala el paquete "aptitude" de forma silenciosa
    && apt-get install -y aptitude \
    # Realiza una actualización segura de paquetes de forma silenciosa
    && aptitude safe-upgrade -y

# Instalar paquetes adicionales de forma silenciosa
RUN apt-get install -y \ 
    # Autocompletado de Bash 
    bash-completion \
    # Transferencia de datos
    curl \
    # Monitor de procesos
    htop \
    # Administrador de archivos
    mc \
    # Editor de texto simple
    nano \
    # Información del sistema
    neofetch \
    # Editor de texto avanzado
    neovim \
    # Servidor SSH
    openssh-server \
    # Ejecutar comandos con privilegios
    sudo \
    # Herramienta de descarga
    wget

# Establecer contraseña del usuario root
RUN echo "root:P@$$w0rd" | chpasswd

# Crear usuario incognia y establecer contraseña
RUN useradd -m -s /bin/bash incognia && echo "incognia:1Nc0gn14" | chpasswd

# Agregar usuario incognia al grupo sudo
RUN usermod -aG sudo incognia

# Copia todos los archivos de app/ al directorio /app/
COPY app/* /app/
# Copia .nanorc al directorio /home/incognia/
RUN cat /app/.nanorc > /home/incognia/.nanorc
# Asigna el usuario incognia como propietario del directorio /home/incognia/
RUN chown -R incognia:incognia /home/incognia

# Configurar el script de inicio
COPY entrypoint.sh /entrypoint.sh
# Otorga permisos ejecución a entrypoint.sh
RUN chmod +x /entrypoint.sh

# Iniciar servicios
ENTRYPOINT [ "/entrypoint.sh" ]