# Message

`ctx.message` fornece acesso a todos os dados da mensagem enviada pelo usuário dentro de um step.

---

## Verificação de tipo

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `is_text()` | `bool` | Mensagem de texto simples |
| `is_voice()` | `bool` | Mensagem de voz |
| `is_audio()` | `bool` | Arquivo de áudio |
| `is_media()` | `bool` | Qualquer tipo de mídia |
| `is_interactive_reply()` | `bool` | Resposta a uma mensagem interativa |
| `is_item(item_id?)` | `bool` | Seleção de item de lista |
| `is_button(button?)` | `bool` | Clique em botão |

---

## Leitura de conteúdo

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `timestamp()` | `str` | Timestamp da mensagem |
| `get_text()` | `str` | Texto da mensagem |
| `get_button_id()` | `int \| str \| None` | ID do botão clicado |
| `get_button_label()` | `str \| None` | Rótulo do botão clicado |
| `get_item_id()` | `int \| str \| None` | ID do item de lista selecionado |
| `get_item_label()` | `str \| None` | Rótulo do item de lista selecionado |
| `get_media_url()` | `str \| None` | URL da mídia recebida |
| `get_media_caption()` | `str \| None` | Legenda da mídia recebida |

---

## Exemplo

```python title="app/flows/mensagem/mensagem_flow.py"
from exflow.flow import Flow, StepOptions, step, flow
from exflow.interaction import InteractionContext
from exflow.execution_action import CompletedFlowAction, WaitUserInputAction


@flow()
class MensagemFlow(Flow):
    """Flow que demonstra o uso de ctx.message para diferentes tipos de entrada."""

    id = "mensagem_flow"
    name = "Demonstração de Message"

    @step(order=0, label="Aguardar entrada", description="Aguarda qualquer tipo de mensagem do usuário")
    async def aguardar(self, ctx: InteractionContext, options: StepOptions):
        await ctx.output.send_text("Envie uma mensagem, botão ou item de lista.")
        return WaitUserInputAction()

    @step(order=1, label="Processar entrada", description="Identifica o tipo da mensagem e extrai o conteúdo")
    async def processar(self, ctx: InteractionContext, options: StepOptions):
        if ctx.message.is_text():
            conteudo = ctx.message.get_text()
            await ctx.output.send_text(f"Texto recebido: {conteudo}")

        elif ctx.message.is_button():
            btn_label = ctx.message.get_button_label()
            btn_id = ctx.message.get_button_id()
            await ctx.output.send_text(f"Botão clicado: {btn_label} (id={btn_id})")

        elif ctx.message.is_item():
            item_label = ctx.message.get_item_label()
            item_id = ctx.message.get_item_id()
            await ctx.output.send_text(f"Item selecionado: {item_label} (id={item_id})")

        elif ctx.message.is_media():
            url = ctx.message.get_media_url()
            await ctx.output.send_text(f"Mídia recebida: {url}")

        return CompletedFlowAction()
```
