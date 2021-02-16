# Tarefas
## 1. Atribuir nome de logradouro nos lotes
Os lotes possuem somente numeração predial e o código de logradouro ao qual o lote pertence.

Atribuir o nome do logradouro nos lotes usando o código de logradouro como um DE-PARA. O código de logradouro está presente nos lotes e nos eixos de vias, na coluna `COD_DV_LOG` de ambos. Ver [Extração](#Extração).

## 2. Gerar ponto de endereço na testada do lote
Procedimento usando PostGIS com script desenvolvido pelo A4A.

Cada ponto terá os dados:
* Nome do logradouro
* Número predial

# Extração
Abaixo os passos para extração por tipo de dado relevante.

## Eixos
SRID: 31983
1. Abrir `recebidos_2020-11-11.zip`.
2. Selecionar arquivos `lograd.*`.
3. Copiar arquivos selecionados para diretório alvo.

### Dados relevantes
Colunas da camada `lograd`:
* `NOME_LOGR` (string): tipo e nome do logradouro em caixa alta. O tipo de logradouro está abreviado.
* `COD_DV_LOG` (real): código do logradouro.

## Lotes
SRID: 31983
1. Abrir `recebidos_2020-11-11.zip`.
2. Selecionar arquivos `lotes.*`.
3. Copiar arquivos selecionados para diretório alvo.

### Dados relevantes
Colunas da camada `lotes`:
* `NRO_IMOV` (int): número predial. Lotes sem número são representados por 0 ou 99999.
* `COD_DV_LOG` (int): código do logradouro.

## Quadras
SRID: 31983
1. Abrir `recebidos_2020-11-11.zip`.
2. Selecionar arquivos `quadras.*`.
3. Copiar arquivos selecionados para diretório alvo.

### Dados relevantes
Colunas da camada `quadras`:
* `QUADRA` (string): número de quadra.

## Outros
Outros dados:
* Pontos de interesse: pontos turísticos e equipamentos de cultura e lazer.

(!!! Havendo outros projetos, esta seção será detalhada !!!)

# Evidências de teste
Teste no QGIS:
![](qgis.png)
