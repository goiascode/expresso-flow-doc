---
hide:
  - toc
---

# Downloads — Expresso Flow CLI

Baixe o binário da CLI para o seu sistema operacional. Não é necessário ter Python instalado.

---

## Versão atual

| Plataforma | Arquivo | Link |
|------------|---------|------|
| :fontawesome-brands-windows: Windows | `exflow.exe` | [:material-download: Download](https://exflow.run/bin/windows/exflow.exe) |
| :fontawesome-brands-linux: Linux | `exflow` | [:material-download: Download](https://exflow.run/bin/linux/exflow) |
| :fontawesome-brands-apple: macOS | `exflow` | [:material-download: Download](https://exflow.run/bin/macos/exflow) |

---

## Instruções de instalação

=== ":fontawesome-brands-apple: macOS"

    ### Via terminal (recomendado)

    ```bash
    curl -L https://exflow.run/bin/macos/exflow -o /usr/local/bin/exflow
    chmod +x /usr/local/bin/exflow
    ```

    ### Verificar instalação

    ```bash
    exflow --version
    ```

    !!! warning "Gatekeeper (macOS)"
        Na primeira execução, o macOS pode exibir um aviso de segurança. Para autorizar:

        ```bash
        xattr -d com.apple.quarantine /usr/local/bin/exflow
        ```

        Ou acesse **Preferências do Sistema → Segurança e Privacidade → Geral** e clique em **Permitir mesmo assim**.

=== ":fontawesome-brands-linux: Linux"

    ### Via terminal (recomendado)

    ```bash
    curl -L https://exflow.run/bin/linux/exflow -o /usr/local/bin/exflow
    chmod +x /usr/local/bin/exflow
    ```

    ### Verificar instalação

    ```bash
    exflow --version
    ```

    !!! tip "Sem permissão em `/usr/local/bin`?"
        Use `~/.local/bin` e garanta que está no seu `PATH`:

        ```bash
        curl -L https://exflow.run/bin/linux/exflow -o ~/.local/bin/exflow
        chmod +x ~/.local/bin/exflow
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        source ~/.bashrc
        ```

=== ":fontawesome-brands-windows: Windows"

    ### Download direto

    [:material-download: Baixar exflow.exe](https://exflow.run/bin/windows/exflow.exe){ .md-button .md-button--primary }

    ### Via PowerShell

    ```powershell
    # Cria a pasta e baixa o executável
    New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.exflow\bin"
    Invoke-WebRequest -Uri https://exflow.run/bin/windows/exflow.exe `
        -OutFile "$env:USERPROFILE\.exflow\bin\exflow.exe"

    # Adiciona ao PATH do usuário (permanente)
    [System.Environment]::SetEnvironmentVariable(
        "PATH",
        "$env:USERPROFILE\.exflow\bin;$([System.Environment]::GetEnvironmentVariable('PATH','User'))",
        "User"
    )
    ```

    Feche e reabra o terminal, depois verifique:

    ```powershell
    exflow --version
    ```

    !!! tip "Por que configurar o PATH?"
        Com o `exflow` no PATH você pode abrir o terminal em qualquer pasta e executar
        `exflow create project --name meu-projeto` diretamente, sem precisar navegar
        até onde o executável está salvo.

---

## Próximos passos

- [CLI — Introdução →](../cli/index.md)
- [exflow create →](../cli/commands/new.md)
