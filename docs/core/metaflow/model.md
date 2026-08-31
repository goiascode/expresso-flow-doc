# Model

O `Model` é um **dataclass** que representa o objeto de dados que o MetaFlow irá preencher ao longo da conversa. Cada campo do modelo corresponde a um `Field` que será coletado pelo engine de IA.

```python
from exflow.metaflow import Model
```

---

## Criando um Model

```python
from dataclasses import dataclass
from exflow.metaflow import Model


@dataclass
class UsuarioModel(Model):
    """
    Modelo de dados que representa um usuário no sistema.
    """

    nome: str | None = None
    email: str | None = None
    telefone: str | None = None
    cidade: str | None = None

    # Campo derivado — preenchido pelo TelefoneResolver
    telefone_id: int | None = None

    @staticmethod
    def from_dict(data: dict):
        return UsuarioModel(
            nome=data.get("nome"),
            email=data.get("email"),
            telefone=data.get("telefone"),
            cidade=data.get("cidade"),
        )

    def to_dict(self):
        return {
            "nome": self.nome,
            "email": self.email,
            "telefone": self.telefone,
            "cidade": self.cidade,
        }
```

---

## Regras

- Deve herdar de `Model`
- Deve ser um `@dataclass`
- Todos os atributos devem ter valor padrão (`None` recomendado)
- Campos derivados (preenchidos por `FieldResolver`) também são declarados aqui

---

## Acessando o model no `@end_step`

```python
@end_step()
async def finalizar(self, ctx: InteractionContext, *args, **kwargs):
    usuario: UsuarioModel = self.state.model

    await ctx.output.send_text(
        f"Nome: {usuario.nome}\n"
        f"Email: {usuario.email}\n"
        f"Telefone: {usuario.telefone}"
    )
```
