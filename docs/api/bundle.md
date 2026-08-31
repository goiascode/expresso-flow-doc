# `exflow.execution_action`

```python
from exflow.execution_action import ExecutionAction  # base abstrata
```

---

## `ExecutionAction`

Classe base abstrata para todas as ações de retorno de steps.

| Campo | Tipo | Padrão | Descrição |
|-------|------|--------|-----------|
| `data` | `dict` | `{}` | Dados propagados para o próximo step |
| `path` | `PathKey \| None` | `None` | Rota alternativa de execução |

`PathKey = str | Enum`

---

## Controle de input

| Action | Parâmetros | Descrição |
|--------|-----------|-----------|
| `WaitUserInputAction` | — | Suspende e aguarda input |
| `ListenUserInputAction` | — | Escuta sem suspender |
| `NoopAction` | — | Não faz nada |
| `BreakLoopAction` | — | Interrompe loop |

---

## Navegação entre steps

| Action | Parâmetros | Descrição |
|--------|-----------|-----------|
| `NextStepFlowAction` | `path?` | Próximo step **(padrão se nada for retornado)** |
| `PreviousStepFlowAction` | `path?` | Step anterior |
| `GoToStepFlowAction` | `step: int` | Step por índice |
| `GoToStepLabelFlowAction` | `label: str` | Step por label |
| `RestartFlowAction` | `step?: int` | Reinicia o flow |

---

## Encerramento

| Action | Parâmetros | Descrição |
|--------|-----------|-----------|
| `CompletedFlowAction` | — | Conclui com sucesso |
| `SuspendedFlowAction` | — | Suspende (retomável) |
| `CancelledFlowAction` | `reason?` | Cancela |
| `FatalRecoveryFlowAction` | `error?`, `reason?` | Erro fatal com recuperação |

---

## Controle de execução

| Action | Parâmetros | Descrição |
|--------|-----------|-----------|
| `StopExecutionAction` | `reason?` | Para imediatamente |
| `RetryExecutionAction` | `context?` | Reexecuta o step |
| `ExecuteToolAction` | `tool_id?`, `tool_cmd?` | Executa ferramenta |

---

## Transição entre flows

Todas recebem `flow_id: str` com o `id` do flow de destino.

| Action | Status atual | Destino |
|--------|-------------|---------|
| `ExecuteFlowAction(flow_id)` | `thread_status` | Executa |
| `ForceExecuteFlowAction(flow_id)` | — | Força execução |
| `CompleteAndStartFlowAction(flow_id)` | COMPLETED | Inicia |
| `SuspendAndStartFlowAction(flow_id)` | SUSPENDED | Inicia |
| `CancelAndStartFlowAction(flow_id)` | CANCELLED | Inicia |
| `CompleteAndResumeFlowAction(flow_id)` | COMPLETED | Retoma suspenso |
| `SuspendAndResumeFlowAction(flow_id)` | SUSPENDED | Retoma suspenso |
| `CancelAndResumeFlowAction(flow_id)` | CANCELLED | Retoma suspenso |

Consulte a [referência completa de Execution Actions →](../core/actions.md)
