# Execution Actions (`exflow.execution_action`)

## Visão Geral
No **Expresso Flow**, cada passo (`@step`) de um fluxo deve retornar uma ação de execução (`ExecutionAction`). Essas ações informam ao orquestrador do framework qual deve ser o próximo comportamento da máquina de estados: aguardar interação do usuário, navegar entre passos, encerrar o fluxo ou realizar transições completas entre fluxos diferentes.

---

## Classe Base: `ExecutionAction`

Todas as ações herdam da classe abstrata `ExecutionAction`. Ela define parâmetros globais aceitos via argumentos nomeados (*keyword-only*) por qualquer action:

```python
from abc import ABC
from dataclasses import dataclass
from enum import Enum

PathKey = str | Enum

@dataclass
class ExecutionAction(ABC):
    data: dict = field(default_factory=dict)  # Dados propagados no contexto da execução
    path: PathKey | None = None               # Rota ou caminho alternativo de execução
```

### Exemplo de uso de parâmetros da classe base:
```python
return WaitUserInputAction(data={"origem": "menu_principal"}, path="rota_alternativa")
```

---

## 1. Controle de Input e Ciclo de Execução

Controlam a escuta de mensagens do canal ou pausam a execução imediata.

| Action | Assinatura | Comportamento |
| :--- | :--- | :--- |
| `WaitUserInputAction` | `(step=None, label=None, *, data={}, path=None)` | Suspende a execução do flow e aguarda a próxima mensagem do usuário. Opcionalmente já define para qual step/label o input será direcionado. |
| `ListenUserInputAction` | `(*, data={}, path=None)` | Habilita a escuta do input do usuário sem suspender o flow (muito utilizado em conjunto com guards como `@safe_step`). |
| `NoopAction` | `(*, data={}, path=None)` | Operação nula (*No Operation*). Mantém o estado atual sem avançar ou alterar a fila. |
| `BreakLoopAction` | `(*, data={}, path=None)` | Interrompe imediatamente um loop de execução de steps no orquestrador. |
| `StopExecutionAction` | `(reason=None, *, data={}, path=None)` | Interrompe imediatamente a execução do step atual. |
| `RetryExecutionAction`| `(context=None, *, data={}, path=None)` | Solicita ao orquestrador a reexecução do step atual. |
| `ExecuteToolAction`   | `(tool_id=None, tool_cmd=None, *, data={}, path=None)` | Dispara a execução de uma ferramenta/tool registrada no container. |

```python
from exflow.execution_action import WaitUserInputAction, ListenUserInputAction, StopExecutionAction

# Aguardar resposta do usuário na etapa atual
return WaitUserInputAction()

# Aguardar resposta redirecionando diretamente para um step específico
return WaitUserInputAction(step=2)
```

---

## 2. Navegação entre Steps (Mesmo Fluxo)

Ações responsáveis por conduzir o fluxo internamente.

| Action | Assinatura | Descrição |
| :---  | :---  | :---  |
| `NextStepFlowAction` | `(*, data={}, path=None)` | Avança para o próximo step em ordem crescente. **(Comportamento padrão quando a função termina sem retorno explícito)**. |
| `PreviousStepFlowAction` | `(*, data={}, path=None)` | Retorna para o step imediatamente anterior. |
| `GoToStepFlowAction` | `(step: int, *, data={}, path=None)` | Pula a execução diretamente para o step pelo índice numérico ou Enum (`order`). |
| `GoToStepLabelFlowAction` | `(label: str, *, data={}, path=None)` | Navega diretamente para um step identificado pelo seu `label`. |
| `RestartFlowAction` | `(step: int | None = None, *, data={}, path=None)` | Reinicia o fluxo do início (step 1/inicial) ou a partir de um step indicado. |

