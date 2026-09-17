# exflow download

Baixa um arquivo temporário (geralmente um pacote `.pkg` gerado por [`publish`](publish.md)) a partir de seu UUID diretamente na pasta atual.

---

## Sintaxe

```bash
exflow download <UUID> [OPÇÕES]
```

## Argumentos

| Argumento | Obrigatório | Descrição |
|-----------|-------------|-----------|
| `UUID` | Sim | Identificador único do arquivo temporário gerado no momento da publicação |

## Opções

| Opção | Padrão | Descrição |
|-------|--------|-----------|
| `--config <arquivo>` | `config.yaml` | Caminho para o arquivo de configuração |
| `-h, --help` | — | Exibe ajuda sobre o comando |

---

## Descrição

O comando `exflow download` recupera pacotes ou arquivos compartilhados temporariamente no repositório do Expresso Flow, salvando o arquivo resultante no diretório de trabalho atual.

---

## Exemplo

```bash
# Baixa o pacote pelo UUID fornecido:
exflow download 3f8b5c20-7d41-4e9b-968b-18a0a9f5d411
```

Saída esperada:
```text
Baixando pacote 3f8b5c20-7d41-4e9b-968b-18a0a9f5d411...
Arquivo salvo na pasta atual: meu-projeto.pkg
```

---

## Próximos passos

* [Comando `exflow publish`](publish.md)
* [Comando `exflow build`](build.md)
