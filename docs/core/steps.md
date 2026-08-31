# Steps

**Steps** são as etapas de um fluxo. Cada step é um método `async` da classe `Flow` responsável por enviar mensagens e/ou aguardar a entrada do usuário.

---

## Definindo Steps

```python
from expresso_flow.flow import Flow
from expresso_flow.step import Step, Message


class MeuFlow(Flow):

    @Step.entry           # Ponto de entrada obrigatório
    async def inicio(self, ctx):
        await ctx.send(Message.text("Qual é o seu nome?"))
        ctx.goto(self.receber_nome)

    async def receber_nome(self, ctx):
        entrada = await ctx.wait_input()
        await ctx.send(Message.text(f"Olá, {entrada.text}!"))
        ctx.end()
```

---

## Decoradores de Step

| Decorador | Descrição |
|-----------|-----------|
| `@Step.entry` | Marca o step como ponto de entrada do flow. Obrigatório — exatamente um por Flow. |
| `@Step.timeout` | Executado quando a sessão do usuário expira por inatividade. |
| `@Step.error` | Executado quando ocorre uma exceção não tratada dentro do flow. |

---

## Navegação entre Steps

### `ctx.goto(step)`

Navega para o próximo step da mesma sessão:

```python
ctx.goto(self.proximo_step)
```

### `ctx.end()`

Encerra o fluxo para a sessão atual:

```python
ctx.end()
```

### `ctx.restart()`

Reinicia o fluxo do zero para a sessão atual (volta ao `@Step.entry`):

```python
ctx.restart()
```

### `ctx.redirect_flow(slug)`

Encerra o fluxo atual e inicia outro fluxo para a sessão:

```python
await ctx.redirect_flow("suporte")
```

---

## Aguardando entrada do usuário

### `ctx.wait_input()`

Suspende o step e aguarda uma mensagem do usuário:

```python
entrada = await ctx.wait_input()
print(entrada.text)       # Texto da mensagem
print(entrada.type)       # Tipo: "text", "image", "audio", etc.
print(entrada.raw)        # Payload bruto do canal
```

### Timeout por step

```python
entrada = await ctx.wait_input(timeout=60)  # 60 segundos
if entrada is None:
    await ctx.send(Message.text("Tempo esgotado!"))
    ctx.end()
```

---

## Enviando mensagens

### `ctx.send(message)`

```python
await ctx.send(Message.text("Olá!"))
```

Consulte a referência de [`Message`](../api/flow.md) para todos os tipos de mensagem disponíveis (texto, imagem, botões, lista, etc.).

---

## Sessão do usuário

O objeto `ctx.session` é um dicionário que persiste durante toda a sessão do usuário no fluxo atual:

```python
ctx.session["nome"] = "João"
# ...em outro step:
nome = ctx.session.get("nome", "usuário")
```

---

## Exemplo: fluxo com tratamento de erro e timeout

```python
class FluxoRobusto(Flow):

    @Step.entry
    async def inicio(self, ctx):
        await ctx.send(Message.text("Digite um número:"))
        ctx.goto(self.processar)

    async def processar(self, ctx):
        entrada = await ctx.wait_input(timeout=30)
        if entrada is None:
            ctx.goto(self.timeout_handler)
            return
        try:
            numero = int(entrada.text)
            await ctx.send(Message.text(f"O dobro é {numero * 2}"))
            ctx.end()
        except ValueError:
            await ctx.send(Message.text("Isso não é um número válido. Tente novamente."))
            ctx.goto(self.processar)

    @Step.timeout
    async def timeout_handler(self, ctx):
        await ctx.send(Message.text("Sessão encerrada por inatividade. Até mais!"))
        ctx.end()

    @Step.error
    async def error_handler(self, ctx, error):
        await ctx.send(Message.text("Ocorreu um erro inesperado. Reiniciando..."))
        ctx.restart()
```

---

## Próximos passos

- [Bundles →](bundles.md)
- [Canais →](channels/index.md)
- [Referência de API — Step →](../api/step.md)
