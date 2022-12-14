#! /bin/bash

# Waalahar theme for Gnome 42.*^
# Version: 1.0.1
# Customization by Spellmell
# spellmell.github.io
# spellmell@protonmail.com
# CC BY-NC-SA
# 8/27/2022

# https://github.com/spellmell/waalahar_gnome_shell_theme

# This program is free software; you can redistribute it and/or modify it
# under the terms and conditions of the GNU Lesser General Public License,
# version 2.1, as published by the Free Software Foundation.

# default theme base colors */
# primary color for buttons and decorations #8b0000 - rgba(139, 0, 0, 1) */
# secondary color for panel #070d13 - rgba(7, 13, 19, 1) */
# ertiary color for backgrounds:hover #203026 - rgba(32, 48, 38, 1) */
# fourth color for texts #bdb76b - rgba(189, 183, 107, 1) */

# https://extensions.gnome.org/extension-data/apps-menugnome-shell-extensions.gcampax.github.com.v51.shell-extension.zip
# https://extensions.gnome.org/extension-data/places-menugnome-shell-extensions.gcampax.github.com.v54.shell-extension.zip
# https://extensions.gnome.org/extension-data/extension-listtu.berry.v30.shell-extension.zip
# https://extensions.gnome.org/extension-data/just-perfection-desktopjust-perfection.v21.shell-extension.zip
# https://extensions.gnome.org/extension-data/user-themegnome-shell-extensions.gcampax.github.com.v49.shell-extension.zip

THEME=waalahar_default
ROUTE=$HOME/.themes

FONTSNAMES=("Lobster" "Cairo")
EXTWL="https://extensions.gnome.org/extension-data"

declare -A EXTUL
EXTUL=(["apps-menu@gnome-shell-extensions.gcampax.github.com"]="apps-menugnome-shell-extensions.gcampax.github.com.v51" ["places-menu@gnome-shell-extensions.gcampax.github.com"]="places-menugnome-shell-extensions.gcampax.github.com.v54" ["extension-list@tu.berry"]="extension-listtu.berry.v30" ["user-theme@gnome-shell-extensions.gcampax.github.com"]="user-themegnome-shell-extensions.gcampax.github.com.v49" ["just-perfection-desktop@just-perfection"]="just-perfection-desktopjust-perfection.v21")

# colors
declare -A COLORS
COLORS=([default]="rgba(33, 37, 43," [darkred]="rgba(139, 0, 0," [tomato]="rgba(255, 99, 71," [crimson]="rgba(220, 20, 60," [firebrick]="rgba(178, 34, 34," [orangered]="rgba(255, 69, 0," [darkolivegreen]="rgba(85, 107, 47," [forestgreen]="rgba(34, 139, 34," [darkcyan]="rgba(0, 139, 139," [dimgrey]="rgba(105, 105, 105," [midnightblue]="rgba(25, 25, 112," [royalblue]="rgba(65, 105, 225," [slateblue]="rgba(106, 90, 205," [seagreen]="rgba(46, 139, 87," [teal]="rgba(0, 128, 128," [purple]="rgba(128, 0, 128,")
declare -A COLORSHEX
COLORSHEX=([default]="#21252B" [darkred]="#8B0000" [tomato]="#FF6347" [crimson]="#DC143C" [firebrick]="#B22222" [orangered]="#FF4500" [darkolivegreen]="#556B2F" [forestgreen]="#228B22" [darkcyan]="#008B8B" [dimgrey]="#696969" [midnightblue]="#191970" [royalblue]="#4169E1" [slateblue]="#6A5ACD" [seagreen]="#2E8B57" [teal]="#008080" [purple]="#800080")

# fonts instalation
declare -F install_fonts
install_fonts (){
  installFonts=true
  fontRoute=$HOME/.local/share/fonts
  if [ $installFonts == true ];
  then
    for FONTNAME in ${!FONTSNAMES[@]};
    do
      if [[ ! -d "/usr/share/fonts/${FONTSNAMES[FONTNAME]}" && ! -d "$fontRoute/${FONTSNAMES[FONTNAME]}" ]];
      then
        if [ ! -d $fontRoute ];
        then
          mkdir -p $fontRoute
        fi
        wget -O ${FONTSNAMES[FONTNAME]}.zip "https://fonts.google.com/download?family=${FONTSNAMES[FONTNAME]}"
        unzip -o -d $fontRoute/${FONTSNAMES[FONTNAME]} ${FONTSNAMES[FONTNAME]}.zip
        rm ./${FONTSNAMES[FONTNAME]}.zip
      fi
    done
  fi
}

