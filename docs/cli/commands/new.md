# exflow new

Cria um novo projeto Expresso Flow com a estrutura de diretórios padrão, ambiente virtual configurado e dependências instaladas.

---

## Sintaxe

```bash
exflow new <NOME_DO_PROJETO> [OPÇÕES]
```

## Argumentos

| Argumento | Obrigatório | Descrição |
|-----------|-------------|-----------|
| `NOME_DO_PROJETO` | Sim | Nome do projeto e da pasta a ser criada |

## Opções

| Opção | Padrão | Descrição |
|-------|--------|-----------|
| `--template` | `default` | Template de projeto a usar |
| `--no-venv` | `false` | Não cria ambiente virtual automaticamente |
| `--no-install` | `false` | Não instala dependências após criar o projeto |

---

## Exemplo

```bash
exflow new meu-chatbot
cd meu-chatbot
```

### Estrutura gerada

```
meu-chatbot/
├── .venv/               # Ambiente virtual Python
├── flows/
│   └── __init__.py
├── main.py              # Bootstrap da aplicação
├── pyproject.toml       # Metadados e dependências
├── .env                 # Variáveis de ambiente
└── .gitignore
```

---

## Próximos passos

- [exflow run →](run.md)
- [exflow add →](add.md)
