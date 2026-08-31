# `expresso_flow`

```python
from expresso_flow import ExpressoFlow
```

---

## `ExpressoFlow`

Classe principal da aplicação. Ponto de entrada do framework.

### Construtor

```python
ExpressoFlow(
    name: str = "expresso-flow-app",
    debug: bool = False,
    config: Config | None = None,
)
```

### Métodos

| Método | Assinatura | Descrição |
|--------|-----------|-----------|
| `flow` | `(slug: str) -> Callable` | Decorador/registrador de flows |
| `register_bundle` | `(bundle: Bundle) -> None` | Registra um bundle no bootstrap |
| `run` | `(host: str, port: int) -> None` | Inicia a aplicação (bloqueante) |

### Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `state` | `SimpleNamespace` | Namespace compartilhado acessível de qualquer parte da aplicação |
| `flows` | `dict[str, type[Flow]]` | Dicionário de flows registrados por slug |
| `bundles` | `list[Bundle]` | Lista de bundles registrados |

!!! note "Em construção"
    Assinaturas completas, parâmetros adicionais e exemplos avançados serão adicionados nesta página.
