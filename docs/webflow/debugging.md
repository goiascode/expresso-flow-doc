# Depuração com WebFlow

O painel **DEBUG** exibe em tempo real tudo que acontece durante a execução do flow. O contador no cabeçalho indica o total de eventos na sessão.

---

## Aba Console

A aba **Console** registra todas as mensagens trocadas e os logs emitidos via `ctx.console`.

![Console mostrando sent, received, error, info e warning](../assets/images/webflow/webflow-panel-console.png)

### Tipos de entrada

| Badge | Descrição | Origem |
|-------|-----------|--------|
| `sent` | Mensagem enviada pelo usuário | Input do usuário |
| `received` | Mensagem recebida do flow | `ctx.output.send_*()` |
| `error` | Log de erro | `ctx.console.error()` |
| `info` | Log informativo | `ctx.console.info()` |
| `warning` | Log de aviso | `ctx.console.warning()` |

### Tipos de mensagem

O campo `MESSAGE` pode conter subtipos que indicam o formato da mensagem recebida pelo flow:

| Subtipo | Descrição |
|---------|-----------|
| `MESSAGE` | Texto simples |
| `INTERACTIVE_LIST` | Seleção de item em lista interativa |

---

## Aba Steps

A aba **Steps** exibe cada step executado com seus metadados e status.

![Steps mostrando ACTIVE e COMPLETED](../assets/images/webflow/webflow-panel-steps.png)

### Status dos steps

| Status | Cor | Significado |
|--------|-----|-------------|
| `ACTIVE` | Laranja | Step em execução ou aguardando `WaitUserInputAction` |
| `COMPLETED` | Verde | Step concluído — `CompletedFlowAction` ou avanço para próximo step |

### Campos

| Campo | Descrição |
|-------|-----------|
| `FLOW ID` | Identificador do flow (`id`) |
| `STEP #` | Número sequencial na thread de execução |
| `ORDER` | Índice `order` do `@step()` |
| `LABEL` | Rótulo `label` do `@step()` |
| `ELAPSED` | Tempo de execução do step |

### Lendo a sequência de steps

O mesmo step pode aparecer duas vezes:

1. Primeira entrada com `ACTIVE` — step iniciado e retornou `WaitUserInputAction` (aguarda o usuário)
2. Segunda entrada com `ACTIVE` ou `COMPLETED` — step foi executado novamente após o input do usuário

---

## Aba Requests

A aba **Requests** registra todas as requisições HTTP externas feitas durante a execução.

![Requests mostrando POST 200](../assets/images/webflow/webflow-panel-requests.png)

Cada linha exibe o método, status code (verde para 2xx) e tempo de resposta. Clique em uma entrada para inspecionar os detalhes.

### Request Details — Request

![Detalhe da requisição, aba Request](../assets/images/webflow/webflow-modal-request-request.png)

Exibe os **headers** e o **body** enviados na requisição. Útil para verificar credenciais, tokens e payload.

### Request Details — Response

![Detalhe da requisição, aba Response](../assets/images/webflow/webflow-modal-request-response.png)

Exibe os **headers** e o **body** da resposta recebida — incluindo tokens de acesso, dados JSON retornados, etc.

### Request Details — cURL

![Detalhe da requisição, aba cURL](../assets/images/webflow/webflow-modal-request-curl.png)

Gera o **comando cURL** equivalente com botão **Copy**. Útil para:

- Reproduzir a requisição fora do flow
- Testar a API diretamente no terminal
- Compartilhar a chamada para depuração

---

## Aba Exceptions

A aba **Exceptions** exibe as exceções não tratadas capturadas pelo runtime.

![Exceptions mostrando uma entrada ERROR](../assets/images/webflow/webflow-panel-exception.png)

Cada entrada mostra o nível e a mensagem. Clique para abrir o modal de detalhes completo.

![Modal de detalhe de exceção com MESSAGE e STACK TRACE](../assets/images/webflow/webflow-modal-exception.png)

| Campo | Descrição |
|-------|-----------|
| **Nível** | Severidade: `ERROR` |
| **MESSAGE** | Mensagem da exceção |
| **STACK TRACE** | Rastreamento completo para localizar a origem no código |

---

## Dicas

!!! tip "Contador de eventos"
    O número ao lado de `DEBUG` indica o total de eventos na sessão. Clique em **Clear** para zerar sem reiniciar o flow.

!!! tip "Labels descritivos"
    O campo `LABEL` na aba Steps exibe o `label` do `@step()`. Use nomes descritivos para identificar rapidamente qual step está sendo executado durante o debug.

!!! tip "Múltiplas sessões"
    Abra múltiplas abas do navegador para simular usuários simultâneos — cada aba tem sua própria sessão e painel de debug independente.

---

## Próximos passos

- [Interface →](interface.md)
- [Steps →](../core/steps.md)
