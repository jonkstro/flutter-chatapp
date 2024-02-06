# Flutter Chat App

## Usaremos:

- **Firebase**
- **Firestore como database**
- **Push notifications**
- **Autenticação Firebase**
- **Storage de arquivos**

## Tecnologias e Recursos Utilizados

1. **Firebase:** O Firebase é uma plataforma de desenvolvimento móvel fornecida pelo Google, oferecendo uma variedade de serviços essenciais para o desenvolvimento de aplicativos, como autenticação, armazenamento de dados, mensagens em tempo real e muito mais.

2. **Firestore como Database:** O Firestore é um banco de dados NoSQL em tempo real fornecido pelo Firebase. Ele será utilizado para armazenar e sincronizar dados em tempo real entre os usuários do aplicativo, possibilitando uma experiência de bate-papo em tempo real.

3. **Push Notifications:** Implementaremos notificações push para manter os usuários informados sobre novas mensagens, garantindo uma comunicação eficiente e instantânea.

4. **Autenticação Firebase:** Utilizaremos o serviço de autenticação do Firebase para permitir que os usuários acessem o aplicativo de forma segura, garantindo uma experiência personalizada e protegida.

5. **Storage de Arquivos:** Faremos uso do serviço de armazenamento do Firebase para lidar com o upload e o download de arquivos, como imagens compartilhadas durante as conversas.

## Instruções de Configuração

Antes de iniciar o desenvolvimento, é necessário configurar o ambiente e as chaves de API necessárias. Siga as instruções abaixo:

1. **Configuração do Firebase:**
   - Crie um projeto no [Console do Firebase](https://console.firebase.google.com/).
   - Ative o Firestore, a Autenticação e o Storage no console.
   - Obtenha as chaves de configuração necessárias para integrar o Flutter com o Firebase.

2. **Configuração do Projeto Flutter:**
   - Clone este repositório em sua máquina local.
   - Substitua as chaves de configuração no arquivo `lib/config/firebase_config.dart` pelos valores obtidos no Console do Firebase.

3. **Dependências do Flutter:**
   - Execute `flutter pub get` para instalar as dependências necessárias do projeto.

4. **Execução do Aplicativo:**
   - Agora, você está pronto para executar o aplicativo. Utilize o comando `flutter run` no terminal.

## Contribuições

Contribuições são bem-vindas! Se você encontrar bugs ou tiver sugestões para melhorias, sinta-se à vontade para abrir uma issue ou enviar um pull request.

Divirta-se desenvolvendo o Flutter Chat App!
