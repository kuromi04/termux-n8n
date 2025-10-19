---

## � Contribuir

¡Las contribuciones son bienvenidas! �

### � **Cómo Contribuir**

1. � **Fork** el repositorio
2. � **Crea** una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. � **Commit** tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. � **Push** a la rama (`git push origin feature/AmazingFeature`)
5. � **Abre** un Pull Request

### � **Áreas de Contribución**

- � **Reportar bugs** y problemas
- ✨ **Nuevas funcionalidades** y mejoras
- � **Documentación** y ejemplos
- � **Mejoras de UI/UX**
- ⚡ **Optimizaciones** de rendimiento
- � **Testing** y validaciones

---

## � Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

---

## � Créditos

- **Autor**: @tiendastelegram
- **Inspirado por**: La comunidad de IvanByCinderella, n8n y Termux
- **Telegram**: https://t.me/tiendastelegram
- **YouTube**: [Video tutorial](https://www.youtube.com/watch?v=DYtlUBZ3Od4)

---

## � Sistema de Backup

Los datos de n8n se almacenan en `$HOME/.n8n`. El gestor incluye sistema de backup automático:

### � **Crear Backup**
```bash
# Opción 1: Desde el menú
./scripts/n8n_manager.sh
# Seleccionar opción 3

# Opción 2: Modo no interactivo
./scripts/n8n_manager.sh backup

# Opción 3: Comando directo (después de instalación)
n8n backup  # Si está implementado
```

### � **Restaurar Backup**
```bash
# Opción 1: Desde el menú
./scripts/n8n_manager.sh
# Seleccionar opción 4

# Opción 2: Modo no interactivo
./scripts/n8n_manager.sh restore /ruta/al/backup.tar.gz
```

### � **Ubicación de Backups**
- **Directorio**: `~/backups/`
- **Formato**: `n8n-backup-YYYYMMDD-HHMMSS.tar.gz`
- **Compresión**: tar.gz optimizada

---

## � Instalación de Termux

> ⚠️ **Importante**: Siempre instala Termux desde su [repositorio oficial en GitHub](https://github.com/termux/termux-app/releases) o desde los **Termux Packages** de [IvanByCinderella](https://github.com/IvanByCinderella/termux-packages).  
> No uses la versión de Google Play: está desactualizada y puede dar problemas con n8n.

### **Opción 1 – GitHub oficial de Termux**
1. Abre: [https://github.com/termux/termux-app/releases](https://github.com/termux/termux-app/releases)
2. Busca la última versión estable (`.apk`) y descárgala
3. Instala el APK (activa "permitir orígenes desconocidos" si es necesario)

### **Opción 2 – Termux Packages de IvanByCinderella**
1. Abre: [https://github.com/IvanByCinderella/termux-packages](https://github.com/IvanByCinderella/termux-packages)
2. En releases, descarga el `.apk` más reciente
3. Instálalo igual que en la opción 1

### **Verificación**
```bash
termux-info
```
Debe mostrar la versión instalada y arquitectura.

---

## � Casos de Uso con IA

Con n8n en tu Android puedes automatizar casi cualquier cosa:

- **Integración con Telegram** � — Envía mensajes automáticos o responde con IA
- **WhatsApp Bots** � — Responde automáticamente usando ChatGPT o modelos locales
- **Google Sheets** � — Registra datos, genera reportes y envía notificaciones
- **APIs externas** � — Consume APIs de IA para análisis de texto, visión por computadora
- **Notificaciones inteligentes** � — Alertas por correo, push o mensajería
- **Scraping y resumen** � — Recopila info de webs y genera resúmenes con IA

> Todo esto sin pagar VPS, sin depender de la nube y con el control total de tus datos.

---

<div align="center">

### � **¿Te gusta este proyecto?**

[![GitHub stars](https://img.shields.io/github/stars/tu-usuario/n8n-termux-android-ia?style=social)](https://github.com/tu-usuario/n8n-termux-android-ia/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/tu-usuario/n8n-termux-android-ia?style=social)](https://github.com/tu-usuario/n8n-termux-android-ia/network)
[![GitHub watchers](https://img.shields.io/github/watchers/tu-usuario/n8n-termux-android-ia?style=social)](https://github.com/tu-usuario/n8n-termux-android-ia/watchers)

**¡Dale una ⭐ si te ha sido útil!**

---

**Desarrollado con ❤️ para la comunidad de Termux y N8N**

[![Termux](https://img.shields.io/badge/Made%20for-Termux-1f425f.svg)](https://termux.com/)
[![N8N](https://img.shields.io/badge/Powered%20by-N8N-ff6d5a.svg)](https://n8n.io/)

</div>n8n_manager.sh restart

# � Ver logs en tiempo real
./scripts/n8n_manager.sh logs

# � Solucionar locks de apt
./scripts/n8n_manager.sh fix-locks
```

### � **Comando Directo n8n (Después de la Instalación)**
```bash
# Después de la instalación, puedes usar directamente:
n8n start     # Iniciar n8n
n8n stop      # Detener n8n
n8n restart   # Reiniciar n8n
n8n status    # Ver estado
n8n logs      # Ver logs
n8n open      # Abrir en navegador
n8n           # Mostrar ayuda
```

---

## � Requisitos del Sistema

<div align="center">

| Componente | Versión Mínima | Recomendada |
|:----------|:--------------:|:-----------:|
| **Android** | 7.0+ | 10.0+ |
| **Termux** | 0.118+ | Última |
| **RAM** | 2GB | 4GB+ |
| **Almacenamiento** | 1GB libre | 5GB+ |
| **Conexión** | WiFi/4G | WiFi estable |

</div>

### � **Requisitos Detallados**

- � **Termux** instalado desde [GitHub Releases](https://github.com/termux/termux-app/releases) (NO desde Google Play)
- � **Conexión a internet** para la instalación inicial
- � **Almacenamiento libre** mínimo 1GB
- � **Batería** suficiente para procesos de larga duración

---

## � Funcionalidades Detalladas

### � **1. Instalación Automática**
- ✅ Actualización de paquetes de Termux
- ✅ Instalación de dependencias de compilación
- ✅ Configuración automática de NDK para node-gyp
- ✅ Instalación de N8N con SQLite embebido
- ✅ Configuración de PM2 como gestor de procesos
- ✅ Creación de directorios necesarios
- ✅ **Solución automática** de locks de apt

### � **2. Gestión de Procesos**
- ▶️ **Inicio inteligente** con validaciones
- ⏹️ **Parada segura** con guardado de estado
- � **Reinicio automático** con recuperación
- � **Monitoreo en tiempo real** del estado
- � **Visualización de logs** con scroll automático

### � **3. Sistema de Backup**
- � **Timestamps automáticos** en nombres de archivo
- � **Compresión optimizada** con tar.gz
- � **Validación de integridad** de archivos
- � **Organización automática** en directorio backups/
- � **Restauración segura** con verificación de permisos

### � **4. Interfaz de Usuario**
- � **Colores y emojis** para mejor experiencia
- � **Diseño responsive** para pantallas pequeñas
- ⚡ **Navegación rápida** con teclas de acceso
- � **Mensajes informativos** y de error claros
- � **Indicadores visuales** de progreso

### � **5. Comando Directo n8n**
- ⚡ **Acceso global** al comando `n8n` desde cualquier directorio
- � **Comandos intuitivos** con subcomandos fáciles de recordar
- � **Gestión completa** sin necesidad del menú interactivo
- � **Integración perfecta** con Termux y PM2
- � **Sistema de ayuda** integrado con `n8n` sin argumentos

---

## �️ Seguridad

### � **Recomendaciones de Seguridad**
- Configura **credenciales** vía variables de entorno (no subas `.env` con datos reales)
- Si expones el puerto 5678 fuera de tu red local, usa **proxy** con autenticación
- Considera **túneles temporales** (ngrok/cloudflared) para pruebas, no para producción
- **Backup regular** de tus workflows y configuraciones

### � **Variables de Entorno (Opcional)**
Crea `~/.n8n/.env`:
```ini
# Puerto donde escuchará n8n
N8N_PORT=5678

# Usuario/contraseña inicial (solo si usas basic auth en un reverse proxy)
BASIC_AUTH_USER=admin
BASIC_AUTH_PASSWORD=cambia_esto

# Directorio de datos
N8N_USER_FOLDER=$HOME/.n8n

# Producción / desarrollo
NODE_ENV=production
```

---

## � Solución de Problemas

### � **Problemas Comunes**

| Problema | Solución |
|:---------|:---------|
| **Locks de apt** | Usa: `./scripts/n8n_manager.sh fix-locks` |
| **Error de compilación** | Verifica dependencias: `pkg install -y ndk-sysroot clang make python` |
| **SQLite no encontrado** | Verifica ruta: `--sqlite=/data/data/com.termux/files/usr/bin/sqlite3` |
| **PM2 no resucita** | Verifica `~/.bashrc` contiene `pm2 resurrect` y ejecuta `pm2 save` |
| **No abre en navegador** | Verifica IP con `ifconfig` y puerto 5678 accesible en LAN |

### � **Verificación Rápida**
```bash
# Verificar estado de PM2
pm2 list

# Ver logs de n8n
pm2 logs n8n --lines 50

# Verificar que n8n responde
curl -I http://127.0.0.1:5678

# Usar comando directo
n8n status
```

### � **Solución Automática de Locks**
```bash
# Opción 1: Script independiente
./scripts/fix_apt_locks.sh

# Opción 2: Desde el menú
./scripts/n8n_manager.sh
# Seleccionar opción 9

# Opción 3: Modo no interactivo
./scripts/n8n_manager.sh fix-locks
```

---

## � Contribuir

¡Las contribuciones son bienvenidas! �

### � **Cómo Contribuir**

1. � **Fork** el repositorio
2. � **Crea** una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. � **Commit** tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. � **Push** a la rama (`git push origin feature/AmazingFeature`)
5. � **Abre** un Pull Request

### � **Áreas de Contribución**

- � **Reportar bugs** y problemas
- ✨ **Nuevas funcionalidades** y mejoras
- � **Documentación** y ejemplos
- � **Mejoras de UI/UX**
- ⚡ **Optimizaciones** de rendimiento
- � **Testing** y validaciones

---

## � Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

---

## � Créditos

- **Autor**: @tiendastelegram
- **Inspirado por**: La comunidad de IvanByCinderella, n8n y Termux
- **Telegram**: https://t.me/tiendastelegram
- **YouTube**: [Video tutorial](https://www.youtube.com/watch?v=DYtlUBZ3Od4)

---

## � Sistema de Backup

Los datos de n8n se almacenan en `$HOME/.n8n`. El gestor incluye sistema de backup automático:

### � **Crear Backup**
```bash
# Opción 1: Desde el menú
./scripts/n8n_manager.sh
# Seleccionar opción 3

# Opción 2: Modo no interactivo
./scripts/n8n_manager.sh backup

# Opción 3: Comando directo (después de instalación)
n8n backup  # Si está implementado
```

### � **Restaurar Backup**
```bash
# Opción 1: Desde el menú
./scripts/n8n_manager.sh
# Seleccionar opción 4

# Opción 2: Modo no interactivo
./scripts/n8n_manager.sh restore /ruta/al/backup.tar.gz
```

### � **Ubicación de Backups**
- **Directorio**: `~/backups/`
- **Formato**: `n8n-backup-YYYYMMDD-HHMMSS.tar.gz`
- **Compresión**: tar.gz optimizada

---

## � Instalación de Termux

> ⚠️ **Importante**: Siempre instala Termux desde su [repositorio oficial en GitHub](https://github.com/termux/termux-app/releases) o desde los **Termux Packages** de [IvanByCinderella](https://github.com/IvanByCinderella/termux-packages).  
> No uses la versión de Google Play: está desactualizada y puede dar problemas con n8n.

### **Opción 1 – GitHub oficial de Termux**
1. Abre: [https://github.com/termux/termux-app/releases](https://github.com/termux/termux-app/releases)
2. Busca la última versión estable (`.apk`) y descárgala
3. Instala el APK (activa "permitir orígenes desconocidos" si es necesario)

### **Opción 2 – Termux Packages de IvanByCinderella**
1. Abre: [https://github.com/IvanByCinderella/termux-packages](https://github.com/IvanByCinderella/termux-packages)
2. En releases, descarga el `.apk` más reciente
3. Instálalo igual que en la opción 1

### **Verificación**
```bash
termux-info
```
Debe mostrar la versión instalada y arquitectura.

---

## � Casos de Uso con IA

Con n8n en tu Android puedes automatizar casi cualquier cosa:

- **Integración con Telegram** � — Envía mensajes automáticos o responde con IA
- **WhatsApp Bots** � — Responde automáticamente usando ChatGPT o modelos locales
- **Google Sheets** � — Registra datos, genera reportes y envía notificaciones
- **APIs externas** � — Consume APIs de IA para análisis de texto, visión por computadora
- **Notificaciones inteligentes** � — Alertas por correo, push o mensajería
- **Scraping y resumen** � — Recopila info de webs y genera resúmenes con IA

> Todo esto sin pagar VPS, sin depender de la nube y con el control total de tus datos.

---

<div align="center">

### � **¿Te gusta este proyecto?**

[![GitHub stars](https://img.shields.io/github/stars/tu-usuario/n8n-termux-android-ia?style=social)](https://github.com/tu-usuario/n8n-termux-android-ia/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/tu-usuario/n8n-termux-android-ia?style=social)](https://github.com/tu-usuario/n8n-termux-android-ia/network)
[![GitHub watchers](https://img.shields.io/github/watchers/tu-usuario/n8n-termux-android-ia?style=social)](https://github.com/tu-usuario/n8n-termux-android-ia/watchers)

**¡Dale una ⭐ si te ha sido útil!**

---

**Desarrollado por @kuromi04 para la comunidad de Termux y N8N**

[![Termux](https://img.shields.io/badge/Made%20for-Termux-1f425f.svg)](https://termux.com/)
[![N8N](https://img.shields.io/badge/Powered%20by-N8N-ff6d5a.svg)](https://n8n.io/)

</div>
