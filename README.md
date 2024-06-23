Gera comando heimdall para fleshar imagens em partiçôes


*** Requisitos:
```
apt update && apt install lz4 tar unzip -y
```

*** Gerar comando baseado no PIT:
```
./heimcomm.sh build-command pit.txt
```

> [!WARNING]
Pra gerar o comando baseado na pasta de arquivos flashes `vendor.img` ou `ch.bin` arquivos flashes, precisa extrair a stock rom em uma pasta chamada `extracted` usando o comando a seguir:
```
./heimcomm.sh extract stockrom.zip
```

Boa sorte ;)
