# ZUP Cidadão > APP iOS

    ZUP Cidadão APP iOS 
    Copyright (C) <2016> <Instituto TIM>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
--- 

## Instalação das dependências

Para a instalação do projeto, você necessita:

* xcode
* cocoapods

### Cocoapods

#### Homebrew

Para instalar o Cocoapods via homebrew, utilize o comando abaixo:
```
    brew instal cocoapods
```

#### Ruby

Para instalar num ambiente com ruby, utilize o seguinte comando:
```
    gem install cocoapods
```
#### Outros

Veja o site do [Cocoapods](https://cocoapods.org/)

## Configuração do projeto no xcode

1. Clique na opção "Open another project":
<img width="1672" alt="screen shot 2017-06-03 at 20 26 31" src="https://cloud.githubusercontent.com/assets/641411/26788651/502782f8-49e4-11e7-8b25-ab51c94ccb20.png">

2. Selecione a pasta `zup-ios-cidadao`

## Instalar dependências com o Cocoapods

Para instalar as dependências do projeto do Cocoa, rodar o seguinte comando no endereço:
```
    pod install
```

## Selecionando o Scheme correto

Para selecionar o scheme correto para a geração da build, utilize o seguinte menu:
<img width="521" alt="screen shot 2017-06-03 at 20 30 10" src="https://cloud.githubusercontent.com/assets/641411/26788489/b42f608c-49e3-11e7-8e8b-2a65525d5678.png">


## Configurando a conta para assinar a build

1. Para configurar a conta, adicionar nas preferências a conta de desenvolvedor da Apple, conforme imagem:

<img width="792" alt="screen shot 2017-06-03 at 20 32 34" src="https://cloud.githubusercontent.com/assets/641411/26788541/e6b6f934-49e3-11e7-8dc2-8dd3f93052de.png">

2. Após adição da conta, configurar a conta para assinar a build, conforme imagem:
<img width="1438" alt="screen shot 2017-06-03 at 20 35 52" src="https://cloud.githubusercontent.com/assets/641411/26788566/f8806ff6-49e3-11e7-9038-eb963473e803.png">

## Configurando Fabric

Neste projeto é utilizado o Fabric para o tracking da aplicação, erros e outras estatísticas.

Caso você continue desejando utilizar o Fabric, atualizar esta seção da build, ver imagem:
<img width="1552" alt="screen shot 2017-06-03 at 20 47 02" src="https://cloud.githubusercontent.com/assets/641411/26788582/0e57b8fc-49e4-11e7-8ae7-eeee8def98ba.png">

Ver instruções de instalação do Fabric aqui: https://docs.fabric.io/apple/fabric/overview.html.

Caso queira remover a integração com o Fabric, remover esta mesma seção da imagem acima.

## Enviando para App Store

Para enviar para a Apple Store, seguir o padrão de desenvolvimento iOS, ver link de referência: [Link](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/UploadingYourApptoiTunesConnect/UploadingYourApptoiTunesConnect.html#//apple_ref/doc/uid/TP40012582-CH36-SW2)
