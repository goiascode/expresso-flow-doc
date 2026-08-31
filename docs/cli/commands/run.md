# exflow run

Executa o projeto Expresso Flow em modo desenvolvimento com **hot-reload** e logs em tempo real.

---

## Sintaxe

```bash
exflow run [OPÇÕES]
```

## Opções

| Opção | Padrão | Descrição |
|-------|--------|-----------|
| `--host` | `0.0.0.0` | Host de escuta |
| `--port` | `8000` | Porta principal |
| `--reload` | `true` | Ativa hot-reload ao salvar arquivos |
| `--no-reload` | — | Desativa hot-reload |
| `--env-file` | `.env` | Caminho para o arquivo de variáveis de ambiente |

---

## Exemplo

```bash
# Na raiz do projeto:
exflow run

# Com porta customizada:
exflow run --port 9000

# Sem hot-reload:
exflow run --no-reload
```

---

## Próximos passos

- [exflow build →](build.md)
- [exflow add →](add.md)
