#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# Colores para la salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para liberar locks de apt
fix_apt_locks() {
    echo -e "${YELLOW}==> Solucionando problemas de locks de apt${NC}"
    
    # Verificar si hay procesos apt ejecutándose
    if pgrep -f "apt|dpkg" > /dev/null; then
        echo -e "${YELLOW}==> Procesos apt/dpkg detectados, esperando a que terminen...${NC}"
        while pgrep -f "apt|dpkg" > /dev/null; do
            echo -e "${BLUE}==> Esperando a que terminen los procesos apt/dpkg...${NC}"
            sleep 5
        done
        echo -e "${GREEN}==> Procesos apt/dpkg terminados${NC}"
    fi
    
    # Limpiar locks si existen
    echo -e "${GREEN}==> Limpiando locks de apt/dpkg${NC}"
    rm -f /data/data/com.termux/files/usr/var/lib/dpkg/lock-frontend 2>/dev/null || true
    rm -f /data/data/com.termux/files/usr/var/lib/dpkg/lock 2>/dev/null || true
    rm -f /data/data/com.termux/files/usr/var/cache/apt/archives/lock 2>/dev/null || true
    
    echo -e "${GREEN}==> Locks limpiados exitosamente${NC}"
    echo "Ahora puedes intentar la instalación nuevamente."
}

# Función para configurar email
configure_email() {
    echo -e "${GREEN}==> Configuración de Email para N8N${NC}"
    echo ""
    echo -e "${YELLOW}Proveedores de email soportados:${NC}"
    echo "1) Gmail"
    echo "2) Outlook/Hotmail"
    echo "3) Yahoo"
    echo "4) Otro (SMTP personalizado)"
    echo ""
    echo -n "Selecciona tu proveedor (1-4): "
    read provider_choice
    
    case $provider_choice in
        1)
            SMTP_HOST="smtp.gmail.com"
            SMTP_PORT="587"
            ;;
        2)
            SMTP_HOST="smtp-mail.outlook.com"
            SMTP_PORT="587"
            ;;
        3)
            SMTP_HOST="smtp.mail.yahoo.com"
            SMTP_PORT="587"
            ;;
        4)
            echo -n "Ingresa el servidor SMTP: "
            read SMTP_HOST
            echo -n "Ingresa el puerto SMTP (587 para TLS, 465 para SSL): "
            read SMTP_PORT
            ;;
        *)
            echo -e "${RED}Opción inválida${NC}"
            return 1
            ;;
    esac
    
    echo ""
    echo -n "Ingresa tu email: "
    read EMAIL_USER
    echo -n "Ingresa tu contraseña de aplicación: "
    read -s EMAIL_PASS
    echo ""
    
    # Crear archivo de configuración
    cat > "$HOME/.n8n/.env" << EOF
# Configuración de N8N
N8N_PORT=5678
N8N_USER_FOLDER=\$HOME/.n8n
NODE_ENV=production

# Configuración de Email
N8N_EMAIL_MODE=smtp
N8N_SMTP_HOST=$SMTP_HOST
N8N_SMTP_PORT=$SMTP_PORT
N8N_SMTP_USER=$EMAIL_USER
N8N_SMTP_PASS=$EMAIL_PASS
N8N_SMTP_SENDER=$EMAIL_USER
N8N_SMTP_SECURE=false

# Configuración de notificaciones
N8N_PERSONALIZATION_ENABLED=true
N8N_USER_MANAGEMENT_DISABLED=false
EOF
    
    echo -e "${GREEN}==> Configuración de email guardada en ~/.n8n/.env${NC}"
    echo ""
    echo -e "${YELLOW}IMPORTANTE:${NC}"
    echo "- Para Gmail, usa contraseñas de aplicación, no tu contraseña normal"
    echo "- Ve a: https://myaccount.google.com/apppasswords"
    echo "- Genera una contraseña de aplicación para 'Mail'"
    echo "- Usa esa contraseña en lugar de tu contraseña normal"
    echo ""
    echo "Reinicia n8n para aplicar los cambios:"
    echo "  n8n restart"
}

