#!/data/data/com.termux/files/usr/bin/bash
# Script para solucionar el problema de múltiples sesiones en Termux

echo "� Solucionando problema de múltiples sesiones en Termux..."

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}==> Problema: Termux abre una nueva sesión cada vez${NC}"
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
            echo -e "${GREEN}==> Cerrando solo procesos de apt/dpkg${NC}"
            
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
        exit 1
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
