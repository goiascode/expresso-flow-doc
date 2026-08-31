---
hide:
  - navigation
  - toc
---

# Expresso Flow

<div class="hero" markdown>

# Construa fluxos de comunicação com elegância e velocidade.

**Expresso Flow** é um framework Python 3.12 para criação de fluxos conversacionais em múltiplos canais — WhatsApp, Telegram, ChatWeb e muito mais. Com uma arquitetura baseada em **bundles**, você instala apenas o que precisa e sai do zero ao deploy em minutos.

<div class="hero-buttons" markdown>

[Começar agora](getting-started/quick-start.md){ .md-button .md-button--primary }
[Ver exemplos](getting-started/first-flow.md){ .md-button }

</div>

</div>

---

## Instale em segundos

=== "pip"

    ```bash
    pip install --index-url https://exflow.run/simple expresso-flow
    ```

=== "CLI (macOS / Linux)"

    ```bash
    # Baixe o binário e adicione ao PATH
    curl -L https://exflow.run/bin/macos/exflow -o /usr/local/bin/exflow
    chmod +x /usr/local/bin/exflow
    exflow --version
    ```

=== "CLI (Windows)"

    ```powershell
    # Baixe o executável
    Invoke-WebRequest -Uri https://exflow.run/bin/windows/exflow.exe -OutFile exflow.exe
    # Adicione ao PATH ou mova para uma pasta já no PATH
    ```

---

## Por que Expresso Flow?

<div class="grid cards" markdown>

- :material-lightning-bolt: **Rápido para começar**

    Do `pip install` ao primeiro fluxo em produção em menos de 10 minutos, com CLI integrada para scaffolding do projeto.

- :material-puzzle: **Arquitetura de Bundles**

    Instale apenas o que você precisa. WebFlow, canais e agentes de IA são bundles independentes e configuráveis no bootstrap.

- :material-routes: **Multi-canal nativo**

    Escreva um fluxo uma única vez e conecte a WhatsApp, Telegram, ChatWeb e outros canais com configuração mínima.

- :material-bug: **WebFlow: depuração visual**

    Acesse e interaja com seus fluxos locais diretamente pelo navegador com o bundle **WebFlow**, sem infraestrutura extra.

- :material-robot: **Agentes de IA integrados**

    Adicione inteligência aos seus fluxos com agentes de IA disponíveis no repositório Expresso Flow.

- :material-code-braces: **Python puro**

    Toda a lógica do fluxo é escrita em Python 3.12 idiomático — sem DSLs, sem YAML de negócio, sem magia desnecessária.

</div>

---

## Hello World

O `main.py` mínimo para iniciar um projeto:

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

Com o `WebflowBundle` registrado, acesse `http://localhost:8080/webflow` no navegador para visualizar e interagir com seus fluxos.

---

## Módulos do framework

| Módulo | Descrição | Instalação |
|--------|-----------|------------|
| **Core** (`expresso-flow`) | Motor principal de fluxos | `pip install expresso-flow` |
| **CLI** (`exflow`) | Scaffolding, execução e build via terminal | [Download](downloads/index.md) |
| **WebFlow** (`exflow-webflow`) | Interface web para debug local | `pip install exflow-webflow` |

---

## Comunidade e suporte

<div class="grid cards" markdown>

- :fontawesome-brands-github: **GitHub** — [expresso-flow/expresso-flow](https://github.com/expresso-flow/expresso-flow)
- :fontawesome-brands-discord: **Discord** — [Servidor da comunidade](https://discord.gg/exflow)
- :material-package: **PyPI** — [exflow.run/simple](https://exflow.run/simple)

</div>