# Función para solucionar sesiones de Termux
fix_termux_sessions() {
    echo -e "${GREEN}==> Solucionando problema de múltiples sesiones en Termux${NC}"
    echo ""
    echo -e "${YELLOW}Problema: Termux abre una nueva sesión cada vez${NC}"
    echo ""
    echo -e "${BLUE}Soluciones disponibles:${NC}"
    echo "1) Configurar Termux para usar una sola sesión"
    echo "2) Cerrar todas las sesiones existentes"
    echo "3) Configurar autoinicio de n8n"
    echo "4) Todas las anteriores"
    echo ""
    echo -n "Selecciona una opción (1-4): "
    read choice
    
    case $choice in
        1)
            echo -e "${GREEN}==> Configurando Termux para una sola sesión${NC}"
            
            # Crear script de inicio único
            cat > "$HOME/.termux_start.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# Script de inicio único para Termux

# Verificar si ya hay una sesión activa
if pgrep -f "termux" > /dev/null; then
    echo "Termux ya está ejecutándose. Usando sesión existente."
    exit 0
fi

# Cargar configuración de n8n si existe
if [ -f "$HOME/.n8n/.env" ]; then
    export $(grep -v '^#' "$HOME/.n8n/.env" | xargs)
fi

# Resucitar procesos PM2
pm2 resurrect 2>/dev/null || true

echo "Termux iniciado correctamente."
EOF
            
            chmod +x "$HOME/.termux_start.sh"
            
            # Añadir al bashrc
            if ! grep -q ".termux_start.sh" "$HOME/.bashrc"; then
                echo "
# Inicio único de Termux
source ~/.termux_start.sh" >> "$HOME/.bashrc"
            fi
            
            echo -e "${GREEN}==> Configuración completada${NC}"
            ;;
            
        2)
            echo -e "${GREEN}==> Cerrando procesos de apt/dpkg solamente${NC}"
            
            # Cerrar solo procesos de apt/dpkg, NO Termux
            pkill -f "apt" 2>/dev/null || true
            pkill -f "dpkg" 2>/dev/null || true
            
            echo -e "${GREEN}==> Procesos de apt/dpkg cerrados${NC}"
            echo "Termux sigue funcionando normalmente."
            ;;
            
        3)
            echo -e "${GREEN}==> Configurando autoinicio de n8n${NC}"
            
            # Crear script de autoinicio
            cat > "$HOME/.n8n_autostart.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# Autoinicio de n8n

# Esperar un poco para que Termux se inicie completamente
sleep 3

# Cargar variables de entorno
if [ -f "$HOME/.n8n/.env" ]; then
    export $(grep -v '^#' "$HOME/.n8n/.env" | xargs)
fi

# Verificar si n8n ya está corriendo
if pm2 list | grep -q "n8n.*online"; then
    echo "n8n ya está corriendo."
else
    echo "Iniciando n8n..."
    pm2 start n8n --name n8n
    pm2 save
fi
EOF
            
            chmod +x "$HOME/.n8n_autostart.sh"
            
            # Añadir al bashrc
            if ! grep -q ".n8n_autostart.sh" "$HOME/.bashrc"; then
                echo "
# Autoinicio de n8n
~/.n8n_autostart.sh &" >> "$HOME/.bashrc"
            fi
            
            echo -e "${GREEN}==> Autoinicio configurado${NC}"
            ;;
            
        4)
            echo -e "${GREEN}==> Aplicando todas las soluciones${NC}"
            
            # Solución 1: Configurar una sola sesión
            cat > "$HOME/.termux_start.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# Script de inicio único para Termux

# Verificar si ya hay una sesión activa
if pgrep -f "termux" > /dev/null; then
    echo "Termux ya está ejecutándose. Usando sesión existente."
    exit 0
fi

# Cargar configuración de n8n si existe
if [ -f "$HOME/.n8n/.env" ]; then
    export $(grep -v '^#' "$HOME/.n8n/.env" | xargs)
fi

# Resucitar procesos PM2
pm2 resurrect 2>/dev/null || true

