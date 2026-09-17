# Expresso Flow CLI

A **CLI do Expresso Flow** (`exflow`) é a ferramenta oficial de linha de comando para criação, configuração, empacotamento, publicação e execução de projetos do framework. Está disponível para **Windows**, **Linux** e **macOS** como binário independente — sem necessidade de Python instalado.

---

## Instalação e Configuração

1. Consulte a página de [Downloads](../downloads/index.md) para obter o executável e o arquivo `config.yaml`.
2. Baixe o `config.yaml` em [https://exflow.run/bin/config.yaml](https://exflow.run/bin/config.yaml) e mantenha-o no mesmo diretório do executável.
3. Configure suas credenciais (`access_id`, `access_key`) e seu `host` conforme detalhado na página de [Configuração da CLI](configuration.md).

---

## Comandos disponíveis

```text
Usage:
  exflow [command]
```

| Comando | Descrição |
|---------|-----------|
| [`exflow add`](commands/add.md) | Operações de adição de pacotes e bundles |
| [`exflow build`](commands/build.md) | Empacota o projeto atual em um arquivo `.pkg` |
| [`exflow config`](commands/config.md) | Gerencia a configuração do Expresso Flow |
| [`exflow create`](commands/new.md) | Operações de criação de projetos |
| [`exflow download`](commands/download.md) | Baixa um arquivo temporário pelo UUID na pasta atual |
| [`exflow publish`](commands/publish.md) | Publica o pacote `.pkg` via link temporário |
| [`exflow run`](commands/run.md) | Inicia o daemon do Expresso Flow (conecta ao Router e WhatsApp) |
| `exflow version` | Exibe a versão do exflow |
| `exflow help` | Exibe ajuda sobre qualquer comando |

---

## Flags globais

| Flag | Descrição |
|------|-----------|
| `--config string` | Caminho para o arquivo de configuração (padrão: `"config.yaml"`) |
| `-h, --help` | Ajuda sobre o comando |

---

## Uso básico

```bash
# 1. Verificar versão
exflow version

# 2. Criar novo projeto
exflow create project --name meu-projeto

# 3. Iniciar o daemon (requer config.yaml na mesma pasta ou via --config)
exflow run

# 4. Empacotar o projeto em .pkg
exflow build

# 5. Publicar o pacote com link temporário
exflow publish meu-projeto.pkg
```

---

## Seções da documentação da CLI

<div class="grid cards" markdown>

- :material-download: **[Instalação](installation.md)**

    Download e configuração do binário por plataforma.

- :material-cog: **[Configuração (config.yaml)](configuration.md)**

    Credenciais de acesso, configuração de host e integração com WhatsApp.

- :material-plus-box: **[exflow create](commands/new.md)**

    Cria a estrutura completa de um novo projeto.

- :material-play: **[exflow run](commands/run.md)**

    Inicia o daemon e o túnel com o Router e WhatsApp.

- :material-package-variant-plus: **[exflow add](commands/add.md)**

    Adiciona pacotes e bundles ao projeto existente.

- :material-archive-arrow-up: **[exflow build & publish](commands/build.md)**

    Empacota em `.pkg` e publica links temporários de distribuição.

</div>
