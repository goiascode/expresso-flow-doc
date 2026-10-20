# exflow publish

Publica o pacote `.pkg` gerado pelo comando `build` e disponibiliza um link temporário para download.

---

## Sintaxe

```bash
exflow publish [ARQUIVO.pkg] [OPÇÕES]
```

## Opções

| Opção | Padrão | Descrição |
|-------|--------|-----------|
| `--config <arquivo>` | `config.yaml` | Caminho para o arquivo de configuração |
| `-h, --help` | — | Exibe ajuda sobre o comando |

---

## Descrição

O comando `exflow publish` envia o arquivo `.pkg` para o repositório temporário do Expresso Flow e gera um identificador único (UUID) e um link de acesso com tempo de expiração determinado.

Esse link e UUID podem ser utilizados por outros desenvolvedores ou ambientes para baixar o pacote usando o comando [`exflow download`](download.md).

---

## Exemplo

```bash
# Publica o arquivo .pkg gerado anteriormente
exflow publish meu-projeto.pkg
```

Saída esperada:
```text
Enviando pacote meu-projeto.pkg...
Pacote publicado com sucesso!
UUID: <<UUID_AQUI>>
Link temporário: https://exflow.run/pkg/<<UUID_AQUI>>
```

---

## Próximos passos

* [Comando `exflow download`](download.md)
* [Comando `exflow build`](build.md)
