# `expresso_flow.step`

```python
from expresso_flow.step import Step, Message
```

---

## `Step`

Namespace de decoradores para métodos de fluxo.

| Decorador | Descrição |
|-----------|-----------|
| `@Step.entry` | Ponto de entrada do flow |
| `@Step.timeout` | Handler de timeout de sessão |
| `@Step.error` | Handler de exceções não tratadas |

---

## `Context` (injetado como `ctx`)

Objeto disponível em todos os steps como primeiro argumento.

| Membro | Tipo | Descrição |
|--------|------|-----------|
| `ctx.send(msg)` | `async` | Envia uma mensagem ao usuário |
| `ctx.wait_input(timeout?)` | `async` | Aguarda entrada do usuário |
| `ctx.goto(step)` | `sync` | Navega para outro step |
| `ctx.end()` | `sync` | Encerra o fluxo |
| `ctx.restart()` | `sync` | Reinicia o fluxo |
| `ctx.redirect_flow(slug)` | `async` | Redireciona para outro flow |
| `ctx.session` | `dict` | Estado da sessão atual |
| `ctx.user_id` | `str` | Identificador do usuário no canal |
| `ctx.channel` | `str` | Nome do canal de origem |
| `ctx.app` | `ExpressoFlow` | Referência à aplicação |

---

## `Message`

Fábrica de mensagens multi-canal.

| Método | Descrição |
|--------|-----------|
| `Message.text(content)` | Mensagem de texto simples |

!!! note "Em construção"
    Os demais tipos de mensagem (`image`, `audio`, `buttons`, `list`, etc.) serão documentados aqui.
