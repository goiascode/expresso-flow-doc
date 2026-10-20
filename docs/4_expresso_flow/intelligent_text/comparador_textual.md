## Comparar Texto Aproximado do Usuário:                 
`FuzzyMatcher`

## Processamento de Texto e Comparação Aproximada:              
`FuzzyMatcher`

## Visão Geral
Em canais de mensagens de texto, usuários frequentemente cometem erros de digitação, omitem acentos ou utilizam abreviações ao informar nomes de cidades, bairros ou opções de menu (ex.: `"goiania"`, `"Goiania"`, `"goiânia"`, `"ap de goiania"`).

O `FuzzyMatcher` calcula o grau de similaridade (score de 0.0 a 1.0) entre o texto digitado e as opções disponíveis, permitindo identificar com precisão a intenção do usuário sem depender de correspondência exata de strings.

## Import

```python
from exflow.matching import FuzzyMatcher, TextMatcherBuilder
```

## Utilização Direta (FuzzyMatcher)
O método score(query, candidate) é assíncrono e retorna um valor entre 0.0 e 1.0:

```python
import asyncio
from exflow.matching import FuzzyMatcher

async def validar_opcao():
    matcher = FuzzyMatcher()
    
    score1 = await matcher.score("goiania", "Goiânia")
    print(score1) # 0.714 (~71% similaridade)
    
    score2 = await matcher.score("aparecida goiania", "Aparecida de Goiânia")
    print(score2) # 0.700 (~70% similaridade)
```

## Utilização Integrada com TextMatcherBuilder

O framework permite combinar normalização, fuzzy e threshold em um motor único de correspondência:

```python
from exflow.matching import TextMatcherBuilder

matcher = (
    TextMatcherBuilder()
    .with_fuzzy()
    .with_threshold(0.70) # Considera correspondência se score >= 70%
    .build()
)
```

## Exemplo de Uso Prático em Seleção de Cidades

```python
from exflow.flow import Flow, flow, step, StepOptions
from exflow.interaction import InteractionContext
from exflow.matching import FuzzyMatcher
from exflow.execution_action import GoToStepFlowAction, PreviousStepFlowAction
from cin.flows.flow.cin_flow.cin_enum_steps.cin_enum_steps import CinEnumSteps

CIDADES_VALIDAS = [
    {"id": 52, "nome": "Goiânia"},
    {"id": 53, "nome": "Aparecida de Goiânia"},
    {"id": 54, "nome": "Rio Verde"},
    {"id": 55, "nome": "Anápolis"},
]

@step(CinEnumSteps.MUNICIPIO_VALIDAR_RESP)
async def validar_municipio_aproximado(self, ctx: InteractionContext, params: StepOptions):
    texto_usuario = ctx.message.get_text().strip()
    matcher = FuzzyMatcher()

    melhor_opcao = None
    maior_score = 0.0

    for cidade in CIDADES_VALIDAS:
        pontuacao = await matcher.score(texto_usuario, cidade["nome"])
        if pontuacao > maior_score:
            maior_score = pontuacao
            melhor_opcao = cidade

    # Limiar mínimo de 65% de similaridade
    if melhor_opcao and maior_score >= 0.65:
        self.session.set_int("ID_MUNICIPIO", melhor_opcao["id"])
        self.session.set_str("MUNICIPIO", melhor_opcao["nome"])
        await ctx.output.send_text(f"Entendido! Cidade identificada: *{melhor_opcao['nome']}*")
        return GoToStepFlowAction(step=CinEnumSteps.UNIDADES_CONSULTAR)
    
    await ctx.output.send_text("Não conseguimos identificar essa cidade. Por favor, digite novamente.")
    return PreviousStepFlowAction()
```

