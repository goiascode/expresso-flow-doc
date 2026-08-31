# Instalação da CLI

A CLI do Expresso Flow é distribuída como um **binário independente**, sem necessidade de Python instalado na máquina.

---

## Download

Consulte a página de [Downloads](../downloads/index.md) para todos os links de download ou use os comandos abaixo:

=== ":fontawesome-brands-apple: macOS"

    ```bash
    curl -L https://exflow.run/bin/macos/exflow -o /usr/local/bin/exflow
    chmod +x /usr/local/bin/exflow
    ```

    Verifique a instalação:

    ```bash
    exflow --version
    ```

=== ":fontawesome-brands-linux: Linux"

    ```bash
    curl -L https://exflow.run/bin/linux/exflow -o /usr/local/bin/exflow
    chmod +x /usr/local/bin/exflow
    ```

    Verifique a instalação:

    ```bash
    exflow --version
    ```

=== ":fontawesome-brands-windows: Windows"

    1. Baixe o executável em [https://exflow.run/bin/windows/exflow.exe](https://exflow.run/bin/windows/exflow.exe)
    2. Mova `exflow.exe` para uma pasta incluída no `PATH` (ex: `C:\Windows\System32` ou crie uma pasta dedicada)
    3. Abra o **Prompt de Comando** ou **PowerShell** e verifique:

    ```powershell
    exflow --version
    ```

---

## Atualizando a CLI

Para atualizar para a versão mais recente, repita o comando de download acima. O binário novo substituirá o existente.

---

## Próximos passos

- [exflow new →](commands/new.md)
- [exflow run →](commands/run.md)
