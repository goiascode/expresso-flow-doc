# Interface — WebFlow

Acesse em `http://localhost:8080/webflow` após executar `python main.py` com o `WebflowBundle` registrado.

---

## Painel de Chat

O painel esquerdo simula a interface de um canal de mensagens.

### Cabeçalho

| Elemento | Descrição |
|----------|-----------|
| **WebFlow Bot** | Nome e status do bot (online) |
| Seletor de usuário | Avatar e nome do usuário simulado na sessão atual |
| :material-note-text: | Abre informações da sessão |
| :material-delete: | Limpa o histórico do chat |
| :material-dots-vertical: | Menu de opções adicionais |

### Área de conversa

Exibe as mensagens trocadas na sessão atual em ordem cronológica:

- **Mensagens enviadas** (direita) — input do usuário simulado
- **Mensagens recebidas** (esquerda) — respostas do flow, com ícone do bot e timestamp

### Campo de mensagem

Barra inferior com campo de texto livre para enviar mensagens ao flow. Suporta também envio de áudio e emoji.

---

## Painel de Debug

O painel direito exibe informações em tempo real sobre a execução do flow.

### Cabeçalho

| Elemento | Descrição |
|----------|-----------|
| **DEBUG** | Título do painel |
| Contador (ex: `7`) | Total de eventos registrados na sessão |
| **Clear** | Limpa todos os registros da sessão atual |

---

### Aba Console

Exibe os logs emitidos via `ctx.console` durante a execução dos steps.

Cada entrada mostra:
- Direção: `sent` (enviado pelo bot) ou `received` (recebido do usuário)
- Tipo: `MESSAGE`
- Timestamp
- Conteúdo da mensagem

---

### Aba Steps

Exibe o histórico de steps executados na sessão atual.

Cada entrada contém:

| Campo | Descrição |
|-------|-----------|
| **Badge `step`** | Tipo do evento |
| **Status** | `ACTIVE` (laranja) — em execução / `COMPLETED` (verde) — concluído |
| **Nome do flow** | Nome exibido do flow (`name`) |
| **Timestamp** | Horário de execução |
| **FLOW ID** | Identificador do flow (`id`) |
| **STEP #** | Número sequencial do step na thread |
| **ORDER** | Índice `order` definido no decorador `@step()` |
| **LABEL** | Rótulo `label` definido no decorador `@step()` |
| **ELAPSED** | Tempo de execução do step |

```
┌─────────────────────────────────────────────────┐
│ step  ACTIVE    MEU PRIMEIRO FLUXO   16:18:43   │
│                                                 │
│  FLOW ID   first_flow                           │
│  STEP #    0                                    │
│  ORDER     0                                    │
│  LABEL     start                                │
│  ELAPSED   0.002s                               │
└─────────────────────────────────────────────────┘
```

---

### Aba Requests

Exibe as requisições HTTP realizadas durante a execução do flow (ex: chamadas a APIs externas, LLMs, etc.).

---

### Aba Exceptions

Exibe exceções não tratadas capturadas durante a execução do flow, com stack trace completo.

---

## Próximos passos

- [Depuração →](debugging.md)
- [Configuração →](configuration.md)
