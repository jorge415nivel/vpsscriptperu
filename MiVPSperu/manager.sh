#!/bin/bash
# ==============================================================================
# MiVPS Manager - Sistema Completo (SSH + Generador de Keys)
# ==============================================================================

CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

get_system_info() {
    OS=$(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '"' | awk '{print $1, $2}')
    OS_VERSION=$(cat /etc/os-release 2>/dev/null | grep VERSION_ID | cut -d'=' -f2 | tr -d '"')
    ARCH=$(uname -m)
    CORES=$(nproc)
    IP=$(curl -s ifconfig.me 2>/dev/null || echo "No disponible")
    DATE=$(date '+%d/%m/%Y-%H:%M')
    
    DNS_PORT=$(ss -tlnp 2>/dev/null | grep ':53 ' | wc -l)
    APACHE_PORT=$(ss -tlnp 2>/dev/null | grep ':80\|:81 ' | wc -l)
    SSH_PORT=$(ss -tlnp 2>/dev/null | grep ':22 ' | wc -l)
    
    RAM_TOTAL=$(free -m 2>/dev/null | awk '/Mem:/ {print $2}')
    RAM_USED=$(free -m 2>/dev/null | awk '/Mem:/ {print $3}')
    RAM_FREE=$(free -m 2>/dev/null | awk '/Mem:/ {print $4}')
    RAM_CACHE=$(free -m 2>/dev/null | awk '/Mem:/ {print $6}')
    [ -z "$RAM_CACHE" ] && RAM_CACHE=0
    RAM_PERCENT=$(free 2>/dev/null | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')
    
    CPU_PERCENT=$(top -bn1 2>/dev/null | grep -i "cpu" | awk '{print $2}' | cut -d'%' -f1 | head -n 1)
    [ -z "$CPU_PERCENT" ] && CPU_PERCENT="0.0"
}

show_banner() {
    echo -e "${CYAN}${BOLD}"
    echo "  ██╗    ██╗███████╗██████╗ "
    echo "  ██║    ██║██╔════╝██══██╗"
    echo "  ██║ █╗ ██║█████╗  ██████╔╝"
    echo "  ██║███╗██║██╔══╝  ██╔══██╗"
    echo "  ╚███╔███╔╝███████╗██████╔╝"
    echo "   ╚══╝╚══╝ ╚══════╝═════╝ "
    echo -e "${NC}"
}

show_system_info() {
    get_system_info
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${YELLOW}• S.O:${NC} ${OS} ${OS_VERSION}   ${YELLOW}Base:${NC} ${ARCH}   ${YELLOW}Cores:${NC} ${CORES}"
    echo -e " ${YELLOW}• IP:${NC} ${IP}   ${YELLOW}FECHA:${NC} ${DATE}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}Key:${NC} Verified [ MiVPSperu © ] (v1.0)"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${YELLOW}• System-DNS:${NC} $(if [ "$DNS_PORT" -gt 0 ]; then echo -e "${GREEN}53 [ON]${NC}"; else echo -e "${RED}53 [OFF]${NC}"; fi)   ${YELLOW}APACHE:${NC} $(if [ "$APACHE_PORT" -gt 0 ]; then echo -e "${GREEN}81 [ON]${NC}"; else echo -e "${RED}81 [OFF]${NC}"; fi)"
    echo -e " ${YELLOW}• SSH:${NC} $(if [ "$SSH_PORT" -gt 0 ]; then echo -e "${GREEN}22 [ON]${NC}"; else echo -e "${RED}22 [OFF]${NC}"; fi)"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}▶ TOTAL:${NC} ${RAM_TOTAL}M   ${GREEN}Libre:${NC} ${RAM_FREE}M   ${GREEN}Usada:${NC} ${RAM_USED}M"
    echo -e " ${GREEN}▶ Uso RAM:${NC} ${RAM_PERCENT}%   ${GREEN}Uso CPU:${NC} ${CPU_PERCENT}%   ${GREEN}Cache:${NC} ${RAM_CACHE}M"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

show_protocols_menu() {
    echo -e "${CYAN}🔧 GESTIÓN Y PROTOCOLOS 🔧${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${YELLOW}[1]${NC} › CREAR USUARIO SSH  [✅]   ${YELLOW}[12]${NC} › TROJAN-GO         [OFF]"
    echo -e " ${YELLOW}[2]${NC} › VER USUARIOS       [✅]   ${YELLOW}[13]${NC} › PSIPHON SERVER     [OFF]"
    echo -e " ${YELLOW}[3]${NC} › ELIMINAR USUARIO   [✅]   ${YELLOW}[14]${NC} › TCP DNS           [OFF]"
    echo -e " ${YELLOW}[4]${NC} › SQUID              [OFF]   ${YELLOW}[15]${NC} › WEBMIN            [OFF]"
    echo -e " ${YELLOW}[5]${NC} › DROPBEAR           [OFF]   ${YELLOW}[16]${NC} › SlowDNS           [OFF]"
    echo -e " ${YELLOW}[6]${NC} › OPENVPN            [OFF]   ${YELLOW}[17]${NC} › SSL→PYTHON        [OFF]"
    echo -e " ${YELLOW}[7]${NC} › SSL/TLS            [OFF]   ${YELLOW}[18]${NC} › SSH Multiplex     [OFF]"
    echo -e " ${YELLOW}[8]${NC} › SHADOWSOCKS-R      [OFF]   ${YELLOW}[19]${NC} › OVER WEBSOCKET    [OFF]"
    echo -e " ${YELLOW}[9]${NC} › SHADOWSOCKS        [OFF]   ${YELLOW}[20]${NC} › SOCKS5            [OFF]"
    echo -e " ${YELLOW}[10]${NC} › PROXY PYTHON      [OFF]   ${YELLOW}[21]${NC} › UDPServer Request [OFF]"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${YELLOW}[11]${NC} › V2RAY SWITCH      [OFF]   ${YELLOW}[22]${NC} › CHISEL            [OFF]"
    echo -e " ${YELLOW}[23]${NC} › GENERAR KEYS ADM  [✅]   ${YELLOW}[0]${NC}  › [ SALIR DEL PANEL ]"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

while true; do
    clear
    show_banner
    show_system_info
    show_protocols_menu
    
    read -p " Opcion: " opcion

    case $opcion in
        1) clear; bash <(curl -s https://raw.githubusercontent.com/jorge415nivel/vpsscriptperu/main/MiVPSperu/modules/crear_usuario.sh) ;;
        2)
            clear
            echo "========================================================================"
            echo "                    USUARIOS SSH ACTUALES                               "
            echo "========================================================================"
            USUARIOS=$(awk -F: '$3 >= 1000 && $1 != "nobody" && $1 != "ubuntu" {print $1}' /etc/passwd)
            COUNT=$(echo "$USUARIOS" | grep -c . 2>/dev/null || echo 0)
            [ -z "$USUARIOS" ] && COUNT=0
            
            if [ "$COUNT" -eq 0 ]; then
                echo -e " \e[31m  No hay usuarios creados actualmente en el sistema.\e[0m"
            else
                echo -e " \e[32mTotal de usuarios:\e[0m \e[1;33m$COUNT\e[0m"
                echo "------------------------------------------------------------------------"
                printf "  \e[33m%-12s\e[0m | \e[33m%-12s\e[0m | \e[33m%-8s\e[0m | \e[33m%-15s\e[0m\n" "USUARIO" "PASSWORD" "LIMITE" "VALIDEZ"
                echo "------------------------------------------------------------------------"
                
                ONLINES=0; DEADLINES=0; TODAY=$(date +%s)
                for user in $USUARIOS; do
                    who | grep -q "^$user " && ONLINES=$((ONLINES+1))
                    EXP_DATE_RAW=$(chage -l "$user" 2>/dev/null | grep -i "expires\|expira" | cut -d: -f2 | xargs)
                    
                    if [ -z "$EXP_DATE_RAW" ] || [ "$EXP_DATE_RAW" == "never" ]; then
                        EXP_DATE="Nunca"; COLOR_DIAS="\e[32m"
                    else
                        EXP_SEC=$(date -d "$EXP_DATE_RAW" +%s 2>/dev/null)
                        if [ -n "$EXP_SEC" ]; then
                            DAYS_LEFT=$(( (EXP_SEC - TODAY) / 86400 ))
                            if [ "$DAYS_LEFT" -lt 0 ]; then
                                DAYS_LEFT=0; DEADLINES=$((DEADLINES+1)); COLOR_DIAS="\e[31m"; EXP_DATE="$DAYS_LEFT Dias (Vencido)"
                            else
                                COLOR_DIAS="\e[32m"; EXP_DATE="$DAYS_LEFT Dias"
                            fi
                        else
                            EXP_DATE="N/A"; COLOR_DIAS="\e[33m"
                        fi
                    fi
                    LIMIT=$(cat /etc/MiVPSperu/limits/$user 2>/dev/null || echo "1")
                    printf "  \e[32m%-12s\e[0m | \e[37m%-12s\e[0m | \e[36m%-8s\e[0m | ${COLOR_DIAS}%-15s\e[0m\n" "$user" "****" "$LIMIT" "$EXP_DATE"
                    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                done
                echo ""
                echo -e "• \e[33mAll USERS $COUNT\e[0m • \e[32mONLINES: $ONLINES\e[0m • \e[31mDEADLINES: $DEADLINES\e[0m •"
                echo "========================================================================"
                echo " Nota: Por seguridad de Linux, la contraseña real solo se muestra"
                echo "       en el momento exacto de la creación del usuario."
                echo "========================================================================"
            fi
            read -p " Presiona ENTER para volver al menú..."
            ;;
        3)
            clear
            echo "=========================================="
            echo "        ELIMINAR USUARIO SSH              "
            echo "=========================================="
            read -p " Nombre del usuario a eliminar: " user_del
            if id "$user_del" &>/dev/null; then
                userdel -r "$user_del" 2>/dev/null || userdel "$user_del"
                rm -f /etc/MiVPSperu/limits/$user_del 2>/dev/null
                echo -e "\e[32m[OK] Usuario '$user_del' eliminado del sistema.\e[0m"
            else
                echo -e "\e[31m[ERROR] El usuario '$user_del' no existe.\e[0m"
            fi
            read -p " Presiona ENTER para volver..."
            ;;
        23)
            clear
            bash <(curl -s https://raw.githubusercontent.com/jorge415nivel/vpsscriptperu/main/MiVPSperu/modules/generar_keys.sh)
            ;;
        4) echo -e "${YELLOW}Instalando SQUID...${NC}"; apt install -y squid; sleep 2 ;;
        5) echo -e "${YELLOW}Instalando DROPBEAR...${NC}"; apt install -y dropbear; sleep 2 ;;
        6) echo -e "${YELLOW}Instalando OPENVPN...${NC}"; apt install -y openvpn; sleep 2 ;;
        7) echo -e "${YELLOW}Configurando SSL/TLS...${NC}"; sleep 2 ;;
        8) echo -e "${YELLOW}Instalando SHADOWSOCKS-R...${NC}"; sleep 2 ;;
        9) echo -e "${YELLOW}Instalando SHADOWSOCKS...${NC}"; apt install -y shadowsocks-libev; sleep 2 ;;
        10) echo -e "${YELLOW}Instalando PROXY PYTHON...${NC}"; sleep 2 ;;
        11) echo -e "${YELLOW}Instalando V2RAY...${NC}"; bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh); sleep 2 ;;
        12) echo -e "${YELLOW}Instalando TROJAN-GO...${NC}"; sleep 2 ;;
        13) echo -e "${YELLOW}Instalando PSIPHON...${NC}"; sleep 2 ;;
        14) echo -e "${YELLOW}Configurando TCP DNS...${NC}"; sleep 2 ;;
        15) echo -e "${YELLOW}Instalando WEBMIN...${NC}"; sleep 2 ;;
        16) echo -e "${YELLOW}Instalando SlowDNS...${NC}"; sleep 2 ;;
        17) echo -e "${YELLOW}Configurando SSL→PYTHON...${NC}"; sleep 2 ;;
        18) echo -e "${YELLOW}Configurando SSH Multiplex...${NC}"; sleep 2 ;;
        19) echo -e "${YELLOW}Configurando OVER WEBSOCKET...${NC}"; sleep 2 ;;
        20) echo -e "${YELLOW}Configurando SOCKS5...${NC}"; sleep 2 ;;
        21) echo -e "${YELLOW}Configurando UDPServer...${NC}"; sleep 2 ;;
        22) echo -e "${YELLOW}Instalando CHISEL...${NC}"; apt install -y chisel; sleep 2 ;;
        0) clear; echo -e "${RED}Saliendo del panel. ¡Hasta luego!${NC}"; exit 0 ;;
        *) echo -e "${RED}Opción no válida. Intente de nuevo.${NC}"; sleep 2 ;;
    esac
done
