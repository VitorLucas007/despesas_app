# 💰 Despesas App

Aplicativo desenvolvido em Flutter para controle financeiro pessoal, permitindo gerenciar despesas e receitas de forma simples e intuitiva.

## 📱 Sobre o Aplicativo

O **Despesas App** é uma aplicação mobile desenvolvida em Flutter que ajuda você a controlar suas finanças pessoais. Com ele, você pode:

- 📊 Registrar despesas e receitas
- 📈 Visualizar resumo financeiro (entradas, saídas e saldo)
- 🔍 Buscar transações por descrição
- 📅 Filtrar por período (mês/ano)
- 🏷️ Organizar por categorias (Alimentação, Transporte, Salário, etc.)
- ✏️ Editar e excluir transações

## 🚀 Funcionalidades

### Página Home
- **Resumo Financeiro**: Visualize totais de entradas (receitas) e saídas (despesas)
- **Lista de Transações**: Veja todas as suas despesas e receitas ordenadas por data
- **Busca**: Encontre transações específicas digitando parte da descrição
- **Ações Rápidas**: Edite ou exclua despesas diretamente da lista

### Página Histórico
- **Filtros Avançados**: 
  - Filtre por mês/ano (navegação anterior/próximo)
  - Filtre por tipo (Todos, Despesas ou Receitas)
  - Filtre por categoria específica
- **Resumo do Período**: Visualize o resumo financeiro apenas do período selecionado
- **Busca**: Busque transações por descrição no histórico filtrado

### Página Cadastro
- **Registro Simples**: Preencha descrição, valor e selecione a categoria
- **Categorias Intuitivas**: Escolha entre categorias pré-definidas com ícones visuais
- **Tipo de Transação**: Registre despesas ou receitas
- **Validação**: Campos validados antes de salvar

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versão 3.10.4 ou superior)
- [Dart SDK](https://dart.dev/get-dart) (incluído com Flutter)
- Android Studio ou VS Code com extensão Flutter
- Emulador Android/iOS ou dispositivo físico para testes

## 🔧 Instalação

1. **Clone o repositório** (ou baixe os arquivos):
   ```bash
   git clone <url-do-repositorio>
   cd despesas_app/despesas_app
   ```

2. **Instale as dependências**:
   ```bash
   flutter pub get
   ```

3. **Execute o aplicativo**:
   ```bash
   flutter run
   ```

## 💻 Como Usar

### Primeira Execução

Na primeira vez que abrir o aplicativo:
- O banco de dados será criado automaticamente
- As categorias padrão serão carregadas (Casa, Alimentação, Transporte, etc.)

### Cadastrar uma Despesa/Receita

1. Acesse a aba **Cadastro** (ícone de ➕)
2. Preencha os campos:
   - **Descrição**: Nome da transação (ex: "Compras no supermercado")
   - **Valor**: Valor em reais (ex: 150.50)
   - **Tipo**: Selecione Despesa ou Receita
   - **Categoria**: Toque em uma das categorias disponíveis
3. Clique em **Salvar**

### Visualizar o Resumo Financeiro

1. Na aba **Home**, você verá:
   - Total de **Entradas** (receitas) em verde
   - Total de **Saídas** (despesas) em vermelho
   - Lista de todas as transações

### Filtrar o Histórico

1. Acesse a aba **Histórico**
2. Use os controles:
   - **⬅️ ➡️**: Navegue entre meses
   - **Todos/Despesas/Receitas**: Filtre por tipo
   - **Ícone de categoria**: Filtre por categoria específica
   - **Ícone de busca**: Busque por descrição

### Editar uma Despesa

1. Na lista de despesas, toque no item desejado
2. Ou toque nos **3 pontos** (⋮) e selecione **Editar**
3. Altere os dados necessários
4. Clique em **Salvar Alterações**

### Excluir uma Despesa

1. Na lista de despesas, toque nos **3 pontos** (⋮)
2. Selecione **Deletar**
3. Confirme a exclusão no diálogo

### Buscar Transações

1. Na **Home** ou **Histórico**, toque no ícone de **🔍 busca**
2. Digite parte da descrição da transação
3. Os resultados serão filtrados automaticamente
4. Toque no "X" do chip de busca para limpar

## 🗂️ Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── models/                   # Modelos de dados
│   ├── categoria.dart        # Modelo de categoria
│   ├── despesa.dart          # Modelo de despesa/receita
│   └── resumo_financeiro.dart # Modelo de resumo financeiro
├── database/                 # Configuração do banco de dados
│   └── app_database.dart     # SQLite database setup
├── services/                 # Serviços de negócio
│   ├── init_service.dart     # Inicialização do app
│   ├── categoria_service.dart # CRUD de categorias
│   └── despesas_service.dart  # CRUD de despesas
├── pages/                    # Telas da aplicação
│   ├── home_page.dart        # Página inicial
│   ├── historico_page.dart   # Página de histórico
│   ├── add_despesa_page.dart # Página de cadastro
│   └── edit_despesa_page.dart # Página de edição
└── widgets/                  # Componentes reutilizáveis
    ├── despesas_tile_widget.dart      # Item de lista de despesa
    ├── resumo_card_widget.dart        # Card de resumo financeiro
    ├── historico_filtro_widget.dart   # Widget de filtros
    └── main_navigation_page_widget.dart # Navegação principal
```

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework de desenvolvimento multiplataforma
- **Dart**: Linguagem de programação
- **SQLite**: Banco de dados local (via package `sqflite`)
- **Material Design**: Design system do Flutter

## 📦 Dependências Principais

- `flutter`: SDK Flutter
- `sqflite`: ^2.4.2 - Banco de dados SQLite
- `path`: ^1.9.1 - Manipulação de caminhos
- `intl`: ^0.20.2 - Formatação de datas e valores

## 🗄️ Banco de Dados

O aplicativo utiliza SQLite local para armazenar os dados. As tabelas criadas são:

- **categorias**: Armazena as categorias disponíveis
- **despesas**: Armazena todas as transações (despesas e receitas)

Os dados são persistidos localmente no dispositivo e não são sincronizados com nenhum servidor.

## 📝 Categorias Padrão

O aplicativo vem com as seguintes categorias pré-configuradas:

### Despesas:
- 🏠 Casa
- 🍔 Alimentação
- 🐾 Pet
- 🚗 Carro
- 🏍️ Moto
- 🎓 Faculdade
- 🎮 Lazer
- 🚌 Transporte
- 🏥 Saúde

### Receitas:
- 💼 Salário
- 💻 Freela
- 🔧 Serviços

## 🔐 Privacidade

Todos os dados são armazenados localmente no seu dispositivo. Nenhuma informação é enviada para servidores externos ou compartilhada com terceiros.

## 📄 Licença

Este projeto é de código aberto e está disponível para uso pessoal e educacional.

## 👨‍💻 Desenvolvimento

Para contribuir ou reportar problemas:

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/NovaFuncionalidade`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/NovaFuncionalidade`)
5. Abra um Pull Request

## 📞 Suporte

Se você tiver dúvidas ou encontrar problemas, abra uma issue no repositório.

---

**Desenvolvido com ❤️ usando Flutter**