```python
from exflow.execution_action import (
    GoToStepFlowAction,
    GoToStepLabelFlowAction,
    PreviousStepFlowAction,
    RestartFlowAction,
)
from cin.flows.flow.cin_flow.cin_enum_steps.cin_enum_steps import ExampleEnumSteps

# Navegar para step via Enum de steps
return GoToStepFlowAction(step=ExampleEnumSteps.ENDERECO)

# Voltar ao step anterior em caso de dado inválido
return PreviousStepFlowAction()

# Ir para um step via label descritivo
return GoToStepLabelFlowAction(label="Confirmar Pedido")

# Reiniciar fluxo do início
return RestartFlowAction()
```

---

## 3. Encerramento do Fluxo Atual

Ações que definem o encerramento da execução do fluxo corrente sem necessariamente transicionar para outro.

| Action | Assinatura | Descrição |
| :--- | :--- | :--- |
| `CompleteFlowAction` | `(redirect=None, *, data={}, path=None)` | Finaliza o fluxo com sucesso. |
| `CancelFlowAction` | `(reason=None, redirect=None, *, data={}, path=None)` | Cancela o fluxo atual registrando motivo opcional. |
| `SuspendFlowAction` | `(redirect=None, *, data={}, path=None)` | Suspende o fluxo atual, mantendo seu estado para eventual retomada posterior. |
| `FatalRecoveryFlowAction` | `(error=None, reason=None, *, data={}, path=None)` | Encerra a execução em decorrência de erro fatal e dispara rotinas de recuperação de contingência. |

```python
from exflow.execution_action import CompleteFlowAction, CancelFlowAction, SuspendFlowAction

# Concluir o fluxo com sucesso
return CompleteFlowAction()

# Cancelar por desistência ou limite de tentativas
return CancelFlowAction(reason="Usuário cancelou a operação")
```

---

## 4. Transições entre Fluxos (`ExecuteFlowAction` e Derivadas)

As ações de transição permitem orquestrar múltiplos fluxos de trabalho, conectando fluxos principais, subfluxos especialistas e menus.

### Visão Comparativa de Estados

| Action | Status Aplicado ao Fluxo Atual | Comportamento no Fluxo Destino | Pilha / Retomada |
| :--- | :--- | :--- | :--- |
| `CompleteAndStartFlowAction` | `COMPLETED` | Inicia o fluxo destino do início | Fluxo atual encerrado; **sem** retorno. |
| `CancelAndStartFlowAction` | `CANCELLED` | Inicia o fluxo destino do início | Fluxo atual cancelado e descartado; **sem** retorno. |
| `SuspendAndStartFlowAction` | `SUSPENDED` | Inicia o fluxo destino do início | Fluxo atual pausado na pilha; **permite retorno**. |
| `CompleteAndResumeFlowAction` | `COMPLETED` | Retoma um fluxo pai suspenso | Fluxo atual finalizado com sucesso e desempilhado. |
| `CancelAndResumeFlowAction` | `CANCELLED` | Retoma um fluxo pai suspenso | Fluxo atual cancelado e desempilhado. |
| `SuspendAndResumeFlowAction` | `SUSPENDED` | Retoma um fluxo suspenso | Ambos os fluxos permanecem em pilha de suspensão. |
| `ForceExecuteFlowAction` | Mantém execução | Força o disparo imediato de outro fluxo | Execução paralela/forçada. |

---

### Detalhamento das Ações de Transição

#### 4.1. `CompleteAndStartFlowAction`
Encerra definitivamente o fluxo atual com status `COMPLETED` e inicializa um novo fluxo a partir de seu primeiro step (ou do step configurado).

- **Quando usar:** Quando a etapa atual foi concluída com sucesso e o usuário deve ser transferido para o próximo processo de negócio (ex.: terminou a solicitação e vai para a pesquisa de satisfação ou pagamento).
- **Assinatura:**
  ```python
  CompleteAndStartFlowAction(
      flow_id: str | None = None,
      step: int | None = None,
      transition: FlowTransition | None = None,
      *, data: dict = {}, path: PathKey | None = None
  )
  ```
