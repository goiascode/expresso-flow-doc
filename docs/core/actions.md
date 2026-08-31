# Execution Actions

Todo step deve retornar uma subclasse de `ExecutionAction`. Se nenhuma ação for retornada, o framework aplica **`NextStepFlowAction`** automaticamente, avançando para o próximo step.

```python
from exflow.execution_action import <NomeDaAction>
```

---

## Classe base

```python
@dataclass
class ExecutionAction(ABC):
    data: dict        # Dados propagados para o próximo step (padrão: {})
    path: PathKey | None  # Rota/caminho alternativo de execução (padrão: None)
```

`PathKey = str | Enum`

Todos os campos da classe base estão disponíveis em qualquer action via `kw_only`:

```python
return WaitUserInputAction(data={"nome": "João"}, path="rota_alternativa")
```

---

## Controle de input

| Action | Parâmetros | Descrição |
|--------|-----------|-----------|
| `WaitUserInputAction` | — | Suspende o flow e aguarda o próximo input do usuário |
| `ListenUserInputAction` | — | Escuta o input sem suspender o flow |
| `NoopAction` | — | Não faz nada — mantém o estado atual sem avançar |
| `BreakLoopAction` | — | Interrompe um loop de execução |

---

## Navegação entre steps

| Action | Parâmetros | Descrição |
|--------|-----------|-----------|
| `NextStepFlowAction` | `path?` | Avança para o próximo step **(padrão quando nada é retornado)** |
| `PreviousStepFlowAction` | `path?` | Volta para o step anterior |
| `GoToStepFlowAction` | `step: int` | Navega para o step pelo índice `order` |
| `GoToStepLabelFlowAction` | `label: str` | Navega para o step pelo `label` |
| `RestartFlowAction` | `step?: int` | Reinicia o flow (opcionalmente a partir de um step) |

```python
from exflow.execution_action import GoToStepFlowAction, GoToStepLabelFlowAction, RestartFlowAction

# Ir para o step de índice 2
return GoToStepFlowAction(step=2)

# Ir para o step pelo label
return GoToStepLabelFlowAction(label="Confirmar pedido")

# Reiniciar o flow do início
return RestartFlowAction()

# Reiniciar a partir do step 1
return RestartFlowAction(step=1)
```

---

## Encerramento do flow

| Action | Parâmetros | Descrição |
|--------|-----------|-----------|
| `CompletedFlowAction` | — | Conclui o flow com sucesso |
| `SuspendedFlowAction` | — | Suspende o flow (pode ser retomado) |
| `CancelledFlowAction` | `reason?: str` | Cancela o flow |
| `FatalRecoveryFlowAction` | `error?: Exception`, `reason?: str` | Encerra por erro fatal e aciona recuperação |

```python
from exflow.execution_action import CompletedFlowAction, CancelledFlowAction, SuspendedFlowAction

return CompletedFlowAction()
return SuspendedFlowAction()
return CancelledFlowAction(reason="Usuário solicitou cancelamento")
```

---

## Controle de execução

| Action | Parâmetros | Descrição |
|--------|-----------|-----------|
| `StopExecutionAction` | `reason?: str` | Para a execução do step imediatamente |
| `RetryExecutionAction` | `context?: InteractionContext` | Reexecuta o step atual |
| `ExecuteToolAction` | `tool_id?: str`, `tool_cmd?: ToolCmd` | Executa uma ferramenta registrada |

---

## Transição entre flows

Todas as actions abaixo herdam de `ExecuteFlowAction` e recebem `flow_id` com o `id` do flow de destino.

### `ExecuteFlowAction`

```python
@dataclass
class ExecuteFlowAction(ExecutionAction):
    flow_id: str | None = None
    step: int | None = None            # Step inicial no flow de destino
    thread_status: ThreadStatus = ThreadStatus.COMPLETED
```

### Actions de transição

| Action | Status aplicado ao flow atual | Comportamento no flow destino |
|--------|-----------------------------|-------------------------------|
| `ForceExecuteFlowAction(flow_id)` | — | Força execução imediata |
| `CompleteAndStartFlowAction(flow_id)` | `COMPLETED` | Inicia |
| `SuspendAndStartFlowAction(flow_id)` | `SUSPENDED` | Inicia |
| `CancelAndStartFlowAction(flow_id)` | `CANCELLED` | Inicia |
| `CompleteAndResumeFlowAction(flow_id)` | `COMPLETED` | Retoma suspenso |
| `SuspendAndResumeFlowAction(flow_id)` | `SUSPENDED` | Retoma suspenso |
| `CancelAndResumeFlowAction(flow_id)` | `CANCELLED` | Retoma suspenso |

```python
from exflow.execution_action import (
    CompleteAndStartFlowAction,
    SuspendAndStartFlowAction,
    CompleteAndResumeFlowAction,
)

# Conclui o flow atual e inicia outro
return CompleteAndStartFlowAction(flow_id="suporte")

# Suspende o flow atual e inicia outro (o atual pode ser retomado)
return SuspendAndStartFlowAction(flow_id="autenticacao")

# Conclui o flow atual e retoma um flow que estava suspenso
return CompleteAndResumeFlowAction(flow_id="cadastro")
```
