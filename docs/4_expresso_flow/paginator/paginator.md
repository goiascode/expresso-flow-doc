# Visão Geral

UX e Paginação Interativa: `Paginator`                      
Paginar Muitas Cidades/Unidades: `Paginator`

Canais conversacionais como o WhatsApp possuem restrições rígidas quanto à quantidade de botões e opções em listas interativas (por exemplo, listas de seleção suportam até 10 itens por mensagem). Quando um endpoint retorna dezenas de cidades, unidades de atendimento ou agendamentos, o componente `Paginator` divide a lista em páginas controladas com indicador de continuação (*load-more*).

## Import
```python
from exflow.ux import Paginator
```

## Assinatura e Parâmetros

```python
paginator: Paginator[T] = Paginator(
    page_size: int = 9,       # Quantidade de itens retornados por página (deixa 1 slot para o botão "Ver mais")
    page_threshold: int = 10, # Limite mínimo de itens para disparar a paginação
    namespace: str = ""       # Namespace opcional para segregar estados em sessão
)
```

## Métodos e propriedades

    • get_page(items: list, offset: int = 0) -> PageResult

        ◦ page.items: Lista contendo os itens fatiados para a página atual.
        ◦ page.has_next: Booleano que indica se restam itens após esta página (necessidade de botão/opção "Ver mais").
        ◦ page.next_offset: Próximo índice de deslocamento para obter a próxima página.

## Exemplos de Uso Prático

```python
import json
from exflow.flow import Flow, flow, step, StepOptions
from exflow.interaction import InteractionContext
from exflow.ux import Paginator
from exflow.execution_action import WaitUserInputAction, GoToStepFlowAction, PreviousStepFlowAction
from cin.flows.flow.cin_flow.cin_enum_steps.cin_enum_steps import CinEnumSteps

@step(CinEnumSteps.UNIDADE_LISTAR)
async def listar_unidades(self, ctx: InteractionContext, params: StepOptions):
    unidades: list = self.session.get("UNIDADES") or []
    offset: int = self.session.get("PAGINA_UNIDADES_OFFSET") or 0

    # WhatsApp permite até 10 itens em listas interativas.
    # Usamos page_size=9 para reservar 1 item para a opção 'Carregar mais'.
    paginator = Paginator(page_size=9, page_threshold=10)
    page = paginator.get_page(unidades, offset=offset)

    opcoes = []
    for item in page.items:
        opcoes.append((str(item["id"]), item["descricao"]))

    if page.has_next:
        opcoes.append(("MORE", "➡️ Ver mais unidades..."))
        self.session.set_int("PROXIMO_OFFSET", page.next_offset)
    else:
        self.session.set_int("PROXIMO_OFFSET", 0)

    await ctx.output.send_list(
        body_text="Selecione o local de atendimento:",
        button_text="Ver unidades",
        items=opcoes
    )
    return WaitUserInputAction()

@step(CinEnumSteps.UNIDADE_ESCOLHER_RESP)
async def responder_unidade(self, ctx: InteractionContext, params: StepOptions):
    escolha = ctx.message.get_selected_row_id() or ctx.message.get_text().strip()

    # Usuário solicitou carregar a próxima página
    if escolha == "MORE":
        novo_offset = self.session.get("PROXIMO_OFFSET") or 0
        self.session.set_int("PAGINA_UNIDADES_OFFSET", novo_offset)
        return GoToStepFlowAction(step=CinEnumSteps.UNIDADE_LISTAR)

    # Usuário selecionou uma unidade válida
    self.session.set_str("UNIDADE_ID", escolha)
    self.session.set_int("PAGINA_UNIDADES_OFFSET", 0)  # Reset do offset
    return GoToStepFlowAction(step=CinEnumSteps.CONFIRMAR_DADOS)
    
```