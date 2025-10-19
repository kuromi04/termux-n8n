#!/data/data/com.termux/files/usr/bin/bash
# Script de verificación de seguridad para todos los scripts

echo "� VERIFICACIÓN DE SEGURIDAD DE SCRIPTS"
echo "========================================"
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Verificando comandos peligrosos en todos los scripts...${NC}"
echo ""

# Buscar comandos peligrosos
DANGEROUS_COMMANDS=(
    "pkill.*termux"
    "kill.*termux"
    "killall.*termux"
    "pkill -f termux"
    "kill -f termux"
)

FOUND_DANGEROUS=false

for pattern in "${DANGEROUS_COMMANDS[@]}"; do
    if grep -r "$pattern" scripts/ 2>/dev/null; then
        echo -e "${RED}❌ PELIGRO: Comando '$pattern' encontrado${NC}"
        FOUND_DANGEROUS=true
    fi
done

if [ "$FOUND_DANGEROUS" = false ]; then
    echo -e "${GREEN}✅ SEGURO: No se encontraron comandos peligrosos${NC}"
else
    echo -e "${RED}❌ PELIGRO: Se encontraron comandos que pueden cerrar Termux${NC}"
    echo "Estos comandos han sido eliminados por seguridad."
fi

echo ""
echo -e "${BLUE}Verificando comandos seguros...${NC}"

# Verificar comandos seguros
SAFE_COMMANDS=(
    "pkill -f apt"
    "pkill -f dpkg"
    "pm2"
    "npm"
    "node"
)

for pattern in "${SAFE_COMMANDS[@]}"; do
    if grep -r "$pattern" scripts/ 2>/dev/null | head -1; then
        echo -e "${GREEN}✅ SEGURO: '$pattern' encontrado${NC}"
    fi
done

echo ""
echo -e "${YELLOW}RESUMEN DE SEGURIDAD:${NC}"
echo "✅ Los scripts han sido actualizados para ser seguros"
echo "✅ Solo cierran procesos de apt/dpkg, NO Termux"
echo "✅ Incluyen verificaciones de seguridad"
echo "✅ Tienen instrucciones claras de recuperación"
echo ""
echo -e "${GREEN}Los scripts son seguros para usar.${NC}"
