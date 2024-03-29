#!/usr/bin/env bash



install() {

    #### TÍTULO ####

    echo -e ""
    echo -e "  \033[1m=================================================================\033[0m"
    echo -e "  \033[1m|        INSTALANDO \"ACTUALIZACIÓN AUTOMÁTICA CON APT\"          |\033[0m"
    echo -e "  \033[1m=================================================================\033[0m"
    echo -e "   version 1.1.0"



    #### MENSAJES ####

    advertencia() {
        echo -e ""
        echo -e "  \033[1m=================================================================\033[0m"
        echo -e "  \033[1m|\033[43m                           ATENCIÓN!                           \033[0m\033[1m|\033[0m"
        echo -e "  \033[1m=================================================================\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m Va a instalar el programa de \033[1mACTUALIZACIÓN AUTOMÁTICA         |\033[0m"
        echo -e "  \033[1m|\033[0m \033[1mCON APT\033[0m.                                                      \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m Esto permitirá que se actualize su sistema de forma           \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m automática a diario.                                          \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m También le mostrará una ventana informativa durante la        \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m actualización indicándole si todo ha ido bien o si ha habido  \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m algún problema.                                               \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m Desea continuar?                                              \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m---------------------------------------------------------------\033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"

        options=("Si" "No")

        source ./assets/menu-si-no.sh
        select_option "${options[@]}"
        choice=$?

        echo -e ""
        echo -e ""
        echo -e ""
    }

    clave_sudo() {
        echo -e "Introduzca la contraseña de \033[1msu usuario\033[0m para autorizar que empiece la instalación."

        sudo echo ""

        if [[ $? != 0 ]]; then      # Capturar fallo
            echo -e ""
            echo -e "\033[1mLa contraseña no es correcta.\033[0m"
            sleep 2
            exit
        fi
    }

    previa() {
        echo -e ""
        echo -e "  \033[1m=================================================================\033[0m"
        echo -e "  \033[1m|\033[41m                           ATENCIÓN!                           \033[0m\033[1m|\033[0m"
        echo -e "  \033[1m=================================================================\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m Parece que ya existe una instalación previa.                  \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m Desea \033[1mborrarla\033[0m y realizar una \033[1minstalación nueva\033[0m?              \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m---------------------------------------------------------------\033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"

        options=("Si" "No")

        source ./assets/menu-si-no.sh
        select_option "${options[@]}"
        choice_previa=$?

        if [[ $choice_previa == 0 ]]; then
            echo -e ""
            echo -e ""
            echo -e ""
            uninstall
        else
            echo -e ""
            echo -e ""
            echo -e ""
            echo -e "\033[1m Instalación cancelada.\033[0m"
            sleep 2
            exit
        fi
    }

    uninstall() {
        clave_sudo

        # Borrando el directorio.
        if [[ -e $HOME/.local/share/daily-apt-autoupdate ]]; then
            echo -e "Eliminando el directorio \033[1m$HOME/.local/share/daily-apt-autoupdate\033[0m y su contenido."
            rm -fr $HOME/.local/share/daily-apt-autoupdate
        else
            echo -e "No se ha encontrado el directorio \033[1m$HOME/.local/share/daily-apt-autoupdate\033[0m para poder borrarlo."
        fi

        # Borrando el registro de Anacron.
        if [[ $(grep daily-apt-autoupdate-$USER /etc/anacrontab) != "" ]]; then
            echo -e "Borrando el registro del usuario \033[1m$USER\033[0m en \033[1m/etc/anacrontab\033[0m."
            sudo sed -i "/daily-apt-autoupdate-$USER/d" /etc/anacrontab
        else
            echo -e "No se ha encontrado el registro del usuario \033[1m$USER\033[0m en \033[1m/etc/anacrontab\033[0m para poder borrarlo."
        fi

        # Borrando el comando.
        if [[ -L $HOME/.local/bin/daily-apt-autoupdate ]]; then
            echo -e "Eliminando el comando \033[1mdaily-apt-autoupdate\033[0m de su usuario."
            rm $HOME/.local/bin/daily-apt-autoupdate
        else
            echo -e "No se ha encontrado el comando \033[1mdaily-apt-autoupdate\033[0m en su usuario."
        fi

        echo -e ""
    }

    fallo() {
        echo -e ""
        echo -e ""
        echo -e "  \033[1m=================================================================\033[0m"
        echo -e "  \033[1m|\033[41m                             ERROR                             \033[0m\033[1m|\033[0m"
        echo -e "  \033[1m=================================================================\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m La instalación ha fallado por un motivo desconocido.          \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m FALLO: $1                           \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m---------------------------------------------------------------\033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m Presione \033[7;5;1m ENTER \033[0m o cierre la ventana para salir.              \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m=================================================================\033[0m"
        echo -e ""

        read cerrar
        exit
    }

    exito() {
        echo -e ""
        echo -e ""
        echo -e "  \033[1m=================================================================\033[0m"
        echo -e "  \033[1m|\033[42m                     INSTALACIÓN TERMINADA                     \033[0m\033[1m|\033[0m"
        echo -e "  \033[1m=================================================================\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m La instalación ha finalizado correctamente.                   \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m---------------------------------------------------------------\033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m Presione \033[7;5;1m ENTER \033[0m o cierre la ventana para salir.              \033[1m|\033[0m"
        echo -e "  \033[1m|\033[0m                                                               \033[1m|\033[0m"
        echo -e "  \033[1m=================================================================\033[0m"
        echo -e ""
        echo -e "  * Presione \033[1mESC\033[0m para evitar que esta ventana se cierre dentro de 1 minuto."
        echo -e ""

        t_now=$(date +%s)
        t_end=$(date --date="+60 sec" +%s)

        while [ $t_now -lt $t_end ]; do
            IFS=""
            read -sn 1 -t $(($t_end - $t_now)) cerrar

            case $cerrar in
                $'\e')
                    echo -e "  Cuando haya terminado presione \033[1mENTER\033[0m para salir."
                    read cerrar
                    exit ;;
                "")
                    exit ;;
                *)
                    : ;;
            esac
            t_now=$(date +%s)
        done
    }



    #### COMPROBACIONES ####

    choice_previa=""

    # Comprovación de la existencia del directorio "$HOME/.local/share/daily-apt-autoupdate".
    if [[ -e $HOME/.local/share/daily-apt-autoupdate ]]; then
        previa
    fi

    # Comprovación de la existencia del enlace en "$HOME/.local/bin/daily-apt-autoupdate".
    if [[ -L $HOME/.local/bin/daily-apt-autoupdate ]]; then
        previa
    fi

    # Comprovación de la existencia del registro en "/etc/anacrontab".
    if [[ $(grep daily-apt-autoupdate-$USER /etc/anacrontab) != "" ]]; then
        previa
    fi



    #### INSTALACIÓN ####

    # Evita "advertencia" si ya ha mostrado "previa".
    if [[ $choice_previa == "" ]]; then
        advertencia

        if [[ $choice == 1 ]]; then
            echo -e "\033[1m Instalación cancelada.\033[0m"
            sleep 2
            exit
        fi

        clave_sudo

    fi

    # Creación del directorio y copia de los archivos.
    echo -e "Creando el directorio \033[1m$HOME/.local/share/daily-apt-autoupdate\033[0m y copiando en el los ficheros necesarios."

    mkdir -p $HOME/.local/share/daily-apt-autoupdate

    if [[ $? != 0 ]]; then      # Capturar fallo
        fallo "\033[1;31mCreación del directorio\033[0m.    "
    fi

    cp -r * $HOME/.local/share/daily-apt-autoupdate
    chmod +x $HOME/.local/share/daily-apt-autoupdate/daily-apt-autoupdate.sh $HOME/.local/share/daily-apt-autoupdate/install.sh $HOME/.local/share/daily-apt-autoupdate/uninstall.sh

    if [[ $? != 0 ]]; then      # Capturar fallo
        rm -fr $HOME/.local/share/daily-apt-autoupdate
        fallo "\033[1;31mCopia de los ficheros\033[0m.      "
    fi

    echo -e "Copia de ficheros realizada con exito."
    echo -e ""

    # Creación del comando.
    echo -e "Creando el comando \033[1mdaily-apt-autoupdate\033[0m para su usuario."

    if [[ ! -e $HOME/.local/bin ]]; then
        mkdir -p $HOME/.local/bin
    fi

    ln -s $HOME/.local/share/daily-apt-autoupdate/daily-apt-autoupdate.sh $HOME/.local/bin/daily-apt-autoupdate

    if [[ $? != 0 ]]; then      # Capturar fallo
        rm -fr $HOME/.local/share/daily-apt-autoupdate
        fallo "\033[1;31mCreación del comando\033[0m.      "
    fi

    echo -e "Creación del comando realizada con exito."
    echo -e ""

    # Creación del comando: Ajuste para que funcione correctamente en KDE Plasma ya que parece que no ejecuta bien ~/.profile y no añade automáticamente ~/.local/bin al PATH.

    if [[ $XDG_CURRENT_DESKTOP == *"KDE"* && ! -e $HOME/.config/plasma-workspace/env/path.sh ]]; then
        echo -e "
