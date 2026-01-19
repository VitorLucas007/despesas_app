import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> get instance async {
    if (_database != null) return _database!;
    // Get the path to the database
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'app_database.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Criação da tabela "categorias"
        await db.execute('''
          CREATE TABLE categorias (
            id TEXT PRIMARY KEY,
            nome TEXT NOT NULL,
            icon_code_point INTEGER NOT NULL,
            icon_font_family TEXT,
            icon_font_package TEXT,
            tipo TEXT NOT NULL
          )
        ''');

        // Criação da tabela "despesas"
        await db.execute('''
          CREATE TABLE despesas (
            id TEXT PRIMARY KEY,
            descricao TEXT NOT NULL,
            valor REAL NOT NULL,
            data TEXT NOT NULL,
            tipo TEXT NOT NULL,
            categoria_id TEXT NOT NULL,
            FOREIGN KEY (categoria_id) REFERENCES categorias(id)
          )
        ''');

        // Criar índices para melhor performance
        await db.execute('''
          CREATE INDEX idx_despesas_data ON despesas(data)
        ''');
        await db.execute('''
          CREATE INDEX idx_despesas_categoria ON despesas(categoria_id)
        ''');
        await db.execute('''
          CREATE INDEX idx_despesas_tipo ON despesas(tipo)
        ''');
      },
    );

    return _database!;
  }

  // Método para fechar o banco de dados
  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
