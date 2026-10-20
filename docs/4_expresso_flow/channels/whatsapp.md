# Canal — WhatsApp

!!! info "Pacote"
    ```bash
    pip install --index-url https://exflow.run/simple exflow-whatsapp
    ```

---

## Visão geral

O bundle `WhatsAppBundle` integra o Expresso Flow com a **API oficial do WhatsApp Business** (Cloud API). Suporta mensagens de texto, imagens, áudio, documentos, botões e listas.

---

## Configuração

```python title="main.py"
from expresso_flow import ExpressoFlow
from exflow_whatsapp import WhatsAppBundle

app = ExpressoFlow()

app.register_bundle(
    WhatsAppBundle(
        token="SEU_TOKEN_DE_ACESSO",        # Token da API do WhatsApp Business
        phone_number_id="SEU_PHONE_ID",     # ID do número de telefone
        verify_token="TOKEN_DE_VERIFICACAO", # Token de verificação do webhook
        webhook_path="/webhook/whatsapp",    # Caminho do webhook (opcional)
    )
)
```

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| `token` | `str` | Sim | Token de acesso permanente ou temporário |
| `phone_number_id` | `str` | Sim | ID do número de telefone no Meta Business |
| `verify_token` | `str` | Sim | Token de verificação do webhook |
| `webhook_path` | `str` | Não | Caminho do endpoint de webhook |

---

## Tipos de mensagem suportados

<!-- Será preenchido com a referência completa -->

!!! note "Em construção"
    Esta seção será expandida com a referência completa de tipos de mensagem e exemplos de cada um.

---

## Próximos passos

- [Telegram →](telegram.md)
- [ChatWeb →](chatweb.md)
