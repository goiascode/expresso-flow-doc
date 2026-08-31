# Media

`ctx.media` permite obter informações e acessar o conteúdo de mídias recebidas pelo usuário.

---

## Métodos

| Método | Retorno | Descrição |
|--------|---------|----------|
| `get_type()` | `str \| None` | Tipo MIME da mídia (ex: `"image/jpeg"`) |
| `get_size()` | `int \| None` | Tamanho em bytes |
| `get_path(content_type, ttl?)` | `str \| None` | URL/caminho temporário para acesso ao arquivo. `ttl` define o tempo de vida em segundos (padrão: `120`) |

---

## Exemplo

```python
from exflow.media import MediaContentType

if ctx.message.is_media():
    tipo = await ctx.media.get_type()
    tamanho = await ctx.media.get_size()
    caminho = await ctx.media.get_path(MediaContentType.IMAGE, ttl=300)

    ctx.console.info(f"Mídia recebida: {tipo} ({tamanho} bytes)")
```
