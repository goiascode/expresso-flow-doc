# exflow add

Adiciona pacotes, bundles ou canais do repositório Expresso Flow ao projeto atual.

---

## Sintaxe

```bash
exflow add <PACOTE> [PACOTES...] [OPÇÕES]
```

## Argumentos

| Argumento | Obrigatório | Descrição |
|-----------|-------------|-----------|
| `PACOTE` | Sim | Nome do pacote a instalar (um ou mais) |

## Opções

| Opção | Descrição |
|-------|-----------|
| `--no-configure` | Instala o pacote sem configurar automaticamente o `main.py` |

---

## Exemplo

```bash
# Adicionar o bundle WebFlow
exflow add webflow

# Adicionar múltiplos pacotes
exflow add whatsapp telegram

# Sem configuração automática
exflow add chatweb --no-configure
```

O comando `add` instala o pacote via pip no ambiente virtual do projeto e, quando possível, atualiza o `main.py` com o código de registro do bundle.

---

## Aliases de pacotes

| Alias | Pacote completo |
|-------|----------------|
| `webflow` | `exflow-webflow` |
| `whatsapp` | `exflow-whatsapp` |
| `telegram` | `exflow-telegram` |
| `chatweb` | `exflow-chatweb` |

---

## Próximos passos

- [Bundles →](../../core/bundles.md)
- [Canais →](../../core/channels/index.md)
