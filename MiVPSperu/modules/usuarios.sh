#!/bin/bash
# ==========================================
# Módulo: Crear Usuario SSH - Base de Datos
# ==========================================

clear
echo "=========================================="
echo "        CREAR NUEVA CUENTA SSH            "
echo "=========================================="

read -p " Nombre del usuario: " usuario
if [[ -z "$usuario" || "$usuario" =~ [[:space:]] ]]; then
    echo -e "\e[31m[ERROR] Nombre inválido o contiene espacios.\e[0m"
    sleep 2
    exit 1
fi
if id "$usuario" &>/dev/null; then
    echo -e "\e[31m[ERROR] El usuario '$usuario' ya existe.\e[0m"
    sleep 2
    exit 1
fi

read -s -p " Contraseña: " pass
echo ""
read -p " Días de validez: " dias
if ! [[ "$dias" =~ ^[0-9]+$ ]]; then dias=30; fi

read -p " Límite de conexiones: " limit
if ! [[ "$limit" =~ ^[0-9]+$ ]] || [ "$limit" -eq 0 ]; then limit=1; fi

fecha_exp_visual=$(date -d "+$dias days" '+%d/%m/%Y')
fecha_exp_sys=$(date -d "+$dias days" '+%Y-%m-%d')

# 1. Crear usuario en Linux
useradd -m -s /bin/bash -e "$fecha_exp_sys" "$usuario"
echo "$usuario:$pass" | chpasswd

# 2. GUARDAR EN BASE DE DATOS OCULTA (Para que el menú pueda leer la contraseña y límite)
mkdir -p /etc/MiVPSperu
sed -i "/^$usuario:/d" /etc/MiVPSperu/user_data.db
echo "$usuario:$pass:$limit:$fecha_exp_sys" >> /etc/MiVPSperu/user_data.db

IP=$(curl -s ifconfig.me 2>/dev/null || echo "No disponible")

clear
echo -e "\e[32mSSH ACCOUNT CREATED!\e[0m"
echo ""
echo -e "\e[33m♻️ Paid Private SSH ♻️\e[0m"
echo ""
echo -e "\e[36m$usuario\e[0m"
echo "======================"
echo "=❌ NO SPAM | NO DDOS | NO HACKING"
echo "======================="
echo ""
echo -e "ᗚ IP \t\t• ๛ $IP"
echo -e " Username \t• ๛ $usuario"
echo -e "ᗚ Password \t• ๛ $pass"
echo -e " Expire \t• ๛ $fecha_exp_visual"
echo -e "ᗚ Limit \t• ๛ $limit"
echo ""
echo -e "࿂ SSH: 22 | SSL: 443 | Squid: 8080 | Dropbear: 80"
echo " [-] ═───────◇───────═"
echo "›☬[•] SCRIPTS ◇ MiVPSperu ◇═ [•]☬"
echo ""
read -p " Presiona ENTER para volver al MENU!"
