# Primeiro Fluxo

Neste guia você entenderá a estrutura de um flow e construirá uma conversa completa passo a passo com a API real do Expresso Flow.

---

## Conceitos principais

| Conceito | Descrição |
|----------|-----------|
| **Flow** | Uma conversa completa, composta por steps numerados. |
| **Step** | Uma etapa da conversa — envia mensagens e/ou aguarda input do usuário. |
| **InteractionContext** | Objeto `ctx` disponível em cada step — acesso a `output` e `message`. |
| **Ação de retorno** | Valor retornado pelo step que controla o fluxo (`WaitUserInputAction`, `CompletedFlowAction`). |

---

## Estrutura do projeto

Após executar `exflow create project --name meu-projeto`, a estrutura gerada é:

```
meu-projeto/
├── app/
│   └── flows/
│       └── hellow/
│           └── hellow_flow.py
├── .env
├── main.py
├── README.md
└── requirements.txt
```

---

## Entendendo o flow gerado

O arquivo `hellow_flow.py` já criado pela CLI é o flow de exemplo do projeto:

```python title="app/flows/hellow/hellow_flow.py"
from exflow.flow import Flow, StepOptions, step, flow
from exflow.interaction import InteractionContext
from exflow.execution_action import CompletedFlowAction, WaitUserInputAction


@flow()                          # (1)!
class HellowFlow(Flow):
    """
    Flow de boas-vindas que apresenta o bot e coleta o nome do usuário.
    Utilizada como description pelo engine de intent para roteamento.
    """  # (2)!

    id = "first_flow"            # (3)!
    name = "Meu primeiro fluxo"  # (4)!

    @step(order=0, label="Boas-vindas", description="Apresenta o bot e solicita o nome do usuário")  # (5)!
    async def start(self, ctx: InteractionContext, options: StepOptions):
        await ctx.output.send_text(
            (
                "👋 Olá! Eu sou o *Expresso Flow*!\n\n"
                "Como posso te chamar? 😊\n"
            )
        )
        return WaitUserInputAction()  # (6)!

    @step(order=1, label="Receber nome", description="Recebe o nome digitado pelo usuário e encerra o flow")
    async def on_user_input(self, ctx: InteractionContext, options: StepOptions):
        user_input = ctx.message.get_text()  # (7)!

        await ctx.output.send_text(
            (
                f"🎉 Seja muito bem-vindo(a), *{user_input}*!\n\n"
                "Você acaba de rodar o seu primeiro fluxo com o *Expresso Flow* 🚀\n\n"
                "A partir daqui você pode criar fluxos com múltiplos passos,\n"
                "interações ricas e integrações com outros sistemas. 💡\n\n"
                "Seu ambiente está pronto para começar a criar fluxos! ✨\n"
            )
        )
        return CompletedFlowAction()  # (8)!
```

1. `@flow()` registra a classe como um flow do Expresso Flow.
2. A **docstring** é usada como `description` pelo engine de intent para roteamento entre flows.
3. `id` é o identificador único do flow — referenciado pelas actions de navegação (`flow_id`).
4. `name` é o nome exibido em todos os ambientes (WebFlow, CLI, WhatsApp, etc.).
5. `@step(order, label, description)` define a ordem, o rótulo no painel de debug e o objetivo do step para o engine de IA.
6. `WaitUserInputAction` suspende o flow e aguarda a próxima mensagem do usuário.
7. `ctx.message.get_text()` lê o texto enviado pelo usuário.
8. `CompletedFlowAction` encerra o flow para a sessão atual.

---

## Executando o projeto

### 1. Instale as dependências

```bash
pip install -r requirements.txt
```

### 2. Execute

```bash
python main.py
```

### 3. Acesse o WebFlow

Abra no navegador:

```
http://localhost:8080/webflow
```

Selecione o flow **"Meu primeiro fluxo"** e interaja com ele diretamente no navegador.

---

## Criando seu próprio flow

Para criar um novo flow, adicione um arquivo na pasta `app/flows/`:

```python title="app/flows/saudacao/saudacao_flow.py"
from exflow.flow import Flow, StepOptions, step, flow
from exflow.interaction import InteractionContext
from exflow.execution_action import CompletedFlowAction, WaitUserInputAction


@flow()
class SaudacaoFlow(Flow):
    """Flow de saudação personalizada — coleta o nome do usuário e o cumprimenta."""

    id = "saudacao"
    name = "Saudação personalizada"

    @step(order=0, label="Pedir nome", description="Solicita o nome do usuário para saudação personalizada")
    async def pedir_nome(self, ctx: InteractionContext, options: StepOptions):
        await ctx.output.send_text("Olá! Qual é o seu nome?")
        return WaitUserInputAction()

    @step(order=1, label="Responder", description="Envia saudação personalizada com o nome recebido e encerra o flow")
    async def responder(self, ctx: InteractionContext, options: StepOptions):
        nome = ctx.message.get_text()
        await ctx.output.send_text(f"Prazer em te conhecer, *{nome}*! 👋")
        return CompletedFlowAction()
```

---

## Próximos passos

- [Flows →](../core/flow.md) — referência completa sobre flows
- [Steps →](../core/steps.md) — ações, ctx e formatação de mensagens
- [Bootstrap →](../core/bootstrap.md) — como configurar o `ExpressoFlowBootstrap`
