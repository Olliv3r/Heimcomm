#!/usr/bin/env bash
#
# Gera um comando extenso baseado no pit do dispositivo para enviar arquivos flash para as partições do dispositivo usando o heimdall.
#
#

partition_names_array=()
flash_filenames_array=()
command=("heimdall flash")
directory_md5=("AP" "BL" "CSC" "CP" "HOME")

# LER ARQUIVO PIT EXTRAÍDO DO DISPOSITIVO
read_pit() {
	pit_file=$1

	while IFS= read -r line; do
		if [[ "$line" == "Partition Name:"* ]]; then
			partition_name=${line#Partition Name: }
		fi

		if [[ "$line" == "Flash Filename:"* ]]; then
			flash_filename=${line#Flash Filename: }

			if [[ -n "$partition_name" && "$partition_name" != "-" && -n "$flash_filename" && "$flash_filename" != "-" ]]; then
				if [[ -f extracted/$flash_filename ]]; then
					partition_names_array+=("$partition_name")
					flash_filenames_array+=("$flash_filename")
				fi
			fi

			partition_name=""
			flash_filename=""
		fi
	done < "$pit_file"
}

# CONSTRUINDO COMANDO LONGO DO HEIMDALL
build_command() {
	if [[ ${#partition_names_array[*]} -eq ${#flash_filenames_array[*]} ]]; then
		for ((i=0; i < ${#partition_names_array[*]}; i++)); do
			param="--${partition_names_array[$i]} ${flash_filenames_array[$i]}"
			command+=("$param")
		done
	fi

	echo -e "Novo comando heimdall gerado:\n"
	echo -e "${command[*]}\n"
}

# EXTRAI TODOS OS ARQUIVO TAR.MD5
extract_all_tar_md5() {
	echo -e "\e[1;32mExtraíndo arquivos (MD5)...\e[0m"
	for dir in ${directory_md5[*]}; do
		tar -xvf ${dir}_* -C $dir
	done
	rm -rf *.md5
}

# EXTRAI TODOS OS ARQUIVO LZ4
extract_all_lz4() {
	echo -e "\e[1;32mExtraíndo arquivos (LZ4)...\e[0m"
	for dir in ${directory_md5[*]}; do
		for file in ./${dir}/* ; do
			if [ ! -d $file ]; then
				lz4 $file
			fi
		done
	done
}

# MOVE TODOS OS ARQUIVO EXTRAIDOS
move_files_all() {
	echo -e "\e[1;32mMovendo arquivos...\e[0m"
	[ ! -d extracted ] && mkdir extracted

	for dir in ${directory_md5[*]}; do
		mv $dir/* extracted
	done
}

extract() {
	ext=$(echo "$1" | cut -d . -f2)
	[ "$ext" != "zip" ] && echo -e "\e[1;31mExtensão invalida!\e[0m" && exit
	
	echo -e "\e[1;32mExtraíndo arquivo (ZIP)...\e[0m"
	unzip $file
	rm $file

	if [ $? -eq 9 ]; then
		echo -e "\e[1;31mArquivo ZIP invalido!\e[0m" && exit 9
	fi

	mkdir AP BL CP CSC HOME
	
	extract_all_tar_md5
	extract_all_lz4
	move_files_all

	rm -rf AP BL CP CSC HOME *.md5
	rm -rf extracted/*.lz4
	echo -e "\n\e[1;32mOs arquivos foram movidos para o diretório 'extracted'.\e[0m"
	echo -e "\e[1;36mProcesso de extração da STOCK ROM finalizado.\e[0m"
	
}

# Ajuda
helper() {
	echo -e "Usage: $(basename $0) <action> <action arguments>\n\nAction: extract\nArguments: [FILE_ZIP_STOCK_ROM]\nDescription: Extrai os arquivos da STOCK ROM no diretório 'extracted'.\n\nAction: build-command\nArguments: [FILE_PIT]\nDescription: Constrói comando longo do heimdall de acordo com o arquivo PIT extraído do dispositivo."
}

# TRATAMENTO DE OPÇÔES
if [ -z "$1" ];then
	helper
	exit
else
	while [ -n "$1" ]; do
		case "$1" in
			help) helper;;
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
