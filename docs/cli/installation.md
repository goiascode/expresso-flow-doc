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
    2. Crie uma pasta dedicada, por exemplo `C:\exflow\bin`, e mova o `exflow.exe` para lá
    3. Adicione essa pasta ao **PATH do sistema** para que o `exflow` possa ser executado de qualquer diretório:

        **Via interface gráfica:**

        - Abra **Painel de Controle → Sistema → Configurações avançadas do sistema → Variáveis de Ambiente**
        - Em **Variáveis do sistema**, selecione `Path` e clique em **Editar**
        - Clique em **Novo** e adicione o caminho `C:\exflow\bin`
        - Confirme com **OK** em todas as janelas

        **Via PowerShell (como Administrador):**

        ```powershell
        [System.Environment]::SetEnvironmentVariable(
            "PATH",
            "$([System.Environment]::GetEnvironmentVariable('PATH','Machine'));C:\exflow\bin",
            "Machine"
        )
        ```

    4. Feche e reabra o terminal, depois verifique:

    ```powershell
    exflow --version
    ```

    !!! tip "Por que configurar o PATH?"
        Com o `exflow` no PATH, você pode abrir o terminal em qualquer pasta do seu computador e executar `exflow create project --name meu-projeto` diretamente, sem precisar navegar até onde o executável está salvo.

---

## Atualizando a CLI

Para atualizar para a versão mais recente, repita o comando de download acima. O binário novo substituirá o existente.

---

## Próximos passos

- [exflow create →](commands/new.md)
- [exflow run →](commands/run.md)
