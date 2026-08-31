# Primeiro Fluxo

Neste guia você construirá um fluxo conversacional completo — com múltiplos steps, condicionais e coleta de dados — para entender os conceitos fundamentais do Expresso Flow.

---

## Conceitos principais

| Conceito | Descrição |
|----------|-----------|
| **Flow** | Uma conversa completa, composta por um ou mais steps. |
| **Step** | Uma etapa da conversa — envia mensagens e/ou aguarda entrada do usuário. |
| **Context (`ctx`)** | Objeto disponível em cada step com acesso ao canal, sessão e utilitários. |
| **Message** | Abstração de mensagem multi-canal (texto, imagem, botões, etc.). |

---

## Estrutura do projeto

```
meu-projeto/
├── main.py          # Bootstrap do ExpressoFlow
├── flows/
│   └── cadastro.py  # Seu fluxo de exemplo
└── pyproject.toml
```

---

## Construindo o fluxo

### 1. Definindo o fluxo

```python title="flows/cadastro.py"
from expresso_flow.flow import Flow
from expresso_flow.step import Step, Message


class CadastroFlow(Flow):
    """Fluxo de cadastro de usuário."""

    @Step.entry
    async def boas_vindas(self, ctx):
        await ctx.send(Message.text("Bem-vindo ao cadastro! 👋\nQual é o seu nome?"))
        ctx.goto(self.coletar_nome)  # (1)!

    async def coletar_nome(self, ctx):
        nome = await ctx.wait_input()
        ctx.session["nome"] = nome.text  # (2)!
        await ctx.send(Message.text(f"Olá, {nome.text}! Qual é o seu e-mail?"))
        ctx.goto(self.coletar_email)

    async def coletar_email(self, ctx):
        email = await ctx.wait_input()

        if "@" not in email.text:  # (3)!
            await ctx.send(Message.text("E-mail inválido. Por favor, tente novamente."))
            ctx.goto(self.coletar_email)
            return

        ctx.session["email"] = email.text
        ctx.goto(self.finalizar)

    async def finalizar(self, ctx):
        nome = ctx.session["nome"]
        email = ctx.session["email"]
        await ctx.send(
            Message.text(f"✅ Cadastro concluído!\nNome: {nome}\nE-mail: {email}")
        )
        ctx.end()  # (4)!
```

1. `ctx.goto()` navega para o próximo step do fluxo.
2. `ctx.session` é um dicionário persistido durante toda a sessão do usuário naquele fluxo.
3. Validações são feitas diretamente em Python — sem DSL específica.
4. `ctx.end()` encerra o fluxo para aquela sessão de usuário.

### 2. Registrando o fluxo no bootstrap

```python title="main.py"
from expresso_flow import ExpressoFlow
from flows.cadastro import CadastroFlow

app = ExpressoFlow()

app.flow("cadastro")(CadastroFlow)  # (1)!

if __name__ == "__main__":
    app.run()
```

1. O primeiro argumento é o **slug** do fluxo — identificador único usado pelos canais para roteamento.

### 3. Executando

```bash
python main.py
# ou
exflow run
```

---

## Próximos passos

- [Core — Flows](../core/flows.md) — referência completa sobre flows e steps
- [Core — Bootstrap](../core/bootstrap.md) — como configurar o `ExpressoFlow`
- [Canais](../core/channels/index.md) — conecte seu fluxo ao WhatsApp, Telegram e outros
