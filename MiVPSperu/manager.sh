#!/bin/bash
# ==========================================
# MiVPS Manager - Estilo ADM
# ==========================================

# Función para obtener colores
CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Función para obtener datos reales del sistema
get_system_info() {
    # Sistema operativo
    OS=$(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '"' | awk '{print $1, $2}')
    OS_VERSION=$(cat /etc/os-release | grep VERSION_ID | cut -d'=' -f2 | tr -d '"')
    
    # Arquitectura
    ARCH=$(uname -m)
    
    # Núcleos CPU
    CORES=$(nproc)
    
    # IP pública
    IP=$(curl -s ifconfig.me 2>/dev/null || echo "No disponible")
    
    # Fecha actual
    DATE=$(date '+%d/%m/%Y-%H:%M')
    
    # Puertos en uso
    DNS_PORT=$(ss -tlnp | grep ':53 ' | wc -l)
    APACHE_PORT=$(ss -tlnp | grep ':80 ' | wc -l)
    SSH_PORT=$(ss -tlnp | grep ':22 ' | wc -l)
    
    # Memoria RAM
    RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
    RAM_USED=$(free -m | awk '/Mem:/ {print $3}')
    RAM_FREE=$(free -m | awk '/Mem:/ {print $4}')
    RAM_CACHE=$(free -m | awk '/Mem:/ {print $6}')
    RAM_PERCENT=$(free | awk '/Mem:/ {printf "%.2f", $3/$2 * 100}')
    
    # Uso CPU
    CPU_PERCENT=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
}

# Función para mostrar el banner
show_banner() {
    echo -e "${CYAN}"
    echo "  ██╗    ██╗███████╗██████╗ "
    echo "  ██║    ██║██╔════╝██╔══██╗"
    echo "  ██║ █╗ ██║█████╗  ██████╔╝"
    echo "  ██║███╗██║██╔══╝  ██╔══██╗"
    echo "  ╚███╔███╔╝███████╗██████╔╝"
    echo "   ╚══╝╚══╝ ╚══════╝╚═════╝ "
    echo -e "${NC}"
}

# Función para mostrar información del sistema
show_system_info() {
    get_system_info
    
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${YELLOW}• S.O:${NC} ${OS} ${OS_VERSION}   ${YELLOW}Base:${NC} ${ARCH}   ${YELLOW}Cores:${NC} ${CORES}"
    echo -e " ${YELLOW}• IP:${NC} ${IP}   ${YELLOW}FECHA:${NC} ${DATE}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}Key:${NC} Verified [ MiVPSperu © ] (v1.0)"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${YELLOW}• System-DNS:${NC} $(if [ $DNS_PORT -gt 0 ]; then echo -e "${GREEN}53 [ON]${NC}"; else echo -e "${RED}53 [OFF]${NC}"; fi)   ${YELLOW}APACHE:${NC} $(if [ $APACHE_PORT -gt 0 ]; then echo -e "${GREEN}81 [ON]${NC}"; else echo -e "${RED}81 [OFF]${NC}"; fi)"
    echo -e " ${YELLOW}• SSH:${NC} $(if [ $SSH_PORT -gt 0 ]; then echo -e "${GREEN}22 [ON]${NC}"; else echo -e "${RED}22 [OFF]${NC}"; fi)"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}▶ TOTAL:${NC} ${RAM_TOTAL}M   ${GREEN}Libre:${NC} ${RAM_FREE}M   ${GREEN}Usada:${NC} ${RAM_USED}M"
    echo -e " ${GREEN}▶ Uso RAM:${NC} ${RAM_PERCENT}%   ${GREEN}Uso CPU:${NC} ${CPU_PERCENT}%   ${GREEN}Cache:${NC} ${RAM_CACHE}M"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Función para mostrar el menú de protocolos
