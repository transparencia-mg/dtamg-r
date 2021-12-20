## Controle de alterações

Documentação das principais alterações sofridas por este pacote.

### [Em desenvolvimento]

### [0.2.1] - 2021-12-20
#### Added
- Função `parse_sql.R` para renderização de consultas SQL para extração dos dados de um recurso a partir das informações presentes no table schema associado

#### Fixed
- Erro na `flatten_resource` durante leitura dos arquivos de dados de recursos referenciados

### [0.2.0] - 2021-27-07
#### Added
- Função `extract_datapackage` para criação de um novo 
data package gerado a partir de um subconjunto dos recursos de um data package pré-existente.

    Essa função foi motivada pela necessidade de extrair do data package [age7](https://github.com/transparencia-mg/age7) subconjuntos para representação de cada uma das consultas do Portal da Transparência.
- Função `flatten_resource` para realizar múltiplos _left joins_ a partir de um recurso base, seguindo as chaves estrangeiras definidas no data package associado. 

    Função motivada para facilitar processo de análise exploratória de tabelas fato do modelo dimensional do Portal da Transparência.

### [0.1.2] - 2021-07-01
#### Changed
- Altera posição das propriedades `description` e `notes` no processo de ordenação de `style_tableschema`

### [0.1.1] - 2021-06-18
#### Fixed
- Corrige geração de table schema inválido em `style_tableschema` ([#1](https://github.com/transparencia-mg/dtamg-r/issues/1))

### [0.1.0] - 2021-07-22
- Versão inicial
