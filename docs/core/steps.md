# Steps

**Steps** são as etapas de um flow. Cada step é um método `async` decorado com `@step()`, que define a ordem de execução, o rótulo exibido no painel de debug e a descrição utilizada pelo engine de IA para avaliar a intenção do usuário.

---

## Definindo Steps

```python
from exflow.flow import Flow, StepOptions, step, flow
from exflow.interaction import InteractionContext
from exflow.execution_action import CompletedFlowAction, WaitUserInputAction


@flow()
class MeuFlow(Flow):

    id = "meu_flow"
    name = "Meu Flow"

    @step(
        order=0,
        label="Boas-vindas",
        description="Apresenta o bot e solicita o nome do usuário",
    )
    async def start(self, ctx: InteractionContext, options: StepOptions):
        await ctx.output.send_text("Qual é o seu nome?")
        return WaitUserInputAction()

    @step(
        order=1,
        label="Receber nome",
        description="Recebe o nome digitado pelo usuário e encerra o flow",
    )
    async def receber_nome(self, ctx: InteractionContext, options: StepOptions):
        nome = ctx.message.get_text()
        await ctx.output.send_text(f"Olá, {nome}!")
        return CompletedFlowAction()
```

---

## Decorador `@step()`

```python
@step(order: int, label: str, description: str)
```

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| `order` | `int` | Sim | Define a ordem de execução do step pelo runtime. Começa em `0`. |
| `label` | `str` | Sim | Nome do step exibido no painel de debug do **WebFlow**. |
| `description` | `str` | Sim | Objetivo do step — utilizado pelo **engine de IA** para avaliar a intenção do usuário. |

### O papel da `description` no engine de IA

A `description` é lida pelo **engine de intent** do Expresso Flow para determinar, a cada mensagem recebida, se o usuário deseja:

- **Continuar no step atual** — a mensagem é aderente ao objetivo declarado
- **Mudar para outro step** — a intenção diverge do step em execução
- **Trocar de flow** — o usuário demonstra interesse em outro assunto

Escreva descriptions objetivas e em linguagem natural para que o engine consiga avaliar corretamente:

```python
# Boa description — clara e objetiva
@step(
    order=0,
    label="Coleta de e-mail",
    description="Solicita e valida o endereço de e-mail do usuário para cadastro",
)

# Description ruim — vaga
@step(
    order=0,
    label="Step 1",
    description="Pede dado",
)
```

---

## Assinatura dos steps

```python
async def nome_do_step(self, ctx: InteractionContext, options: StepOptions):
    ...
```

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `ctx` | `InteractionContext` | Contexto da interação atual |
| `options` | `StepOptions` | Metadados e direção de execução do step |

### `StepOptions`

```python
from exflow.flow import StepOptions, FlowDirection
```

| Campo | Tipo | Padrão | Descrição |
|-------|------|--------|-----------|
| `direction` | `FlowDirection` | `FlowDirection.FORWARD` | Direção de execução do flow (`FORWARD` ou `REWIND`) |
| `data` | `dict` | `{}` | Dados propagados pelo step anterior via `ExecutionAction.data` |
| `description` | `str \| None` | `None` | Descrição contextual injetada pelo runtime |

```python
# Verificar direção de execução
if options.direction == FlowDirection.REWIND:
    await ctx.output.send_text("Voltando ao passo anterior...")

# Acessar dados propagados pelo step anterior
nome = options.data.get("nome")
```

---

## `InteractionContext` (`ctx`)

O `InteractionContext` é injetado como primeiro parâmetro em todos os steps. Contém todas as informações e metadados necessários para executar o flow.

```python
async def meu_step(self, ctx: InteractionContext, options: StepOptions):
    ...
```

---

### `ctx.message` — Mensagem recebida

Fornece acesso a todos os dados da mensagem enviada pelo usuário.

#### Verificação de tipo

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `is_text()` | `bool` | Mensagem de texto simples |
| `is_voice()` | `bool` | Mensagem de voz |
| `is_audio()` | `bool` | Arquivo de áudio |
| `is_media()` | `bool` | Qualquer tipo de mídia |
| `is_interactive_reply()` | `bool` | Resposta a uma mensagem interativa |
| `is_item(item_id?)` | `bool` | Seleção de item de lista |
| `is_button(button?)` | `bool` | Clique em botão |

