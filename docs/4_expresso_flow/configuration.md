# Configuração

O Expresso Flow suporta configuração via **variáveis de ambiente**, **arquivo `.env`** e **objeto `Config`** programático.

---

## Variáveis de ambiente

| Variável | Padrão | Descrição |
|----------|--------|-----------|
| `EXFLOW_DEBUG` | `false` | Ativa modo debug (`true`/`false`) |
| `EXFLOW_HOST` | `0.0.0.0` | Host de escuta para canais HTTP |
| `EXFLOW_PORT` | `8000` | Porta principal da aplicação |
| `EXFLOW_LOG_LEVEL` | `INFO` | Nível de log (`DEBUG`, `INFO`, `WARNING`, `ERROR`) |
| `EXFLOW_SESSION_TIMEOUT` | `600` | Timeout global de sessão em segundos |

---

## Arquivo `.env`

O Expresso Flow carrega automaticamente um arquivo `.env` na raiz do projeto:

```ini title=".env"
EXFLOW_DEBUG=true
EXFLOW_PORT=8000
EXFLOW_LOG_LEVEL=DEBUG
EXFLOW_SESSION_TIMEOUT=300
```

---

## Objeto `Config`

Para configuração programática avançada:

```python
from expresso_flow import ExpressoFlow
from expresso_flow.config import Config

config = Config(
    debug=True,
    host="0.0.0.0",
    port=8000,
    log_level="DEBUG",
    session_timeout=300,
)

app = ExpressoFlow(config=config)
```

---

## Próximos passos

- [Bootstrap →](bootstrap.md)
- [Pacotes e Agentes →](packages.md)
