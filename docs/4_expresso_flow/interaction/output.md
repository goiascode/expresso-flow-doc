# Output

`ctx.output` envia mensagens ao usuário dentro de um step. Todos os métodos são `async`. Cada tipo possui uma variante `send_*` (envia normalmente) e `reply_*` (responde a uma mensagem específica via `reply_to`).

---

## Métodos disponíveis

### Texto
| Método | Descrição |
|--------|-----------|
| `send_text(text)` | Envia texto |
| `reply_text(text, reply_to?)` | Responde com texto |

### Botões
| Método | Descrição |
|--------|-----------|
| `send_buttons(body_text, buttons, on_select?)` | Envia mensagem com botões |
| `reply_buttons(body_text, buttons, on_select?, reply_to?)` | Responde com botões |

### Lista
| Método | Descrição |
|--------|-----------|
| `send_list(body_text, items, action_title?, on_select?)` | Envia lista de seleção |
| `reply_list(body_text, items, action_title?, reply_to?, on_select?)` | Responde com lista |

### URL Button
| Método | Descrição |
|--------|-----------|
| `send_url_button(body_text, display_text, url)` | Envia botão de link |
| `reply_url_button(body_text, display_text, url, reply_to?)` | Responde com botão de link |

### Mídia
| Método | Descrição |
|--------|-----------|
| `send_image(media_url, caption?)` | Envia imagem |
| `send_audio(media_url)` | Envia áudio |
| `send_video(media_url, caption?)` | Envia vídeo |
| `send_document(media_url, caption?, filename?)` | Envia documento |

### Carrossel
| Método | Descrição |
|--------|-----------|
| `send_carousel_quick_reply(body_text, cards, header_type?)` | Carrossel com botões de resposta rápida |
| `send_carousel_url(body_text, cards, header_type?)` | Carrossel com botões de URL |

---

## Exemplo

```python title="app/flows/menu/menu_flow.py"
from exflow.flow import Flow, StepOptions, step, flow
from exflow.interaction import InteractionContext
from exflow.execution_action import CompletedFlowAction, WaitUserInputAction


@flow()
class MenuFlow(Flow):
    """Flow de menu principal que demonstra os principais tipos de output."""

    id = "menu_flow"
    name = "Menu Principal"

    @step(order=0, label="Exibir menu", description="Exibe as opções do menu principal com botões")
    async def menu(self, ctx: InteractionContext, options: StepOptions):
        await ctx.output.send_buttons(
            body_text="Como posso te ajudar?",
            buttons=[
                ("btn_info", "Informações"),
                ("btn_doc", "Documentos"),
                ("btn_link", "Site"),
            ]
        )
        return WaitUserInputAction()

    @step(order=1, label="Responder opção", description="Responde conforme a opção selecionada no menu")
    async def responder(self, ctx: InteractionContext, options: StepOptions):
        btn_id = ctx.message.get_button_id()

        if btn_id == "btn_info":
            await ctx.output.send_text("ℹ️ Aqui estão as informações solicitadas.")

        elif btn_id == "btn_doc":
            await ctx.output.send_document(
                "https://exemplo.com/manual.pdf",
                filename="manual.pdf",
                caption="Manual do usuário",
            )

        elif btn_id == "btn_link":
            await ctx.output.send_url_button(
                body_text="Acesse nossa página:",
                display_text="Acessar site",
                url="https://exflow.run",
            )

        return CompletedFlowAction()
```
