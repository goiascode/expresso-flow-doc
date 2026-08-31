# exflow build

Empacota o projeto para **deploy em produção**, gerando um artefato otimizado.

---

## Sintaxe

```bash
exflow build [OPÇÕES]
```

## Opções

| Opção | Padrão | Descrição |
|-------|--------|-----------|
| `--output` | `./dist` | Diretório de saída |
| `--clean` | `false` | Remove o diretório de saída antes de buildar |

---

## Exemplo

```bash
exflow build
exflow build --output ./deploy --clean
```

!!! note "Em construção"
    A documentação detalhada do processo de build e opções de deploy será publicada em breve.
