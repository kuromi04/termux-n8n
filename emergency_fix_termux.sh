#!/data/data/com.termux/files/usr/bin/bash
# Script de emergencia para restaurar Termux

echo "� SCRIPT DE EMERGENCIA - RESTAURAR TERMUX"
echo "=========================================="
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${RED}Si Termux no se puede abrir después de usar fix-locks:${NC}"
echo ""
echo -e "${YELLOW}MÉTODOS DE SOLUCIÓN:${NC}"
echo ""
echo -e "${BLUE}1. REINICIAR DISPOSITIVO ANDROID (Recomendado)${NC}"
echo "   - Mantén presionado el botón de encendido"
echo "   - Selecciona 'Reiniciar' o 'Restart'"
echo "   - Espera a que el dispositivo se reinicie"
echo "   - Abre Termux nuevamente"
echo ""
echo -e "${BLUE}2. FORZAR DETENCIÓN DESDE CONFIGURACIÓN${NC}"
echo "   - Ve a Configuración de Android"
echo "   - Aplicaciones → Todas las aplicaciones"
echo "   - Busca 'Termux'"
echo "   - Toca 'Forzar detención' (Force Stop)"
echo "   - Toca 'Eliminar caché' (Clear Cache)"
echo "   - Intenta abrir Termux nuevamente"
echo ""
echo -e "${BLUE}3. REINSTALAR TERMUX (Último recurso)${NC}"
echo "   - Ve a Configuración → Aplicaciones → Termux"
echo "   - Toca 'Desinstalar'"
echo "   - Descarga Termux desde:"
echo "     https://github.com/termux/termux-app/releases"
echo "   - Instala el APK"
echo "   - Ejecuta la instalación de n8n nuevamente"
echo ""
echo -e "${GREEN}4. VERIFICAR QUE TERMUX FUNCIONA${NC}"
echo "   - Abre Termux"
echo "   - Ejecuta: pwd"
echo "   - Si funciona, ejecuta: ./scripts/n8n_manager.sh"
echo ""
echo -e "${YELLOW}NOTA:${NC} El script fix-locks ha sido corregido para evitar este problema en el futuro."
echo "Ahora solo cierra procesos de apt/dpkg, NO Termux completo."
echo ""
echo -e "${BLUE}Para prevenir este problema:${NC}"
echo "1. Usa: ./scripts/n8n_manager.sh fix-locks"
echo "2. O usa: ./scripts/fix_apt_locks.sh"
echo "3. Ambos scripts han sido actualizados para ser más seguros"
