# `exflow.flow`

```python
from exflow.flow import Flow, StepOptions, step, flow
```

---

## `Flow`

Classe base para todos os flows. Deve ser decorada com `@flow()`.

### Atributos obrigatórios

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | `str` | Identificador único — usado pelas actions de navegação (`flow_id`) |
| `name` | `str` | Nome de exibição em todos os ambientes |
| `description` | `str` | Docstring da classe — usada pelo engine de intent |

### Propriedade de instância

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `self.session` | `FlowSession` | Sessão de dados persistida entre steps |

---

## `@flow()`

Decorador obrigatório. Registra a classe no container de execução do framework.

```python
@flow()
class MeuFlow(Flow):
    """Descrição do flow."""
    id = "meu_flow"
    name = "Meu Flow"
```

---

## `@step(order, label, description)`

Decorador que define e ordena um step dentro de um flow.

```python
@step(order: int, label: str, description: str)
async def nome_do_step(self, ctx: InteractionContext, options: StepOptions):
    ...
```

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `order` | `int` | Ordem de execução (começa em `0`) |
| `label` | `str` | Nome exibido no painel de debug do WebFlow |
| `description` | `str` | Objetivo do step — usado pelo engine de intent para avaliar a intenção do usuário |

---

## `StepOptions`

Injetado como segundo parâmetro em todos os steps.

```python
@dataclass
class StepOptions:
    direction: FlowDirection  # FORWARD | REWIND (padrão: FORWARD)
    data: dict                # Dados propagados pelo step anterior
    description: str | None   # Descrição contextual injetada pelo runtime
```

---

## `FlowSession`

Acessível via `self.session` dentro de qualquer step.

| Método | Descrição |
|--------|-----------|
| `set(key, value)` | Armazena qualquer valor |
| `set_str / set_int / set_float / set_bool / set_list` | Armazena com tipo específico |
| `load(props: dict)` | Carrega múltiplos valores |
| `get(key, default?)` | Lê um valor |
| `exists(key)` | Verifica existência |

Consulte a [documentação completa de Flows →](../core/flows.md) e [FlowSession →](../core/session.md)