#### Leitura de conteúdo

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `get_text()` | `str` | Texto da mensagem |
| `timestamp()` | `str` | Timestamp da mensagem |
| `get_button_id()` | `int \| str \| None` | ID do botão clicado |
| `get_button_label()` | `str \| None` | Rótulo do botão clicado |
| `get_item_id()` | `int \| str \| None` | ID do item de lista selecionado |
| `get_item_label()` | `str \| None` | Rótulo do item de lista selecionado |
| `get_media_url()` | `str \| None` | URL da mídia recebida |
| `get_media_caption()` | `str \| None` | Legenda da mídia recebida |

```python
# Verificar tipo antes de ler
if ctx.message.is_text():
    texto = ctx.message.get_text()

if ctx.message.is_button():
    botao_id = ctx.message.get_button_id()
    botao_label = ctx.message.get_button_label()
```

---

### `ctx.output` — Envio de mensagens

Todos os métodos são `async`. Cada tipo tem uma variante `send_*` (envia normalmente) e `reply_*` (envia como resposta a uma mensagem específica via `reply_to`).

#### Texto

```python
await ctx.output.send_text("Olá! 👋")
await ctx.output.reply_text("Recebi sua mensagem.", reply_to="message_id")
```

#### Botões

```python
from exflow.interaction import Button

await ctx.output.send_buttons(
    body_text="Como posso te ajudar?",
    buttons=[
        ("btn_1", "Suporte"),
        ("btn_2", "Vendas"),
    ]
)
```

#### Lista de itens

```python
await ctx.output.send_list(
    body_text="Escolha uma opção:",
    items=[
        ("item_1", "Opção 1"),
        ("item_2", "Opção 2", "Descrição opcional"),
    ],
    action_title="Selecionar",
)
```

#### Botão de URL

```python
await ctx.output.send_url_button(
    body_text="Acesse nossa documentação",
    display_text="Ver documentação",
    url="https://exflow.run",
)
```

#### Mídia

| Método | Parâmetros | Descrição |
|--------|-----------|-----------|
| `send_image(media_url, caption?)` | — | Envia imagem |
| `send_audio(media_url)` | — | Envia áudio |
| `send_video(media_url, caption?)` | — | Envia vídeo |
| `send_document(media_url, caption?, filename?)` | — | Envia documento |

```python
await ctx.output.send_image("https://exemplo.com/imagem.png", caption="Legenda")
await ctx.output.send_document("https://exemplo.com/arquivo.pdf", filename="manual.pdf")
```

#### Carrossel

```python
# Carrossel com botões de resposta rápida
await ctx.output.send_carousel_quick_reply(
    body_text="Confira nossos planos:",
    cards=[
        ("Plano Basic", "R$ 29/mês", [("btn_basic", "Escolher")]),
        ("Plano Pro",   "R$ 79/mês", [("btn_pro",   "Escolher")]),
    ],
)

# Carrossel com botões de URL
await ctx.output.send_carousel_url(
    body_text="Conheça nossos produtos:",
    cards=[
        ("Produto A", "Descrição A", "https://exemplo.com/a", "Ver mais"),
        ("Produto B", "Descrição B", "https://exemplo.com/b", "Ver mais"),
    ],
)
```

#### `send()` / `reply()` com builder

Para casos avançados, use o `_BaseBuilder` diretamente:

```python
await ctx.output.send(builder)
await ctx.output.reply(builder, reply_to="message_id")
```

---

### `ctx.media`

Permite obter informações e acessar o conteúdo de mídias recebidas pelo usuário.

| Método | Retorno | Descrição |
|--------|---------|----------|
| `get_type()` | `str \| None` | Tipo MIME da mídia (ex: `"image/jpeg"`) |
| `get_size()` | `int \| None` | Tamanho em bytes |
| `get_path(content_type, ttl?)` | `str \| None` | URL/caminho temporário para acesso ao arquivo. `ttl` define o tempo de vida em segundos (padrão: `120`) |

```python
from exflow.media import MediaContentType

if ctx.message.is_media():
    tipo = await ctx.media.get_type()
    tamanho = await ctx.media.get_size()
    caminho = await ctx.media.get_path(MediaContentType.IMAGE, ttl=300)
```

---

### `ctx.console`

Interface de logging estruturado dentro do step. As mensagens são exibidas no terminal e no painel de debug do **WebFlow**.

| Método | Descrição |
|--------|----------|
| `log(message)` | Log genérico |
| `info(message)` | Informação |
| `warning(message)` | Aviso |
| `error(message)` | Erro |
| `exception(message, level?, exc?)` | Loga uma excessão com nível configurável (`"error"` por padrão) |

