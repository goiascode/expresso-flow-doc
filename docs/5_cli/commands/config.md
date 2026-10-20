# exflow config

Gerencia as configurações e parâmetros operacionais do Expresso Flow e da CLI.

---

## Sintaxe

```bash
exflow config [SUB-COMANDO / OPÇÕES]
```

## Opções

| Opção | Padrão | Descrição |
|-------|--------|-----------|
| `--config <arquivo>` | `config.yaml` | Caminho para o arquivo de configuração |
| `-h, --help` | — | Exibe ajuda sobre o comando |

---

## Descrição

O comando `exflow config` permite inspecionar, validar ou atualizar as definições de ambiente e credenciais armazenadas no arquivo [`config.yaml`](../configuration.md).

Para conhecer todos os campos suportados (como `account`, `router`, `host`, `flow` e `msgrelay`), consulte a página dedicada à [Configuração da CLI](../configuration.md).

---

## Próximos passos

* [Estrutura completa do `config.yaml`](../configuration.md)
* [Comando `exflow run`](run.md)