# This file is needed because ~/.profile doesn't seem to run properly on KDE Plasma.

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
        " > $HOME/.config/plasma-workspace/env/path.sh
    fi

    # Programación de la taréa en /etc/anacriontab.
    echo -e "Incluyendo el registro en \033[1mAnacron\033[0m para que se ejecute el script \033[1mdiariamente\033[0m a los 3 min de iniciar sesión con su usuario."

    source ./assets/default-term.sh
    echo -e "1	3	daily-apt-autoupdate-$USER	export XAUTHORITY=$XAUTHORITY HOME=$HOME USER=$USER GROUP=$(id -gn) && export DISPLAY=\$(who | grep tty | grep \$USER | cut -d '(' -f2 |cut -d ')' -f1) && $default_term $HOME/.local/share/daily-apt-autoupdate/daily-apt-autoupdate.sh &" | sudo tee -a /etc/anacrontab > /dev/null

    if [[ $? != 0 ]]; then      # Capturar fallo
        rm -fr $HOME/.local/share/daily-apt-autoupdate $HOME/.local/bin/daily-apt-autoupdate
        fallo "\033[1;31mIncluir tarea en anacrontab\033[0m."
    fi

    echo -e "El registro ha sido añadido a /etc/anacrontab con exito."

    # Corrección detectada para Ubuntu 22.04 LTS: Falta el paquete "dbus-x11" y por ese motivo Anacron no logra lanzar la ventada de gnome-terminal como root.
    if [[ $(dpkg -l | grep dbus-x11) != ii* ]]; then
        echo -e ""
        echo -e "El paquete necesario \033[1mdbus-x11\033[0m no se ha encontrado en su sistema y se procede a instalarlo."
        sudo apt install dbus-x11 &> /dev/null
    fi

    exito

    #### FIN ####
}



# Permite que el script se ejecute en su propia ventana de terminal con un simple doble click.
source ./assets/default-term.sh
export -f install

if [[ $XDG_CURRENT_DESKTOP == *"GNOME"* || $XDG_CURRENT_DESKTOP == *"XFCE"*  ]]; then
    install
else
    $default_term install
fi
