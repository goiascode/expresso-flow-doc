# Instalação — WebFlow

## Pré-requisito

O core do Expresso Flow deve estar instalado:

```bash
pip install --index-url https://exflow.run/simple expresso-flow
```

---

## Instalar o WebFlow

=== "pip"

    ```bash
    pip install --index-url https://exflow.run/simple exflow-webflow
    ```

=== "CLI"

    ```bash
    exflow add webflow
    ```

---

## Registrar no bootstrap

Após instalar, registre o bundle no `main.py` antes de `app.run()`:

```python title="main.py"
from expresso_flow import ExpressoFlow
from exflow_webflow import WebFlowBundle

app = ExpressoFlow()

app.register_bundle(WebFlowBundle(port=8765))

# ... seus flows ...

if __name__ == "__main__":
    app.run()
```

Execute e acesse no navegador:

```
http://localhost:8765
```

---

## Próximos passos

- [Configuração →](configuration.md)
- [Interface →](interface.md)
