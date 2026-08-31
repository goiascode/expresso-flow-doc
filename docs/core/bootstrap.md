# Bootstrap

O **bootstrap** é o ponto de entrada de qualquer projeto Expresso Flow. Internamente utiliza **FastAPI** e **Uvicorn** como servidor HTTP, e segue um padrão **Singleton** — uma única instância por processo.

---

## `ExpressoFlowBootstrap`

```python
from exflow.application.bootstrap import ExpressoFlowBootstrap
```

### Construtor

```python
bootstrap = ExpressoFlowBootstrap(
    host="localhost",          # Host do servidor (padrão: "localhost")
    port=8080,                 # Porta do servidor (padrão: 8080)
    bundles=[],                # Bundles adicionais
    is_debug=False,            # Ativa modo debug
    class_loader_paths=[],     # Pastas extras para carregamento automático de flows
)
```

| Parâmetro | Tipo | Padrão | Descrição |
|-----------|------|--------|-----------|
| `host` | `str` | `"localhost"` | Host de escuta do servidor |
| `port` | `int` | `8080` | Porta do servidor |
| `bundles` | `list[Bundle]` | `[]` | Bundles adicionais registrados após os padrão |
| `is_debug` | `bool` | `False` | Ativa logs detalhados via `IS_DEBUG` env |
| `class_loader_paths` | `list[str]` | `[]` | Pastas extras para o `FlowLoaderBundle` carregar automaticamente |

---

## Método `run()`

Inicia o servidor Uvicorn e bloqueia a thread principal:

```python
if __name__ == "__main__":
    bootstrap.run()
```

Internamente, `run()` inicializa os bundles na seguinte ordem:

1. **`register()`** — cada bundle registra seus componentes no bootstrap
2. **`configure()`** — cada bundle aplica suas configurações
3. **`routes()`** — cada bundle adiciona suas rotas FastAPI
4. **`shutdown()`** — executado ao encerrar (`CTRL+C`)

---

## Singleton — `get_instance()`

O bootstrap é acessível de qualquer parte da aplicação após a inicialização:

```python
from exflow.application.bootstrap import ExpressoFlowBootstrap

bootstrap = ExpressoFlowBootstrap.get_instance()
```

!!! warning
    Chamar `get_instance()` antes de instanciar o `ExpressoFlowBootstrap` lança `RuntimeError`.

---

## Bundles padrão

O bootstrap registra automaticamente os seguintes bundles **antes** dos bundles customizados:

| Bundle | Descrição |
|--------|-----------|
| `ConfigDefaultBundle` | Configurações padrão da aplicação |
| `DefaultIntentsBundle` | Intents padrão do engine de IA |
| `FailureRecoveryBundle` | Políticas de recuperação de falhas |
| `InfoBundle` | Endpoint de informações da aplicação |
| `FlowApiBundle` | API REST para execução de flows |
| `FlowLoaderBundle` | Carregamento automático de flows por pasta |

### Pastas de carregamento automático (`FlowLoaderBundle`)

Os flows são carregados automaticamente a partir das seguintes pastas:

```
app/flows/         ← flows conversacionais
app/metaflows/     ← flows de meta-orquestração
app/services/      ← serviços internos
app/apis/          ← integrações com APIs externas
app/providers/     ← provedores de dados
app/llms/          ← agentes e integrações de IA
```

Para adicionar pastas extras:

```python
bootstrap = ExpressoFlowBootstrap(
    class_loader_paths=["app/custom", "app/integrations"],
)
```

---

## Exemplo mínimo

```python title="main.py"
from exflow.application.bootstrap import ExpressoFlowBootstrap
from webflow_bundle import WebflowBundle

bootstrap = ExpressoFlowBootstrap(
    bundles=[
        WebflowBundle(),
    ]
)

if __name__ == "__main__":
    bootstrap.run()
```

Com o `WebflowBundle` registrado, acesse `http://localhost:8080/webflow` no navegador para interagir com os flows.

---

## Próximos passos

- [Flows →](flows.md)
- [Bundles →](bundles.md)
- [Configuração →](configuration.md)
