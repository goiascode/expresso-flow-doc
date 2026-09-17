# Configuração da CLI (`config.yaml`)

Para o funcionamento completo da **Expresso Flow CLI** — especialmente para a execução do daemon através de `exflow run` — é obrigatório que o arquivo de configuração `config.yaml` esteja presente e devidamente configurado.

---

## Visão geral

O `config.yaml` estabelece a ponte de comunicação entre a CLI em sua máquina local e a infraestrutura central do Expresso Flow (Router), permitindo a autenticação da sua conta e a criação de um **host local para vínculo direto com o WhatsApp**.

```
┌───────────────────┐       ┌───────────────────┐       ┌────────────────────────┐
│   WhatsApp User    ────►     Router Remoto   ────►   Daemon Local (exflow)│
│                    ◄────        (run)        ◄────   http://localhost:8080│
└───────────────────┘       └───────────────────┘       └────────────────────────┘
                                                               │
                                                        Lê config.yaml
                                                   (access_id, host, relay)
```

---

## Onde obter o arquivo

O template padrão do `config.yaml` pode ser obtido diretamente do repositório de binários:

* **Download**: [https://exflow.run/bin/](https://exflow.run/bin/)

!!! important "Mesma pasta do executável"
    O arquivo `config.yaml` deve ficar **na mesma pasta do executável `exflow`** (ou no diretório a partir do qual você executa o comando no terminal).
    
    Caso queira manter o arquivo em outro diretório, utilize a flag `--config`:
    ```bash
    exflow run --config /caminho/para/seu/config.yaml
    ```

---

## Estrutura do `config.yaml`

Abaixo está o modelo completo do arquivo de configuração:

```yaml title="config.yaml"
app:
  name: exflow-cli
  version: "0.1.29"

account:
  access_id: "<<ACCESS_ID>>"
  access_key: "<<ACCESS_KEY>>"

host:
  id: "meu-host-local"
  name: "Meu Host Local" #Fulano Flows
  owner:
    name: "Seu Nome"
    email: "seu.email@exemplo.com"

flow:
  endpoint: "http://localhost:8080"
  interval_seconds: 3

msgrelay:
  addr: ":9090"
```

---

## Descrição dos campos

### `app`
Metadados da aplicação CLI.
* `name`: Identificador da CLI (`expresso-flow-cli`).
* `version`: Versão do formato de configuração.

### `account`
Credenciais de acesso e autenticação no ecossistema Expresso Flow:
* `access_id`: Identificador exclusivo da conta (ex: `EFL_SEU_ACCESS_ID`).
* `access_key`: Chave secreta de autenticação (ex: `sua_access_key_aqui`).

!!! warning "Credenciais obrigatórias"
    O `access_id` e a `access_key` são **fornecidos pelo responsável/administrador do framework Expresso Flow**. 
    
    Sem essas credenciais válidas preenchidas no `config.yaml`, o comando `exflow run` não terá autorização para conectar ao router.

### `host`
Identificação personalizada da sua máquina/instância de desenvolvimento:
* `id`: Identificador exclusivo do seu host (ex: `meu-host-local`). Deve ser único na rede do router.
* `name`: Nome amigável do host (ex: `Meu Host Local`).
* `owner.name`: Nome do desenvolvedor responsável pelo host (ex: `Seu Nome`).
* `owner.email`: E-mail de contato do desenvolvedor (ex: `seu.email@exemplo.com`).

### `flow`
Configurações da aplicação de fluxos que roda na sua máquina:
* `endpoint`: URL local onde seu fluxo está rodando e escutando requisições (padrão: `http://localhost:8080`).
* `interval_seconds`: Intervalo em segundos para sincronização e health-check com o daemon.

### `msgrelay`
Configuração do servidor de retransmissão de mensagens:
* `addr`: Porta local de escuta do message relay (padrão: `:9090`).

---

## Passo a passo: Configuração e Vínculo com o WhatsApp

1. **Baixar o executável e o arquivo de configuração**:
   Baixe o `exflow` (ou `exflow.exe`) e o `config.yaml` em [https://exflow.run/bin/](https://exflow.run/bin/) e armazene ambos na mesma pasta.

2. **Solicitar as credenciais**:
   Solicite o seu `access_id` e `access_key` junto ao time responsável pelo Expresso Flow.

3. **Editar o `config.yaml`**:
   Abra o arquivo em seu editor e preencha:
   * O seu `access_id` e `access_key` recebidos na seção `account`.
   * As informações personalizadas da sua máquina na seção `host` (`id`, `name`, `owner`).

4. **Executar o daemon**:
   No terminal, dentro da pasta onde está o arquivo (ou com o executável no PATH):
   ```bash
   exflow run
   ```

5. **Acesso autorizado e roteamento WhatsApp ativo**:
   Ao iniciar, o daemon se conecta de forma segura ao roteador central. Esse processo autoriza seu host local e permite o vínculo direto com o WhatsApp: as mensagens destinadas ao seu host configurado serão entregues diretamente ao seu endpoint local (`http://localhost:8080`), permitindo testar e debugar seus fluxos conversacionais em tempo real.

---

## Próximos passos

* [Referência do comando `exflow run`](commands/run.md)
* [Referência de todos os comandos CLI](commands/index.md)
