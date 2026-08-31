# Depuração com WebFlow

O WebFlow oferece ferramentas específicas para inspecionar e depurar seus flows durante o desenvolvimento.

---

## Inspecionando a sessão

O painel **Sessão** exibe o conteúdo atual de `ctx.session` em tempo real, atualizado a cada step executado.

---

## Log de steps

O painel **Steps** registra cada step executado na sessão ativa, incluindo:

- Nome do step
- Timestamp de execução
- Mensagens enviadas e recebidas
- Eventuais exceções capturadas

---

## Simulando cenários

| Ação | Como fazer |
|------|-----------|
| Reiniciar sessão | Botão **Reiniciar** no painel de controles |
| Simular timeout | Botão **Timeout** — dispara o `@Step.timeout` handler |
| Injetar erro | Botão **Erro** — dispara o `@Step.error` handler |
| Trocar de flow | Selecione outro flow no painel lateral e inicie nova sessão |

---

## Dicas

!!! tip "Debug mode"
    Ative `debug=True` no `ExpressoFlow` ou `WebFlowBundle` para ver informações extras de roteamento e estado interno nos logs do terminal.

!!! tip "Múltiplas sessões"
    Abra múltiplas abas do navegador para simular múltiplos usuários simultâneos no mesmo flow.

---

## Próximos passos

- [Flows →](../core/flows.md)
- [Steps →](../core/steps.md)
