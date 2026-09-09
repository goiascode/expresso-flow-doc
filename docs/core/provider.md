# Access Token Provider

## Visão geral

O `MockAccessTokenProvider` é um provider responsável por centralizar a manipulação e disponibilização do token de acesso utilizado pela aplicação.

Sua principal finalidade é abstrair a forma como o token é armazenado e disponibilizado para os componentes que necessitam realizar operações autenticadas.

A implementação apresentada é voltada principalmente para **mock, testes e ambientes de desenvolvimento**, permitindo trabalhar com um token previamente definido sem depender de um serviço externo de autenticação.

## Implementação

```python
class MockAccessTokenProvider:
    _token: str = ""

    async def get_token(self) -> str:
        return self._token

    async def bearer_header(self) -> str:
        token = await self.get_token()
        return f"Bearer {token}"
```

## Responsabilidades

O provider possui as seguintes responsabilidades:

* Armazenar o token de acesso.
* Disponibilizar o token para os componentes da aplicação.
* Gerar o token no formato utilizado pelo protocolo de autenticação `Bearer`.
* Centralizar a manipulação do token.
* Permitir a substituição da implementação de autenticação sem alterar os componentes consumidores.

## Métodos

### `get_token()`

Responsável por recuperar o token atualmente armazenado no provider.

```python
token = await provider.get_token()
```

**Retorno:**

```text
str
```

Exemplo:

```text
eyJhbGciOiJIUzI1NiIs...
```

---

### `bearer_header()`

Responsável por recuperar o token e formatá-lo para utilização no cabeçalho HTTP `Authorization`.

```python
header = await provider.bearer_header()
```

**Retorno:**

```text
Bearer eyJhbGciOiJIUzI1NiIs...
```

Esse método permite utilizar o resultado diretamente em uma requisição HTTP:

```python
headers = {
    "Authorization": await provider.bearer_header()
}
```

## Utilização durante a inicialização

O provider pode ser instanciado e disponibilizado durante a inicialização da aplicação, permitindo que os serviços que necessitam de autenticação recebam uma referência para o provider.

Dessa forma, os serviços consumidores não precisam conhecer a origem do token. Eles apenas solicitam ao provider o valor necessário para autenticação.

## Exemplo de utilização

```python
provider = MockAccessTokenProvider()

headers = {
    "Authorization": await provider.bearer_header()
}
```

O resultado será semelhante a:

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

## Benefícios

A utilização de um provider para manipulação do token proporciona:

### Desacoplamento

Os serviços não precisam saber como o token é obtido ou armazenado.

### Facilidade de testes

Em testes automatizados, é possível utilizar um token fixo sem depender de um servidor de autenticação.

### Padronização

Todos os componentes da aplicação podem utilizar a mesma interface para acessar o token.

### Substituição da implementação

A implementação `MockAccessTokenProvider` pode posteriormente ser substituída por uma implementação real sem necessidade de alterar os componentes consumidores.

Por exemplo:

```python
MockAccessTokenProvider # Desenvolvimento/testes -> Aplicação
RealAccessTokenProvider # Produção -> Serviço de autenticação
```

## Uso em diferentes ambientes

Uma possível estratégia é utilizar implementações diferentes conforme o ambiente:

| Ambiente        | Provider                  | Origem do token             |
| --------------- | ------------------------- | --------------------------- |
| Desenvolvimento | `MockAccessTokenProvider` | Token fixo/mock             |
| Testes          | `MockAccessTokenProvider` | Token controlado pelo teste |
| Homologação     | `AccessTokenProvider`     | Serviço de autenticação     |
| Produção        | `AccessTokenProvider`     | Serviço de autenticação     |

O código consumidor permanece independente da implementação utilizada.

## Considerações

O `MockAccessTokenProvider` não realiza, por si só, autenticação, renovação ou validação do token. Sua responsabilidade é **disponibilizar o token e fornecer sua representação no formato `Bearer`**.

Em uma implementação de produção, podem ser adicionadas funcionalidades como:

* Obtenção automática do token.
* Renovação do token expirado.
* Controle de expiração.
* Cache do token.
* Tratamento de falhas na autenticação.
* Integração com um serviço de identidade.
* Atualização dinâmica do token.

## Resumo

O `AccessTokenProvider` funciona como uma camada de abstração entre a aplicação e o mecanismo responsável pelo gerenciamento do token.

A interface pode ser resumida em:

```python
get_token() # Retorna o token bruto
bearer_header() # Retorna "Bearer <token>"
```
Essa abordagem mantém a autenticação desacoplada dos serviços da aplicação e facilita a utilização de diferentes estratégias de autenticação conforme o ambiente.