echo "Termux iniciado correctamente."
EOF
            
            chmod +x "$HOME/.termux_start.sh"
            
            # Solución 2: Cerrar solo procesos de apt/dpkg
            pkill -f "apt" 2>/dev/null || true
            pkill -f "dpkg" 2>/dev/null || true
            
            # Solución 3: Configurar autoinicio
            cat > "$HOME/.n8n_autostart.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# Autoinicio de n8n

# Esperar un poco para que Termux se inicie completamente
sleep 3

# Cargar variables de entorno
if [ -f "$HOME/.n8n/.env" ]; then
    export $(grep -v '^#' "$HOME/.n8n/.env" | xargs)
fi

# Verificar si n8n ya está corriendo
if pm2 list | grep -q "n8n.*online"; then
    echo "n8n ya está corriendo."
else
    echo "Iniciando n8n..."
    pm2 start n8n --name n8n
    pm2 save
fi
EOF
            
            chmod +x "$HOME/.n8n_autostart.sh"
            
            # Limpiar bashrc y añadir configuraciones
            cp "$HOME/.bashrc" "$HOME/.bashrc.backup"
            
            # Crear nuevo bashrc
            cat > "$HOME/.bashrc" << 'EOF'
# ~/.bashrc

# Inicio único de Termux
source ~/.termux_start.sh

# PM2 resurrect
pm2 resurrect

# Autoinicio de n8n
~/.n8n_autostart.sh &

# PATH personalizado
export PATH=$HOME/.local/bin:$PATH
EOF
            
            echo -e "${GREEN}==> Todas las soluciones aplicadas${NC}"
            echo "Backup del bashrc guardado en ~/.bashrc.backup"
            ;;
            
        *)
            echo -e "${RED}Opción inválida${NC}"
            return 1
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}==> Solución completada${NC}"
    echo ""
    echo -e "${YELLOW}Recomendaciones adicionales:${NC}"
    echo "1. Reinicia Termux completamente"
    echo "2. Verifica que n8n se inicie automáticamente"
    echo "3. Si el problema persiste, reinicia tu dispositivo Android"
    echo ""
    echo -e "${BLUE}Para verificar el estado:${NC}"
    echo "  pm2 list"
    echo "  pm2 logs n8n"
}

# Función para mostrar el menú
show_menu() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}    GESTOR DE N8N PARA TERMUX ANDROID${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    echo "1) Instalar n8n (primera vez)"
    echo "2) Iniciar n8n con PM2"
    echo "3) Crear backup de n8n"
    echo "4) Restaurar backup de n8n"
    echo "5) Ver estado de PM2"
    echo "6) Detener n8n"
    echo "7) Reiniciar n8n"
    echo "8) Ver logs de n8n"
    echo "9) Solucionar locks de apt"
    echo "10) Configurar email"
    echo "11) Solucionar sesiones de Termux"
    echo "12) Salir"
    echo ""
    echo -n "Selecciona una opción (1-12): "
}

