# exflow create

Cria um novo projeto Expresso Flow com a estrutura de diretórios padrão e arquivos de configuração prontos para uso.

---

## Sintaxe

```bash
exflow create project --name <NOME_DO_PROJETO>
```

## Opções

| Opção | Obrigatório | Descrição |
|-------|-------------|-----------|
| `--name` | Sim | Nome do projeto e da pasta a ser criada |

---

## Exemplo

```bash
exflow create project --name meu-chatbot
cd meu-chatbot
```

### Estrutura gerada

```
meu-chatbot/
├── app/
│   └── flows/
│       └── hellow/
│           └── hellow_flow.py
├── .env
├── main.py
├── README.md
└── requirements.txt
```

### `requirements.txt` gerado

```text
--index-url https://exflow.run/simple --trusted-host exflow.run

exflow
webflow-bundle
python-dotenv
```

### `hellow_flow.py` gerado

```python title="app/flows/hellow/hellow_flow.py"
from exflow.flow import Flow, StepOptions, step, flow
from exflow.interaction import InteractionContext
from exflow.execution_action import CompletedFlowAction, WaitUserInputAction


@flow()
class HellowFlow(Flow):
    """
    Flow de teste para o expresso-flow
    """

    id = "first_flow"
    name = "Meu primeiro fluxo"

    @step(0)
    async def start(self, ctx: InteractionContext, options: StepOptions):
        await ctx.output.send_text(
            (
                "👋 Olá! Eu sou o *Expresso Flow*!\n\n"
                "Como posso te chamar? 😊\n"
            )
        )

        return WaitUserInputAction()

    @step(1)
    async def on_user_input(self, ctx: InteractionContext, options: StepOptions):
        user_input = ctx.message.get_text()

        await ctx.output.send_text(
            (
                f"🎉 Seja muito bem-vindo(a), *{user_input}*!\n\n"
                "Você acaba de rodar o seu primeiro fluxo com o *Expresso Flow* 🚀\n\n"
                "A partir daqui você pode criar fluxos com múltiplos passos,\n"
                "interações ricas e integrações com outros sistemas. 💡\n\n"
                "Seu ambiente está pronto para começar a criar fluxos! ✨\n"
            )
        )

        return CompletedFlowAction()
```

---

## Instalando as dependências

Após criar o projeto, instale as dependências:

```bash
pip install -r requirements.txt
```

---

## Próximos passos

- [exflow run →](run.md)
- [Primeiro Fluxo →](../../getting-started/first-flow.md)
