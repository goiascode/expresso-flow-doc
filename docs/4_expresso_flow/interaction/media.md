# Media

`ctx.media` permite obter informações e acessar o conteúdo de mídias recebidas pelo usuário.

---

## Métodos

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `get_type()` | `str \| None` | Tipo MIME da mídia (ex: `"image/jpeg"`) |
| `get_size()` | `int \| None` | Tamanho em bytes |
| `get_path(content_type, ttl?)` | `str \| None` | URL/caminho temporário. `ttl` define o tempo de vida em segundos (padrão: `120`) |

---

## Exemplo

```python title="app/flows/imagem/imagem_flow.py"
from exflow.flow import Flow, StepOptions, step, flow
from exflow.interaction import InteractionContext
from exflow.media import MediaContentType
from exflow.execution_action import CompletedFlowAction, WaitUserInputAction


@flow()
class ImagemFlow(Flow):
    """Flow que recebe uma imagem do usuário e exibe suas informações de metadados."""

    id = "imagem_flow"
    name = "Recebimento de Imagem"

    @step(order=0, label="Solicitar imagem", description="Pede ao usuário que envie uma imagem")
    async def solicitar(self, ctx: InteractionContext, options: StepOptions):
        await ctx.output.send_text("Por favor, envie uma imagem.")
        return WaitUserInputAction()

    @step(order=1, label="Processar mídia", description="Lê os metadados da imagem recebida e confirma o recebimento")
    async def processar(self, ctx: InteractionContext, options: StepOptions):
        if not ctx.message.is_media():
            await ctx.output.send_text("Isso não é uma mídia. Por favor, envie uma imagem.")
            return WaitUserInputAction()

        tipo = await ctx.media.get_type()
        tamanho = await ctx.media.get_size()
        caminho = await ctx.media.get_path(MediaContentType.IMAGE, ttl=300)

        ctx.console.info(f"Mídia recebida: {tipo} ({tamanho} bytes)")

        await ctx.output.send_text(
            f"✅ Imagem recebida!\n"
            f"Tipo: {tipo}\n"
            f"Tamanho: {tamanho} bytes"
        )
        return CompletedFlowAction()
```
