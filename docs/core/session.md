# FlowSession

O flow disponibiliza a propriedade `self.session` em todos os steps para persistir dados entre etapas durante a execução da conversa.

```python
# Acessível diretamente na instância do flow
self.session.set_str("nome", "João")
nome = self.session.get("nome")
```

---

## Métodos de escrita

| Método | Descrição |
|--------|-----------|
| `set(key, value)` | Armazena qualquer valor |
| `set_str(key, value)` | Armazena como `str` |
| `set_int(key, value)` | Armazena como `int` |
| `set_float(key, value)` | Armazena como `float` |
| `set_bool(key, value)` | Armazena como `bool` |
| `set_list(key, value)` | Armazena como `list` |
| `load(props)` | Carrega múltiplos valores a partir de um `dict` |

```python
# Armazenar valores tipados
self.session.set_str("nome", ctx.message.get_text())
self.session.set_int("tentativas", 0)
self.session.set_bool("autenticado", True)

# Carregar múltiplos valores de uma vez
self.session.load({"nome": "João", "plano": "pro", "tentativas": 0})
```

---

## Métodos de leitura

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `get(key, default=None)` | `Any` | Retorna o valor ou `default` se a chave não existir |
| `exists(key)` | `bool` | Verifica se a chave existe na sessão |

```python
# Leitura simples
nome = self.session.get("nome")

# Leitura com valor padrão
tentativas = self.session.get("tentativas", 0)

# Verificar antes de ler
if self.session.exists("nome"):
    nome = self.session.get("nome")
```

---

## Exemplo completo

```python
from exflow.flow import Flow, StepOptions, step, flow
from exflow.interaction import InteractionContext
from exflow.execution_action import CompletedFlowAction, WaitUserInputAction


@flow()
class CadastroFlow(Flow):
    """Flow de cadastro com persistência de dados entre steps."""

    id = "cadastro"
    name = "Cadastro"

    @step(order=0, label="Pedir nome", description="Solicita o nome do usuário")
    async def pedir_nome(self, ctx: InteractionContext, options: StepOptions):
        await ctx.output.send_text("Qual é o seu nome?")
        return WaitUserInputAction()

    @step(order=1, label="Salvar nome", description="Salva o nome e solicita o e-mail")
    async def salvar_nome(self, ctx: InteractionContext, options: StepOptions):
        self.session.set_str("nome", ctx.message.get_text())
        await ctx.output.send_text("Qual é o seu e-mail?")
        return WaitUserInputAction()

    @step(order=2, label="Finalizar", description="Confirma o cadastro com nome e e-mail")
    async def finalizar(self, ctx: InteractionContext, options: StepOptions):
        nome = self.session.get("nome")
        email = ctx.message.get_text()
        await ctx.output.send_text(f"✅ Cadastro de *{nome}* ({email}) concluído!")
        return CompletedFlowAction()
```

---

!!! info "Escopo da sessão"
    A sessão persiste durante toda a execução do flow para aquela conversa. Ao encerrar o flow (`CompletedFlowAction`, `CancelledFlowAction`, etc.), a sessão é descartada.
