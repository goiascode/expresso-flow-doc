# Bootstrap

O **bootstrap** é o ponto de entrada de qualquer projeto Expresso Flow. É nele que você registra os bundles e inicia a aplicação.

---

## `ExpressoFlowBootstrap`

```python
from exflow.application.bootstrap import ExpressoFlowBootstrap
```

### Construtor

```python
bootstrap = ExpressoFlowBootstrap(
    bundles=[...],   # Lista de bundles a inicializar
)
```

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| `bundles` | `list[Bundle]` | Não | Bundles registrados na inicialização |

---

## Registrando Bundles

Os bundles são passados diretamente no construtor do `ExpressoFlowBootstrap`:

```python
from exflow.application.bootstrap import ExpressoFlowBootstrap
from webflow_bundle import WebflowBundle

bootstrap = ExpressoFlowBootstrap(
    bundles=[
        WebflowBundle(),
    ]
)
```

!!! info "Bundles são opcionais"
    O core funciona sem nenhum bundle. Bundles adicionam capacidades como interfaces web, canais externos e integrações de IA.

---

## Iniciando a aplicação

```python
if __name__ == "__main__":
    bootstrap.run()
```

O método `run()` bloqueia a thread principal, inicializa todos os bundles registrados e começa a processar eventos. Para encerramento gracioso, `CTRL+C` aciona o shutdown de todos os bundles.

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

Com o `WebflowBundle` registrado, acesse `http://localhost:8080/webflow` no navegador para interagir com os fluxos da aplicação.

---

## Próximos passos

- [Flows →](flows.md)
- [Bundles →](bundles.md)
- [Configuração →](configuration.md)
