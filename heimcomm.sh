#!/usr/bin/env bash
#
# Gera um comando extenso baseado no pit do dispositivo para fleshar as imagens nas partiçoes correspondente.
#
#

partition_names_array=()
flash_filenames_array=()
command=("heimdall flash")

check_os() {
	device=$(getprop ro.product.vendor.brand)

	if [ "$device" != "samsung" ] ; then
		echo -e "\e[1;31mDispositivo $device não compatível com este programa, tentar executá-lo pode resultar em erros.\e[0m"
		exit
	else
		echo -e "\e[1;32mDispositivo compatível: $device\e[0m"
	fi
}

read_pit() {
	pit_file=$1

	# LENDO ARQUIVO PIT EXTRAÍDO DO DISPOSITIVO
	while IFS= read -r line; do
		if [[ "$line" == "Partition Name:"* ]]; then
			partition_name=${line#Partition Name: }
		fi

		if [[ "$line" == "Flash Filename:"* ]]; then
			flash_filename=${line#Flash Filename: }

			if [[ -n "$partition_name" && "$partition_name" != "-" && -n "$flash_filename" && "$flash_filename" != "-" ]]; then
				partition_names_array+=("$partition_name")
				flash_filenames_array+=("$flash_filename")
			fi

			partition_name=""
			flash_filename=""
		fi
	done < "$pit_file"
}

build_command() {
	# CONSTRUINDO COMANDO LONGO DO HEIMDALL
	if [[ ${#partition_names_array[*]} -eq ${#flash_filenames_array[*]} ]]; then
		for ((i=0; i < ${#partition_names_array[*]}; i++)); do
			param="--${partition_names_array[$i]} ${flash_filenames_array[$i]}"
			command+=("$param")
		done
	fi

	echo -e "Novo comando heimdall gerado:\n"
	echo -e "${command[*]}\n"
}


extract_all() {
	for file in ./* ; do
		if [ ! -d $file ]; then
			lz4 $file
		fi
	done
	cd ..
}

extract() {
	ext=$(echo "$1" | cut -d . -f2)
	[ "$ext" != "zip" ] && echo "Extensão invalida!" && exit
	clear
	file=$1
	size=$(ls -lh $file | cut -d " " -f 5)
	
	echo -e "\e[1;32mNome do arquivo: \e[1;36m[$file]\e[0m"
	echo -e "\e[1;32mTamanho do arquivo: \e[1;36m[$size]\e[0m"
	echo -e "\e[1;32mExtraíndo arquivo (ZIP)...\e[0m"
	unzip $file

	mkdir extracted
	mkdir AP BL CP CSC HOME
	
	echo -e "\e[1;32mExtraíndo arquivos (MD5)...\e[0m"
	tar -xvf AP_* -C AP
	tar -xvf BL_* -C BL
	tar -xvf CP_* -C CP
	tar -xvf CSC_* -C CSC
	tar -xvf HOME_* -C HOME

	echo -e "\e[1;32mExtraíndo arquivos (LZ4)...\e[0m"
	cd AP && extract_all
	cd BL && extract_all
	cd CP && extract_all
	cd CSC && extract_all
	cd HOME && extract_all

	echo -e "\e[1;32mMovendo todos os extraídos para o um diretório separado...\e[0m"
	cp AP/* extracted -rf
	cp BL/* extracted -rf
	cp CP/* extracted -rf
	cp CSC/* extracted -rr
	cp HOME/* extracted -rf

	rm -rf AP BL CP CSC HOME *.md5
	rm -rf extracted/*.lz4
	echo -e "\n\e[1;31mOs arquivos foram movidos para o diretório 'extracted'.\e[0m"
	echo -e "\e[1;36mO processo de extração da STOCK ROM finalizado.\e[0m"
}

helper() {
	echo -e "Usage: $(basename $0) <action> <action arguments>\n\nAction: check-os\nDescription: Verifica se o dispositivoo tem suporte ao uso desse programa.\n\nAction: extrack\nArguments: [FILE_ZIP_STOCK_ROM]\nDescription: Extrai o arquivo da STOCK ROM passando pelo os 4 níveis de compactação.\n\nAction: build-command\nArguments: [FILE_PIT]\nDescription: Constrói comando longo do heimdall de acordo com o arquivo PIT extraído do dispositivo."
}

if [ -z "$1" ];then
	helper
	exit
else
	while [ -n "$1" ]; do
		case "$1" in
			help) helper;;
			check-os) check_os;;
			extract)
				shift
				file=$1
				
				if [ -n "$file" ]; then
					extract $file
				else
					echo "Precisa do arquivo ZIP da STOCK ROM!"
					exit
				fi
				;;
			build-command)
				shift
				file=$1
				
				if [ -n "$file" ]; then
					read_pit $file
					build_command
				else
					echo "Precisa do arquivo PIT extraído do dispositivo!"
					exit
				fi
				;;
			*)
				helper;;
		esac
		shift
	done
fi
