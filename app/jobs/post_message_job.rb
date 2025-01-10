class PostMessageJob < ApplicationJob
  queue_as :default

  ZEE_URL = 'http://localhost:3000'
  AUTH_TOKEN = 'eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjI0NmM5MDU2YjhkOGVhYWQxNzgzMTAzYjFmZGFmOTQzZjE4YWJjNzcifQ.eyJpYXQiOjE3MzY0MjYzOTMsIm5iZiI6MTczNjQyNjM5MywiZXhwIjoxNzY3OTgzOTkzLCJhdWQiOiJhcGkiLCJqdGkiOiIyYWRiNDI2YmU3MGNmNGM3In0.1nDs34dmXG0czCU-IfI4QpbOY0ET5c8u50B4wkwLeeK5CT6Dg67Ib7axNy_-TRbA9KH-HPKx8oQ2DqnudJ0aNQ'

  def perform
    last_message = Message.last

    metadata = JSON.parse(last_message.metadata, symbolize_names: true)
    topic_id = metadata[:topic_id]
    message_id = metadata[:assistant_message_id]

    client = Faraday.new(url: ZEE_URL)

    endpoint = "api/v1/chat/topics/#{topic_id}/messages/#{message_id}"
    headers = { 'Authorization' => "Bearer #{AUTH_TOKEN}" }
    payload = [markdown, text_long, text_medium, text_small, json, html].sample

    result = client.patch(endpoint, payload, headers)
  end

  def html
    {
      content_type: 'html',
      content: <<~HTML
        <h1>Simulated response from the assistant formated in HTML</h1>
        <p>This is a simulated response from the assistant. The following examples show how to format the response in HTML.</p>
        <ul>
          <li>Item 1</li>
          <li>Item 2</li>
          <li>Item 3</li>
        </ul>
        <p>It can be used to send more complex messages with HTML tags.</p>
      HTML
    }
  end

  def text_long
    {
      content_type: 'text',
      content: 'The standard Lorem Ipsum passage, used since the 1500s
"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

Section 1.10.32 of "de Finibus Bonorum et Malorum", written by Cicero in 45 BC
"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"

1914 translation by H. Rackham
"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?"

Section 1.10.33 of "de Finibus Bonorum et Malorum", written by Cicero in 45 BC
"At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."

1914 translation by H. Rackham
"On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains."'
    }
  end

  def text_medium
    {
      content_type: 'text',
      content: "This is a simulated response from the assistant in plain text.\n\nIt can be used to send simple text messages.\n\nIt can also be used to send messages with line breaks.\n\nIt can also be used to send messages with line breaks.This is a simulated response from the assistant in plain text.\n\nIt can be used to send simple text messages.\n\nIt can also be used to send messages with line breaks.\n\nIt can also be used to send messages with line breaks."
    }
  end

  def text_small
    {
      content_type: 'text',
      content: "This is a simulated response from the assistant."
    }
  end

  def json
    {
      content_type: 'json',
      content: {
        key: 'value',
        key2: 'value2',
        key3: 'value3',
        key4: [
          'value4',
          'value5',
          'value6'
        ],
        key5: {
          key6: 'value7',
          key7: 'value8'
        },
        key8: {
          key9: [
            'value9',
            'value10'
          ]
        }
      }.to_json
    }
  end

  def markdown
    {
      content_type: 'markdown',
      content: <<~MARKDOWN
# Simulated response from the assistant formated in markdown

This is a simulated response from the assistant. The following examples show how to format the response in markdown.

# Título de Nível 1 (H1)
## Título de Nível 2 (H2)
### Título de Nível 3 (H3)
#### Título de Nível 4 (H4)
##### Título de Nível 5 (H5)
###### Título de Nível 6 (H6)

---

## **Texto e Estilo**

**Texto em negrito**

*Texto em itálico*

***Texto em negrito e itálico***

~~Texto tachado~~

Texto com `inline code`

~~Superscript~~

<sub>Subscript</sub>

~~Texto sublinhado~~

<u>Texto sublinhado</u>
---

## **Listas**

### Lista Ordenada
1. Primeiro item
2. Segundo item
3. Terceiro item
   1. Subitem 1
   2. Subitem 2

### Lista Não Ordenada
- Primeiro item
- Segundo item
  - Subitem 1
  - Subitem 2
- Terceiro item

---

## **Links**

[Link para Google](https://www.google.com)

[Link com título ao passar o mouse](https://www.example.com "Título do link")

---

## **Imagens**

![Texto alternativo da imagem](https://via.placeholder.com/150 "Título da imagem")

---

## **Citação**

> Este é um exemplo de citação em Markdown.  
> Pode ser usado para destacar informações importantes.

---

## **Bloco de Código**

### Código em Python
```python
def hello_world():
    print("Hello, World!")
```

### Código em JavaScript
```javascript
console.log("Hello, World! Hello, World! Hello, World! Hello, World! Hello, World! Hello, World! Hello, World!");

```

---

## **Tabelas**

| Coluna 1      | Coluna 2      | Coluna 3      |
|---------------|---------------|---------------|
| Linha 1, Col1 | Linha 1, Col2 | Linha 1, Col3 |
| Linha 2, Col1 | Linha 2, Col2 | Linha 2, Col3 |
| Linha 3, Col1 | Linha 3, Col2 | Linha 3, Col3 |

---

## **Listas de Tarefas**

- [x] Tarefa concluída
- [ ] Tarefa pendente
- [ ] Outra tarefa pendente

---

## **Detalhes/Resumo (em alguns renderizadores)**

<details>
  <summary>Clique para expandir</summary>
  Este é o texto dentro do detalhe/expansível.
</details>

---

## **Footnotes**

Aqui está um exemplo de nota de rodapé[^1].

[^1]: Este é o texto da nota de rodapé.

---

## **Emoji**

🎉 👍 🚀 😄 🎉 :smile: :+1:

---

## **Customização Avançada**

### Highlight (destaque de texto)
```html
<span style="background-color: yellow;">Texto destacado</span>
```

### Tabelas alinhadas
| Alinhado à Esquerda | Centralizado  | Alinhado à Direita |
|:--------------------|:-------------:|-------------------:|
| Texto               | Texto         | Texto             |


## Image

![Image](https://placehold.co/600x400?text=Hello+World)            

MARKDOWN
    }
  end
end