# Depuração com WebFlow

O painel de **DEBUG** do WebFlow exibe em tempo real tudo que acontece durante a execução do flow — mensagens, steps, requisições e exceções.

---

## Aba Steps

A aba **Steps** é a principal ferramenta de debug. Cada vez que um step é executado, uma entrada é adicionada com as seguintes informações:

| Campo | Descrição |
|-------|-----------|
| `FLOW ID` | Identificador do flow (`id`) |
| `STEP #` | Número sequencial do step na thread de execução |
| `ORDER` | Índice `order` definido no `@step()` |
| `LABEL` | Rótulo definido no `@step()` — exibido como nome do step |
| `ELAPSED` | Tempo de execução do step |

### Status dos steps

| Status | Cor | Significado |
|--------|-----|-------------|
| `ACTIVE` | Laranja | Step em execução ou aguardando input do usuário |
| `COMPLETED` | Verde | Step concluído com sucesso |

### Exemplo de sequência

Uma conversa com 2 steps gera 3 entradas na aba Steps:

```
step  ACTIVE     MEU PRIMEIRO FLUXO   16:18:43
      FLOW ID    first_flow
      STEP #     0  |  ORDER  0
      LABEL      start
      ELAPSED    0.002s

step  ACTIVE     MEU PRIMEIRO FLUXO   16:20:37
      FLOW ID    first_flow
      STEP #     1  |  ORDER  1
      LABEL      on_user_input
      ELAPSED    0.002s

step  COMPLETED  MEU PRIMEIRO FLUXO   16:20:37
      FLOW ID    first_flow
      STEP #     1  |  ORDER  1
      LABEL      on_user_input
      ELAPSED    0s
```

> O step 0 aparece com status `ACTIVE` porque retornou `WaitUserInputAction()` — aguardando a resposta do usuário. Quando o usuário responde, o step 1 é executado e o flow é concluído.

---

## Aba Console

Exibe as mensagens enviadas e recebidas durante a sessão, com direção e timestamp:

- **`sent`** — mensagem enviada pelo usuário
- **`received`** — resposta do flow

Também exibe logs emitidos por `ctx.console.info()`, `ctx.console.warning()`, etc.

---

## Aba Requests

Registra requisições HTTP externas realizadas durante a execução — útil para depurar integrações com APIs, provedores de LLM e serviços externos.

---

## Aba Exceptions

Exibe exceções não tratadas capturadas pelo runtime do flow. Cada entrada mostra:

- Tipo da exceção
- Mensagem de erro
- Stack trace completo
- Step e flow em que ocorreu

---

## Dicas

!!! tip "Contador de eventos"
    O número ao lado de `DEBUG` (ex: `7`) indica o total de eventos registrados na sessão. Clique em **Clear** para reiniciar a contagem.

!!! tip "Múltiplas sessões"
    Abra múltiplas abas do navegador para simular usuários simultâneos no mesmo flow — cada aba mantém sua própria sessão e painel de debug independente.

!!! tip "Label dos steps"
    O campo `LABEL` na aba Steps exibe o valor do parâmetro `label` definido em `@step(order=N, label="...")`. Use labels descritivos para facilitar a identificação durante o debug.

---

## Próximos passos

- [Interface →](interface.md)
- [Steps →](../core/steps.md)