- **Exemplo:**
  ```python
  from exflow.execution_action import CompleteAndStartFlowAction

  @step(ExampleEnumSteps.FINALIZAR_SOLICITACAO)
  async def finalizar(self, ctx: InteractionContext, params: StepOptions):
      await ctx.output.send_text("Sua solicitação foi registrada com sucesso!")
      # Conclui este fluxo e transfere o usuário para a pesquisa de satisfação
      return CompleteAndStartFlowAction(flow_id="pesquisa_satisfacao_flow")
  ```

---

#### 4.2. `CancelAndStartFlowAction`
Cancela o fluxo atual marcando-o como `CANCELLED`, limpa sua pilha e transfere o usuário para um novo fluxo.

- **Quando usar:** Em cancelamentos voluntários, resets de teste (ex.: `/flow reset`) ou desvios de rota em que o fluxo atual não deve ser concluído nem retomado.
- **Assinatura:**
  ```python
  CancelAndStartFlowAction(
      flow_id: str | None = None,
      step: int | None = None,
      transition: FlowTransition | None = None,
      *, data: dict = {}, path: PathKey | None = None
  )
  ```
- **Exemplo:**
  ```python
  from exflow.execution_action import CancelAndStartFlowAction

  @step(2)
  async def aplicar_reset(self, ctx: InteractionContext, params: StepOptions):
      # Cancela o fluxo auxiliar de reset e reinicia o fluxo principal limpo
      return CancelAndStartFlowAction(flow_id="cin_flow")
  ```

---

#### 4.3. `SuspendAndStartFlowAction`
Coloca o fluxo pai em estado **suspenso** (`SUSPENDED`), salva seu snapshot de execução na pilha e inicializa um fluxo filho. Permite que o fluxo filho devolva o controle ao pai ao terminar.

- **Quando usar:** Ao delegar uma tarefa para um subfluxo (autenticação Gov.br, captura de endereço via CEP, checkout) e precisar retornar ao mesmo ponto após a conclusão.
- **Assinatura:**
  ```python
  SuspendAndStartFlowAction(
      flow_id: str | None = None,
      step: int | None = None,
      transition: FlowTransition | None = None,
      back_to_step: int | None = None,   # Step para onde o pai deve voltar ao ser retomado
      back_to_label: str | None = None, # Label para onde o pai deve voltar ao ser retomado
      *, data: dict = {}, path: PathKey | None = None
  )
  ```
- **Exemplo:**
  ```python
  from exflow.execution_action import SuspendAndStartFlowAction
  from cin.flows.flow.cin_flow.cin_enum_steps.cin_enum_steps import ExampleEnumSteps

  @step(ExampleEnumSteps.AUTENTICACAO_RESP)
  async def autenticar(self, ctx: InteractionContext, params: StepOptions):
      # Suspende o cin_flow e chama o fluxo de login, programando o retorno para VERIFICAR_LOGADO
      return SuspendAndStartFlowAction(
          flow_id="gov_auth_flow",
          back_to_step=ExampleEnumSteps.VERIFICAR_LOGADO,
          data={"origem": "cin_flow"}
      )
  ```

---

#### 4.4. `CompleteAndResumeFlowAction`
Finaliza o fluxo filho atual com status `COMPLETED` e **retoma** a execução do fluxo pai que estava suspenso na pilha.

- **Quando usar:** Na última etapa de um subfluxo quando a operação foi realizada com sucesso, devolvendo o controle para o fluxo chamador (no step configurado no `back_to_step` do pai).
- **Assinatura:**
  ```python
  CompleteAndResumeFlowAction(
      flow_id: str | None = None, # Opcional: ID explícito do fluxo a retomar (se omitido, desempilha o pai)
      step: int | None = None,    # Step opcional de retomada
      *, data: dict = {}, path: PathKey | None = None
  )
  ```
- **Exemplo:**
  ```python
  from exflow.execution_action import CompleteAndResumeFlowAction

  @step(2)
  async def callback_login_sucesso(self, ctx: InteractionContext, params: StepOptions):
      self.session.set_bool("LOGADO", True)
      await ctx.output.send_text("✅ Login realizado com sucesso!")
      
      # Finaliza o subfluxo de login e retoma o fluxo pai suspenso
      return CompleteAndResumeFlowAction()
  ```

