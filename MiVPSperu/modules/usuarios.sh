#!/bin/bash
# ==============================================================================
# Módulo: Generador de Keys de Acceso (Estilo ADM Profesional)
# ==============================================================================

fun_ip() {
    local MEU_IP=$(ip addr | grep 'inet ' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
    local MEU_IP2=$(wget -qO- ipv4.icanhazip.com 2>/dev/null)
    [[ -n "$MEU_IP2" ]] && echo "$MEU_IP2" || echo "$MEU_IP"
}

IP="$(fun_ip)"
DIR_CGH="/etc/adm-cgh"
DIR_CT="/etc/adm-ct"
FILE_VAL="/root/chumogh.val"
FILE_TM="$DIR_CT/tm"

ofus() {
    local input="$1"
    local output=""
    local len=${#input}
    for (( i=0; i<len; i++ )); do
        local char="${input:$i:1}"
        case "$char" in
            ".") char="+" ;; "+") char="." ;; "1") char="@" ;; "@") char="1" ;;
            "2") char="?" ;; "?") char="2" ;; "4") char="%" ;; "%") char="4" ;;
            "-") char="K" ;; "K") char="-" ;; "m") char="7" ;; "7") char="m" ;;
            "S") char="i" ;; "i") char="S" ;; "C") char="h" ;; "h") char="C" ;;
            "f") char="3" ;; "3") char="f" ;; "5") char="s" ;; "s") char="5" ;;
            "0") char="8" ;; "8") char="0" ;; "=") char="_" ;; "_") char="=" ;;
            "B") char="g" ;; "g") char="B" ;; "A") char="r" ;; "r") char="A" ;;
            "R") char="b" ;; "b") char="R" ;;
        esac
        output="${char}${output}"
    done
    echo "$output"
}

# Preparar entorno
mkdir -p "$DIR_CGH" "$DIR_CT" /var/www/html
touch "$FILE_VAL" "$FILE_TM" /var/www/html/index.html
chmod -R 755 /var/www

# Instalar apache2 si no está y mover a puerto 81
if ! systemctl is-active --quiet apache2; then
    apt-get install apache2 -y > /dev/null 2>&1
    sed -i "s/Listen 80/Listen 81/g" /etc/apache2/ports.conf 2>/dev/null
    systemctl restart apache2 > /dev/null 2>&1
fi

while true; do
    clear
    echo -e "\033[1;32m========================================================\033[0m"
    echo -e "\033[1;36m          GENERADOR DE KEYS DE ACCESO (ADM)           \033[0m"
    echo -e "\033[1;32m========================================================\033[0m"
    echo -e " \033[1;33m[0]\033[0m > Regresar al Menú Principal"
    echo -e " \033[1;33m[1]\033[0m > Generar Nueva Key"
    echo -e " \033[1;33m[2]\033[0m > Ver Keys Activas"
    echo -e " \033[1;33m[3]\033[0m > Eliminar Key Manualmente"
    echo -e " \033[1;33m[4]\033[0m > Destruir TODAS las Keys"
    echo -e "\033[1;32m========================================================\033[0m"
    
    echo -ne "\033[1;37mEscoje una opción [0-4]: \033[0m"
    read -r opcion
    
    case "$opcion" in
        0) break ;;
        1)
            clear
            echo -e "\033[1;36m--- GENERAR NUEVA KEY ---\033[0m"
            echo -ne "Ingresa el código de la KEY: "
            read -r key_raw
            
            if [[ -z "$key_raw" ]]; then
                echo -e "\033[1;31m[ERROR] La key no puede estar vacía.\033[0m"
                sleep 2; continue
            fi
            
            key_ofus=$(ofus "$key_raw")
            echo -e "\033[1;32mKEY OFUSCADA: \033[1;35m$key_ofus\033[0m"
            echo -ne "¿Deseas colocarla en el sistema? [S/N]: "
            read -r confirm
            [[ ! "$confirm" =~ ^[SsYy]$ ]] && continue
            
            echo -e "\033[1;34mTiempo de uso (ej: 30d, 12h, 45m, 60s): \033[0m"
            echo -ne "Ingresa el tiempo: "
            read -r tiempo
            
            if [[ ! "$tiempo" =~ ^[0-9]+[dhms]$ ]]; then
                echo -e "\033[1;31m[ERROR] Formato de tiempo inválido. Usa ej: 30d\033[0m"
                sleep 2; continue
            fi
            
            echo "$tiempo,$key_raw" >> "$FILE_TM"
            echo "$key_raw" >> "$FILE_VAL"
            
            cat << EOF > "$DIR_CGH/${key_ofus}.sh"
