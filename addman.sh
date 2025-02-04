#!/bin/bash
# shellcheck disable=SC1090
# shellcheck disable=SC2154


addman_path=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
addons_path="$addman_path/addons"
config_path="$addman_path/config.sh"
get_zip_url_py="$addman_path/utils/get-zip-url.py"

color_red='\033[0;31m'
color_green='\033[0;32m'
color_yellow='\033[0;33m'
color_reset='\033[0m'

batch_size=10

# source config
. "$config_path"


if [ "$wow_addons_path" == "" ]
then
    echo "wow_addons_path is not set in config.sh"
    exit 1
fi


if [ ! -d "$addons_path" ]
then
    mkdir "$addons_path"
fi


update_single_addon() {
    addon_name="$1"
    echo "Checking $addon_name..."
    python3 "$get_zip_url_py" "$addon_name" > "$addons_path/$addon_name/latest" &
}


update_addons() {
    i=0

    for addon in "$addons_path/"*
    do
        addon_name=$(basename "$addon")
        update_single_addon "$addon_name"
        (( ++i % batch_size == 0 )) && wait
    done

    wait
}


download_single_addon() {
    addon="$1"
    addon_name=$(basename "$addon")

    while [ "$latest" == "" ]
    do
        sleep 0.1
        latest=$(cat "$addon/latest")
    done

    if [ -f "$addon/installed"  ]
    then
        installed=$(cat "$addon/installed")
        latest=$(cat "$addon/latest")

        if [ "$installed" == "$latest" ]
        then
            echo -e "${color_green}$addon_name is up to date.${color_reset}"
            return
        fi
    fi

    echo -e "${color_yellow}$addon_name is not up to date${color_reset}".

    echo "Downloading $addon_name..."
    echo "$latest" > "$addon/installed"
    wget -q -O "$addon/addon.zip" "$latest" &&
    unzip -q -o "$addon/addon.zip" -d "$wow_addons_path" &&
    echo -e "${color_green}Successfully installed $addon_name${color_reset}"

    if [ -f "$addon/addon.zip" ]
    then
        rm "$addon/addon.zip"
    else
        echo -e "${color_red}$addon_name may have failed, manual intervention is required.${color_reset}"
    fi   
}


download_addons() {
    for addon in "$addons_path/"*
    do
        download_single_addon "$addon"
    done
}


if [ "$1" ]
then
    if [ "$1" = "install" ] || [ "$1" = "remove" ]
    then
        if ! [ "$2" ]
        then
            echo "no addon name provided"
            exit 1
        fi

        if [ "$1" = "install" ]
        then
            mkdir "$addons_path/$2"
            update_single_addon "$2"
            download_single_addon "$2"
        fi

        if [ "$1" = "remove" ]
        then
            if [ -d "$addons_path/$2" ]
            then
                rm -rf "${addons_path:?}/$2"
            fi
        fi

        exit 0
    fi

    # check if is number
    if ! [[ $1 =~ ^[0-9]+$ ]]
    then
        echo "invalid batch size"
        exit 1
    fi

    batch_size="$1"
fi


update_addons
download_addons