# extensions installation
declare -F install_extensions
install_extensions (){
  installExtensions=true
  extensionsRoute=$HOME/.local/share/gnome-shell/extensions
  if [ $installExtensions == true ];
  then
    for EXTN in ${!EXTUL[@]};
    do
      if [ ! -d $extensionsRoute/$EXTN ];
      then
        wget "$EXTWL/${EXTUL[$EXTN]}.shell-extension.zip"
        ZIPNAME=./${EXTUL[$EXTN]}.shell-extension
        gnome-extensions install -f $ZIPNAME.zip
        unzip -d $ZIPNAME $ZIPNAME.zip
        NAME=$(jq '.uuid' ./$ZIPNAME/metadata.json | tr -d '"')
        gnome-extensions enable $NAME
        rm -Rf ./$ZIPNAME*
      fi
    done
  fi
}

declare -F setup
setup (){
  # call funcs
  install_fonts
  install_extensions
  
  cp ./setup/waalahar.dconf_setup ./waalahar.dconf
  sed -i "s/_USERNAME_/$USER/" ./waalahar.dconf
  cp -r ./waalahar_default ./temp
  cp ./setup/gnome-shell_PATRON_.css ./temp/gnome-shell/gnome-shell.css
  sed -i "s/_WAALAHARTHEME_/waalahar_$1/g" ./waalahar.dconf
  sed -i "s/(_PRIMARY_COLOR_)/($1)/g" ./temp/gnome-shell/gnome-shell.css
  if [ $1 != "default" ];
  then
    if [[ ${2::1} == "#" ]]; 
    then
      # preseted colors
      sed -i "s/_ACTIVE_TEXT_COLOR_BUTTON_/$2/g" ./temp/gnome-shell/gnome-shell.css
      sed -i "s/#ff6600/$2/g" ./temp/gnome-shell/assets/grad_bg_overview.svg
      sed -i "s/#ff6600/$2/g" ./temp/gnome-shell/assets/grad_bg_popups.svg
      sed -i "s/#ff6600/$2/g" ./temp/gnome-shell/assets/grad_bg_panel.svg
      sed -i "s/#ff6600/$2/g" ./temp/gnome-shell/assets/grad_bg_button.svg
      sed -i "s/#ff0000/$2/g" ./temp/gnome-shell/assets/grad_bg_overview.svg
      sed -i "s/#ff0000/$2/g" ./temp/gnome-shell/assets/grad_bg_popups.svg
      sed -i "s/#ff0000/$2/g" ./temp/gnome-shell/assets/grad_bg_panel.svg
      sed -i "s/#ff0000/$2/g" ./temp/gnome-shell/assets/grad_bg_button.svg
      sed -i "s/#d45500/$2/g" ./temp/gnome-shell/assets/toggle-on-light.svg
      sed -i "s/#d45500/$2/g" ./temp/gnome-shell/assets/checkbox.svg
    else
      # random colors
      sed -i "s/_ACTIVE_TEXT_COLOR_BUTTON_/\#$2/g" ./temp/gnome-shell/gnome-shell.css
      sed -i "s/#ff6600/\#$2/g" ./temp/gnome-shell/assets/grad_bg_overview.svg
      sed -i "s/#ff6600/\#$2/g" ./temp/gnome-shell/assets/grad_bg_popups.svg
      sed -i "s/#ff6600/\#$2/g" ./temp/gnome-shell/assets/grad_bg_panel.svg
      sed -i "s/#ff6600/\#$2/g" ./temp/gnome-shell/assets/grad_bg_button.svg
      sed -i "s/#ff0000/\#$2/g" ./temp/gnome-shell/assets/grad_bg_overview.svg
      sed -i "s/#ff0000/\#$2/g" ./temp/gnome-shell/assets/grad_bg_popups.svg
      sed -i "s/#ff0000/\#$2/g" ./temp/gnome-shell/assets/grad_bg_panel.svg
      sed -i "s/#ff0000/\#$2/g" ./temp/gnome-shell/assets/grad_bg_button.svg
      sed -i "s/#d45500/\#$2/g" ./temp/gnome-shell/assets/toggle-on-light.svg
      sed -i "s/#d45500/\#$2/g" ./temp/gnome-shell/assets/checkbox.svg
    fi
  else
      # for default theme
    sed -i "s/_ACTIVE_TEXT_COLOR_BUTTON_/orangered/g" ./temp/gnome-shell/gnome-shell.css
    sed -i "s/#ff6600/\#1E1E1E/g" ./temp/gnome-shell/assets/grad_bg_panel.svg
    sed -i "s/#ff0000/\#1E1E1E/g" ./temp/gnome-shell/assets/grad_bg_panel.svg
    sed -i "s/#ff6600/\#1E1E1E/g" ./temp/gnome-shell/assets/grad_bg_button.svg
    sed -i "s/#ff0000/\#1E1E1E/g" ./temp/gnome-shell/assets/grad_bg_button.svg
  fi
}

