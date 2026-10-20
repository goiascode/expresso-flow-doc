## Notação @mock
Mocks e Cenários de Testes com `@mock`, JSON e `ResetFlow`      
Guia Completo: Testes e Injeção de Cenários Mock no Expresso Flow
---
## Arquitetura de Testes e Carregamento Dinâmico

O framework Expresso Flow possui suporte nativo a testes isolados de fluxos conversacionais via injeção de dependências (`exflow.di`).

A inicialização no `main.py` define o parâmetro `class_loader_paths=['tests']`:

```python
bootstrap = ExFlowBootstrap(
    namespace="flow_example",
    class_loader_paths=['tests'],  # <-- Registra fluxos e classes dentro da pasta /tests
    bundles=[
        ExFlowBundle(),
        WebFlowStreamBundle(),
    ]
)
```

    O que o class_loader_paths=['tests'] habilita:

        ° Auto-descoberta de Mocks via @mock: Qualquer classe anotada com @mock dentro de tests/ substitui automaticamente o serviço original no container de injeção de dependência (container.resolve(...)).             
        ° Descoberta de Comandos de Teste (ResetFlow): Fluxos de utilidade dentro de tests/flows/ (como o comando /flow reset) tornam-se disponíveis durante o desenvolvimento e homologação para alternar cenários em tempo real via chat.                    

## Estrutura de Diretórios Recomendada

---
```
example-flow/
├── example/
│   └── flows/flow/example_flow/
│       ├── example_flow.py
│       └── example_service/
│           └── example_service.py       # Interface/Serviço original
├── tests/
│   ├── flows/
│   │   └── reset_flow.py            # Fluxo (/flow reset) para seleção interativa
│   └── mock/
│       ├── mock_example_service.py      # Serviço anotado com @mock herdando de ExampleService
│       └── scenarios/
│           ├── active_scenario.json # Ponteiro do cenário ativo no momento
│           ├── primeira_via.json
│           ├── segunda_via.json
│           ├── autenticacao_entrar_autenticado.json
│           └── nao_elegivel.json

```

## Passo a Passo de Implementação

Passo 1: Criação dos Cenários em Arquivos JSON (tests/mock/scenarios/)
Cada arquivo .json representa o estado completo de respostas de API e dados de usuário simulados para um caso de teste específico:
tests/mock/scenarios/autenticacao_entrar_autenticado.json:

```json

- .json com os dados/atributos montados para recepção em uma API.
- considerando dados para simulação de de uma resposta a ser valida com status 200.

{
  "scenario": "autenticacao_entrar_autenticado",
  "name": "Autenticação -> Entrar Autenticado -> Encerrar para Auth",
  "description": "Usuário inicia não autenticado (logado=false), na etapa de Autenticação escolhe 'Entrar autenticado',
   (muda logado para true) e segue para o início logado.",
  "consultar_rg_segunda_via_rapida_e_andamento": {
    "status_code": 200,
    "tipo": "NACIONAL_1VIA",
    "rgCivil": "9999999",
    "result": "PRIMEIRA_VIA"
  },
  "user": {
    "id": 1,
    "nome_completo": "João da Silva",
    "cpf": "00999999999",
    "telefone": "62 99341-0475",
    "data_nascimento": "16/06/1940",
    "rg": "9999999",
    "logado": false,
    "active": true
  }
}

```

O arquivo active_scenario.json armazena qual arquivo de cenário está em vigor:

```markdown
{
  "scenario": "autenticacao_entrar_autenticado"
}
```

Passo 2: Implementando o Mock Service com @mock (MockExampleService)
A classe de mock herda da classe de serviço real e é decorada com @mock. O container de DI substitui automaticamente o ExampleService pelo MockExampleService:

```python

import json
from pathlib import Path
from exflow.di import mock
from example.flows.flow.example_flow.example_service.example_service import ExampleService

SCENARIOS_DIR = Path(__file__).parent / "scenarios"
ACTIVE_SCENARIO_FILE = SCENARIOS_DIR / "active_scenario.json"

@mock
class MockExampleService(ExampleService):
    """
    Substitui automaticamente o ExampleService pelo container de DI do Expresso Flow.
    Carrega dinamicamente os retornos do cenário ativo configurado em JSON.
    """

    @classmethod
    def get_current_scenario_key(cls) -> str:
        if ACTIVE_SCENARIO_FILE.exists():
            try:
                data = json.loads(ACTIVE_SCENARIO_FILE.read_text(encoding="utf-8"))
                return data.get("scenario", "primeira_via")
            except Exception:
                pass
        return "primeira_via"

    @classmethod
    def set_scenario(cls, scenario_key: str) -> None:
        ACTIVE_SCENARIO_FILE.write_text(
            json.dumps({"scenario": scenario_key}, indent=2, ensure_ascii=False),
            encoding="utf-8"
        )

    @classmethod
    def load_scenario_data(cls) -> dict:
        key = cls.get_current_scenario_key()
        file_path = SCENARIOS_DIR / f"{key}.json"
        if not file_path.exists():
            file_path = SCENARIOS_DIR / "primeira_via.json"
        return json.loads(file_path.read_text(encoding="utf-8"))

    @classmethod
    def list_scenarios(cls) -> list[dict]:
        scenarios = []
        for file in sorted(SCENARIOS_DIR.glob("*.json")):
            if file.name == "active_scenario.json":
                continue
            data = json.loads(file.read_text(encoding="utf-8"))
            scenarios.append({
                "scenario": data.get("scenario", file.stem),
                "name": data.get("name", file.stem),
                "description": data.get("description", "")
            })
        return scenarios

    # Sobrescrita dos métodos de API para retornar os dados do JSON ativo:
    async def consultar_rg_segunda_via_rapida_e_andamento(self, params: dict):
        scenario_data = self.load_scenario_data()
        endpoint_data = scenario_data.get("consultar_rg_segunda_via_rapida_e_andamento", {})
        
        if endpoint_data.get("rgCivil"):
            self.session.set_str("RG", str(endpoint_data["rgCivil"]))
        if endpoint_data.get("tipo"):
            self.session.set_str("TIPO_VIA", str(endpoint_data["tipo"]))

        return endpoint_data.get("result", "PRIMEIRA_VIA")
```

