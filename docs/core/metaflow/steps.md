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

## FieldFlowStep
Substitui o comportamento padrão de pergunta para um campo específico. Use quando a coleta de um campo exige interação mais rica — como uma lista paginada, um carrossel ou validação de UI personalizada.(`CidadeStep`)

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
    field = CidadeField()   # Associa o Step ao campo pelo tipo

    def __init__(self):
        self._datasource = CidadeDatasource()
        self._pagelist = PageList(
            namespace="usuarios",
            datasource=self._datasource,
            message="Selecione uma cidade para continuar.",
        )
        super().__init__()

    async def execute(self, ctx: InteractionContext, options: StepOptions):
        # 1. Seleção via item de lista interativa
        if ctx.message.is_item():
            if self._datasource.exists(context=ctx, id=ctx.message.get_item_id(), label=ctx.message.get_item_label()):
                return NextStepFlowAction()

        # 2. Seleção via botão interativo
        if ctx.message.is_button():
            if self._datasource.exists(context=ctx, id=ctx.message.get_button_id(), label=ctx.message.get_button_label()):
                return NextStepFlowAction()

        # 3. Navegação da Paginação (Próxima Página)
        if self._pagelist.is_next_page(ctx):
            await self._pagelist.next_page(ctx)
            return ListenUserInputAction()

        # 4. Navegação da Paginação (Página Anterior)
        if self._pagelist.is_prev_page(ctx):
            await self._pagelist.prev_page(ctx)
            return ListenUserInputAction()

        # 5. Reexibição ao voltar no fluxo (REWIND)
        if options.direction == FlowDirection.REWIND:
            await self._pagelist.current_page(ctx, message="Você precisa selecionar uma cidade.")
            return ListenUserInputAction()

        # 6. Exibição inicial (Primeira Página)
        await self._pagelist.first_page(ctx)
        return ListenUserInputAction()
```
```python
from exflow.metaflow import Field
from app.metaflows.usuario.models.user_model import UserModel

class CidadeField(Field[UserModel]):
    """
    Campo para seleção de cidade do usuario.
    """

    name = "cidade"
    priority = 13
    question = "Selecione uma cidade para continuar."
    validation_error_message = "Falha ao verificar Cidade."
```

## Atributos obrigatórios
---
| **Atributo** | **Tipo** | **Descrição**                               |
| ------------ | -------- | ------------------------------------------- |
| `field`      | `Field`  | Instância do campo que este step substitui. |
---

## Registrando no MetaFlow

Registrando:
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

    def load_field_steps(self):
        return [
            CidadeStep(),
        ]
```
---

## Detalhamento das Responsabilidades

### Associação com o Campo (`field`)
* **`field = CidadeField()`**: Associa diretamente o Step ao campo correspondente do modelo (`UserModel.cidade`). Isso garante que a resposta validada seja vinculada ao estado do fluxo.

### Inicialização (`__init__`)
* **`CidadeDatasource`**: Provedor dos dados das cidades (disponibiliza os itens no formato `ListItem`).
* **`PageList`**: Gerenciador da experiência de usuário (UX) responsável por:
  * Manter o estado da página atual por usuário (`namespace="usuarios"`).
  * Renderizar os botões/listas interativas no WhatsApp/Chatbot.
  * Formatar mensagens de navegação (*Ver mais*, *Voltar*).

---

## Fluxo de Execução do Método `execute()`

O método `execute` opera como uma **máquina de estados**, avaliando a interação do usuário na seguinte ordem:

```
                    📩 MENSAGEM RECEBIDA
                            │
                            ▼
                 ┌──────────────────────┐
                 │ É uma opção da lista │
                 │     ou um botão?     │
                 └──────────┬───────────┘
                       SIM  │  NÃO
                            │
              ┌─────────────┘
              ▼
       ┌──────────────────┐
       │ Está no          │
       │ CidadeDatasource?│
       └───────┬──────────┘
          SIM  │  NÃO
               │
               ▼
      ┌─────────────────┐       ┌───────────────────┐
      │ NextStepFlow    │       │ Continuar fluxo   │
      │ Action          │       │ normalmente       │
      └─────────────────┘       └───────────────────┘


              NÃO ──────────────────────────────┐
                                                ▼
                                  ┌────────────────────────┐
                                  │ É comando de paginação?│
                                  └───────────┬────────────┘
                                         SIM │ NÃO
                                             │
                                             ▼
                                  ┌─────────────────────┐
                                  │ Qual a direção?     │
                                  └──────────┬──────────┘
                                             │
                              ┌──────────────┴──────────────┐
                              ▼                             ▼
                         ◀ REWIND                       AVANÇAR ▶
                              │                             │
                              ▼                             ▼
                     Página atual                    Próxima página
                              │                             │
                              └──────────────┬──────────────┘
                                             ▼
                                  🔄 Renderizar resultado
```

### A. Validação de Seleção (`is_item` / `is_button`)
* Se o usuário clicou em um item da lista (`ctx.message.is_item()`) ou em um botão (`ctx.message.is_button()`):
  * O método `_datasource.exists()` verifica se o ID e Label correspondem a uma cidade válida.
  * Se for válida, retorna **`NextStepFlowAction()`**, avançando para a próxima etapa do fluxo.

### B. Navegação de Páginas (`is_next_page` / `is_prev_page`)
* **`is_next_page(ctx)`**: Identifica se o usuário clicou em *"Ver mais ➔"*. Executa `await self._pagelist.next_page(ctx)` e aguarda novo input (**`ListenUserInputAction()`**).
* **`is_prev_page(ctx)`**: Identifica se o usuário clicou em *"⬅ Voltar"*. Executa `await self._pagelist.prev_page(ctx)` e aguarda novo input (**`ListenUserInputAction()`**).

### C. Suporte a Rebobinamento / Voltar Passo (`REWIND`)
* Quando o usuário retorna a este passo no fluxo (`options.direction == FlowDirection.REWIND`), o Step reexibe a página onde o usuário estava (`current_page`) acompanhada de uma mensagem de orientação.

### D. Renderização Inicial (`first_page`)
* Caso seja o primeiro acesso ao Step, `await self._pagelist.first_page(ctx)` exibe a primeira página da lista de cidades e retorna **`ListenUserInputAction()`** para aguardar a interação do usuário.

### Vantagens desta Abordagem
1. **Desacoplamento**: O `CidadeStep` é o único responsável pela lógica de paginação e interação UX.
2. **Reaproveitamento de Estado**: O `PageList` gerencia automaticamente os offsets de página do usuário sem poluir o modelo de dados.
3. **Resiliência de Navegação**: Suporta navegação para frente, para trás e reinício de contexto (REWIND) de forma nativa.
