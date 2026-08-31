# Output

`ctx.output` envia mensagens ao usuário dentro de um step. Todos os métodos são `async`. Cada tipo possui uma variante `send_*` (envia normalmente) e `reply_*` (responde a uma mensagem específica via `reply_to`).

---

## Texto

```python
await ctx.output.send_text("Olá! 👋")
await ctx.output.reply_text("Recebi sua mensagem.", reply_to="message_id")
```

---

## Botões

```python
await ctx.output.send_buttons(
    body_text="Como posso te ajudar?",
    buttons=[
        ("btn_1", "Suporte"),
        ("btn_2", "Vendas"),
    ]
)
```

```python
await ctx.output.reply_buttons(
    body_text="Escolha uma opção:",
    buttons=[("btn_1", "Opção A"), ("btn_2", "Opção B")],
    reply_to="message_id",
)
```

---

## Lista de itens

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

---

## Botão de URL

```python
await ctx.output.send_url_button(
    body_text="Acesse nossa documentação",
    display_text="Ver documentação",
    url="https://exflow.run",
)
```

---

## Mídia

| Método | Descrição |
|--------|----------|
| `send_image(media_url, caption?)` | Envia imagem |
| `reply_image(media_url, caption?, reply_to?)` | Responde com imagem |
| `send_audio(media_url)` | Envia áudio |
| `reply_audio(media_url, reply_to?)` | Responde com áudio |
| `send_video(media_url, caption?)` | Envia vídeo |
| `reply_video(media_url, caption?, reply_to?)` | Responde com vídeo |
| `send_document(media_url, caption?, filename?)` | Envia documento |
| `reply_document(media_url, caption?, filename?, reply_to?)` | Responde com documento |

```python
await ctx.output.send_image("https://exemplo.com/img.png", caption="Legenda")
await ctx.output.send_document("https://exemplo.com/manual.pdf", filename="manual.pdf")
```

---

## Carrossel

```python
# Botões de resposta rápida
await ctx.output.send_carousel_quick_reply(
    body_text="Confira nossos planos:",
    cards=[
        ("Plano Basic", "R$ 29/mês", [("btn_basic", "Escolher")]),
        ("Plano Pro",   "R$ 79/mês", [("btn_pro",   "Escolher")]),
    ],
)

# Botões de URL
await ctx.output.send_carousel_url(
    body_text="Conheça nossos produtos:",
    cards=[
        ("Produto A", "Descrição A", "https://exemplo.com/a", "Ver mais"),
        ("Produto B", "Descrição B", "https://exemplo.com/b", "Ver mais"),
    ],
)
```

---

## Builder avançado

Para envios customizados use `send()` / `reply()` com um `_BaseBuilder`:

```python
await ctx.output.send(builder)
await ctx.output.reply(builder, reply_to="message_id")
```
