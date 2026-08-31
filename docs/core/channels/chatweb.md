# Canal — ChatWeb

!!! info "Pacote"
    ```bash
    pip install --index-url https://exflow.run/simple exflow-chatweb
    ```

---

## Visão geral

O bundle `ChatWebBundle` disponibiliza um **widget de chat embeddable** que pode ser inserido em qualquer site ou aplicação web. A comunicação entre o widget e o Expresso Flow é feita via WebSocket.

---

## Configuração

```python title="main.py"
from expresso_flow import ExpressoFlow
from exflow_chatweb import ChatWebBundle

app = ExpressoFlow()

app.register_bundle(
    ChatWebBundle(
        port=8800,                     # Porta do servidor WebSocket
        cors_origins=["*"],            # Origens permitidas (CORS)
        default_flow="atendimento",    # Flow inicial para novos usuários
    )
)
```

| Parâmetro | Tipo | Padrão | Descrição |
|-----------|------|--------|-----------|
| `port` | `int` | `8800` | Porta do servidor WebSocket |
| `cors_origins` | `list[str]` | `["*"]` | Origens CORS permitidas |
| `default_flow` | `str \| None` | `None` | Slug do flow padrão para novos usuários |

---

## Tipos de mensagem suportados

<!-- Será preenchido com a referência completa -->

!!! note "Em construção"
    Esta seção será expandida com instruções de embedding, customização do widget e referência completa.

---

## Próximos passos

- [WhatsApp →](whatsapp.md)
- [Telegram →](telegram.md)
