# Resolvers

Um `FieldResolver` é executado após a validação do campo, permitindo **enriquecer ou transformar** o valor extraído — por exemplo, buscar um ID em banco de dados, normalizar um número de telefone ou converter um texto em uma entidade do domínio.

```python
from exflow.metaflow import FieldResolver
```

---

## Criando um Resolver

```python
from exflow.metaflow import FieldResolver
from exflow.interaction import InteractionContext
from app.metaflows.usuario.fields.telefone_field import TelefoneField


class TelefoneResolver(FieldResolver):
    field = TelefoneField   # associa o resolver ao campo

    async def resolve(self, context: InteractionContext, field: TelefoneField) -> str:
        # Enriquece o valor com metadados adicionais
        field.value.metadata = {
            "id": 200,
            "telefone": field.value.raw,
        }
```

---

## Atributos obrigatórios

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `field` | `type[Field]` | Classe do campo que este resolver processa |

---

## Método `resolve`

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `context` | `InteractionContext` | Contexto da interação atual |
| `field` | `Field` | Instância do campo. Use `field.value.raw` para ler o valor bruto e `field.value.metadata` para armazenar dados enriquecidos |

Os dados salvos em `field.value.metadata` ficam disponíveis no método `apply()` do `Field` para preenchimento do `Model`.

---

## Registrando no MetaFlow

```python
from exflow.flow import flow
from exflow.metaflow import MetaFlow
from exflow.llm import LLMProvider

from app.metaflows.usuario.models.usuario_model import UsuarioModel
from app.metaflows.usuario.fields.nome_field import NomeField
from app.metaflows.usuario.fields.telefone_field import TelefoneField
from app.metaflows.usuario.resolvers.telefone_resolver import TelefoneResolver


@flow()
class UsuarioFlow(MetaFlow):
    """Fluxo de cadastro de usuário."""

    id = "usuario_flow"
    name = "Cadastro de Usuário"

    def __init__(self, provider: LLMProvider):
        super().__init__(provider=provider)

    def create_model(self):
        return UsuarioModel()

    def load_fields(self):
        return [NomeField(), TelefoneField()]

    def load_resolvers(self):  # (1)!
        return [
            TelefoneResolver(),
        ]
```

1. O resolver é executado após a validação do campo, antes de o valor ser aplicado ao model.
