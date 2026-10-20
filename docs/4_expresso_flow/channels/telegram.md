# Canal — Telegram

!!! info "Pacote"
    ```bash
    pip install --index-url https://exflow.run/simple exflow-telegram
    ```

---

## Visão geral

O bundle `TelegramBundle` integra o Expresso Flow com a **Telegram Bot API**. Suporta os modos **polling** (desenvolvimento) e **webhook** (produção).

---

## Configuração

```python title="main.py"
from expresso_flow import ExpressoFlow
from exflow_telegram import TelegramBundle

app = ExpressoFlow()

app.register_bundle(
    TelegramBundle(
        token="SEU_BOT_TOKEN",   # Token fornecido pelo @BotFather
        mode="polling",          # "polling" ou "webhook"
    )
)
```

| Parâmetro | Tipo | Padrão | Descrição |
|-----------|------|--------|-----------|
| `token` | `str` | — | Token do bot (fornecido pelo @BotFather) |
| `mode` | `str` | `"polling"` | Modo de recebimento de mensagens |
| `webhook_url` | `str \| None` | `None` | URL do webhook (obrigatório se `mode="webhook"`) |
| `webhook_path` | `str` | `"/webhook/telegram"` | Caminho do endpoint de webhook |

---

## Tipos de mensagem suportados

<!-- Será preenchido com a referência completa -->

!!! note "Em construção"
    Esta seção será expandida com a referência completa de tipos de mensagem e exemplos de cada um.

---

## Próximos passos

- [WhatsApp →](whatsapp.md)
- [ChatWeb →](chatweb.md)
