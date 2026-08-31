# Bundles

O sistema de **bundles** é o mecanismo de extensão plugável do Expresso Flow. Um bundle encapsula um conjunto de funcionalidades — um canal, uma interface, uma integração — que pode ser instalado e registrado no bootstrap da aplicação.

---

## O que é um Bundle?

Um bundle é qualquer classe que herda de `Bundle` e implementa os hooks de ciclo de vida:

```python
from expresso_flow.bundle import Bundle


class MeuBundle(Bundle):

    async def on_startup(self, app):
        """Executado durante app.run(), antes de processar eventos."""
        print("Bundle iniciado!")

    async def on_shutdown(self, app):
        """Executado ao encerrar a aplicação (CTRL+C ou sinal de shutdown)."""
        print("Bundle encerrado!")
```

---

## Registrando um Bundle

```python
app.register_bundle(MeuBundle())
```

Múltiplos bundles são inicializados na ordem em que foram registrados.

---

## Bundles oficiais

| Pacote | Bundle | Descrição |
|--------|--------|-----------|
| `exflow-webflow` | `WebFlowBundle` | Interface web para debug e teste |
| `exflow-whatsapp` | `WhatsAppBundle` | Canal WhatsApp (via API oficial) |
| `exflow-telegram` | `TelegramBundle` | Canal Telegram (Bot API) |
| `exflow-chatweb` | `ChatWebBundle` | Widget de chat embeddable |

### Instalação

```bash
pip install --index-url https://exflow.run/simple <PACOTE>
```

---

## Criando um Bundle customizado

```python title="meu_bundle.py"
from expresso_flow.bundle import Bundle
from expresso_flow import ExpressoFlow


class DatabaseBundle(Bundle):
    """Bundle de exemplo que conecta a um banco de dados."""

    def __init__(self, url: str):
        self.url = url
        self.connection = None

    async def on_startup(self, app: ExpressoFlow):
        # Abre conexão e disponibiliza para os flows
        self.connection = await connect(self.url)
        app.state.db = self.connection  # (1)!

    async def on_shutdown(self, app: ExpressoFlow):
        if self.connection:
            await self.connection.close()
```

1. `app.state` é um namespace compartilhado acessível a partir do `ctx.app.state` dentro dos steps.

### Usando no bootstrap

```python title="main.py"
from meu_bundle import DatabaseBundle

app.register_bundle(DatabaseBundle(url="postgresql://localhost/mydb"))
```

### Acessando o estado do bundle nos steps

```python
async def buscar_usuario(self, ctx):
    db = ctx.app.state.db
    usuario = await db.fetch("SELECT * FROM users WHERE id = $1", ctx.user_id)
```

---

## Hooks disponíveis

| Hook | Assinatura | Quando é chamado |
|------|-----------|-----------------|
| `on_startup` | `async (app)` | Antes de processar qualquer evento |
| `on_shutdown` | `async (app)` | Ao encerrar a aplicação |
| `on_event` | `async (app, event)` | Para cada evento recebido (qualquer canal) |

---

## Próximos passos

- [Canais →](channels/index.md)
- [WebFlow Bundle →](../webflow/index.md)
- [Referência de API — Bundle →](../api/bundle.md)
