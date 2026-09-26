#!/bin/bash
# ==========================================
# Módulo: Crear Usuario SSH con Expiración
# ==========================================

clear
echo "=========================================="
echo "        CREAR NUEVO USUARIO SSH           "
echo "=========================================="

# 1. Pedir nombre de usuario
read -p " Nombre del usuario: " usuario

# Validar que no esté vacío y no tenga espacios
if [[ -z "$usuario" || "$usuario" =~ [[:space:]] ]]; then
    echo -e "\e[31m[ERROR] Nombre inválido o contiene espacios.\e[0m"
    sleep 2
    exit 1
fi

# 2. Verificar si el usuario ya existe
if id "$usuario" &>/dev/null; then
    echo -e "\e[31m[ERROR] El usuario '$usuario' ya existe en el sistema.\e[0m"
    sleep 2
    exit 1
fi

# 3. Pedir contraseña (oculta)
read -s -p " Contraseña: " pass
echo ""

# 4. Pedir días de validez
read -p " Días de validez (ej. 1, 7, 30): " dias

# Validar que sean números
if ! [[ "$dias" =~ ^[0-9]+$ ]]; then
    echo -e "\e[31m[ERROR] Debes ingresar un número válido de días.\e[0m"
    sleep 2
    exit 1
fi

# 5. Calcular fecha de expiración (Formato YYYY-MM-DD)
fecha_exp=$(date -d "+$dias days" '+%Y-%m-%d')

# 6. Crear el usuario y asignar contraseña
useradd -m -s /bin/bash -e "$fecha_exp" "$usuario"
echo "$usuario:$pass" | chpasswd

# 7. Mostrar resumen
clear
echo "=========================================="
echo "   ¡USUARIO CREADO CON ÉXITO! ✅          "
echo "=========================================="
echo -e " \e[32mUsuario\e[0m    : $usuario"
echo -e " \e[32mContraseña\e[0m : $pass"
echo -e " \e[32mVence el\e[0m   : $fecha_exp"
echo -e " \e[32mPuerto SSH\e[0m : 22"
echo -e " \e[32mIP del Server\e[0m: $(curl -s ifconfig.me)"
echo "=========================================="
echo " Guarda estos datos, no se volverán a mostrar."
echo "=========================================="
read -p " Presiona ENTER para volver al menú principal..."
