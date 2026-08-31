# Expresso Flow CLI

A **CLI do Expresso Flow** (`exflow`) é uma ferramenta de linha de comando para criação, configuração, execução e build de projetos. Está disponível para **Windows**, **Linux** e **macOS** como binário independente — sem necessidade de Python instalado.

---

## Instalação

Consulte a página de [Downloads](../downloads/index.md) para instalar o binário da sua plataforma.

---

## Comandos disponíveis

| Comando | Descrição |
|---------|-----------|
| [`exflow create`](commands/new.md) | Cria um novo projeto Expresso Flow |
| [`exflow run`](commands/run.md) | Executa o projeto em modo desenvolvimento |
| [`exflow build`](commands/build.md) | Prepara o projeto para produção |
| [`exflow add`](commands/add.md) | Adiciona bundles, canais e pacotes ao projeto |

---

## Uso básico

```bash
# Criar novo projeto
exflow create project --name meu-projeto

# Entrar na pasta e executar
cd meu-projeto
exflow run

# Adicionar um bundle
exflow add webflow
```

---

## Versão e ajuda

```bash
exflow --version
exflow --help
exflow <comando> --help
```

---

## Seções desta documentação

<div class="grid cards" markdown>

- :material-download: **[Instalação](installation.md)**

    Download e configuração do binário por plataforma.

- :material-plus-box: **[exflow create](commands/new.md)**

    Cria a estrutura completa de um novo projeto.

- :material-play: **[exflow run](commands/run.md)**

    Executa o projeto com hot-reload e logs em tempo real.

- :material-package-variant-plus: **[exflow add](commands/add.md)**

    Adiciona pacotes e bundles ao projeto existente.

- :material-hammer-wrench: **[exflow build](commands/build.md)**

    Empacota o projeto para deploy em produção.

</div>
