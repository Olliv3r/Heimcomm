Gera um comando extenso baseado no pit do dispositivo para enviar arquivos de flash para as partiçôes do dispositivo.



### Instalação:
```
apt update && apt install lz4 tar unzip -y
```

Gerar comando baseado no diretório e PIT:
```
./heimcomm.sh build-command extracted pit.txt
```

> [!WARNING]
Para gerar o comando baseado no diretório padrão, é necessário extrair a stock rom em uma pasta chamada `extracted` usando o seguinte comando:
```
./heimcomm.sh extract stockrom.zip
```

Gerar comando para `heimdall no pc`:
![Heimdall pc](https://github.com/Olliv3r/Heimcomm/blob/main/media/build_command_pc.jpg)

> [!NOTE]
Apenas para android Termux: *Pra que a pasta cache do aplicativo `heimdoo` seja acessível, precisamos abrir o aplicativo e selecionar um arquivo pelo menos uma vez pra que o app crie a pasta cache pra utilização no app.*

Movendo todos os arquivos para a pasta cache do `heimdoo app` *Apenas para Android TERMUX*:
![Copiar para cache Heimdoo](https://github.com/Olliv3r/Heimcomm/blob/main/media/mv_files_cache.jpg)

Gerar comando para o aplicativo `heimdoo` *Apenas para Android Termux*:
![Gerar comando para o aplicativo Heimdoo](https://github.com/Olliv3r/Heimcomm/blob/main/media/build_command_android.jpg)

Limpar o cache de arquivos do aplicativo `heimdoo` depois do processo *Apenas para Android Termux*:
![Limpar o cache de arquivos do Heimdoo](https://github.com/Olliv3r/Heimcomm/blob/main/media/clear_cache.jpg)

Fontes importantes:
1. <a href="https://github.com/RohitVerma882/Heimdoo">Heimdoo Android</a>
2. <a href="https://github.com/amo13/Heimdall">Heimdall Linux PC</a>

Boa sorte ;)
