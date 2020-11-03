# Digital-preservation-BR
[Preservação digital](https://en.wikipedia.org/wiki/Digital_preservation) das principais fontes  do **banco de dados AddressForAll-Brasil**, mantido pelo [Instituto AddressForAll](http://addressforall.org/).

# OPERAÇÃO DESTE GIT

Neste repositório são registrados apenas dados de gestão, metadados dos arquivos doados (*input* de geometrias) e relatórios. 

Os metadados relativos a datasets são relativos ao arquivo comprimido contendo um ou mais pacotes de dados preservados (doação), relativos a um doador e uma data específicos. Metadados típicos são o número de bytes (file size), o tipo de arquivo (ex. `.zip` ou  `.gz`), a data de aceitação ou registro, o CNPJ da entidade doadora, o hash SHA256 do arquivo, etc. Vide pasta `/data` deste git.

Os relatórios são como um blog de anúncio de atos de registro, em geral com um resumo para apresentar também os metadados. Vide pasta `/reports` deste git.

# CONCEITOS
Apresentação dos principais conceitos e diretivas adotadas na AddressForAll e no seu Projeto de Preservação Digital.

## Fontes primárias 
As [fontes de dados primárias](https://en.wikipedia.org/wiki/Primary_source) podem ter diversas origens e diferentes metodologias de coleta. De especial interesse para o Instituto AddressForAll, num contexto de preservação de longo prazo (décadas), são as fontes de dados relativos a endereços postais de cada município do Brasil. Cada fonte consiste de um conjunto de dados sistematizados e publicados **por uma instituição** (nacional ou internacional) com idoniedade reconhecida pela comunidade local.

As fontes primárias estão relacionadas aos [dados brutos](https://en.wikipedia.org/wiki/Raw_data), quando tidos como ["verdade de campo" ou  "verdade oficial"](https://wiki.openstreetmap.org/wiki/Ground_truth_and_Official_truth), e com o trabalho mobilizado pela instituição para sistematizar, consolidar ou transformar os dados brutos em dados geográficos consistentes. Dois exemplos ilustrativos:

* Um carteiro com seu [GPS](https://en.wikipedia.org/wiki/Global_Positioning_System), confirmando que o endereço de entrega existe e está localizado nas coordenadas de latitude e longitude indicadas pelo GPS. Diversos carteiros, entregadores e outros profissionais podem alimentar uma planilha e essa planilha por fim, publicada como [**arquivo CSV**](https://en.wikipedia.org/wiki/Comma-separated_values), será a nossa fonte primária de dados.

* [Imagens de satélite](https://en.wikipedia.org/wiki/Remote_sensing) são dados brutos. Os lotes, rios e vias são desenhados sobre a imagem a partir de softwares confiáveis assistidos por pessoas habilidadas, e que terão seu trabalho publicado (na forma por exemplo de [**arquivos&nbsp;GeoJSON**](https://en.wikipedia.org/wiki/GeoJSON)) por instituições que "assinam embaixo" desse trabalho, tais como o IBGE, a Fundação OpenStreetMap, o departamento de cartografia de uma grande prefeitura, e muitos outros. <br/>Mesmo tendo  usado a mesma imagem como origem, os produtos (ex. arquivos GeoJSON resultantes) podem diferir bastante em termos de qualidade, metodologia de interpretação, modelagem dos dados e software de interpretação, de modo que **cada produto de interpretação da imagem é considerado uma fonte primária distinta**.

### Fontes OpenStreetMap Geofabrik
O [mapa OSM](https://www.openstreetmap.org/about) cobre todo o planeta, é mantido pela [Openstreetmap Foundation](https://blog.osmfoundation.org/about/), uma fundação inglesa registrada sob *Company Registration Number 05912761*.

O [planeta inteiro](https://planet.openstreetmap.org/) é uma massa de dados tão grande que inviabiliza filtragem de dados específicos. Diversos recortes do mapa OSM são [gerados por membros da OSMF](https://wiki.openstreetmap.org/wiki/Planet.osm), entre eles a  [empresa alemã, Geofabrik](https://www.geofabrik.de/geofabrik/openstreetmap.html) (*USt-Id DE222535480*). Seus recortes são considerados fiáveis e utilizados por governos e empresas por todo o mundo, portanto  amplamente auditados. Por orientação do projeto  [OSM-Stable Brasil](https://github.com/OSMBrasil/stable) ([docs](http://addressforall.org/osms/)),  o Instituto AddressForAll também  faz uso desses recortes. 

Os metadados dos arquivos preservados estão descritos no *git* do projeto, [git/OSMBrasil/stable/brazil-latest.osm.md](https://github.com/OSMBrasil/stable/blob/master/brazil-latest.osm.md#dump-opensstreetmap-do-brasil).

### Fontes IBGE
Fonte dos dados estatísticos oficiais do Brasil, bem como elementos de cartografia e localização de endereços. O IBGE - Instituto Brasileiro de Geografia e Estatística (*CNPJ  33.787.094/0001-40*)

Por ser uma fonte muito extensa, requer  [curadoria e decisões de projeto](https://github.com/AddressForAll/digital-preservation-BR/issues/1).

### Fontes nas prefeituras
Por ser uma fonte muito extensa e diversificada, requer  [curadoria e decisões de projeto](https://github.com/AddressForAll/digital-preservation-BR/issues/1).


## Normalização das fontes
Os conjuntos de dados de cada fonte apresentam formatos e características de modelagem de dados distintas. Para que possam ser comparados entre si ou processados pelas ferramentas internas do AddressForAll, precisam estar todos obedecendo a um mesmo esquema, todos modelados com uma semântica.

A transformação que se aplica a um determinado conjunto de dados da *fonte primária* para chegar no modelo de dados padrão AddressForAll, é denominada **normalização**. A descrição da metodologia, dos algorímos, bem como os códigos-fonte do software de normalização, são todos também preservados, com a mesma perspectiva de longo prazo que os dados da fonte primária.

Todos os elementos da normalização são repositórios *git* com licença aberta e publicamente distribuidos, atualmente em https://github.com/AddressForAll

## Depósito legal e preservação digital

O Depósito legal dos metadados e da normalização das fontes é realizado em dois meios complementares, tendo em vista que no Brasil os cartórios e o sistema jurídico ainda não são 100% digitais.

* **Depósito em blockchain** realizado previamente a cada confirmação de entrada, no "cartório digital" [Uniproof.com.br](https://uniproof.com.br/), garangtindo a integridade dos registros da licença e de integridade dos arquivos da fonte.

* **Depósito legal** realizado anualmente através da consolidação dos metados e códigos-fonte em um documento entitulado **"Inventário Anual  AddressForAll"**, junto à Fundação Biblioteca Nacional. O [*depósito legal* é um dispositivo previsto pelas leis federais nº 10.994 de 2004 e  nº 12.192 de 2010](https://www.bn.gov.br/sobre-bn/deposito-legal).

A preservação do arquivo em si (muitos Gigabytes) é feita por contratos de longo prazo (décadas), ainda em estudo. Uma vez no repositório definitivo, alguns parceiros se comprometem também com réplicas. PS: sistemas como  Filecoin ou LOCKSS, também em estudo, geram as réplicas de segurança automaticamente.

## Acoplamento com o projeto AddressForAll

A *Plataforma de Projetos* do *Instituto AdddressForAll* foi concebida para a gestão de projetos integrados e uso de um ecosistema de padrões e metodologias interoperáveis.
O presente projeto de preservação digital é um deles, e um subconjunto das suas entregas é utilizado no *Projeto AddressForAll*. Abaixo um diagrama que resume o passo-a-passo da preservação e como ele se relaciona com atividades de outros projetos.

![](https://github.com/AddressForAll/specifications/raw/master/docs/assets-spec02/image5.png)
 
