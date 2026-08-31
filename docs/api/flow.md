# `expresso_flow.flow`

```python
from expresso_flow.flow import Flow
```

---

## `Flow`

Classe base para todos os fluxos da aplicação.

### Atributos de instância disponíveis nos steps

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `app` | `ExpressoFlow` | Referência à instância principal da aplicação |

### Classe interna `Meta`

```python
class Meta:
    name: str
    description: str
    timeout: int
    default_channel: str | None
```

!!! note "Em construção"
    Documentação completa em elaboração.
