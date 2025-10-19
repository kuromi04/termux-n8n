# Gestor Unificado de N8N para Termux Android

Este script combina todas las funcionalidades de los scripts individuales en una sola herramienta de gestión.

## Características

- **Menú interactivo** con opciones numeradas
- **Modo no interactivo** para uso en scripts
- **Colores** para mejor visualización
- **Validaciones** de errores y dependencias
- **Gestión completa** de n8n y PM2

## Uso

### Modo Interactivo (Recomendado)
```bash
./scripts/n8n_manager.sh
```

### Modo No Interactivo
```bash
# Instalar n8n
./scripts/n8n_manager.sh install

# Iniciar n8n
./scripts/n8n_manager.sh start

# Crear backup
./scripts/n8n_manager.sh backup

# Restaurar backup
./scripts/n8n_manager.sh restore /ruta/al/backup.tar.gz

# Ver estado
./scripts/n8n_manager.sh status

# Detener n8n
./scripts/n8n_manager.sh stop

# Reiniciar n8n
./scripts/n8n_manager.sh restart

# Ver logs
./scripts/n8n_manager.sh logs
```

## Opciones del Menú

1. **Instalar n8n** - Instalación completa de n8n y dependencias
2. **Iniciar n8n** - Inicia n8n con PM2 y opción de abrir en navegador
3. **Crear backup** - Crea un backup de los datos de n8n
4. **Restaurar backup** - Restaura un backup existente
5. **Ver estado** - Muestra el estado actual de PM2
6. **Detener n8n** - Detiene n8n
7. **Reiniciar n8n** - Reinicia n8n
8. **Ver logs** - Muestra los logs en tiempo real
9. **Salir** - Sale del programa

## Requisitos

- Termux instalado desde GitHub (no desde Google Play)
- Conexión a internet para la instalación inicial

## Notas

- Los backups se guardan en `$HOME/backups/`
- Los datos de n8n se almacenan en `$HOME/.n8n/`
- El script incluye validaciones de errores y dependencias
- Compatible con Termux en Android