Passo 3: Implementando o Fluxo de Escolha de Cenários (ResetFlow)
Localizado em tests/flows/reset_flow.py, este fluxo é carregado via class_loader_paths=['tests'] e acionado diretamente pelo comando /flow reset:

```python

from exflow.flow import Flow, flow, step, StepOptions
from exflow.interaction import InteractionContext
from exflow.execution_action import (
    WaitUserInputAction,
    CancelAndStartFlowAction,
    PreviousStepFlowAction,
)
from tests.mock.mock_example_service import MockExampleService

@flow()
class ResetFlow(Flow):
    """
    Fluxo de utilidade para desenvolvedores e testers.
    Permite escolher qualquer cenário mockado via mensagem de chat.
    """

    id = "reset"
    name = "Reset de Cenários Mock"
    description = "Configuração e troca de cenários mock para testes do fluxo CIN"

    @step(1)
    async def listar_cenarios(self, ctx: InteractionContext, params: StepOptions):
        current = MockExampleService.get_current_scenario_key()
        scenarios = MockExampleService.list_scenarios()

        msg = (
            "🔄 *Configuração de Cenários Mock da API (CIN)*\n\n"
            f"📌 *Cenário ativo:* -> `{current}`\n\n"
            "Escolha o cenário que deseja ativar enviando o *número* correspondente:\n\n"
        )

        for idx, item in enumerate(scenarios, start=1):
            msg += f"*{idx}* - {item['name']}\n_{item['description']}_\n\n"

        msg += "Envie o número da opção desejada:"
        await ctx.output.send_text(msg)
        return WaitUserInputAction()

    @step(2)
    async def aplicar_cenario(self, ctx: InteractionContext, params: StepOptions):
        user_input = ctx.message.get_text().strip().lower()
        scenarios = MockExampleService.list_scenarios()

        selected_key = None
        selected_name = None

        if user_input.isdigit():
            idx = int(user_input) - 1
            if 0 <= idx < len(scenarios):
                selected_key = scenarios[idx]["scenario"]
                selected_name = scenarios[idx]["name"]
        else:
            for item in scenarios:
                if user_input in (item["scenario"].lower(), item["name"].lower()):
                    selected_key = item["scenario"]
                    selected_name = item["name"]
                    break

        if not selected_key:
            await ctx.output.send_text(
                f"❌ Opção inválida: '{ctx.message.get_text()}'.\n"
                "Por favor, envie o número de uma das opções listadas."
            )
            return PreviousStepFlowAction()

        # Altera o ponteiro no active_scenario.json
        MockExampleService.set_scenario(selected_key)

        await ctx.output.send_text(
            f"✅ Cenário *{selected_name}* ativado com sucesso!\n\n"
            "Reiniciando o fluxo principal..."
        )
        # Cancela o reset_flow e inicia o fluxo principal com os novos dados
        return CancelAndStartFlowAction(flow_id="example_flow")
```
## Como Testar no Dia a Dia

1. Via Chat / Emulador Web:     
    ◦ Digite /flow reset.       
    ◦ O bot lista os cenários extraídos dos arquivos .json da pasta tests/mock/scenarios/.      
    ◦ Digite o número desejado (ex: 1 para Autenticação, 2 para Não Elegível).      
    ◦ O ResetFlow grava o cenário em active_scenario.json e reinicia imediatamente o example_flow já populado com o novo contexto.      
2. Via Testes Automatizados (Scripts de Teste):     


```python

from tests.mock.mock_example_service import MockExampleService
from example.flows.flow.example_flow.example_flow import ExampleFlow

# Define o cenário programaticamente antes de executar o teste:
MockExampleService.set_scenario("autenticacao_entrar_autenticado")
service = MockExampleService()
flow = ExampleFlow(service=service)
# Executa os steps assertando transições
```