#!/bin/bash

ID_WIFI=~/.config/polybar/wifi_bar_pid
SCAN_WIFI=~/.polybar_scanned_wifis
BAR_CONFIG_DIR=~/.temp
BAR_STATUS=~/.temp/status_bar

iwctl station wlan0 get-networks \
| tail -n +5 \
| head -n -1 \
| sed -e "s:\[1;30m::g" \
| sed -e "s:\[0m::g" \
| sed -e "s:\*\x1b.*:\*:g" \
| sed -e "s:\x1b::g" | sed "s/^[ \t]*//" > $SCAN_WIFI

#read first wifi scan file then use it to get other thingys

WIFI_NAMES_ONLY=$(cat "$SCAN_WIFI" | sed -r 's/(^[\s])*\s*(psk|open).*$/\1/g')
WIFI_FILE_NAMES=$(cat "$SCAN_WIFI" | sed -r 's/(^[\s])*\s*(psk|open).*$/\1/g' | sed -r 's/ //g')
WIFI_NAMES_SIGNAL=$(cat "$SCAN_WIFI" | sed -r 's/(^[\s])*\s*(psk|open)\s*([*]*).*$/\1 \3/g')

mapfile arr_f_n < <(echo "$WIFI_FILE_NAMES")
mapfile arr_n_s < <(echo "$WIFI_NAMES_SIGNAL")
mapfile arr_n_o < <(echo "$WIFI_NAMES_ONLY")
echo "${#arr_f_n[@]}"

height=18
arr_length=${#arr_f_n[@]}

for(( i=0; i<${arr_length}; i++ )); do
  printf "lol%d lol%s" $i "${arr_n_s[$i]}"
done

if [ $(cat $ID_WIFI | wc -c) -eq 0 ] && [ $(cat $BAR_STATUS) == 0 ]; then
  echo 0 > $BAR_STATUS
  echo open
  while read -r line; do
    name=$(echo "$line" | sed -r 's/(^[\s])*\s*(psk|open).*$/\1/g')
    filename=$(echo "$name" | sed -r 's/ //g')
    name_signal=$(echo "$line" | sed -r 's/(^[\s])*\s*(psk|open).\s*/ /g')
    BAR_CONFIG_PATH="${BAR_CONFIG_DIR}/wifi_${filename}.ini"
    echo -e "include-file=~/.config/polybar/colors.ini\ninclude-directory=~/.config/polybar/modules\n[bar/$filename]" > "$BAR_CONFIG_PATH"
    echo -e "monitor=\${env:MONITOR:}\nwidth=20%\nheight=18pt\nbackground = #cc1a1b26\nmodules-left=lab\ncursor-click=pointer\noverride-redirect=true\noffset-y="$height"pt\noffset-x=70%\ndpi=192\n[module/lab]\ntype=custom/text\ncontent=%{A1:alacritty:}"$name_signal"%{A}" >> "$BAR_CONFIG_PATH"
    height=$((height+18))
#    echo $height

#    polybar --reload -c "~/.temp/wifi_$filename.ini" &
    #sleep 0.05
    #echo $! >> $ID_WIFI
  done < $SCAN_WIFI
  echo 1 > $BAR_STATUS
else
  echo close
  echo 0 > $BAR_STATUS
  while read -r line; do
    kill $line
  done < $ID_WIFI
  rm $ID_WIFI
fi
#while IFS='$' read -ra ADDR; do for i in "${ADDR[@]}"; do touch "${i}"; done; done <<< "${a}"
#a=$(cat ~/.polybar_scanned_wifisa | sed -r 's/(^[\s])*\s*(psk|open).*$/\1$/g')
