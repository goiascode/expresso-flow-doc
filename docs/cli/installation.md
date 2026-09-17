# Instalação da CLI

A CLI do Expresso Flow é distribuída como um **binário independente**, sem necessidade de Python instalado na máquina.

---

## Download

Consulte a página de [Downloads](../downloads/index.md) para todos os links de download ou use os comandos abaixo para baixar o executável e o arquivo de configuração `config.yaml`:

=== ":fontawesome-brands-apple: macOS"

    ```bash
    curl -L https://exflow.run/bin/macos/exflow -o /usr/local/bin/exflow
    chmod +x /usr/local/bin/exflow
    curl -L https://exflow.run/bin/config.yaml -o /usr/local/bin/config.yaml
    ```

    Verifique a instalação:

    ```bash
    exflow version
    ```

=== ":fontawesome-brands-linux: Linux"

    ```bash
    curl -L https://exflow.run/bin/linux/exflow -o /usr/local/bin/exflow
    chmod +x /usr/local/bin/exflow
    curl -L https://exflow.run/bin/config.yaml -o /usr/local/bin/config.yaml
    ```

    Verifique a instalação:

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
