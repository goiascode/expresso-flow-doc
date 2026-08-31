# `exflow.application.bootstrap`

```python
from exflow.application.bootstrap import ExpressoFlowBootstrap
```

---

## `ExpressoFlowBootstrap`

Entry point da aplicação. Inicializa bundles, registra flows e sobe o servidor HTTP (FastAPI + Uvicorn).

### Construtor

```python
ExpressoFlowBootstrap(
    *,
    host: str = "localhost",
    port: int = 8080,
    bundles: list[Bundle] = [],
    is_debug: bool = False,
    class_loader_paths: list[str] = [],
)
```

| Parâmetro | Tipo | Padrão | Descrição |
|-----------|------|--------|-----------|
| `host` | `str` | `"localhost"` | Host de escuta do servidor |
| `port` | `int` | `8080` | Porta do servidor |
| `bundles` | `list[Bundle]` | `[]` | Bundles adicionais (registrados após os padrão) |
| `is_debug` | `bool` | `False` | Ativa modo debug via `IS_DEBUG` env |
| `class_loader_paths` | `list[str]` | `[]` | Pastas extras para carregamento automático de flows |

### Métodos

| Método | Assinatura | Descrição |
|--------|-----------|-----------|
| `run()` | `() -> None` | Inicia o servidor (bloqueante) |
| `get_instance()` | `classmethod () -> ExpressoFlowBootstrap` | Retorna a instância singleton |

### Bundles padrão registrados automaticamente

| Bundle | Descrição |
|--------|-----------|
| `ConfigDefaultBundle` | Configurações padrão |
| `DefaultIntentsBundle` | Intents do engine de IA |
| `FailureRecoveryBundle` | Políticas de recuperação de falhas |
| `InfoBundle` | Endpoint de informações |
| `FlowApiBundle` | API REST para execução de flows |
| `FlowLoaderBundle` | Carregamento automático de flows por pasta |

### Pastas carregadas automaticamente

```
app/flows/       app/metaflows/    app/services/
app/apis/        app/providers/    app/llms/
```

Consulte a [documentação completa do Bootstrap →](../core/bootstrap.md)