# Función para instalar n8n
install_n8n() {
    echo -e "${YELLOW}==> Asegúrate de que Termux está instalado desde:${NC}"
    echo "    - https://github.com/termux/termux-app/releases"
    echo "    - o los Termux Packages de IvanByCinderella: https://github.com/IvanByCinderella/termux-packages"
    echo "    - No uses la versión de Google Play (obsoleta)."
    echo ""
    read -p "¿Continuar con la instalación? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Instalación cancelada."
        return
    fi

    echo -e "${GREEN}==> 1) Verificando y liberando locks de apt${NC}"
    # Verificar si hay procesos apt ejecutándose
    if pgrep -f "apt|dpkg" > /dev/null; then
        echo -e "${YELLOW}==> Procesos apt/dpkg detectados, esperando a que terminen...${NC}"
        while pgrep -f "apt|dpkg" > /dev/null; do
            echo -e "${BLUE}==> Esperando a que terminen los procesos apt/dpkg...${NC}"
            sleep 5
        done
        echo -e "${GREEN}==> Procesos apt/dpkg terminados${NC}"
    fi
    
    # Limpiar locks si existen
    sudo rm -f /data/data/com.termux/files/usr/var/lib/dpkg/lock-frontend 2>/dev/null || true
    sudo rm -f /data/data/com.termux/files/usr/var/lib/dpkg/lock 2>/dev/null || true
    sudo rm -f /data/data/com.termux/files/usr/var/cache/apt/archives/lock 2>/dev/null || true
    
    echo -e "${GREEN}==> 2) Actualizando Termux${NC}"
    pkg update -y && pkg upgrade -y

    echo -e "${GREEN}==> 3) Instalando dependencias de compilación y runtime${NC}"
    pkg install -y nodejs-lts python binutils make clang pkg-config libsqlite ndk-sysroot

    echo -e "${GREEN}==> 4) Configurando solución NDK para node-gyp${NC}"
    export GYP_DEFINES="android_ndk_path=''"

    echo -e "${GREEN}==> 5) Instalando n8n con SQLite embebido${NC}"
    npm install -g n8n --sqlite=/data/data/com.termux/files/usr/bin/sqlite3

    echo -e "${GREEN}==> 6) Instalando PM2 (gestor de procesos)${NC}"
    npm install -g pm2

    echo -e "${GREEN}==> 7) Creando carpeta de datos de n8n${NC}"
    mkdir -p $HOME/.n8n
    
    echo -e "${GREEN}==> 7.1) Configurando variables de entorno para email${NC}"
    # Crear archivo de configuración de email
    cat > "$HOME/.n8n/.env" << 'EOF'
# Configuración de N8N
N8N_PORT=5678
N8N_USER_FOLDER=$HOME/.n8n
NODE_ENV=production

# Configuración de Email (Gmail como ejemplo)
N8N_EMAIL_MODE=smtp
N8N_SMTP_HOST=smtp.gmail.com
N8N_SMTP_PORT=587
N8N_SMTP_USER=tu_email@gmail.com
N8N_SMTP_PASS=tu_contraseña_de_aplicacion
N8N_SMTP_SENDER=tu_email@gmail.com
N8N_SMTP_SECURE=false

# Configuración de notificaciones
N8N_PERSONALIZATION_ENABLED=true
N8N_USER_MANAGEMENT_DISABLED=false
EOF
    
    echo -e "${YELLOW}==> IMPORTANTE: Edita ~/.n8n/.env con tus credenciales de email${NC}"
    echo "   - Cambia 'tu_email@gmail.com' por tu email real"
    echo "   - Cambia 'tu_contraseña_de_aplicacion' por tu contraseña de aplicación"
    echo "   - Para Gmail, usa contraseñas de aplicación, no tu contraseña normal"

    echo -e "${GREEN}==> 8) Añadiendo resurrect de PM2 al bashrc${NC}"
    grep -q "pm2 resurrect" "$HOME/.bashrc" || echo "
pm2 resurrect" >> "$HOME/.bashrc"

    echo -e "${GREEN}==> 9) Creando alias global para n8n${NC}"
    # Crear alias para n8n que use PM2
    if ! grep -q "alias n8n=" "$HOME/.bashrc"; then
        echo "
# Alias para n8n con PM2
alias n8n='pm2 start n8n --name n8n || pm2 restart n8n || pm2 logs n8n'" >> "$HOME/.bashrc"
    fi

    echo -e "${GREEN}==> 10) Creando script ejecutable n8n${NC}"
    # Crear script ejecutable en PATH
    mkdir -p "$HOME/.local/bin"
    cat > "$HOME/.local/bin/n8n" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# Script para gestionar n8n con PM2

case "$1" in
    "start")
        pm2 start n8n --name n8n
        pm2 save
        echo "n8n iniciado con PM2"
        ;;
    "stop")
        pm2 stop n8n
        pm2 save
        echo "n8n detenido"
        ;;
    "restart")
        pm2 restart n8n
        pm2 save
        echo "n8n reiniciado"
        ;;
    "status")
        pm2 status n8n
        ;;
    "logs")
        pm2 logs n8n
        ;;
    "open")
        termux-open-url http://localhost:5678
        ;;
    *)
        echo "Uso: n8n [start|stop|restart|status|logs|open]"
        echo ""
        echo "Comandos disponibles:"
        echo "  start   - Iniciar n8n con PM2"
        echo "  stop    - Detener n8n"
        echo "  restart - Reiniciar n8n"
        echo "  status  - Ver estado de n8n"
        echo "  logs    - Ver logs en tiempo real"
        echo "  open    - Abrir n8n en el navegador"
        echo ""
        echo "Sin argumentos: muestra esta ayuda"
        ;;
