# hi Paw

Aplicativo Flutter modularizado com autenticação Firebase, persistência local e redirecionamento automático por perfil (admin/patient). O projeto segue princípios de clean architecture, separando responsabilidades em camadas de domínio, dados e apresentação.

## Tecnologias

- Flutter 3.24 (null-safety)
- Riverpod para gerenciamento de estado
- Firebase Authentication + Cloud Firestore
- Shared Preferences para cache local do usuário
- Docker para padronizar o ambiente de desenvolvimento

## Estrutura de pastas

```
lib/
  core/
    constants/        # rotas nomeadas, keys e afins
    router/           # AppRouter centralizado
    services/         # integrações compartilhadas (cache local)
    theme/            # temas globais
  features/
    auth/             # fluxo completo de autenticação
      data/           # datasources + repositórios
      domain/         # entidades e casos de uso
      presentation/   # telas e controllers
    admin/            # telas do administrador
    patient/          # telas do paciente
```

## Fluxo de autenticação

1. `SplashScreen` observa o provider `authControllerProvider` e encaminha automaticamente para `/login`, `/admin/home` ou `/patient/home`.
2. Tela de login realiza autenticação e oferece diálogo para criação de contas (com seleção de role).
3. Após autenticar, o repositório grava o usuário na coleção `users` do Firestore, além de persistir um cache local para inicialização mais rápida.
4. Tanto `AdminHomeScreen` quanto `PatientHomeScreen` exibem conteúdos dedicados e permitem logout.

## Configuração do Firebase

1. Execute `flutterfire configure` e substitua os valores de `lib/firebase_options.dart`.
2. Adicione os arquivos `google-services.json` (Android) e `GoogleService-Info.plist` (iOS) nos diretórios padrões.
3. Garanta que a coleção `users` exista e contenha o campo `role` (`admin` ou `patient`).

## Executando via Docker

1. Construa a imagem: `docker compose build`.
2. Suba o container interativo: `docker compose run --rm flutter-dev`.
3. Dentro do container, execute `flutter pub get` e `flutter run` para iniciar o app.

## Testes

Por padrão, o projeto vem com as dependências configuradas para que você possa criar testes de unidade nas camadas de domínio e apresentação. Utilize `flutter test` para rodá-los dentro do container.

## Splash screen nativa

O app utiliza o pacote `flutter_native_splash` para exibir a imagem `images/splash_screen.jpg` imediatamente ao abrir. Após alterar a arte, execute `dart run flutter_native_splash:create` para regerar os assets nativos de Android/iOS.
