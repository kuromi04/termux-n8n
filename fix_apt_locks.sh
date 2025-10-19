#!/data/data/com.termux/files/usr/bin/bash
# Script rápido para solucionar locks de apt en Termux

echo "� Solucionando problemas de locks de apt/dpkg..."

# Verificar si hay procesos apt ejecutándose
if pgrep -f "apt|dpkg" > /dev/null; then
    echo "⚠️  Procesos apt/dpkg detectados, esperando a que terminen..."
    while pgrep -f "apt|dpkg" > /dev/null; do
        echo "⏳ Esperando a que terminen los procesos apt/dpkg..."
        sleep 5
    done
    echo "✅ Procesos apt/dpkg terminados"
fi

# Limpiar locks si existen
echo "� Limpiando locks de apt/dpkg..."
rm -f /data/data/com.termux/files/usr/var/lib/dpkg/lock-frontend 2>/dev/null || true
rm -f /data/data/com.termux/files/usr/var/lib/dpkg/lock 2>/dev/null || true
rm -f /data/data/com.termux/files/usr/var/cache/apt/archives/lock 2>/dev/null || true

echo "✅ Locks limpiados exitosamente"
echo "� Ahora puedes intentar la instalación nuevamente:"
echo "   ./scripts/n8n_manager.sh install"
echo ""
echo "⚠️  IMPORTANTE:"
echo "Si Termux no se abre después de esto:"
echo "1. Reinicia tu dispositivo Android"
echo "2. O ve a Configuración → Aplicaciones → Termux → Forzar detención"
echo "3. Luego intenta abrir Termux nuevamente"
