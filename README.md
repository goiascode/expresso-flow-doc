# Expresso Flow — Documentação

Repositório da documentação oficial do **Expresso Flow** (`exflow`) — framework Python 3.12 para construção de fluxos conversacionais em múltiplos canais de comunicação.

Site: [https://exflow.run](https://exflow.run)

---

## Executando a documentação localmente

### Pré-requisitos

- Python 3.12+
- pip

### Instalação das dependências

```bash
pip install -r requirements.txt
```

### Servir com hot-reload

```bash
mkdocs serve
```

Acesse em `http://127.0.0.1:8000`.

### Build estático

```bash
mkdocs build
```

Os arquivos estáticos são gerados em `./site/`.

---

## Estrutura

```
docs/
├── index.md                    # Página inicial
├── 2_getting_started/          # Instalação, Quick Start, Primeiro Fluxo
├── 3_downloads/                # Downloads da CLI por plataforma
├── 4_expresso_flow/            # Documentação do Core (ExpressoFlow)
│   └── channels/               # Canais (WhatsApp, Telegram, ChatWeb)
├── 5_cli/                      # CLI (exflow)
│   └── commands/               # Referência de comandos
├── 6_webflow/                  # Bundle WebFlow
├── 7_referencia_api/           # Referência de API
└── changelog.md
```

---

## Contribuindo

As seções marcadas com `!!! note "Em construção"` estão aguardando informações detalhadas do time de desenvolvimento. Para contribuir, abra uma issue ou PR no repositório da documentação.
