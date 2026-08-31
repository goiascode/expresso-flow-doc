# Quick Start

Siga este guia para ter um projeto Expresso Flow funcionando em menos de 5 minutos.

---

## Opção 1 — Com a CLI (recomendado)

### 1. Instale a CLI

Consulte [Downloads](../downloads/index.md) para obter o binário da sua plataforma.

### 2. Crie um novo projeto

```bash
exflow create project --name meu-projeto
cd meu-projeto
```

A CLI cria a estrutura de diretórios, os arquivos de configuração e instala as dependências automaticamente.

!!! tip
    O comando `exflow create project` já executa `pip install -r requirements.txt` ao final. Não é necessário instalar as dependências manualmente.

### 3. Execute o projeto

```bash
python main.py
```

---

## Opção 2 — Manualmente

### 1. Instale o core

```bash
pip install --index-url https://exflow.run/simple exflow
```

### 2. Crie o arquivo principal

```python title="main.py"
from exflow.application.bootstrap import ExpressoFlowBootstrap

bootstrap = ExpressoFlowBootstrap()

if __name__ == "__main__":
    bootstrap.run()
```

### 3. Execute

```bash
python main.py
```

---

## Com WebFlow (debug visual)

Para inspecionar o fluxo no navegador, instale e configure o bundle **WebFlow**:

```bash
pip install --index-url https://exflow.run/simple webflow-bundle
```

```python title="main.py" hl_lines="2 4 5 6"
from exflow.application.bootstrap import ExpressoFlowBootstrap
from webflow_bundle import WebflowBundle

bootstrap = ExpressoFlowBootstrap(
    bundles=[
        WebflowBundle(),  # (1)!
    ]
)

if __name__ == "__main__":
    bootstrap.run()
```

1. O `WebflowBundle` sobe um servidor web na porta `8080` que permite interagir com os fluxos diretamente pelo navegador.

Acesse `http://localhost:8080/webflow` no navegador para interagir com seus fluxos visualmente.

---

## Próximos passos

- [Primeiro Fluxo →](first-flow.md)
- [Bootstrap →](../core/bootstrap.md)
- [WebFlow →](../webflow/index.md)
