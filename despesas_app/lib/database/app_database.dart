import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Classe responsável pelo gerenciamento do banco de dados SQLite
/// Utiliza o padrão Singleton para garantir uma única instância do banco
class AppDatabase {
  /// Instância estática do banco de dados (Singleton)
  static Database? _database;

  /// Getter que retorna a instância do banco de dados
  /// Se o banco não existir, cria e inicializa automaticamente
  /// Implementa o padrão Singleton: se já existe, retorna a mesma instância
  static Future<Database> get instance async {
    // Se o banco já está aberto, retorna diretamente (Singleton)
    if (_database != null) return _database!;

    // Obtém o caminho padrão onde os bancos de dados são armazenados
    String databasesPath = await getDatabasesPath();
    // Cria o caminho completo para o arquivo do banco
    String path = join(databasesPath, 'app_database.db');

    // Abre ou cria o banco de dados
    _database = await openDatabase(
      path, // Caminho do arquivo do banco
      version: 1, // Versão do schema do banco (usado para migrations futuras)
      onCreate: (db, version) async {
        // Callback executado apenas na primeira vez que o banco é criado
        // Cria todas as tabelas e estruturas necessárias

        // Criação da tabela "categorias"
        // Armazena as categorias disponíveis para despesas e receitas
        await db.execute('''
          CREATE TABLE categorias (
            id TEXT PRIMARY KEY,                    -- ID único da categoria
            nome TEXT NOT NULL,                     -- Nome da categoria
            icon_code_point INTEGER NOT NULL,       -- Código do ícone
            icon_font_family TEXT,                  -- Família da fonte do ícone
            icon_font_package TEXT,                 -- Pacote da fonte do ícone
            tipo TEXT NOT NULL                      -- Tipo: "despesa" ou "receita"
          )
        ''');

        // Criação da tabela "despesas"
        // Armazena todas as transações financeiras (despesas e receitas)
        await db.execute('''
          CREATE TABLE despesas (
            id TEXT PRIMARY KEY,                    -- ID único da despesa
            descricao TEXT NOT NULL,                -- Descrição da transação
            valor REAL NOT NULL,                    -- Valor monetário
            data TEXT NOT NULL,                     -- Data em formato ISO8601
            tipo TEXT NOT NULL,                     -- Tipo: "despesa" ou "receita"
            categoria_id TEXT NOT NULL,             -- ID da categoria (FK)
            FOREIGN KEY (categoria_id) REFERENCES categorias(id) -- Relacionamento com categorias
          )
        ''');

        // Criar índices para melhorar a performance das consultas
        // Índice na coluna 'data' para consultas por período
        await db.execute('''
          CREATE INDEX idx_despesas_data ON despesas(data)
        ''');
        // Índice na coluna 'categoria_id' para consultas por categoria
        await db.execute('''
          CREATE INDEX idx_despesas_categoria ON despesas(categoria_id)
        ''');
        // Índice na coluna 'tipo' para filtrar despesas/receitas
        await db.execute('''
          CREATE INDEX idx_despesas_tipo ON despesas(tipo)
        ''');
      },
    );

    return _database!;
  }

  /// Fecha a conexão com o banco de dados
  /// Libera os recursos e permite que uma nova conexão seja criada se necessário
  static Future<void> close() async {
    if (_database != null) {
      await _database!.close(); // Fecha a conexão
      _database = null; // Limpa a referência estática
    }
  }
}
