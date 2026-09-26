#!/bin/bash
clear
echo "========================================"
echo "      INSTALADOR MiVPS SCRIPT v1.0      "
echo "========================================"

if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] Debes ejecutar esto como usuario ROOT."
  exit 1
fi

echo "[1/2] Actualizando sistema..."
apt update -y -qq > /dev/null 2>&1

echo "[2/2] Descargando el panel de control..."
wget -qO /usr/bin/mivps https://raw.githubusercontent.com/jorge415nivel/MiVPS/main/manager.sh

chmod +x /usr/bin/mivps

echo "========================================"
echo " ¡INSTALACIÓN COMPLETADA CON ÉXITO! "
echo " Escribe 'mivps' y presiona ENTER para iniciar."
echo "========================================"