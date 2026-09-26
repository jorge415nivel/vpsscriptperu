#!/bin/bash
# Cargamos colores desde la carpeta core de TU repositorio nuevo
source <(curl -s https://raw.githubusercontent.com/jorge415nivel/vpsscriptperu/main/MiVPSperu/core/funciones.sh)

while true; do
    clear
    echo -e "\033[0;36m========================================\033[0m"
    echo -e "\033[1;33m        MI VPS MANAGER v1.0           \033[0m"
    echo -e "\033[0;36m========================================\033[0m"
    echo -e "\033[0;32m 1. Gestionar Usuarios SSH\033[0m"
    echo -e "\033[0;32m 2. Información del Sistema\033[0m"
    echo -e "\033[0;32m 3. Reiniciar Servicios\033[0m"
    echo -e "\033[0;31m 0. Salir\033[0m"
    echo -e "\033[0;36m========================================\033[0m"
    
    read -p " Elige una opción [0-3]: " opcion

    case $opcion in
        1)
            bash <(curl -s https://raw.githubusercontent.com/jorge415nivel/vpsscriptperu/main/MiVPSperu/modules/usuarios.sh)
            ;;
        2)
            clear
            echo -e "\033[1;33m--- INFORMACIÓN DEL SISTEMA ---\033[0m"
            echo "Sistema: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '"')"
            echo "Memoria RAM:"
            free -h | grep Mem
            echo "Disco:"
            df -h / | tail -n 1 | awk '{print "Total: "$2" | Usado: "$3" | Libre: "$4}'
            read -p " Presiona ENTER para volver..."
            ;;
        3)
            echo -e "\033[1;33mReiniciando servicios básicos...\033[0m"
            systemctl restart ssh
            systemctl restart systemd-resolved
            echo -e "\033[0;32m¡Servicios reiniciados!\033[0m"
            sleep 2
            ;;
        0)
            echo -e "\033[0;31mSaliendo del panel. ¡Hasta luego!\033[0m"
            exit 0
            ;;
        *)
            echo -e "\033[0;31mOpción no válida.\033[0m"
            sleep 2
            ;;
    esac
done
