# Instalação

O **Expresso Flow** é um framework construído em Python 3.12. Para desenvolver e executar seus fluxos, é necessário ter o interpretador Python instalado e configurado no sistema antes de prosseguir com a instalação do framework.

---

## 1. Pré-requisito: Instalando o Python 3.12+ {: #instalacao-python }

Antes de instalar o Expresso Flow, certifique-se de que o **Python 3.12 ou superior** está instalado e configurado no `PATH` do seu sistema operacional.

### Verificar se o Python já está instalado

Abra o terminal e execute:

=== "Windows (PowerShell)"

    ```powershell
    python --version
    ```

=== "Linux / macOS"

    ```bash
    python3 --version
    ```

* Se a saída for **Python 3.12.x** (ou superior), seu ambiente já atende ao requisito e você pode pular diretamente para a [Instalação do Core](#2-core-exflow).
* Se a versão for inferior a 3.12 ou o comando não for reconhecido, siga o tutorial abaixo para o seu sistema:

### Tutorial de Instalação por Sistema Operacional

=== ":fontawesome-brands-windows: Windows"

    1. **Download do Instalador**:
        Acesse a página oficial em [python.org/downloads/windows](https://www.python.org/downloads/windows/) e baixe o instalador do **Python 3.12+** (*Windows installer 64-bit*).
        
        *(Opcional via terminal)* Se você utiliza o Windows Package Manager:
        ```powershell
        winget install Python.Python.3.12
        ```

    2. **Atenção na primeira tela do Instalador (Crucial)**:
        Ao abrir o executável de instalação:
        
        !!! danger "Obrigatório: Marcar 'Add python.exe to PATH'"
            Na primeira janela do instalador, **habilite obrigatoriamente a caixa de seleção**:  
            :white_check_mark: **Add python.exe to PATH**  
            Sem essa opção marcada, o terminal não reconhecerá os comandos `python` e `pip`.

    3. **Concluir a instalação**:
        Clique em **Install Now**. Ao término, se for apresentada a opção **"Disable path length limit"**, clique nela para desativar a limitação de caracteres no tamanho de caminhos do Windows.

    4. **Validar no terminal**:
        Feche e abra novamente o **PowerShell** e confirme:
        ```powershell
        python --version
        pip --version
        ```

=== ":fontawesome-brands-apple: macOS"

    1. **Via Homebrew (Recomendado)**:
        Se você já usa o gerenciador [Homebrew](https://brew.sh), basta executar:
        ```bash
        brew install python@3.12
        ```

    2. **Via Instalador Oficial**:
        Acesse [python.org/downloads/macos](https://www.python.org/downloads/macos/) e faça o download do pacote oficial `.pkg` do Python 3.12+. Abra o arquivo baixado e siga as orientações do assistente.

    3. **Validar no terminal**:
        Abra o Terminal e confirme:
        ```bash
        python3 --version
        pip3 --version
        ```

=== ":fontawesome-brands-linux: Linux"

    A maioria das distribuições modernas disponibiliza o Python 3.12 nos repositórios oficiais:

    **Ubuntu 24.04 LTS / Debian 13+**:
    ```bash
    sudo apt update
    sudo apt install -y python3 python3-pip python3-venv
    ```

    **Ubuntu 22.04 LTS (via PPA Deadsnakes)**:
    ```bash
    sudo add-apt-repository ppa:deadsnakes/ppa -y
    sudo apt update
    sudo apt install -y python3.12 python3.12-venv python3.12-dev python3-pip
    ```

    **Fedora 39+ / RHEL / CentOS**:
    ```bash
    sudo dnf install -y python3.12 python3-pip
    ```

    **Arch Linux**:
    ```bash
    sudo pacman -S python python-pip
    ```

    **Validar no terminal**:
    ```bash
    python3 --version
    ```

---

## 2. Core — `exflow`

O pacote principal do framework é instalado via **pip** a partir do repositório oficial:

```bash
pip install --index-url https://exflow.run/simple exflow
```

### Ambiente virtual (recomendado)

=== "venv (padrão)"

    ```bash
    python -m venv .venv
    source .venv/bin/activate        # Linux / macOS
    .venv\Scripts\activate           # Windows

    pip install --index-url https://exflow.run/simple exflow
    ```

=== "uv"

    ```bash
    uv venv
    uv pip install --index-url https://exflow.run/simple exflow
    ```

### Instalando as dependências do projeto

O `requirements.txt` gerado pelo CLI já inclui o índice correto:

```text title="requirements.txt"
--index-url https://exflow.run/simple --trusted-host exflow.run

exflow
webflow-bundle
python-dotenv
```

Para instalar:

```bash
pip install -r requirements.txt
```

---

## 3. Bundles adicionais

Os bundles ampliam o core com canais e ferramentas. Todos são instalados pelo mesmo repositório:

```bash
pip install --index-url https://exflow.run/simple <NOME_DO_PACOTE>
```

| Pacote | Descrição |
|--------|----------|
| `webflow-bundle` | Interface web para debug e teste local |
| `exflow-whatsapp` | Canal WhatsApp |

!!! info "Repositório privado"
    O índice `https://exflow.run/simple` é o repositório oficial do Expresso Flow. Todos os pacotes do framework são publicados exclusivamente neste índice.

---

## 4. CLI — `exflow`

A CLI é distribuída como um binário independente (sem necessidade de Python instalado) para cada plataforma.

Consulte a página de [Downloads](../3_downloads/index.md) para instruções detalhadas por sistema operacional, ou acesse a [documentação da CLI](../5_cli/index.md).

---

## Próximos passos

- [Quick Start →](quick-start.md) — crie e execute um projeto em minutos
- [Primeiro Fluxo →](first-flow.md) — entenda a estrutura completa de um fluxo
