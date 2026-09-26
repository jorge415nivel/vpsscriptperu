#!/bin/bash
# Cargamos colores desde la carpeta core
source <(curl -s https://raw.githubusercontent.com/jorge415nivel/MiVPS/main/core/funciones.sh)

while true; do
    clear
    echo -e "${CYAN}========================================${NC}"
    echo -e "${YELLOW}        MI VPS MANAGER v1.0           ${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "${GREEN} 1. Gestionar Usuarios SSH${NC}"
    echo -e "${GREEN} 2. Información del Sistema${NC}"
    echo -e "${GREEN} 3. Reiniciar Servicios${NC}"
    echo -e "${RED} 0. Salir${NC}"
    echo -e "${CYAN}========================================${NC}"
    
    read -p " Elige una opción [0-3]: " opcion

    case $opcion in
        1)
            bash <(curl -s https://raw.githubusercontent.com/jorge415nivel/MiVPS/main/modules/usuarios.sh)
            ;;
        2)
            clear
            echo -e "${YELLOW}--- INFORMACIÓN DEL SISTEMA ---${NC}"
            echo "Sistema: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '"')"
            echo "Memoria RAM:"
            free -h | grep Mem
            echo "Disco:"
            df -h / | tail -n 1 | awk '{print "Total: "$2" | Usado: "$3" | Libre: "$4}'
            read -p " Presiona ENTER para volver..."
            ;;
        3)
            echo -e "${YELLOW}Reiniciando servicios básicos...${NC}"
            systemctl restart ssh
            systemctl restart systemd-resolved
            echo -e "${GREEN}¡Servicios reiniciados!${NC}"
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