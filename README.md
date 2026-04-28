# Brainhub
Aplicativo desenvolvido para obtenção de nota na disciplina de "Programação de Dispositivos Móveis".
Esta aplicação foi desenvolvida com Flutter.

## Equipe
- Claudiney Gustavo Rodrigues dos Santos
- Thales Janisch Santos

### Divisão geral de tarefas
- Claudiney Gustavo Rodrigues dos Santos: Implementação dos repositories, providers e do interpretador de brainfuck.
- Thales Janisch Santos: Definição do design da aplicação, implementação da estrutura estática das telas.

## Funcionalidades

### Funcionalidades implementadas
- Tela de login e registro de usuários (ainda sem persistência de dados);
- Tela de configurações;
- Tela de menu para criação, seleção e exclusão de scripts de brainfuck;
- Tela de edição de scripts de brainfuck;
- Interpretador de código em brainfuck (parcial);

### Funcionalidades ainda a serem implementadas
- Implementação de database para persistência de dados dos usuários e scripts de brainfuck;
- Geração e leitura de código QR dos scripts de brainfuck;
- Implementação da função de input do interpretador de brainfuck;

## Compilação
A aplicação foi desenvolvida com Flutter, versão 3.41.6. Siga o [Guia Rápido do Flutter](https://docs.flutter.dev/install/quick) para a configuração do ambiente.
As plataformas principais para a aplicação são Android e Linux. Siga a documentação do Flutter para configurar esses ambientes.
Para a compilação da versão do Android, certifique-se de utilizar a versão 17 ou superior do JDK.

Para compilar a versão de Linux, execute o comando:
```bash
flutter build linux
```
O arquivo executável estará disponível em `build/linux/x64/release/bundle/brainhub`.

Para compilar a versão de Linux, execute o comando:
```bash
flutter build apk
```
O arquivo executável estará disponível em `build/app/outputs/apk/release/app-release.apk`. Para a instalação do aplicativo, transfira esse arquivo para seu dispositivo android e realize a instalação. Use um dispositivo com versão Android 12 ou superior.

## Builds
É possível baixar o aplicativo (para android ou linux) pelos [releases](https://github.com/Claudiney-Santos/brainhub/releases/tag/v1.0.0-alpha)
