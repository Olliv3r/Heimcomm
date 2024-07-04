#!/usr/bin/env bash
#
# Gera um comando extenso baseado no pit do dispositivo para enviar arquivos flash para as partições do dispositivo usando o heimdall.
#
# Autor: Oliver Silva
#
# Versão: 0.0.2
#

partition_names_array=()
flash_filenames_array=()
command=("heimdall flash")
directory_md5=("AP" "BL" "CSC" "CP" "HOME")

# LER ARQUIVO PIT EXTRAÍDO DO DISPOSITIVO
read_pit() {
    dir_imgs=$1
    pit_file=$2

    while IFS= read -r line; do
	if [[ "$line" == "Partition Name:"* ]]; then
	    partition_name=${line#Partition Name: }
	fi

	if [[ "$line" == "Flash Filename:"* ]]; then
	    flash_filename=${line#Flash Filename: }

	    if [[ -n "$partition_name" && "$partition_name" != "-" && -n "$flash_filename" && "$flash_filename" != "-" ]]; then
		if [ -d $dir_imgs ]; then
  		    if [[ -f $dir_imgs/$flash_filename ]]; then
  			partition_names_array+=("$partition_name")
  			flash_filenames_array+=("$flash_filename")
  		    fi
  		else
		    echo -e "\e[1;31mDiretório não existe!\e[0m"
		    exit
  		fi
	    fi

	    partition_name=""
	    flash_filename=""
	fi
    done < "$pit_file"
}

# CONSTRUINDO COMANDO LONGO DO HEIMDALL BASEADO NO DIRETÓRIO E PIT
build_command() {
    dir_imgs=$1
  
    if [ ! -d $dir_imgs ]; then
  	echo -e "\e[1;31mDiretório não existe!\e[0m"
	exit
    fi
  
    if [[ ${#partition_names_array[*]} -eq ${#flash_filenames_array[*]} ]]; then
	for ((i=0; i < ${#partition_names_array[*]}; i++)); do
	    param="--${partition_names_array[$i]} $dir_imgs${flash_filenames_array[$i]}"
	    command+=("$param")
	done
    fi

    echo -e "Novo comando heimdall gerado:\n"
    echo -e "${command[*]}\n"
}

# EXTRAI TODOS OS ARQUIVO .TAR.MD5
extract_all_tar_md5() {
    echo -e "\e[1;32mExtraíndo arquivos (MD5)...\e[0m"
    
    for dir in ${directory_md5[*]}; do
	tar -xvf ${dir}_* -C $dir
    done
    rm -rf *.md5
}

# EXTRAI TODOS OS ARQUIVO .LZ4
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

# EXTRAI OS ARQUIVOS DA STOCK ROM
extract() {
    ext=$(echo "$1" | cut -d . -f2)
    [ "$ext" != "zip" ] && echo -e "\e[1;31mExtensão invalida!\e[0m" && exit
	
    echo -e "\e[1;32mExtraíndo arquivo (ZIP)...\e[0m"
    unzip $file && rm $file

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

# COPIA TODOS OS ARQUIVOS DE UM DIRETÓRIO EXPECÍFICO PARA O CACHE DO APLICATIVO HEIMDOO (APENAS PARA ANDROID TERMUX)
mv_files_cache() {
    dir_imgs=$1
   	
    cache=/storage/emulated/0/Android/data/dev.rohitverma882.heimdoo/cache/cached_imgs

    echo -e "\e[0m[!] Todos os arquivos do diretório '$dir_imgs' serão movidos para o cache do heimdoo (app), tem certeza que quer realizar esta operação? (y/n) "
    read resp

    if [ ! -n "$resp" ]; then
	echo -e "\e[0m[!] Opçôes que devem ser usadas 'y' e 'n'.\e[0m"
        mv_files_cache

    elif [ "$resp" == "n" ]; then
	echo -e "\e[1;31m[×] Operação cancelada.\e[0m"
    	exit

    elif [ "$resp" == "y" ]; then
	if [ ! -d $cache ]; then
	    echo -e "\e[0m[!] Cache heimdoo (app) [\e[1;31mNO\e[0m]"
	    echo -e "\e[0m[?] abra o aplicativo 'heimdoo' e selecione pelo menos um arquivo e volte a executar este programa '$0' novamente."
	    exit
	fi

	echo -e "\e[0m[+] Cache heimdoo (app) [\e[1;32mOK\e[0m]"
	printf "\r\e[0m[*] Excluindo arquivos antigos..."
	
	for file in $cache/*; do
	    rm -rf $file
	done
	printf "\r\e[0m[+] Excluindo arquivos antigos...OK\n"
  
    	if [ -d $dir_imgs ]; then
	    echo -e "\e[0m[*] Movenndo novos arquivos para $cache..."
	    mv $dir_imgs/* $cache
	    exit 0
	else
	    echo -e "\e[1;31m[!] Diretório $dir_imgs não existe.\e[0m"
   	    exit
	fi
    else
	echo -e "\e[0m[!] Opçôes que devem ser usadas 'y' e 'n'.\e[0m"
	mv_files_cache
    fi
}

clearCache() { 
    cache=/storage/emulated/0/Android/data/dev.rohitverma882.heimdoo/cache/cached_imgs

    [ ! -d $cache ] && echo -e "\e[0m[!] Diretório \e[1;33m$cache \e[0mnão existe.\e[0m" && exit

    printf "\r\e[0m[*] Excluindo arquivos antigos..."
    for file in $cache/*; do
	rm -rf $file
    done
    printf "\r\e[0m[+] Excluindo arquivos antigos...OK\n"

}

# Ajuda
helper() {
    echo -e "Usage: $(basename $0) <action> <action arguments>\n\nAction: extract\nArguments: [FILE_ZIP_STOCK_ROM]\nDescription: Extrai os arquivos da STOCK ROM no diretório 'extracted'.\n\nAction: build-command\nArguments: [DIRECTORY_IMGS FILE_PIT]\nDescription: Constrói comando longo do heimdall de acordo com o arquivo PIT extraído do dispositivo.\n\nAction: clear-cache\nDescription: Deleta todos os arquivos no cache do aplicativo heimdoo [SOMENTE PARA ANDROID TERMUX].\n\nAction: mv-files-cache\nArguments: [DIRECTORY_IMGS]\nDescription: Move todos os arquivos de um diretório para o cache de imagens do aplicativo heimdoo [SOMENTE PARA ANDROID TERMUX]."
}

# TRATAMENTO DE OPÇÔES
if [ -z "$1" ];then
    helper
    exit
else
    while [ -n "$1" ]; do
	case "$1" in
	    help) helper;;
	    clear-cache) clearCache;;
	    mv-files-cache)
	        shift
	      	dir_imgs=$1
	      
	      	if [ -n "$dir_imgs" ]; then
	  	    mv_files_cache $dir_imgs
	      	else
	            echo "Precisa do diretório de imagens!"
	            exit
	      	fi;;
	    extract)
	        shift
		file=$1
				
		if [ -n "$file" ]; then
		    extract $file
		else
		    echo "Precisa do arquivo ZIP da STOCK ROM!"
		    exit
		fi;;
	    build-command)
	        shift
		dir_imgs=$1

		if [ -n "$dir_imgs" ]; then
		    shift
		    file=$1
				
		    if [ -n "$file" ]; then
		        read_pit $dir_imgs $file
		        build_command $dir_imgs/
		    else
		        echo "Precisa do arquivo PIT extraído do dispositivo!"
			exit
		    fi
		else
		    echo "Precisa do diretório das imagens!"
		    exit
		fi;;
	    *)
	        helper;;
	esac
	shift
    done
fi
