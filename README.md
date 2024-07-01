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
![Heimdall pc](https://github.com/Olliv3r/Heimcomm/blob/main/media/pc.jpg)

> [!NOTE]
Apenas para android Termux: *Pra que a pasta cache do aplicativo `heimdoo` seja acessível, precisamos abrir o aplicativo e selecionar um arquivo pelo menos uma vez pra que o app crie a pasta cache pra utilização no app.*

Copiando arquivos para a pasta cache do `heimdoo app` *Apenas para android TERMUX*:
![Heimdoo app](https://github.com/Olliv3r/Heimcomm/blob/main/media/cp.jpg)

Gerar comando para android com o `heimdoo app`:
![Copiar para cache Heimdoo](https://github.com/Olliv3r/Heimcomm/blob/main/media/android.jpg)

Fontes importantes:
1. ![Heimdoo mobile](https://github.com/RohitVerma882/Heimdoo)
2. ![Heimdall PC](https://github.com/amo13/Heimdall)

Boa sorte ;)