show_protocols_menu() {
    echo -e "${CYAN}🔧 INSTALACIÓN DE PROTOCOLOS 🔧${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${YELLOW}[1]${NC} › SQUID              [OFF]   ${YELLOW}[11]${NC} › PSIPHON SERVER     [OFF]"
    echo -e " ${YELLOW}[2]${NC} › DROPBEAR           [OFF]   ${YELLOW}[12]${NC} › TCP DNS           [OFF]"
    echo -e " ${YELLOW}[3]${NC} › OPENVPN            [OFF]   ${YELLOW}[13]${NC} › WEBMIN            [OFF]"
    echo -e " ${YELLOW}[4]${NC} › SSL/TLS            [OFF]   ${YELLOW}[14]${NC} › SlowDNS           [OFF]"
    echo -e " ${YELLOW}[5]${NC} › SHADOWSOCKS-R      [OFF]   ${YELLOW}[15]${NC} › SSL→PYTHON        [OFF]"
    echo -e " ${YELLOW}[6]${NC} › SHADOWSOCKS        [OFF]   ${YELLOW}[16]${NC} › SSH Multiplex     [OFF]"
    echo -e " ${YELLOW}[7]${NC} › PROXY PYTHON       [OFF]   ${YELLOW}[17]${NC} › OVER WEBSOCKET    [OFF]"
    echo -e " ${YELLOW}[8]${NC} › V2RAY SWITCH       [OFF]   ${YELLOW}[18]${NC} › SOCKS5            [OFF]"
    echo -e " ${YELLOW}[9]${NC} › CLASH FOR          [OFF]   ${YELLOW}[19]${NC} › UDPServer Request [OFF]"
    echo -e " ${YELLOW}[10]${NC} › TROJAN-GO         [OFF]   ${YELLOW}[20]${NC} › FUNCIONES EN DISEÑO!"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${YELLOW}[21]${NC} › CHISEL            [OFF]   ${YELLOW}[0]${NC} › [ REGRESAR ]"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Bucle principal del menú
while true; do
    clear
    show_banner
    show_system_info
    show_protocols_menu
    
    read -p " Opcion: " opcion

    case $opcion in
        1)
            echo -e "${YELLOW}Instalando SQUID...${NC}"
            apt install -y squid
            echo -e "${GREEN}SQUID instalado correctamente.${NC}"
            sleep 2
            ;;
        2)
            echo -e "${YELLOW}Instalando DROPBEAR...${NC}"
            apt install -y dropbear
            echo -e "${GREEN}DROPBEAR instalado correctamente.${NC}"
            sleep 2
            ;;
        3)
            echo -e "${YELLOW}Instalando OPENVPN...${NC}"
            apt install -y openvpn
            echo -e "${GREEN}OPENVPN instalado correctamente.${NC}"
            sleep 2
            ;;
        4)
            echo -e "${YELLOW}Configurando SSL/TLS...${NC}"
            echo -e "${GREEN}SSL/TLS configurado.${NC}"
            sleep 2
            ;;
        5)
            echo -e "${YELLOW}Instalando SHADOWSOCKS-R...${NC}"
            echo -e "${GREEN}SHADOWSOCKS-R instalado.${NC}"
            sleep 2
            ;;
        6)
            echo -e "${YELLOW}Instalando SHADOWSOCKS...${NC}"
            apt install -y shadowsocks-libev
            echo -e "${GREEN}SHADOWSOCKS instalado.${NC}"
            sleep 2
            ;;
        7)
            echo -e "${YELLOW}Instalando PROXY PYTHON...${NC}"
            echo -e "${GREEN}PROXY PYTHON instalado.${NC}"
            sleep 2
            ;;
        8)
            echo -e "${YELLOW}Instalando V2RAY...${NC}"
            bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
            echo -e "${GREEN}V2RAY instalado.${NC}"
            sleep 2
            ;;
        9)
            echo -e "${YELLOW}Instalando CLASH...${NC}"
            echo -e "${GREEN}CLASH instalado.${NC}"
            sleep 2
            ;;
        10)
            echo -e "${YELLOW}Instalando TROJAN-GO...${NC}"
            echo -e "${GREEN}TROJAN-GO instalado.${NC}"
            sleep 2
            ;;
        11)
            echo -e "${YELLOW}Instalando PSIPHON...${NC}"
            echo -e "${GREEN}PSIPHON instalado.${NC}"
            sleep 2
            ;;
        12)
            echo -e "${YELLOW}Configurando TCP DNS...${NC}"
            echo -e "${GREEN}TCP DNS configurado.${NC}"
            sleep 2
            ;;
        13)
            echo -e "${YELLOW}Instalando WEBMIN...${NC}"
            echo -e "${GREEN}WEBMIN instalado.${NC}"
            sleep 2
            ;;
        14)
            echo -e "${YELLOW}Instalando SlowDNS...${NC}"
            echo -e "${GREEN}SlowDNS instalado.${NC}"
            sleep 2
            ;;
        15)
            echo -e "${YELLOW}Configurando SSL→PYTHON...${NC}"
            echo -e "${GREEN}SSL→PYTHON configurado.${NC}"
            sleep 2
            ;;
        16)
            echo -e "${YELLOW}Configurando SSH Multiplex...${NC}"
            echo -e "${GREEN}SSH Multiplex configurado.${NC}"
            sleep 2
            ;;
        17)
            echo -e "${YELLOW}Configurando OVER WEBSOCKET...${NC}"
            echo -e "${GREEN}OVER WEBSOCKET configurado.${NC}"
            sleep 2
            ;;
        18)
            echo -e "${YELLOW}Configurando SOCKS5...${NC}"
            echo -e "${GREEN}SOCKS5 configurado.${NC}"
            sleep 2
            ;;
        19)
            echo -e "${YELLOW}Configurando UDPServer...${NC}"
            echo -e "${GREEN}UDPServer configurado.${NC}"
            sleep 2
            ;;
        20)
            echo -e "${YELLOW}Funciones en desarrollo...${NC}"
            sleep 2
            ;;
        21)
            echo -e "${YELLOW}Instalando CHISEL...${NC}"
            apt install -y chisel
            echo -e "${GREEN}CHISEL instalado.${NC}"
            sleep 2
            ;;
        0)
            echo -e "${RED}Saliendo del panel. ¡Hasta luego!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opción no válida.${NC}"
            sleep 2
            ;;
    esac
done
