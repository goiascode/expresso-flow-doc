# exflow run

Inicia o **daemon do Expresso Flow**, estabelecendo a conexão segura entre a sua máquina local e o Router central para viabilizar a recepção e envio de mensagens (incluindo o vínculo direto com o WhatsApp).

---

## Sintaxe

```bash
exflow run [OPÇÕES]
```

## Opções

| Opção | Padrão | Descrição |
|-------|--------|-----------|
| `--config <arquivo>` | `config.yaml` | Caminho para o arquivo de configuração |
| `-h, --help` | — | Exibe ajuda sobre o comando |

---

## Pré-requisitos

Para que o daemon inicie com sucesso, é obrigatório:

1. Que o arquivo [`config.yaml`](../configuration.md) esteja presente na pasta onde o comando é executado (ou especificado via `--config`).
2. Que as chaves `access_id` e `access_key` da seção `account` estejam preenchidas com as credenciais fornecidas pelo responsável pelo framework.
3. Que a seção `host` esteja preenchida com a identificação personalizada da sua máquina.

```bash
# Executa usando o config.yaml da pasta atual:
exflow run

# Com porta customizada:
exflow run --port 9000

# Sem hot-reload:
exflow run --no-reload

# Especificando um caminho customizado para o config.yaml:
exflow run --config /caminho/para/meu-config.yaml
```

---

## Funcionamento do Daemon

Quando o comando `exflow run` é disparado:

1. **Leitura e validação**: O `config.yaml` é carregado e validado.
2. **Autenticação**: A CLI autentica junto ao Router (`router.url`) usando as credenciais de `account`.
3. **Registro do Host**: O host local é registrado com o `id` e metadados informados.
4. **Vínculo com WhatsApp**: Uma vez autenticado, o Router direciona o tráfego do WhatsApp correspondente ao seu host diretamente para o seu endpoint local (`flow.endpoint`, ex: `http://localhost:8080`), permitindo o teste de fluxos em tempo real.
5. **Message Relay**: O serviço local de relay (`msgrelay.addr`, ex: `:9090`) é inicializado para tráfego bidirecional de mensagens.

---

## Próximos passos

* [Configuração detalhada do `config.yaml`](../configuration.md)
* [Comando `exflow build`](build.md)
* [Comando `exflow publish`](publish.md)
