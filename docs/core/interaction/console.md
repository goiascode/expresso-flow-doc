# Console

`ctx.console` é a interface de logging estruturado dentro de um step. As mensagens são exibidas no terminal e no painel de debug do **WebFlow**.

---

## Métodos

| Método | Descrição |
|--------|----------|
| `log(message)` | Log genérico |
| `info(message)` | Informação |
| `warning(message)` | Aviso |
| `error(message)` | Erro |
| `exception(message, level?, exc?)` | Loga uma excessão com nível configurável (`"error"` por padrão) |

---

## Exemplos

```python
ctx.console.info("Processando cadastro")
ctx.console.warning("Campo e-mail vazio")
ctx.console.error("Falha ao salvar usuário")

try:
    resultado = await salvar_usuario(dados)
except Exception as e:
    ctx.console.exception("Erro ao salvar", level="error", exc=e)
```
