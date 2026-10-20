## Visão Geral
Resiliência e Tratamento de Falhas, `@safe_step` é utilizado em etapas de fluxo que realizam chamadas a serviços externos (APIs REST, gRPC, bancos de dados ou microsserviços), falhas de rede, timeouts ou retornos `5xx` podem lançar exceções não tratadas. Sem um guard, isso interromperia abruptamente a execução do bot e a sessão do usuário.

O decorator `@safe_step` captura qualquer exceção durante a execução do step, notifica o usuário com uma mensagem amigável e retorna `ListenUserInputAction()`, mantendo o fluxo estável para uma nova tentativa ou ação de contingência.

## Import

```python

from exflow.guards import safe_step

```
## Assinatura
@safe_step(message: str = "Ocorreu um erro inesperado. Por favor, tente novamente.")

## Como Funciona Internamente

1. O método decorado com @safe_step é executado normalmente dentro de um bloco protegido.
2. Se nenhuma exceção for lançada, seu retorno (GoToStepFlowAction, WaitUserInputAction, etc.) é entregue ao orquestrador.
3. Se qualquer Exception for levantada:

    ◦ A mensagem configurada em message é enviada ao canal via await ctx.output.send_text(message).

    ◦ O step retorna automaticamente um ListenUserInputAction(), aguardando a próxima interação do usuário sem derrubar a thread do bot.


## Exemplo de uso 

```python

from exflow.flow import Flow, flow, step, StepOptions
from exflow.interaction import InteractionContext
from exflow.guards import safe_step
from exflow.execution_action import GoToStepFlowAction, WaitUserInputAction
from cin.flows.flow.cin_flow.cin_enum_steps.cin_enum_steps import CinEnumSteps
from cin.flows.flow.cin_flow.cin_service.cin_service import CinService

@flow(id="consulta_fluxo", name="Fluxo de Consulta com Resiliência")
class ConsultaFlow(Flow):

    def __init__(self, service: CinService):
        super().__init__()
        self.service = service

    @step(CinEnumSteps.CONSULTAR_DADOS_API)
    @safe_step(message="⚠️ Nosso sistema está temporariamente indisponível para consulta. Por favor, tente novamente em instantes.")
    async def consultar_dados(self, ctx: InteractionContext, params: StepOptions):
        # Se a chamada à API externa falhar com timeout, HTTP 500 ou ConnectionError,
        # o bot não quebra e exibe a mensagem amigável configurada.
        resultado = await self.service.consultar_rg_segunda_via_rapida_e_andamento(
            {"cpf": self.session.get("CPF")}
        )
        
        self.session.set_str("RESULTADO_CONSULTA", resultado)
        return GoToStepFlowAction(step=CinEnumSteps.EXIBIR_RESUMO)

```

Dica: O @safe_step deve envolver a função logo após o decorator @step(...).