---

#### 4.5. `CancelAndResumeFlowAction`
Cancela o fluxo filho atual com status `CANCELLED` e retoma o fluxo pai suspenso.

- **Quando usar:** Quando o usuário desiste ou falha em um subfluxo (ex.: cancelou o login externo ou não confirmou o pagamento) e precisa voltar para o fluxo principal para escolher outra opção.
- **Assinatura:**
  ```python
  CancelAndResumeFlowAction(
      flow_id: str | None = None,
      step: int | None = None,
      *, data: dict = {}, path: PathKey | None = None
  )
  ```
- **Exemplo:**
  ```python
  from exflow.execution_action import CancelAndResumeFlowAction

  @step(2)
  async def cancelar_subfluxo(self, ctx: InteractionContext, params: StepOptions):
      await ctx.output.send_text("Operação cancelada no serviço externo. Retornando ao menu...")
      # Cancela o subfluxo e retoma o fluxo pai para tratamento
      return CancelAndResumeFlowAction()
  ```

---

#### 4.6. `SuspendAndResumeFlowAction`
Suspende o fluxo atual (colocando-o na pilha) e retoma outro fluxo que já estava previamente suspenso.

- **Quando usar:** Em navegações complexas de múltiplos níveis (ex.: menus em abas ou fluxos assistentes paralelos) onde ambos os fluxos precisam ter seus estados mantidos em memória para alternância.
- **Assinatura:**
  ```python
  SuspendAndResumeFlowAction(
      flow_id: str | None = None,
      step: int | None = None,
      *, data: dict = {}, path: PathKey | None = None
  )
  ```
- **Exemplo:**
  ```python
  from exflow.execution_action import SuspendAndResumeFlowAction

  @step(3)
  async def alternar_contexto(self, ctx: InteractionContext, params: StepOptions):
      # Pausa o fluxo de suporte atual e retoma o fluxo de atendimento prévio
      return SuspendAndResumeFlowAction(flow_id="atendimento_principal_flow")
  ```

---

#### 4.7. `ForceExecuteFlowAction`
Executa de forma mandatória e imediata o fluxo destino informado em `flow_id`, ignorando condições convencionais de encerramento da thread atual.

- **Quando usar:** Casos excepcionais de transbordo imediato, interrupções administrativas ou roteamentos emergenciais de canal.
- **Assinatura:**
  ```python
  ForceExecuteFlowAction(
      flow_id: str | None = None,
      step: int | None = None,
      *, data: dict = {}, path: PathKey | None = None
  )
  ```
- **Exemplo:**
  ```python
  from exflow.execution_action import ForceExecuteFlowAction

  @step(1)
  async def manutencao_emergencial(self, ctx: InteractionContext, params: StepOptions):
      # Força a execução imediata do fluxo de aviso de contingência
      return ForceExecuteFlowAction(flow_id="contingencia_emergencial_flow")
  ```

---

## 5. Boas Práticas no Uso de ExecutionActions

1. **Retorno Obrigatório:** Sempre retorne explicitamente uma instância de `ExecutionAction` em métodos `@step`. Se nenhum valor for retornado, o framework assume implicitamente `NextStepFlowAction()`.
2. **Propagação de Estado via `data` vs `FlowSession`:**
   - Use `self.session.set_*()` para dados que devem durar por toda a conversa do usuário no fluxo.
   - Use o parâmetro `data={...}` nas actions para dados voláteis transmitidos diretamente entre o step atual e o step de destino imediato.
3. **Nomes das Classes:** Utilize sempre os nomes no imperativo/presente conforme definidos no pacote `exflow.execution_action`:
   - ✅ `CompleteFlowAction` (não use `CompletedFlowAction`)
   - ✅ `CancelFlowAction` (não use `CancelledFlowAction`)
   - ✅ `SuspendFlowAction` (não use `SuspendedFlowAction`)