declare -F moving
moving (){
  if [ -d $ROUTE/waalahar_$1 ];
  then
    rm -Rf $ROUTE/waalahar_$1
  fi 
  mv ./temp $ROUTE/waalahar_$1
}

declare -F dconfig
dconfig (){
  dconf load / < ./waalahar.dconf
  rm ./waalahar.dconf
  notify-send "waalahar_$1 theme has ben installed" "Make an alt+f2, r and enter, to restart gnome with the new configuration." -i "gnome-logo-text-dark"
}

case "$1" in
-i)
# theme instalation
if [ ! -d $ROUTE ];
then
  mkdir -p $ROUTE
fi

if [[ $2 && $2 != "all" ]];
then
  setup $2 ${COLORSHEX[$2]}
  sed -i "s/_PRIMARY_COLOR_/${COLORS[$2]}/g" ./temp/gnome-shell/gnome-shell.css
  moving $2
  dconfig $2
elif [[ $2 && $2 == "all" ]];
# install all themes colors
then
  for i in ${!COLORS[@]}
  do
    if [ $i != "default" ];
    then
      $0 -i $i
    fi
  done
  $0 -i default # install default theme color
else
  $0 # generic response with help for unexpected errors.
fi
# restart gnome shell
# busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Restarting???")'
;;
-r)
  rndColor=$(echo $(od -txC -An -N3 /dev/random | tr \  -) | sed 's/-//g')
  a=$(echo $rndColor | cut -c 1-2 | tr '[:lower:]' '[:upper:]') b=$(echo $rndColor | cut -c 3-4 | tr '[:lower:]' '[:upper:]') c=$(echo $rndColor | cut -c 5-6 | tr '[:lower:]' '[:upper:]')
  r=$(echo "ibase=16; $a" | bc) g=$(echo "ibase=16; $b" | bc) b=$(echo "ibase=16; $c" | bc)
  
  if [[ $r && $g && $b ]];
  then
    echo "generating new theme whit a random color... #$rndColor"
    setup $rndColor $rndColor
    sed -i "s/_PRIMARY_COLOR_/rgba($r, $g, $b,/g" ./temp/gnome-shell/gnome-shell.css
    moving $rndColor
    dconfig $rndColor
  else
    $0 -r
  fi
;;
-c)
  lengthString=${#2}
  if [[ $2 != "--help" && $2 == +([0-9a-fA-F]) && $lengthString == 6 ]];
  then 
    a=$(echo $2 | cut -c 1-2 | tr '[:lower:]' '[:upper:]') b=$(echo $2 | cut -c 3-4 | tr '[:lower:]' '[:upper:]') c=$(echo $2 | cut -c 5-6 | tr '[:lower:]' '[:upper:]')
    r=$(echo "ibase=16; $a" | bc) g=$(echo "ibase=16; $b" | bc) b=$(echo "ibase=16; $c" | bc)
    echo "generating new theme whit your color... #$2"
    setup $2 $2
    sed -i "s/_PRIMARY_COLOR_/rgba($r, $g, $b,/g" ./temp/gnome-shell/gnome-shell.css
    moving $2
    dconfig $2
  else
    echo -e "\nYou have not entered a valid hexadecimal color code.\n\nYou must enter a 6-digit hexadecimal number (without #), for example: -c bb33cc\n\nhttps://www.w3schools.com/cssref/css_colors.asp"
  fi
;;
-u)
  rm -Rf $ROUTE/waalahar_*
  notify-send "All Waalahar themes have been uninstalled." -i "gnome-logo-text-dark"
;;
*)
echo -e "\n||| Waalahar Gnome Shell Theme |||\n\nRun ./install.sh -i default, all, or one of these colors: darkred, tomato, crimson, firebrick, orangered, darkolivegreen, forestgreen, darkcyan, dimgrey, midnightblue, royalblue, slateblue, seagreen, teal, or purple to install themes with preseted colors.\n\nYou can use -r to generate a random color.\n\nIf you want to set a personal color use -c +hexadecimal color number (whitout #), for example: -c bb33cc.\n\nUse -u to uninstall all installed themes.\n\nTo change between installed themes use the User Themes Extension."
exit 1
;;
esac
exit 0