# `exflow.interaction`

```python
from exflow.interaction import InteractionContext
```

---

## `InteractionContext`

Injetado como primeiro parâmetro (`ctx`) em todos os steps. Contém acesso a mensagem, output, mídia e console.

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `ctx.message` | `Message` | Dados da mensagem recebida |
| `ctx.output` | `Output` | Envio de mensagens ao usuário |
| `ctx.media` | `Media` | Acesso a mídias recebidas |
| `ctx.console` | `Console` | Logging estruturado |

---

## `Message`

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `is_text()` | `bool` | Mensagem de texto |
| `is_voice()` | `bool` | Mensagem de voz |
| `is_audio()` | `bool` | Arquivo de áudio |
| `is_media()` | `bool` | Qualquer mídia |
| `is_interactive_reply()` | `bool` | Resposta interativa |
| `is_item(item_id?)` | `bool` | Seleção de item de lista |
| `is_button(button?)` | `bool` | Clique em botão |
| `timestamp()` | `str` | Timestamp da mensagem |
| `get_text()` | `str` | Texto da mensagem |
| `get_button_id()` | `int \| str \| None` | ID do botão clicado |
| `get_button_label()` | `str \| None` | Rótulo do botão |
| `get_item_id()` | `int \| str \| None` | ID do item selecionado |
| `get_item_label()` | `str \| None` | Rótulo do item |
| `get_media_url()` | `str \| None` | URL da mídia |
| `get_media_caption()` | `str \| None` | Legenda da mídia |

---

## `Output`

Todos os métodos são `async`. Variantes `reply_*` aceitam `reply_to: str`.

| Método | Descrição |
|--------|-----------|
| `send_text(text)` | Texto |
| `send_buttons(body_text, buttons, on_select?)` | Botões |
| `send_list(body_text, items, action_title?, on_select?)` | Lista |
| `send_url_button(body_text, display_text, url)` | Botão de link |
| `send_image(media_url, caption?)` | Imagem |
| `send_audio(media_url)` | Áudio |
| `send_video(media_url, caption?)` | Vídeo |
| `send_document(media_url, caption?, filename?)` | Documento |
| `send_carousel_quick_reply(body_text, cards, header_type?)` | Carrossel com botões |
| `send_carousel_url(body_text, cards, header_type?)` | Carrossel com URL |
| `send(builder)` | Builder avançado |

---

## `Media`

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `get_type()` | `str \| None` | Tipo MIME |
| `get_size()` | `int \| None` | Tamanho em bytes |
| `get_path(content_type, ttl=120)` | `str \| None` | URL temporária |

---

## `Console`

| Método | Descrição |
|--------|-----------|
| `log(message)` | Log genérico |
| `info(message)` | Informação |
| `warning(message)` | Aviso |
| `error(message)` | Erro |
| `exception(message, level?, exc?)` | Exceção com nível configurável |

Consulte a [documentação completa do InteractionContext →](../core/steps.md)
