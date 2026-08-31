# Exemplo completo

Implementação de um MetaFlow completo para cadastro de usuário, cobrindo todas as camadas: flow, model, fields, validators, resolvers e steps.

---

## Flow principal

```python title="app/metaflows/usuario/usuario_flow.py"
from exflow.flow import flow
from exflow.interaction import InteractionContext
from exflow.metaflow import MetaFlow, start_step, end_step
from exflow.llm import LLMProvider

from app.metaflows.usuario.models.usuario_model import UsuarioModel
from app.metaflows.usuario.fields.nome_field import NomeField
from app.metaflows.usuario.fields.email_field import EmailField
from app.metaflows.usuario.fields.telefone_field import TelefoneField
from app.metaflows.usuario.fields.cidade_field import CidadeField
from app.metaflows.usuario.steps.cidade_step import CidadeStep
from app.metaflows.usuario.validators.email_validator import EmailValidator
from app.metaflows.usuario.validators.telefone_validator import TelefoneValidator
from app.metaflows.usuario.resolvers.telefone_resolver import TelefoneResolver


@flow()
class AdicionaUsuarioFlow(MetaFlow):
    """
    Fluxo para adicionar um novo usuário ao sistema.
    """

    id = "adiciona_usuario_flow"
    name = "Adiciona Usuário Flow"

    def __init__(self, provider: LLMProvider):
        super().__init__(provider=provider)

    @start_step()
    async def bem_vindo(self, ctx: InteractionContext, *args, **kwargs):
        await ctx.output.send_text(
            "Bem-vindo ao fluxo de adição de usuário!\n"
            "Vamos começar.\n"
            "Forneça o nome, email e telefone do usuário."
        )

    @end_step()
    async def finalizar(self, ctx: InteractionContext, *args, **kwargs):
        user: UsuarioModel = self.state.model
        await ctx.output.send_text(
            f"✅ Usuário adicionado com sucesso!\n"
            f"Nome: {user.nome}\n"
            f"Email: {user.email}\n"
            f"Telefone: {user.telefone}\n"
        )

    def create_model(self):
        return UsuarioModel()

    def load_fields(self):
        return [
            CidadeField(),
            NomeField(),
            EmailField(),
            TelefoneField(),
        ]

    def load_validators(self):
        return [EmailValidator(), TelefoneValidator()]

    def load_resolvers(self):
        return [TelefoneResolver()]

    def load_field_steps(self):
        return [CidadeStep()]
```

---

## Model

```python title="app/metaflows/usuario/models/usuario_model.py"
from dataclasses import dataclass
from exflow.metaflow import Model


@dataclass
class UsuarioModel(Model):
    """Modelo de dados que representa um usuário no sistema."""

    nome: str | None = None
    email: str | None = None
    telefone: str | None = None
    cidade: str | None = None
    telefone_id: int | None = None
```

---

## Fields

```python title="app/metaflows/usuario/fields/nome_field.py"
from exflow.metaflow import Field
from app.metaflows.usuario.models.usuario_model import UsuarioModel


class NomeField(Field[UsuarioModel]):
    """Campo que representa o nome do usuário."""
    name = "nome"
    priority = 4
    question = "Qual é o nome do usuário?"
    validation_error_message = "O nome não pode estar vazio."
```

```python title="app/metaflows/usuario/fields/telefone_field.py"
from exflow.metaflow import Field
from app.metaflows.usuario.models.usuario_model import UsuarioModel


class TelefoneField(Field[UsuarioModel]):
    """Campo que representa o telefone do usuário."""
    name = "telefone"
    priority = 3
    question = "Qual é o telefone do usuário?"
    validation_error_message = "O telefone não é válido."

    def apply(self, model: UsuarioModel) -> None:
        model.telefone_id = self.value.metadata["id"]
        model.telefone = self.value.metadata["telefone"]
```

---

## Validator

```python title="app/metaflows/usuario/validators/email_validator.py"
import re
from exflow.interaction import InteractionContext
from exflow.metaflow import Field, FieldValidator
from app.metaflows.usuario.fields.email_field import EmailField


class EmailValidator(FieldValidator):
    field = EmailField

    async def validate(self, context: InteractionContext, field: Field) -> bool:
        email_regex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return bool(re.match(email_regex, field.value.raw))
```

---

## Resolver

```python title="app/metaflows/usuario/resolvers/telefone_resolver.py"
from exflow.metaflow import FieldResolver
from exflow.interaction import InteractionContext
from app.metaflows.usuario.fields.telefone_field import TelefoneField


class TelefoneResolver(FieldResolver):
    field = TelefoneField

    async def resolve(self, context: InteractionContext, field: TelefoneField) -> str:
        field.value.metadata = {
            "id": 200,
            "telefone": field.value.raw,
        }
```

---

## FieldFlowStep (Cidade)

```python title="app/metaflows/usuario/steps/cidade_step.py"
from exflow.flow import StepOptions, FlowDirection
from exflow.metaflow import FieldFlowStep
from exflow.interaction import InteractionContext
from exflow.execution_action import ListenUserInputAction, NextStepFlowAction
from exflow.ux import PageList

from app.metaflows.usuario.datasources.cidade_datasource import CidadeDatasource
from app.metaflows.usuario.fields.cidade_field import CidadeField


class CidadeStep(FieldFlowStep):
    """Step para seleção de cidade via lista paginada."""
    field = CidadeField()

    def __init__(self):
        self._datasource = CidadeDatasource()
        self._pagelist = PageList(
            namespace="usuarios",
            datasource=self._datasource,
            message="Selecione uma cidade para continuar.",
        )
        super().__init__()

    async def execute(self, ctx: InteractionContext, options: StepOptions):
        if ctx.message.is_item():
            if self._datasource.exists(context=ctx, id=ctx.message.get_item_id(), label=ctx.message.get_item_label()):
                return NextStepFlowAction()

        if ctx.message.is_button():
            if self._datasource.exists(context=ctx, id=ctx.message.get_button_id(), label=ctx.message.get_button_label()):
                return NextStepFlowAction()

        if self._pagelist.is_next_page(ctx):
            await self._pagelist.next_page(ctx)
            return ListenUserInputAction()

        if self._pagelist.is_prev_page(ctx):
            await self._pagelist.prev_page(ctx)
            return ListenUserInputAction()

        if options.direction == FlowDirection.REWIND:
            await self._pagelist.current_page(ctx, message="Você precisa selecionar uma cidade.")
            return ListenUserInputAction()

        await self._pagelist.first_page(ctx)
        return ListenUserInputAction()
```
