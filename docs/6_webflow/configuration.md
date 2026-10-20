# Configuração — WebFlow

## `WebflowBundle`

```python
from webflow_bundle import WebflowBundle

bootstrap = ExpressoFlowBootstrap(
    bundles=[
        WebflowBundle(),
    ]
)
```

Acesse em `http://localhost:8080/webflow` após iniciar a aplicação.

---

## Parâmetros

| Parâmetro | Tipo | Padrão | Descrição |
|-----------|------|--------|-----------|
| `port` | `int` | `8765` | Porta do servidor WebFlow |
| `host` | `str` | `"127.0.0.1"` | Host de escuta (use `"0.0.0.0"` para acesso externo) |
| `title` | `str` | `"WebFlow"` | Título exibido na interface web |
| `open_browser` | `bool` | `False` | Abre o navegador automaticamente ao iniciar |
| `debug` | `bool` | Herda do `ExpressoFlow` | Ativa painel de debug avançado na interface |

---

## Segurança

!!! warning "Uso apenas em desenvolvimento"
    O WebFlow não possui autenticação por padrão. **Não exponha a porta do WebFlow em ambientes de produção ou redes públicas.** Use `host="127.0.0.1"` (padrão) para garantir acesso apenas local.

---

## Próximos passos

- [Interface →](interface.md)
- [Depuração →](debugging.md)
