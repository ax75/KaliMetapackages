#!/usr/bin/env bash


AptArgs=()

function createMenu(){

while true; do
	clear
        echo "------------------------------------------"
        echo "| KALI MEATAPACKAGES INSTALLATION - ax75 |"
        echo "------------------------------------------"
        echo
	echo "Packages to INSTALL [${AptArgs[@]}]"
	echo
        index=1
	List=($@)
	state=${List[-1]}
	unset List[-1]
	for i in "${List[@]}"; do
		echo "$index) $i"
		let index+=1
	done
        echo -n  "===>"
        read mainChoice
	let mainChoice-=1
	count=${#List[@]}
	let count-=1    
	if [[ $state -eq 1  ]]; then	
		if [[ $mainChoice -eq $count ]]; then
			return -1
		else
			return $mainChoice
		fi
	elif [[ $state -eq 0  ]]; then
		echo "Inside state 0"
		if [[ $mainChoice -eq $count  ]]; then
			return 254 
		else
			Args="${List[$mainChoice]}"
			AptArgs+=($Args)
		fi
	fi
done
}

function load(){
	sleep 3
	pattern=0
	t=1
	state=0
	until [ $state == 1 ]; 
	do
		let pattern=$t%2
		if [[ $pattern -eq 0 ]]; then
				echo -ne "* "
				sleep 1
		else
				echo -ne "# "
				sleep 1
		fi
		if [[ $((t%14)) -eq 0  ]]; then
			echo -ne "\r                              \r"
		fi
		
		let t+=1
	done
}
function apt(){
	clear
	echo "-----------------------"
	echo "| INSTALLING PACKAGES |"
	echo "-----------------------"
	Packages=($@)
	for x in "${Packages[@]}"; do
		echo "=>Installing $x" 
	done
	load &
	 if sudo apt-get -q install -y ${Packages[@]} > ial.log; then
		kill $! 
		echo
		echo "--------------------------------------"
		echo "|=>=>=>=INSTALLED SUCCESSFULLY=<=<=<=|" 
		echo "--------------------------------------"
	fi
	echo -ne "\n"
        read -p "Process done press any key to Continue..."
	unset AptArgs[@]	
}

function main(){
	sudo ls
        Menu=(
        'Systen'
        'Desktop-environments/Window-managers'
        "Tools"
        "Tool-Category"
        "Install-Top-10-Tools"
        "Install-Above-All"
        "Help"
	"INSTALL"
	"Exit"
        )
        System=(
	"kali-linux-core"
	"kali-linux-headless"
	"kali-linux-default"
	"kali-linux-light"
	"kali-linux-arm"
	"kali-linux-nethunter"
	"Back"
	)
	Desktop=(
	"kali-desktop-core"
	"kali-desktop-e17"
	"kali-desktop-gnome"
	"kali-desktop-i3"
	"kali-desktop-kde"
	"kali-desktop-lxde"
	"kali-desktop-mate"
	"kali-desktop-xfce"
	"Back"	
	)
	Tools=(
	"kali-tools-gpu"
	"kali-tools-hardware"
	"kali-tools-crypto-stego"
	"kali-tools-fuzzing"
	"kali-tools-802-11"
	"kali-tools-bluetooth"
	"kali-tools-rfid"
	"kali-tools-sdr"
	"kali-tools-voip"
	"kali-tools-windows-resources"
	"Back"
	)
	CateTools=(
	"kali-tools-information-gathering"
	"kali-tools-vulnerability"
	"kali-tools-web"
	"kali-tools-database"
	"kali-tools-passwords"
	"kali-tools-wireless"
	"kali-tools-reverse-engineering"
	"kali-tools-exploitation"
	"kali-tools-social-engineering"
	"kali-tools-sniffing-spoofing"
	"kali-tools-post-exploitation"
	"kali-tools-forensics"
	"kali-tools-reporting"	
	"Back"
	)
	
	On=1
	Off=0
	choice=0
	until [ $choice == 255  ];
       	do
		createMenu ${Menu[@]} $On
		choice=$?

		if [[ $choice -eq 0  ]]; then
			echo "Inside System!..."
			createMenu ${System[@]} $Off 
		elif [[ $choice -eq 1  ]]; then
			createMenu ${Desktop[@]} $Off
		elif [[ $choice -eq 2  ]]; then
			createMenu ${Tools[@]} $Off
		elif [[ $choice -eq 3  ]]; then
			createMenu ${CateTools[@]} $Off
		elif [[ $choice -eq 4  ]]; then
			apt "kali-tools-top10"
		elif [[ $choice -eq 5  ]]; then
			apt "kali-linux-everything"
		elif [[ $choice -eq 6  ]]; then
			#Documentation for this Script
			clear
			cat README.md
			read -p "Press any key to return to MainMenu..."
		elif [[ $choice -eq 7  ]]; then
			if [[ ${#AptArgs[@]} -eq 0  ]]; then
				read -p "Select any package to INSTALL..."
			else
				apt ${AptArgs[@]}
			fi
		fi
	done
	echo "bye bye | Sayonara...!"
}
main