#!/bin/bash
sleep $tiempo
sed -i "/^$tiempo,$key_raw\$/d" "$FILE_TM"
sed -i "/^$key_raw\$/d" "$FILE_VAL"
rm -f "/var/www/html/${key_raw}.val"
rm -f "$DIR_CGH/${key_ofus}.sh"
EOF
            chmod +x "$DIR_CGH/${key_ofus}.sh"
            
            echo "KEY ACTIVA" > "/var/www/html/${key_raw}.val"
            systemctl restart apache2 > /dev/null 2>&1
            bash "$DIR_CGH/${key_ofus}.sh" &
            
            clear
            echo -e "\033[1;32m✅ KEY GENERADA Y ACTIVADA CON ÉXITO\033[0m"
            echo -e "\033[1;37mURL de la Key: \033[1;36mhttp://$IP:81/${key_raw}.val\033[0m"
            echo -e "\033[1;37mTiempo: \033[1;33m$tiempo\033[0m"
            echo -e "\033[1;32m========================================================\033[0m"
            read -p "Presiona ENTER para continuar..."
            ;;
        2)
            clear
            echo -e "\033[1;36m--- KEYS ACTIVAS EN EL SISTEMA ---\033[0m"
            if [[ ! -s "$FILE_TM" ]]; then
                echo -e "\033[1;31mNo hay keys activas.\033[0m"
            else
                echo -e "\033[1;33mTIEMPO\033[0m | \033[1;33mKEY ORIGINAL\033[0m"
                echo "-----------------------------"
                while IFS=',' read -r t k; do
                    echo -e "\033[1;32m$t\033[0m | \033[1;37m$k\033[0m"
                done < "$FILE_TM"
            fi
            echo -e "\033[1;32m========================================================\033[0m"
            read -p "Presiona ENTER para continuar..."
            ;;
        3)
            clear
            echo -e "\033[1;36m--- ELIMINAR KEY MANUALMENTE ---\033[0m"
            echo -ne "Ingresa la KEY ORIGINAL a eliminar: "
            read -r key_del
            
            if grep -q "^$key_del$" "$FILE_VAL"; then
                sed -i "/^$key_del$/d" "$FILE_VAL"
                sed -i "/,$key_del$/d" "$FILE_TM"
                rm -f "/var/www/html/${key_del}.val"
                for script in "$DIR_CGH"/*.sh; do
                    if grep -q "sleep" "$script" 2>/dev/null && grep -q "$key_del" "$script" 2>/dev/null; then
                        rm -f "$script"
                    fi
                done
                echo -e "\033[1;32m✅ Key eliminada correctamente.\033[0m"
            else
                echo -e "\033[1;31m[ERROR] La key no existe en el sistema.\033[0m"
            fi
            echo -e "\033[1;32m========================================================\033[0m"
            read -p "Presiona ENTER para continuar..."
            ;;
        4)
            clear
            echo -e "\033[1;31m--- DESTRUIR TODAS LAS KEYS ---\033[0m"
            echo -e "\033[1;33m⚠️ ¡ADVERTENCIA! Esta acción es irreversible.\033[0m"
            echo -ne "¿Estás seguro? [S/N]: "
            read -r confirm_destroy
            if [[ "$confirm_destroy" =~ ^[SsYy]$ ]]; then
                rm -f "$FILE_VAL" "$FILE_TM"
                rm -f /var/www/html/*.val
                rm -f "$DIR_CGH"/*.sh
                touch "$FILE_VAL" "$FILE_TM"
                echo -e "\033[1;32m✅ Todas las keys han sido destruidas.\033[0m"
            else
                echo -e "\033[1;33mOperación cancelada.\033[0m"
            fi
            echo -e "\033[1;32m========================================================\033[0m"
            read -p "Presiona ENTER para continuar..."
            ;;
        *)
            echo -e "\033[1;31mOpción no válida.\033[0m"
            sleep 1
            ;;
    esac
done
