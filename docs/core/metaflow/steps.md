# Steps

O MetaFlow oferece três tipos de step: decoradores de ciclo de vida (`@start_step`, `@end_step`) e steps customizados por campo (`FieldFlowStep`).

---

## `@start_step(order?)`

Executado **uma vez** antes do loop de campos. Use para enviar mensagens de boas-vindas ou preparar o contexto.

```python
from exflow.metaflow import start_step
from exflow.interaction import InteractionContext


@start_step()
async def bem_vindo(self, ctx: InteractionContext, *args, **kwargs):
    await ctx.output.send_text(
        "Bem-vindo ao fluxo de cadastro!\n"
        "Forneça o nome, email e telefone."
    )
```

| Parâmetro | Tipo | Padrão | Descrição |
|-----------|------|--------|-----------|
| `order` | `int` | `0` | Ordem de execução quando há múltiplos `@start_step` |

---

## `@end_step(order?)`

Executado **uma vez** após todos os campos serem preenchidos. Use para confirmar o cadastro, salvar em banco ou enviar notificações.

```python
from exflow.metaflow import end_step
from exflow.interaction import InteractionContext


@end_step()
async def finalizar(self, ctx: InteractionContext, *args, **kwargs):
    usuario = self.state.model
    await ctx.output.send_text(
        f"✅ Cadastro concluído!\n"
        f"Nome: {usuario.nome}\n"
        f"Email: {usuario.email}"
    )
```

| Parâmetro | Tipo | Padrão | Descrição |
|-----------|------|--------|-----------|
| `order` | `int` | `0` | Ordem de execução quando há múltiplos `@end_step` |

---

## `FieldFlowStep`

Substitui o comportamento padrão de pergunta para um campo específico. Use quando a coleta de um campo exige interação mais rica — como uma lista paginada, um carrossel ou validação de UI personalizada.

```python
from exflow.metaflow import FieldFlowStep
from exflow.flow import StepOptions, FlowDirection
from exflow.interaction import InteractionContext
from exflow.execution_action import ListenUserInputAction, NextStepFlowAction
from exflow.ux import PageList

from app.metaflows.usuario.datasources.cidade_datasource import CidadeDatasource
from app.metaflows.usuario.fields.cidade_field import CidadeField


class CidadeStep(FieldFlowStep):
    """
    Step para seleção de cidade via lista paginada.
    """
    field = CidadeField()   # associa ao campo pelo tipo

    def __init__(self):
        self._datasource = CidadeDatasource()
        self._pagelist = PageList(
            namespace="usuarios",
            datasource=self._datasource,
            message="Selecione uma cidade para continuar.",
        )
        super().__init__()

    async def execute(self, ctx: InteractionContext, options: StepOptions):
        # Seleção via item de lista ou botão
        if ctx.message.is_item():
            if self._datasource.exists(context=ctx, id=ctx.message.get_item_id(), label=ctx.message.get_item_label()):
                return NextStepFlowAction()

        if ctx.message.is_button():
            if self._datasource.exists(context=ctx, id=ctx.message.get_button_id(), label=ctx.message.get_button_label()):
                return NextStepFlowAction()

        # Paginação
        if self._pagelist.is_next_page(ctx):
            await self._pagelist.next_page(ctx)
            return ListenUserInputAction()

        if self._pagelist.is_prev_page(ctx):
            await self._pagelist.prev_page(ctx)
            return ListenUserInputAction()

        # Reexibição ao voltar (REWIND)
        if options.direction == FlowDirection.REWIND:
            await self._pagelist.current_page(ctx, message="Você precisa selecionar uma cidade.")
            return ListenUserInputAction()

        await self._pagelist.first_page(ctx)
        return ListenUserInputAction()
```

### Atributos obrigatórios

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `field` | `Field` | Instância do campo que este step substitui |

### Registrando no MetaFlow

```python
from exflow.flow import flow
from exflow.metaflow import MetaFlow
from exflow.llm import LLMProvider

from app.metaflows.usuario.models.usuario_model import UsuarioModel
from app.metaflows.usuario.fields.cidade_field import CidadeField
from app.metaflows.usuario.fields.nome_field import NomeField
from app.metaflows.usuario.steps.cidade_step import CidadeStep


@flow()
class UsuarioFlow(MetaFlow):
    """Fluxo de cadastro de usuário."""

    id = "usuario_flow"
    name = "Cadastro de Usuário"

    def __init__(self, provider: LLMProvider):
        super().__init__(provider=provider)

    def create_model(self):
        return UsuarioModel()

    def load_fields(self):
        return [CidadeField(), NomeField()]

    def load_field_steps(self):  # (1)!
        return [
            CidadeStep(),
        ]
```

1. O engine associa o `CidadeStep` ao `CidadeField` pelo tipo da instância em `field`. Quando o loop chega na cidade, executa o step customizado.

!!! info "Correspondência por tipo"
    O engine associa o `FieldFlowStep` ao campo pelo **tipo** da instância em `field`. Quando o loop chega naquele campo, executa o step customizado em vez da pergunta padrão.
