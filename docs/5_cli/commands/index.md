# Referência de Comandos

Referência completa de todos os comandos disponíveis na CLI `exflow`.

---

## Uso

```text
exflow [command]
```

## Comandos disponíveis

| Comando | Descrição |
|---------|-----------|
| [`add`](add.md) | Operações de adição (pacotes, bundles, canais) |
| [`build`](build.md) | Empacota o projeto atual em um arquivo `.pkg` |
| [`config`](config.md) | Gerencia a configuração do Expresso Flow |
| [`create`](new.md) | Operações de criação de projetos e componentes |
| [`download`](download.md) | Baixa um arquivo temporário pelo UUID na pasta atual |
| `help` | Exibe ajuda sobre qualquer comando |
| [`publish`](publish.md) | Publica o pacote `.pkg` via link temporário |
| [`run`](run.md) | Inicia o daemon do Expresso Flow |
| `version` | Exibe a versão instalada da CLI |

---

## Flags globais

| Flag | Tipo | Padrão | Descrição |
|------|------|--------|-----------|
| `--config` | `string` | `"config.yaml"` | Caminho para o arquivo de configuração |
| `-h, --help` | — | — | Ajuda sobre o comando do exflow |

---

## Próximos passos

* [Configuração do `config.yaml`](../configuration.md)
* [Instalação da CLI](../installation.md)
