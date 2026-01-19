import 'package:despesas_app/database/app_database.dart';
import 'package:despesas_app/models/categoria.dart';
import 'package:sqflite/sqflite.dart';

class CategoriaService {
  // Criar uma nova categoria
  Future<void> criar(Categoria categoria) async {
    final db = await AppDatabase.instance;
    await db.insert(
      'categorias',
      categoria.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Buscar uma categoria por ID
  Future<Categoria?> buscarPorId(String id) async {
    final db = await AppDatabase.instance;
    final List<Map<String, dynamic>> maps = await db.query(
      'categorias',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return Categoria.fromMap(maps.first);
  }

  // Listar todas as categorias
  Future<List<Categoria>> listarTodos() async {
    final db = await AppDatabase.instance;
    final List<Map<String, dynamic>> maps = await db.query(
      'categorias',
      orderBy: 'nome ASC',
    );

    return List.generate(maps.length, (i) {
      return Categoria.fromMap(maps[i]);
    });
  }

  // Listar categorias por tipo
  Future<List<Categoria>> listarPorTipo(String tipo) async {
    final db = await AppDatabase.instance;
    final List<Map<String, dynamic>> maps = await db.query(
      'categorias',
      where: 'tipo = ?',
      whereArgs: [tipo],
      orderBy: 'nome ASC',
    );

    return List.generate(maps.length, (i) {
      return Categoria.fromMap(maps[i]);
    });
  }

  // Atualizar uma categoria
  Future<void> atualizar(Categoria categoria) async {
    final db = await AppDatabase.instance;
    await db.update(
      'categorias',
      categoria.toMap(),
      where: 'id = ?',
      whereArgs: [categoria.id],
    );
  }

  // Deletar uma categoria
  Future<void> deletar(String id) async {
    final db = await AppDatabase.instance;
    await db.delete('categorias', where: 'id = ?', whereArgs: [id]);
  }

  // Verificar se categoria existe
  Future<bool> existe(String id) async {
    final categoria = await buscarPorId(id);
    return categoria != null;
  }

  // Buscar categoria por nome
  Future<Categoria?> buscarPorNome(String nome) async {
    final db = await AppDatabase.instance;
    final List<Map<String, dynamic>> maps = await db.query(
      'categorias',
      where: 'nome = ?',
      whereArgs: [nome],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return Categoria.fromMap(maps.first);
  }
}
