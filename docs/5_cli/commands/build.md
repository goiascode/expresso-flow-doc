# exflow build

Empacota o projeto atual em um arquivo de pacote compactado com extensão `.pkg`.

---

## Sintaxe

```bash
exflow build [OPÇÕES]
```

## Opções

| Opção | Padrão | Descrição |
|-------|--------|-----------|
| `--config <arquivo>` | `config.yaml` | Caminho para o arquivo de configuração |
| `-h, --help` | — | Exibe ajuda sobre o comando |

---

## Descrição

O comando `exflow build` inspeciona a estrutura do projeto do Expresso Flow e gera um arquivo `.pkg` contendo todos os fluxos, dependências e metadados necessários para distribuição ou deploy.

O arquivo `.pkg` gerado pode posteriormente ser publicado e compartilhado através de um link temporário utilizando o comando [`exflow publish`](publish.md).

---

## Exemplo

```bash
# Na raiz do projeto:
exflow build
```

Saída esperada:
```text
Compilando projeto...
Pacote gerado com sucesso: meu-projeto.pkg
```

---

## Próximos passos

* [Comando `exflow publish` (publicar pacote)](publish.md)
* [Comando `exflow download` (baixar pacote)](download.md)
