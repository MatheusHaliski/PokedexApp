# PokedexApp
Repositório para o projeto de IOS - App Pokedex. Nomes: Matheus Braschi Haliski, Stephanny Almeida.
LINK PARA VIDEO NO YOUTUBE: https://youtu.be/vq2O9zFgFLw

# Descritivo Tecnico do Aplicativo iOS Pokedex
O aplicativo iOS Pokedex tem como objetivo fornecer uma enciclopedia digital dos Pokemons,
permitindo aos usuarios pesquisar, visualizar detalhes, favoritar Pokemons e gerenciar sua conta
atraves de um sistema simples de login e logout.
# Escolha da API
API Utilizada: PokeAPI (https://pokeapi.co/)
Justificativa:
- API publica e gratuita.
- Extensa base de dados de Pokemons com detalhes.
- Dados bem estruturados, facil manipulacao.
Uso:
- Buscamos nome do pokemon, ID, tipos de evolucao do pokemon, imagens e dados gerais dos Pokemons.
# Arquitetura do Aplicativo (MVVM)
Arquitetura: MVVM
- Model: Entidades no Banco de Dados.
- ViewModel: Backend para processar dados recebidos das Views, manipulando entidades do model.
- View: Frontend com telas de login, cadastro, menu, favoritos.
Diagrama:
View <--> ViewModel <--> Model
Banco de Dados: Persistencia com Core Data
Entidades:
- User: username, password
- Favorite: id(UUID), name, pokemonID(Int), imageUrl(String)
- Item: timestamp(Date)
Funcionamento:
- CRUD completo com NSPersistentContainer.
Autenticacao local baseada na entidade User.

# Definicao de design tokens:
- Arquivos: DesignTokens, DesignTokens2
- Cores: primaryColor, secondaryColor
- Fontes: titleFont, specialFont
- Espacamentos: padding
Aplicacao consistente na UI com SwiftUI.

# Itens de criatividade:
- Animacao da Pokebola na tela de login.
- Modo offline para Pokemons favoritos.
- Tema visual baseado no universo Pokemon.
- 
# Bibliotecas de Terceiros Utilizadas
Bibliotecas:
- SwiftUI
- Core Data
- URLSession (Foundation)
- Combine (se utilizado)

# Conclusao:
O iOS Pokedex combina dados da API com persistencia local, arquitetura moderna MVVM e uma
interface atrativa. Funciona offline e proporciona uma excelente experiencia de usuario.
