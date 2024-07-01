Gera um comando extenso baseado no pit do dispositivo para enviar arquivos de flash para as partiçôes do dispositivo.


Requisitos:
```
apt update && apt install lz4 tar unzip -y
```

Gerar comando baseado no PIT:
```
./heimcomm.sh build-command pit.txt
```

> [!WARNING]
Para gerar um comando expecífico baseado na pasta de arquivos flash `vendor.img` e `ch.bin`, é necessário extrair a stock rom em uma pasta chamada `extracted` usando o comando a seguir:
```
./heimcomm.sh extract stockrom.zip
```

Gerar comando para `heimdall no pc`:
![Heimdall pc](https://github.com/Olliv3r/Heimcomm/blob/main/media/pc.jpg)

Copiando arquivos para a pasta cache do `heimdoo app`:
![Heimdoo app](https://github.com/Olliv3r/Heimcomm/blob/main/media/cp.jpg)

Gerar comando para android com o `heimdoo app`:
![Copiar para cache Heimdoo](https://github.com/Olliv3r/Heimcomm/blob/main/media/android.jpg)

Boa sorte ;)
