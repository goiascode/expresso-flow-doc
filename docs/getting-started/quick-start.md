# Quick Start

Siga este guia para ter um projeto Expresso Flow funcionando em menos de 5 minutos.

---

## Opção 1 — Com a CLI (recomendado)

### 1. Instale a CLI

Consulte [Downloads](../downloads/index.md) para obter o binário da sua plataforma.

### 2. Crie um novo projeto

```bash
exflow new meu-projeto
cd meu-projeto
```

A CLI gera a estrutura de diretórios, cria o ambiente virtual e instala as dependências automaticamente.

### 3. Execute o projeto

```bash
exflow run
```

O framework iniciará e você verá no terminal o endereço para acesso local.

---

## Opção 2 — Manualmente

### 1. Instale o core

```bash
pip install --index-url https://exflow.run/simple expresso-flow
```

### 2. Crie o arquivo principal

```python title="main.py"
from expresso_flow import ExpressoFlow
from expresso_flow.flow import Flow
from expresso_flow.step import Step, Message

app = ExpressoFlow()

@app.flow("saudacao")
class SaudacaoFlow(Flow):
    """Fluxo de saudação simples."""

    @Step.entry  # (1)!
    async def inicio(self, ctx):
        await ctx.send(Message.text("Olá! Como posso te ajudar? 😊"))

        resposta = await ctx.wait_input()  # (2)!
        await ctx.send(Message.text(f"Você digitou: {resposta.text}"))

if __name__ == "__main__":
    app.run()
```

1. `@Step.entry` define o ponto de entrada do fluxo — o primeiro step a ser executado.
2. `ctx.wait_input()` suspende o fluxo aguardando uma resposta do usuário.

### 3. Execute

```bash
python main.py
```

---

## Com WebFlow (debug visual)

Para inspecionar o fluxo no navegador, instale e configure o bundle **WebFlow**:

```bash
pip install --index-url https://exflow.run/simple exflow-webflow
```

```python title="main.py" hl_lines="2 7 8"
from expresso_flow import ExpressoFlow
from exflow_webflow import WebFlowBundle

app = ExpressoFlow()

# Registra o bundle WebFlow no bootstrap
app.register_bundle(WebFlowBundle(port=8765))

# ... seus flows aqui ...

if __name__ == "__main__":
    app.run()
```

Acesse `http://localhost:8765` no navegador para interagir com seus fluxos visualmente.

---

## Próximos passos

- [Primeiro Fluxo →](first-flow.md) — aprofunde-se na estrutura de flows e steps
- [Core →](../core/index.md) — documentação completa do módulo principal
- [WebFlow →](../webflow/index.md) — saiba mais sobre a ferramenta de debug visual
