#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# Colores para la salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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
    echo "9) Salir"
    echo ""
    echo -n "Selecciona una opción (1-9): "
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

    echo -e "${GREEN}==> 1) Actualizando Termux${NC}"
    pkg update -y && pkg upgrade -y

    echo -e "${GREEN}==> 2) Instalando dependencias de compilación y runtime${NC}"
    pkg install -y nodejs-lts python binutils make clang pkg-config libsqlite ndk-sysroot

    echo -e "${GREEN}==> 3) Configurando solución NDK para node-gyp${NC}"
    export GYP_DEFINES="android_ndk_path=''"

    echo -e "${GREEN}==> 4) Instalando n8n con SQLite embebido${NC}"
    npm install -g n8n --sqlite=/data/data/com.termux/files/usr/bin/sqlite3

    echo -e "${GREEN}==> 5) Instalando PM2 (gestor de procesos)${NC}"
    npm install -g pm2

    echo -e "${GREEN}==> 6) Creando carpeta de datos de n8n${NC}"
    mkdir -p $HOME/.n8n

    echo -e "${GREEN}==> 7) Añadiendo resurrect de PM2 al bashrc${NC}"
    grep -q "pm2 resurrect" "$HOME/.bashrc" || echo "
pm2 resurrect" >> "$HOME/.bashrc"

    echo -e "${GREEN}==> 8) Creando alias global para n8n${NC}"
    # Crear alias para n8n que use PM2
    if ! grep -q "alias n8n=" "$HOME/.bashrc"; then
        echo "
# Alias para n8n con PM2
alias n8n='pm2 start n8n --name n8n || pm2 restart n8n || pm2 logs n8n'" >> "$HOME/.bashrc"
    fi

    echo -e "${GREEN}==> 9) Creando script ejecutable n8n${NC}"
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

    echo -e "${GREEN}==> 10) Añadiendo ~/.local/bin al PATH${NC}"
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
                echo -e "${GREEN}¡Hasta luego!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Opción inválida. Presiona Enter para continuar.${NC}"
                read
                ;;
        esac

        if [ "$choice" != "8" ] && [ "$choice" != "9" ]; then
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
        *)
            echo "Uso: $0 [install|start|backup|restore|status|stop|restart|logs]"
            echo "O ejecuta sin argumentos para el menú interactivo."
            exit 1
            ;;
    esac
else
    main
fi
