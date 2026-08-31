# Message

`ctx.message` fornece acesso a todos os dados da mensagem enviada pelo usuário dentro de um step.

```python
from exflow.interaction import InteractionContext

async def meu_step(self, ctx: InteractionContext, options):
    if ctx.message.is_text():
        texto = ctx.message.get_text()
```

---

## Verificação de tipo

| Método | Retorno | Descrição |
|--------|---------|----------|
| `is_text()` | `bool` | Mensagem de texto simples |
| `is_voice()` | `bool` | Mensagem de voz |
| `is_audio()` | `bool` | Arquivo de áudio |
| `is_media()` | `bool` | Qualquer tipo de mídia |
| `is_interactive_reply()` | `bool` | Resposta a uma mensagem interativa |
| `is_item(item_id?)` | `bool` | Seleção de item de lista |
| `is_button(button?)` | `bool` | Clique em botão |

```python
if ctx.message.is_text():
    texto = ctx.message.get_text()
elif ctx.message.is_button():
    btn_id = ctx.message.get_button_id()
elif ctx.message.is_item():
    item_id = ctx.message.get_item_id()
```

---

## Leitura de conteúdo

| Método | Retorno | Descrição |
|--------|---------|----------|
| `timestamp()` | `str` | Timestamp da mensagem |
| `get_text()` | `str` | Texto da mensagem |
| `get_button_id()` | `int \| str \| None` | ID do botão clicado |
| `get_button_label()` | `str \| None` | Rótulo do botão clicado |
| `get_item_id()` | `int \| str \| None` | ID do item de lista selecionado |
| `get_item_label()` | `str \| None` | Rótulo do item de lista selecionado |
| `get_media_url()` | `str \| None` | URL da mídia recebida |
| `get_media_caption()` | `str \| None` | Legenda da mídia recebida |