```python
ctx.console.info("Processando cadastro")
ctx.console.warning("Campo e-mail vazio")
ctx.console.error("Falha ao salvar usuário")

try:
    resultado = await salvar_usuario(dados)
except Exception as e:
    ctx.console.exception("Erro ao salvar", level="error", exc=e)
```

---

## Ações de retorno

Todo step deve retornar uma subclasse de `ExecutionAction`. Se nenhuma ação for retornada, o framework aplica **`NextStepFlowAction`** automaticamente.

Consulte a [referência completa de Execution Actions →](actions.md)

---

| Action | Parâmetros | Descrição |
|--------|-----------|-----------|
| `WaitUserInputAction()` | — | Suspende o flow e aguarda o próximo input do usuário |
| `ListenUserInputAction()` | — | Escuta o input sem suspender o flow |
| `NoopAction()` | — | Não faz nada — continua a execução sem avançar |

---

### Navegação entre steps

| Action | Parâmetros | Descrição |
|--------|-----------|-----------|
| `NextStepFlowAction()` | `path?` | Avança para o próximo step **(padrão quando nada é retornado)** |
| `PreviousStepFlowAction()` | `path?` | Volta para o step anterior |
| `GoToStepFlowAction(step)` | `step: int` | Vai para o step pelo índice `order` |
| `GoToStepLabelFlowAction(label)` | `label: str` | Vai para o step pelo `label` |
| `RestartFlowAction()` | `step?` | Reinicia o flow do início (ou a partir de um step) |

```python
from exflow.execution_action import GoToStepFlowAction, GoToStepLabelFlowAction

# Ir para o step de índice 3
return GoToStepFlowAction(step=3)

# Ir para o step pelo label
return GoToStepLabelFlowAction(label="Confirmar pedido")
```

---

### Encerramento do flow

| Action | Parâmetros | Descrição |
|--------|-----------|-----------|
| `CompletedFlowAction()` | — | Conclui o flow com sucesso |
| `SuspendedFlowAction()` | — | Suspende o flow (pode ser retomado) |
| `CancelledFlowAction()` | `reason?` | Cancela o flow |
| `FatalRecoveryFlowAction()` | `error?`, `reason?` | Encerra por erro fatal e aciona recuperação |

---

### Controle de execução

| Action | Parâmetros | Descrição |
|--------|-----------|-----------|
| `StopExecutionAction()` | `reason?` | Para a execução do step imediatamente |
| `RetryExecutionAction()` | `context?` | Reexecuta o step atual |
| `BreakLoopAction()` | — | Interrompe um loop de execução |
| `ExecuteToolAction()` | `tool_id?`, `tool_cmd?` | Executa uma ferramenta registrada |

---

### Transição entre flows

Consulte a [referência completa de Execution Actions →](actions.md)

---

## Formatação de texto

O `send_text` suporta formatação **Markdown** para canais compatíveis:

```python
await ctx.output.send_text(
    "👋 Olá! Eu sou o *Expresso Flow*!\n\n"
    "Como posso te chamar? 😊"
)
```

| Sintaxe | Efeito |
|---------|--------|
| `*texto*` | **Negrito** |
| `\n` | Quebra de linha |

---

## Exemplo completo com múltiplos steps

```python
from exflow.flow import Flow, StepOptions, step, flow
from exflow.interaction import InteractionContext
from exflow.execution_action import CompletedFlowAction, WaitUserInputAction


@flow()
class CadastroFlow(Flow):

    id = "cadastro"
    name = "Cadastro de usuário"

    @step(order=0, label="Pedir nome", description="Solicita o nome do usuário")
    async def pedir_nome(self, ctx: InteractionContext, options: StepOptions):
        await ctx.output.send_text("Qual é o seu nome?")
        return WaitUserInputAction()

    @step(order=1, label="Pedir e-mail", description="Solicita o e-mail do usuário após receber o nome")
    async def pedir_email(self, ctx: InteractionContext, options: StepOptions):
        nome = ctx.message.get_text()
        await ctx.output.send_text(f"Olá, *{nome}*! Qual é o seu e-mail?")
        return WaitUserInputAction()

    @step(order=2, label="Finalizar", description="Confirma o cadastro com o e-mail informado e encerra o flow")
    async def finalizar(self, ctx: InteractionContext, options: StepOptions):
        email = ctx.message.get_text()
        await ctx.output.send_text(
            f"✅ Cadastro concluído!\nE-mail registrado: *{email}*"
        )
        return CompletedFlowAction()
```

---

## Próximos passos

- [Flows →](flows.md)
- [Canais →](channels/index.md)
- [Referência de API — Step →](../api/step.md)
