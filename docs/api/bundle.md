# `expresso_flow.bundle`

```python
from expresso_flow.bundle import Bundle
```

---

## `Bundle`

Classe base para todos os bundles do Expresso Flow.

### Hooks

| Hook | Assinatura | Descrição |
|------|-----------|-----------|
| `on_startup` | `async (app: ExpressoFlow) -> None` | Inicialização do bundle |
| `on_shutdown` | `async (app: ExpressoFlow) -> None` | Encerramento gracioso |
| `on_event` | `async (app, event: ChannelEvent) -> None` | Interceptação de eventos |

!!! note "Em construção"
    Documentação completa em elaboração.
