# Bootstrap

O **bootstrap** é o processo de inicialização do `ExpressoFlow`. É nele que você registra flows, bundles e define as configurações globais da aplicação antes de chamá-la.

---

## `ExpressoFlow`

```python
from expresso_flow import ExpressoFlow
```

### Construtor

```python
app = ExpressoFlow(
    name="minha-aplicacao",   # Nome da aplicação (opcional)
    debug=False,              # Modo debug (opcional)
    config=None,              # Objeto de configuração (opcional)
)
```

| Parâmetro | Tipo | Padrão | Descrição |
|-----------|------|--------|-----------|
| `name` | `str` | `"expresso-flow-app"` | Identificador da aplicação |
| `debug` | `bool` | `False` | Ativa logs detalhados e hot-reload |
| `config` | `Config \| None` | `None` | Configuração avançada via objeto `Config` |

---

## Registrando Flows

### Via decorador

```python
@app.flow("slug-do-fluxo")
class MeuFluxo(Flow):
    ...
```

### Via chamada direta

```python
from flows.meu_fluxo import MeuFluxo

app.flow("meu-fluxo")(MeuFluxo)
```

---

## Registrando Bundles

Os bundles são registrados antes de `app.run()`. A ordem de registro define a ordem de inicialização.

```python
from exflow_webflow import WebFlowBundle

app.register_bundle(WebFlowBundle(port=8765))
```

!!! info "Bundles são opcionais"
    O core funciona sem nenhum bundle. Bundles adicionam capacidades como interfaces web, canais externos e integrações de IA.

---

## Iniciando a aplicação

```python
if __name__ == "__main__":
    app.run()
```

O método `run()` bloqueia a thread principal, inicializa os bundles e começa a processar eventos. Para encerramento gracioso, `CTRL+C` aciona o shutdown de todos os bundles registrados.

### Opções de `run()`

```python
app.run(
    host="0.0.0.0",   # Host de escuta (canais HTTP)
    port=8000,        # Porta principal
)
```

---

## Exemplo completo de bootstrap

```python title="main.py"
from expresso_flow import ExpressoFlow
from exflow_webflow import WebFlowBundle

from flows.cadastro import CadastroFlow
from flows.suporte import SuporteFlow

app = ExpressoFlow(name="meu-chatbot", debug=True)

# Bundles
app.register_bundle(WebFlowBundle(port=8765))

# Flows
app.flow("cadastro")(CadastroFlow)
app.flow("suporte")(SuporteFlow)

if __name__ == "__main__":
    app.run()
```

---

## Próximos passos

- [Flows →](flows.md)
- [Bundles →](bundles.md)
- [Configuração →](configuration.md)
