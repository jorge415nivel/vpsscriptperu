#!/bin/bash
clear
echo "========================================"
echo "        GESTIÓN DE USUARIOS SSH         "
echo "========================================"
echo "1. Ver usuarios actuales"
echo "2. Crear nuevo usuario"
echo "0. Volver al menú principal"
echo "========================================"

read -p "Elige una opción: " op

case $op in
    1)
        echo "--- Usuarios con acceso a terminal ---"
        cat /etc/passwd | grep "/bin/bash" | cut -d: -f1
        read -p "Presiona ENTER para continuar..."
        ;;
    2)
        read -p "Nombre del nuevo usuario: " nuevo_user
        useradd -m -s /bin/bash "$nuevo_user"
        passwd "$nuevo_user"
        echo "Usuario $nuevo_user creado correctamente."
        read -p "Presiona ENTER para continuar..."
        ;;
    0)
        exit 0
        ;;
    *)
        echo "Opción no válida."
        sleep 1
        ;;
esac