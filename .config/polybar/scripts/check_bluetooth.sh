#!/bin/bash

if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
then
	echo "%{F#707880}%{T3}@%{T-}%{F-}"
else
	if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -ne 0 ]
	then
		echo "%{F#F0C674}%{T3}?%{T-}%{F-}"
	fi
	echo "%{F#F0C674}%{T3}=%{T-}%{F-}"
fi
