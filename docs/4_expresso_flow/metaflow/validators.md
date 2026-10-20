# Validators

Um `FieldValidator` valida o valor extraído pela LLM antes de confirmá-lo no `Model`. Se a validação falhar, o engine solicita novamente o campo ao usuário exibindo a `validation_error_message` do `Field`.

```python
from exflow.metaflow import FieldValidator
```

---

## Criando um Validator

```python
import re
from exflow.interaction import InteractionContext
from exflow.metaflow import Field, FieldValidator
from app.metaflows.usuario.fields.email_field import EmailField


class EmailValidator(FieldValidator):
    field = EmailField   # associa o validator ao campo

    async def validate(self, context: InteractionContext, field: Field) -> bool:
        email_regex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return bool(re.match(email_regex, field.value.raw))
```

---

## Atributos obrigatórios

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `field` | `type[Field]` | Classe do campo que este validator valida |

---

## Método `validate`

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `context` | `InteractionContext` | Contexto da interação atual |
| `field` | `Field` | Instância do campo com o valor extraído em `field.value.raw` |
| **retorno** | `bool` | `True` se válido, `False` para exibir `validation_error_message` |

---

## Registrando no MetaFlow

```python
from exflow.flow import flow
from exflow.metaflow import MetaFlow
from exflow.llm import LLMProvider

from app.metaflows.usuario.models.usuario_model import UsuarioModel
from app.metaflows.usuario.fields.nome_field import NomeField
from app.metaflows.usuario.fields.email_field import EmailField
from app.metaflows.usuario.validators.email_validator import EmailValidator
from app.metaflows.usuario.validators.telefone_validator import TelefoneValidator


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
        return [NomeField(), EmailField()]

    def load_validators(self):  # (1)!
        return [
            EmailValidator(),
            TelefoneValidator(),
        ]
```

1. Cada validator é automaticamente associado ao seu campo pela propriedade `field`.
