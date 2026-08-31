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
    pip install --index-url https://exflow.run/simple webflow-bundle
    ```

=== "CLI"

    ```bash
    exflow add webflow
    ```

---

## Registrar no bootstrap

Após instalar, registre o bundle no `main.py` antes de `bootstrap.run()`:

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

Execute e acesse no navegador:

```
http://localhost:8080/webflow
```

---

## Próximos passos

- [Configuração →](configuration.md)
- [Interface →](interface.md)