esac
EOF
    chmod +x "$HOME/.local/bin/n8n"

    echo -e "${GREEN}==> 11) Añadiendo ~/.local/bin al PATH${NC}"
    if ! grep -q "export PATH=\$HOME/.local/bin:\$PATH" "$HOME/.bashrc"; then
        echo "
# Añadir ~/.local/bin al PATH
export PATH=\$HOME/.local/bin:\$PATH" >> "$HOME/.bashrc"
    fi

    echo -e "${GREEN}==> ¡Instalación completada!${NC}"
    echo ""
    echo -e "${YELLOW}� IMPORTANTE:${NC}"
    echo "1. Reinicia Termux o ejecuta: source ~/.bashrc"
    echo "2. Ahora puedes usar el comando 'n8n' directamente:"
    echo "   - n8n start    # Iniciar n8n"
    echo "   - n8n stop     # Detener n8n"
    echo "   - n8n status   # Ver estado"
    echo "   - n8n logs     # Ver logs"
    echo "   - n8n open     # Abrir en navegador"
    echo ""
    echo "También puedes usar la opción 2 de este menú para iniciar n8n."
}

# Función para iniciar n8n
start_n8n() {
    echo -e "${GREEN}==> Iniciando n8n con PM2${NC}"
    
    # Cargar variables de entorno si existen
    if [ -f "$HOME/.n8n/.env" ]; then
        echo -e "${BLUE}==> Cargando configuración de email desde ~/.n8n/.env${NC}"
        export $(grep -v '^#' "$HOME/.n8n/.env" | xargs)
    else
        echo -e "${YELLOW}==> Archivo ~/.n8n/.env no encontrado. Email no configurado.${NC}"
        echo "   Ejecuta la instalación nuevamente o crea el archivo manualmente."
    fi
    
    # Verificar si el comando n8n está disponible
    if command -v n8n >/dev/null 2>&1; then
        echo -e "${BLUE}==> Usando comando n8n personalizado${NC}"
        n8n start
    else
        echo -e "${YELLOW}==> Usando PM2 directamente (comando n8n no disponible)${NC}"
        pm2 start n8n || true
        pm2 save
    fi
    
    pm2 status

    echo -e "${GREEN}==> n8n está corriendo en segundo plano.${NC}"
    echo "Presiona 'o' para abrir en el navegador o cualquier otra tecla para continuar."

    read -n 1 -s key

    if [[ $key == "o" ]]; then
        echo -e "${GREEN}==> Abriendo n8n en el navegador...${NC}"
        termux-open-url http://localhost:5678
    fi
}

# Función para crear backup
backup_n8n() {
    BACKUP_DIR="$HOME/backups"
    DATA_DIR="$HOME/.n8n"
    TS=$(date +"%Y%m%d-%H%M%S")
    OUT="$BACKUP_DIR/n8n-backup-$TS.tar.gz"

    mkdir -p "$BACKUP_DIR"

    if [ ! -d "$DATA_DIR" ]; then
        echo -e "${RED}Directorio de datos no existe: $DATA_DIR${NC}"
        return 1
    fi

    echo -e "${GREEN}==> Creando backup de $DATA_DIR en $OUT${NC}"
    tar -czf "$OUT" -C "$HOME" .n8n

    echo -e "${GREEN}==> Backup creado: $OUT${NC}"
}

