# Instalação

## Pré-requisitos

- **Python 3.12 ou superior** — [python.org/downloads](https://www.python.org/downloads/)
- **pip 23+** — atualizado automaticamente com versões recentes do Python

---

## Core — `exflow`

O pacote principal do framework é instalado via **pip** a partir do repositório oficial:

```bash
pip install --index-url https://exflow.run/simple exflow
```

### Ambiente virtual (recomendado)

=== "venv (padrão)"

    ```bash
    python -m venv .venv
    source .venv/bin/activate        # Linux / macOS
    .venv\Scripts\activate           # Windows

    pip install --index-url https://exflow.run/simple exflow
    ```

=== "uv"

    ```bash
    uv venv
    uv pip install --index-url https://exflow.run/simple exflow
    ```

### Instalando as dependências do projeto

O `requirements.txt` gerado pelo CLI já inclui o índice correto:

```text title="requirements.txt"
--index-url https://exflow.run/simple --trusted-host exflow.run

exflow
webflow-bundle
python-dotenv
```

Para instalar:

```bash
pip install -r requirements.txt
```

---

## Bundles adicionais

Os bundles ampliam o core com canais e ferramentas. Todos são instalados pelo mesmo repositório:

```bash
pip install --index-url https://exflow.run/simple <NOME_DO_PACOTE>
```

| Pacote | Descrição |
|--------|----------|
| `webflow-bundle` | Interface web para debug e teste local |
| `exflow-whatsapp` | Canal WhatsApp |

!!! info "Repositório privado"
    O índice `https://exflow.run/simple` é o repositório oficial do Expresso Flow. Todos os pacotes do framework são publicados exclusivamente neste índice.

---

## CLI — `exflow`

A CLI é distribuída como um binário independente (sem necessidade de Python instalado) para cada plataforma.

Consulte a página de [Downloads](../downloads/index.md) para instruções detalhadas por sistema operacional, ou acesse a [documentação da CLI](../cli/index.md).

---

## Próximos passos

- [Quick Start →](quick-start.md) — crie e execute um projeto em minutos
- [Primeiro Fluxo →](first-flow.md) — entenda a estrutura completa de um fluxo
