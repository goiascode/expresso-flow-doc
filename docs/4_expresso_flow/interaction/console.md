# Console

`ctx.console` é a interface de logging estruturado dentro de um step. As mensagens são exibidas no terminal e no painel de debug do **WebFlow**.

---

## Métodos

| Método | Descrição |
|--------|-----------|
| `log(message)` | Log genérico |
| `info(message)` | Informação |
| `warning(message)` | Aviso |
| `error(message)` | Erro |
| `exception(message, level?, exc?)` | Loga uma exceção com nível configurável (`"error"` por padrão) |

---

## Exemplo

```python title="app/flows/calculo/calculo_flow.py"
from exflow.flow import Flow, StepOptions, step, flow
from exflow.interaction import InteractionContext
from exflow.execution_action import CompletedFlowAction, WaitUserInputAction


@flow()
class CalculoFlow(Flow):
    """Flow que solicita um número e retorna o dobro, demonstrando ctx.console."""

    id = "calculo_flow"
    name = "Cálculo com Console"

    @step(order=0, label="Solicitar número", description="Solicita um valor numérico ao usuário")
    async def solicitar(self, ctx: InteractionContext, options: StepOptions):
        ctx.console.info("Iniciando flow de cálculo")
        await ctx.output.send_text("Digite um número:")
        return WaitUserInputAction()

    @step(order=1, label="Calcular", description="Converte a entrada para número e retorna o dobro")
    async def calcular(self, ctx: InteractionContext, options: StepOptions):
        entrada = ctx.message.get_text()
        ctx.console.log(f"Entrada recebida: {entrada}")

        try:
            numero = int(entrada)
            ctx.console.info(f"Número válido: {numero}")
            await ctx.output.send_text(f"O dobro de {numero} é {numero * 2}.")
        except ValueError:
            ctx.console.warning(f"Entrada inválida: '{entrada}' não é um número")
            await ctx.output.send_text("Isso não é um número válido.")
        except Exception as e:
            ctx.console.exception("Erro inesperado ao processar entrada", exc=e)
            await ctx.output.send_text("Ocorreu um erro inesperado.")

        return CompletedFlowAction()
```