# Función para restaurar backup
restore_n8n() {
    if [ $# -lt 1 ]; then
        echo -e "${YELLOW}Archivos de backup disponibles:${NC}"
        ls -la $HOME/backups/n8n-backup-*.tar.gz 2>/dev/null || echo "No hay backups disponibles."
        echo ""
        echo -n "Ingresa la ruta completa del archivo de backup: "
        read ARCHIVE
    else
        ARCHIVE="$1"
    fi

    DATA_DIR="$HOME/.n8n"

    if [ ! -f "$ARCHIVE" ]; then
        echo -e "${RED}Archivo no encontrado: $ARCHIVE${NC}"
        return 1
    fi

    echo -e "${YELLOW}==> Deteniendo n8n (si está corriendo con PM2)${NC}"
    pm2 stop n8n || true

    echo -e "${GREEN}==> Restaurando datos en $DATA_DIR${NC}"
    mkdir -p "$DATA_DIR"
    tar -xzf "$ARCHIVE" -C "$HOME"

    echo -e "${GREEN}==> Ajustando permisos${NC}"
    chmod -R 700 "$DATA_DIR" || true

    echo -e "${GREEN}==> Iniciando n8n de nuevo${NC}"
    pm2 start n8n || true
    pm2 save || true
    pm2 status
}

# Función para ver estado de PM2
show_pm2_status() {
    echo -e "${GREEN}==> Estado de PM2:${NC}"
    pm2 status
}

# Función para detener n8n
stop_n8n() {
    echo -e "${YELLOW}==> Deteniendo n8n${NC}"
    
    # Verificar si el comando n8n está disponible
    if command -v n8n >/dev/null 2>&1; then
        n8n stop
    else
        pm2 stop n8n || true
        pm2 save
    fi
    
    echo -e "${GREEN}==> n8n detenido${NC}"
}

# Función para reiniciar n8n
restart_n8n() {
    echo -e "${YELLOW}==> Reiniciando n8n${NC}"
    
    # Verificar si el comando n8n está disponible
    if command -v n8n >/dev/null 2>&1; then
        n8n restart
    else
        pm2 restart n8n || true
        pm2 save
    fi
    
    pm2 status
    echo -e "${GREEN}==> n8n reiniciado${NC}"
}

# Función para ver logs
show_logs() {
    echo -e "${GREEN}==> Mostrando logs de n8n (Ctrl+C para salir)${NC}"
    
    # Verificar si el comando n8n está disponible
    if command -v n8n >/dev/null 2>&1; then
        n8n logs
    else
        pm2 logs n8n
    fi
}

# Función principal
main() {
    while true; do
        clear
        show_menu
        read -r choice

        case $choice in
            1)
                install_n8n
                ;;
            2)
                start_n8n
                ;;
            3)
                backup_n8n
                ;;
            4)
                restore_n8n
                ;;
            5)
                show_pm2_status
                ;;
            6)
                stop_n8n
                ;;
            7)
                restart_n8n
                ;;
            8)
                show_logs
                ;;
            9)
                fix_apt_locks
                ;;
            10)
                configure_email
                ;;
            11)
                fix_termux_sessions
                ;;
            12)
                echo -e "${GREEN}¡Hasta luego!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Opción inválida. Presiona Enter para continuar.${NC}"
                read
                ;;
        esac

        if [ "$choice" != "8" ] && [ "$choice" != "12" ]; then
            echo ""
            echo -n "Presiona Enter para continuar..."
            read
        fi
    done
}

# Verificar si se pasaron argumentos para modo no interactivo
if [ $# -gt 0 ]; then
    case "$1" in
        "install")
            install_n8n
            ;;
        "start")
            start_n8n
            ;;
        "backup")
            backup_n8n
            ;;
        "restore")
            restore_n8n "$2"
            ;;
        "status")
            show_pm2_status
            ;;
        "stop")
            stop_n8n
            ;;
        "restart")
            restart_n8n
            ;;
        "logs")
            show_logs
            ;;
        "fix-locks")
            fix_apt_locks
            ;;
        "configure-email")
            configure_email
            ;;
        "fix-sessions")
            fix_termux_sessions
            ;;
        *)
            echo "Uso: $0 [install|start|backup|restore|status|stop|restart|logs|fix-locks|configure-email|fix-sessions]"
            echo "O ejecuta sin argumentos para el menú interactivo."
            exit 1
            ;;
    esac
else
    main
fi
