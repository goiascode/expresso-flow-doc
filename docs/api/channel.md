# `expresso_flow.channel`

```python
from expresso_flow.channel import Channel, ChannelEvent
```

---

## `Channel`

Classe base para implementação de canais customizados.

!!! note "Em construção"
    Documentação completa em elaboração.

---

## `ChannelEvent`

Representa um evento normalizado recebido de qualquer canal.

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `user_id` | `str` | Identificador do usuário no canal |
| `channel` | `str` | Nome do canal de origem |
| `text` | `str \| None` | Texto da mensagem, se houver |
| `type` | `str` | Tipo do evento (`text`, `image`, `audio`, etc.) |
| `raw` | `Any` | Payload bruto do canal original |

!!! note "Em construção"
    Documentação completa em elaboração.
