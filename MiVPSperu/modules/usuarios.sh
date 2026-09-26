#!/bin/bash
# ==========================================
# Módulo: Crear Usuario SSH - Estilo Profesional
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
    echo -e "\e[31m[ERROR] El usuario '$usuario' ya existe en el sistema.\e[0m"
    sleep 2
    exit 1
fi

read -s -p " Contraseña: " pass
echo ""
read -p " Días de validez (ej. 1, 7, 30): " dias
if ! [[ "$dias" =~ ^[0-9]+$ ]]; then
    echo -e "\e[31m[ERROR] Debes ingresar un número válido de días.\e[0m"
    sleep 2
    exit 1
fi

read -p " Límite de conexiones simultáneas: " limit
if ! [[ "$limit" =~ ^[0-9]+$ ]] || [ "$limit" -eq 0 ]; then
    limit=1
fi

fecha_exp_visual=$(date -d "+$dias days" '+%d/%m/%Y')
fecha_exp_sys=$(date -d "+$dias days" '+%Y-%m-%d')

# CREAR USUARIO FORZANDO /bin/bash
useradd -m -s /bin/bash -e "$fecha_exp_sys" "$usuario"
echo "$usuario:$pass" | chpasswd

IP=$(curl -s ifconfig.me 2>/dev/null || echo "No disponible")

clear
echo -e "\e[32mSSH ACCOUNT CREATED!\e[0m"
echo ""
echo -e "\e[33m♻️ Paid Private SSH ♻️\e[0m"
echo ""
echo -e "\e[36m$usuario\e[0m"
echo "======================"
echo "=❌ NO SPAM"
echo "=❌ NO DDOS"
echo "=❌ NO HACKING"
echo "=❌ NO CARDING"
echo "=❌ NO TORRENT"
echo "=❌ NO OVER DOWNLOAD"
echo "=❌ NO MULTILOGIN"
echo "======================="
echo ""
echo -e "ᗚ IP \t\t• ๛ $IP"
echo -e " Username \t• ๛ $usuario"
echo -e "ᗚ Password \t• ๛ $pass"
echo -e " Expire \t• ๛ $fecha_exp_visual"
echo -e "ᗚ Limit \t• ๛ $limit"
echo ""
echo -e "࿂ SSH \t\t•  22"
echo -e "࿂ SSL \t\t•  443"
echo -e "࿂ Squid \t•  8080"
echo -e "࿂ Dropbear \t•  80"
echo " [-] ═───────◇───────═"
echo -e "࿂ Badvpn \t•  7300"
echo " [-] ═───────◇───────═"
echo "›☬[•] SCRIPTS ═◇ MiVPSperu ◇═ [•]☬"
echo ""
read -p " Presiona ENTER para volver al MENU!"
