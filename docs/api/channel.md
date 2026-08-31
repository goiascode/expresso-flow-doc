# `exflow.application.bundle`

```python
from exflow.application.bundle import Bundle
from exflow.application.bootstrap import ExpressoFlowBootstrap
```

---

## `Bundle`

Classe base abstrata para todos os bundles. Mecanismo oficial de extensão do framework.

### Hooks do ciclo de vida

| Hook | Assinatura | Quando é chamado |
|------|-----------|-----------------|
| `register(bootstrap)` | `(ExpressoFlowBootstrap) -> None` | Antes de `configure()` — registra componentes |
| `configure(bootstrap)` | `(ExpressoFlowBootstrap) -> None` | Após todos os `register()` — aplica configurações |
| `routes(bootstrap)` | `(ExpressoFlowBootstrap) -> list[APIRouter]` | Após `configure()` — adiciona rotas FastAPI |
| `shutdown()` | `() -> None` | Ao encerrar a aplicação |

### Ordem de execução

```
register() → configure() → routes() → shutdown()
```

### Exemplo mínimo

```python
from exflow.application.bundle import Bundle
from exflow.application.bootstrap import ExpressoFlowBootstrap


class MeuBundle(Bundle):

    def register(self, bootstrap: ExpressoFlowBootstrap) -> None:
        bootstrap.meu_servico = MeuServico()

    def configure(self, bootstrap: ExpressoFlowBootstrap) -> None:
        bootstrap.meu_servico.configure()

    def shutdown(self) -> None:
        bootstrap.meu_servico.close()
```

Consulte a [documentação completa de Bundle →](../core/bootstrap.md#bundle)
