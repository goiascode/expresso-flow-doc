# Instalação da CLI

A CLI do Expresso Flow é distribuída como um **binário independente**, sem necessidade de Python instalado na máquina para sua própria execução.

!!! info "Desenvolvimento de projetos"
    Embora o binário do `exflow` seja independente, os projetos e fluxos gerados e executados por ele utilizam Python. Certifique-se de ter o **Python 3.12 ou superior** instalado para executar seus projetos ([ver tutorial](../2_getting_started/installation.md#instalacao-python)).

---

## Download

Consulte a página de [Downloads](../3_downloads/index.md) para todos os links de download ou use os comandos abaixo para baixar o executável e o arquivo de configuração `config.yaml`:

=== ":fontawesome-brands-apple: macOS"

    ```bash
    curl -L https://exflow.run/bin/macos/exflow -o /usr/local/bin/exflow
    chmod +x /usr/local/bin/exflow
    ```

    ### Baixar o config.yaml

    ```bash
    curl -L https://exflow.run/bin/config.yaml -o /usr/local/bin/config.yaml
    ```

    ### Verificar instalação

    ```bash
    exflow version
    ```

    !!! warning "Gatekeeper (macOS)"
        Na primeira execução, o macOS pode exibir um aviso de segurança. Para autorizar:

        ```bash
        xattr -d com.apple.quarantine /usr/local/bin/exflow
        ```

        Ou acesse **Preferências do Sistema → Segurança e Privacidade → Geral** e clique em **Permitir mesmo assim**.

=== ":fontawesome-brands-linux: Linux"

    ```bash
    curl -L https://exflow.run/bin/linux/exflow -o /usr/local/bin/exflow
    chmod +x /usr/local/bin/exflow
    ```

    ### Baixar o config.yaml

    ```bash
    curl -L https://exflow.run/bin/config.yaml -o /usr/local/bin/config.yaml
    ```

    ### Verificar instalação

    ```bash
    exflow version
    ```

=== ":fontawesome-brands-windows: Windows"

    1. Baixe o executável em [https://exflow.run/bin/windows/exflow.exe](https://exflow.run/bin/windows/exflow.exe)
    2. Baixe o arquivo de configuração em [https://exflow.run/bin/config.yaml](https://exflow.run/bin/config.yaml)
    3. Crie uma pasta dedicada (por exemplo `$env:USERPROFILE\.local\bin`) e mova o `exflow.exe` e o `config.yaml` para lá.
    4. Adicione essa pasta ao **PATH**:

        ```powershell
        [System.Environment]::SetEnvironmentVariable(
            "PATH",
            "$env:USERPROFILE\.local\bin;" + [System.Environment]::GetEnvironmentVariable("PATH", "User"),
            "User"
        )
        ```

    5. Feche e reabra o terminal, depois verifique:

    ```powershell
    exflow version
    ```

!!! important "Configuração do config.yaml"
    Para utilizar o comando `exflow run` e iniciar o daemon local integrado ao WhatsApp, é necessário preencher suas credenciais (`access_id`, `access_key`) e personalizar o `host` dentro do `config.yaml`. Consulte a [página de Configuração](configuration.md) para o guia completo.

---

## Atualizando a CLI

Para atualizar para a versão mais recente, repita o comando de download acima. O binário novo substituirá o existente.

---

## Próximos passos

* [Configuração da CLI (`config.yaml`) →](configuration.md)
* [exflow run (Iniciar o daemon) →](commands/run.md)
* [exflow create →](commands/new.md)
