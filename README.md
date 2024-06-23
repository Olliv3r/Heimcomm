Gera um comando extenso baseado no pit do dispositivo para enviar arquivos de flash para as partiçoes do dispositivo.


Requisitos:
```
apt update && apt install lz4 tar unzip -y
```

Gerar comando baseado no PIT:
```
./heimcomm.sh build-command pit.txt
```

> [!WARNING]
Para gerar um comando expecífico baseado na pasta de arquivos flashe `vendor.img` e `ch.bin`, é necessário extrair a stock rom em uma pasta chamada `extracted` usando o comando a seguir:
```
./heimcomm.sh extract stockrom.zip
```

Boa sorte ;)
