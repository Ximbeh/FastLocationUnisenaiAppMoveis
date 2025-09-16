# FastLocation

Aplicativo móvel desenvolvido para consulta de CEP e endereços, com armazenamento local de histórico e funcionalidades de rastreamento de rotas.

O projeto foi desenvolvido em **Flutter**, utilizando **MobX** para gerenciamento de estado e **Hive** para persistência local.

---

## Funcionalidades

- Consulta de endereços a partir de CEP.
- Busca de CEP a partir de endereços completos ou parciais.
- Histórico de consultas armazenado localmente.
- Traçar rota do dispositivo até o último endereço consultado.
- Tela de abertura com animação e redirecionamento automático.
- Componentes reativos usando MobX.

---

## Tecnologias Utilizadas

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [MobX](https://pub.dev/packages/mobx)
- [Hive](https://pub.dev/packages/hive)
- [Dio](https://pub.dev/packages/dio)
- [Map Launcher](https://pub.dev/packages/map_launcher)
- [Geocoding](https://pub.dev/packages/geocoding)

---

## Como Rodar o Projeto

### Pré-requisitos

- Flutter SDK instalado: [Instruções de instalação](https://docs.flutter.dev/get-started/install)
- VS Code ou Android Studio
- Emulador Android ou dispositivo físico conectado

### Comandos Básicos

1. **Instalar dependências**

```bash
flutter pub get
```

2. **Gerar arquivos do MobX e Hive**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. **Executar o aplicativo no dispositivo conectado ou navegador**

```bash
flutter run
```

Para rodar no navegador (Edge/Chrome):

```bash
flutter run -d edge
```

ou

```bash
flutter run -d chrome
```

4. **Hot reload**
   No terminal com o app rodando, pressione r para atualizar sem reiniciar.

---

Projeto desenvolvido como atividade acadêmica da matéria Desenvolvimento de Sistemas Móveis e Distribuídos do curso de Analise e Desenvolvimento de Sistemas da UNISENAI.
