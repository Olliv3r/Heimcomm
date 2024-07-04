Gera um comando gigantesco baseado no diretório e pit do dispositivo para enviar arquivos para as partiçôes do dispositivo.


### Instalação:
```
apt update && apt install lz4 tar unzip -y
```

Gerar comando baseado no diretório e PIT:
```
./heimcomm.sh build-command extracted pit.txt
```

> [!WARNING]
Caso você tenha o arquivo da stock rom, basta extrair todos os arquivos em uma pasta chamada `extracted` usando o seguinte comando:
```
./heimcomm.sh extract stockrom.zip
```

Gerar comando para `heimdall no pc`:
![Heimdall pc](https://github.com/Olliv3r/Heimcomm/blob/main/media/build_command_pc.jpg)
```
./heimcomm.sh build-command extracted pit.txt
```

> [!NOTE]
Apenas para android Termux: *Pra que a pasta cache do aplicativo `heimdoo` seja acessível, precisamos abrir o aplicativo `heimdoo` e selecionar pelo menos um arquivo pra que o app crie esta pasta `cache` que o app utiliza.*

Movendo todos os arquivos do diretório `extracted` para a pasta cache do `heimdoo app`. *Apenas para Android TERMUX*:
![Copiar para cache Heimdoo](https://github.com/Olliv3r/Heimcomm/blob/main/media/mv_files_cache.jpg)
```
./heimcomm.sh mv-files-cache extracted
```

Gerar comando para o aplicativo `heimdoo`. *Apenas para Android Termux*:
![Gerar comando para o aplicativo Heimdoo](https://github.com/Olliv3r/Heimcomm/blob/main/media/build_command_android.jpg)
```
./heimcomm.sh build-command /storage/emulated/0/Android/data/dev.rohitverma882.heimdoo/cache/cached_imgs pit.txt
```

Limpar o cache de arquivos do aplicativo `heimdoo` depois do processo. *Apenas para Android Termux*:
![Limpar o cache de arquivos do Heimdoo](https://github.com/Olliv3r/Heimcomm/blob/main/media/clear_cache.jpg)
```
./heimcomm.sh clear-cache
```

Fontes importantes:
1. <a href="https://github.com/RohitVerma882/Heimdoo">Heimdoo Android</a>
2. <a href="https://github.com/amo13/Heimdall">Heimdall Linux PC</a>

Boa sorte ;)
