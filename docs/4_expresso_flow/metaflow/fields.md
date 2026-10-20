# Fields

Um `Field` define um campo que o engine de IA irá coletar do usuário. Cada campo tem uma pergunta padrão, uma prioridade de preenchimento e uma mensagem de erro de validação.

```python
from exflow.metaflow import Field
```

---

## Criando um Field

```python
from exflow.metaflow import Field
from app.metaflows.usuario.models.usuario_model import UsuarioModel


class NomeField(Field[UsuarioModel]):
    """
    Campo que representa o nome do usuário.
    """

    name = "nome"           # deve corresponder ao atributo no Model
    priority = 4            # ordem de preenchimento (menor = primeiro)
    question = "Qual é o nome do usuário?"
    validation_error_message = "O nome do usuário não pode estar vazio."
```

---

## Atributos obrigatórios

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `name` | `str` | Nome do campo — deve corresponder ao atributo no `Model` |
| `priority` | `int` | Ordem de preenchimento (menor número = coletado primeiro) |
| `question` | `str` | Pergunta padrão enviada ao usuário quando o campo não está preenchido |
| `validation_error_message` | `str` | Mensagem exibida quando a validação falha |

---

## Método `apply` (opcional)

Sobrescreva `apply()` quando o campo preenche **mais de um atributo** no model ou precisa de transformação personalizada:

```python
class TelefoneField(Field[UsuarioModel]):
    """
    Campo que representa o telefone do usuário.
    """

    name = "telefone"
    priority = 3
    question = "Qual é o telefone do usuário?"
    validation_error_message = "O telefone do usuário não é válido."

    def apply(self, model: UsuarioModel) -> None:
        model.telefone_id = self.value.metadata["id"]
        model.telefone = self.value.metadata["telefone"]
```

---

## Registrando os fields no MetaFlow

```python
def load_fields(self):
    return [
        CidadeField(),   # priority=1 — coletado primeiro
        EmailField(),    # priority=2
        TelefoneField(), # priority=3
        NomeField(),     # priority=4 — coletado por último
    ]
```

!!! info "Ordem de coleta"
    Os campos são coletados em ordem crescente de `priority`. Campos com prioridade menor são perguntados primeiro.
