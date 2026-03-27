# ShopFlow — Protótipo de E-commerce Flutter

Aplicativo Flutter de e-commerce desenvolvido como **protótipo de teste para validação do sistema automatizado de tagueamento GA4**, baseado na taxonomia
definida em `taxonomy.flutter.dart.yaml`.

O app simula um ambiente real de produção: não há nenhuma instrução explícita
de tagueamento no código. O automatizador deve inferir os eventos corretos a
partir dos elementos, contextos e comportamentos presentes em cada tela.

---

## Índice

- [Visão Geral](#visão-geral)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Fluxos do App](#fluxos-do-app)
- [Mapa de Eventos Esperados](#mapa-de-eventos-esperados)
- [Cobertura de Eventos da Taxonomia](#cobertura-de-eventos-da-taxonomia)
- [Dados de Teste](#dados-de-teste)
- [Critérios de Validação](#critérios-de-validação)

---

## Visão Geral

### Propósito

O ShopFlow existe para responder a uma pergunta objetiva:

> **O sistema automatizado de tagueamento consegue identificar corretamente > todos os eventos GA4 definidos na taxonomia, apenas analisando o código > Flutter — sem nenhuma anotação manual?**

### O que o app cobre

| Categoria | Eventos cobertos |
|---|---|
| Navegação | `screen_view` em todas as 12 telas |
| Autenticação | `login`, `sign_up` com múltiplos métodos |
| Onboarding | `tutorial_begin`, `tutorial_complete` |
| Descoberta | `search`, `select_content`, `view_item_list` |
| Produto | `view_item`, `select_item`, `add_to_wishlist` |
| Carrinho | `view_cart`, `add_to_cart`, `remove_from_cart` |
| Checkout | `begin_checkout`, `add_shipping_info`, `add_payment_info` |
| Conversão | `purchase` com `transaction_id` real |
| Pós-compra | `refund` via diálogo de devolução |
| Promoções | `view_promotion`, `select_promotion` com carrossel |
| Social | `share` via Share Sheet nativo |

---

## Pré-requisitos

| Ferramenta | Versão mínima |
|---|---|
| Flutter SDK | 3.0.0 |
| Dart SDK | 3.0.0 |
| Android SDK | API 21 (Android 5.0) |
| Xcode | 14.0 (para iOS) |
| VS Code ou Android Studio | Qualquer versão recente |

---

## Instalação

```bash # 1. Clonar o repositório git clone https://github.com/seu-org/shopflow.git cd shopflow # 2. Instalar dependências flutter pub get # 3. Verificar ambiente flutter doctor # 4. Executar no dispositivo ou emulador flutter run # Para executar com logs detalhados flutter run --verbose # Para build de release (teste de performance) flutter build apk --release flutter build ios --release
