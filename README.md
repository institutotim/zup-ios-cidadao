# ZUP Cidadão > APP iOS

## Para compilar o projeto

Para a instalação do projeto, você necessita:

*   xcode
*   cocoapods

### ETAPA 1 - Cocoapods

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

## ETAPA 2 - Instalar dependências com o Cocoapods

Para instalar as dependências do projeto do Cocoa, rodar o seguinte comando no endereço do projeto:
```
    pod install
```
> Observação: Pode ser que seu repositório do Cocoa esteja desatualizado, nesse caso você poderá simplesmente rodar o comando: `pod install --repo-update` Havendo problemas com a atualização mesmo assim, pode ser que há um problema de segurança entre você e o Github
><https://blog.github.com/2018-02-23-weak-cryptographic-standards-removed/> Um dos meios de contornar isso temporariamente é executar os seguntes passos:
> -   Deletar o repositório localizado em ~/.cocoapods/repos/master
> -   Clonar novamente diretamente do [Github](https://github.com/CocoaPods/Specs)
> -   Leia mais em: <http://bit.ly/2oZIUVq>


## ETAPA 3 - Abrindo o projeto no xcode

Abra o arquivo ```zup.xcworkspace```

## ETAPA 4 - Selecionando o Scheme correto

Para selecionar o scheme correto para a geração da build, utilize o seguinte menu:
<img width="521" alt="screen shot 2017-06-03 at 20 30 10" src="https://cloud.githubusercontent.com/assets/641411/26788489/b42f608c-49e3-11e7-8e8b-2a65525d5678.png">

## ETAPA 5 - Configurando a conta para assinar a build

> **OBS:** É necessária acesso e permissão à conta do Instituto TIM para executar estas etapas corretamente

1.  Para configurar a conta, adicionar nas preferências a conta de desenvolvedor da Apple, conforme imagem:

<img width="792" alt="screen shot 2017-06-03 at 20 32 34" src="https://cloud.githubusercontent.com/assets/641411/26788541/e6b6f934-49e3-11e7-8dc2-8dd3f93052de.png">

2.  Após adição da conta, configurar a conta para assinar a build, conforme imagem:
<img width="1438" alt="screen shot 2017-06-03 at 20 35 52" src="https://cloud.githubusercontent.com/assets/641411/26788566/f8806ff6-49e3-11e7-9038-eb963473e803.png">

## ETAPA 6 - Enviando para App Store

Para enviar para a Apple Store, seguir o padrão de desenvolvimento iOS, ver link de referência: [Link](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/UploadingYourApptoiTunesConnect/UploadingYourApptoiTunesConnect.html#//apple_ref/doc/uid/TP40012582-CH36-SW2)
