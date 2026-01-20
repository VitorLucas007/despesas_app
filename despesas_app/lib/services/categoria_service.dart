import 'package:despesas_app/database/app_database.dart';
import 'package:despesas_app/models/categoria.dart';
import 'package:sqflite/sqflite.dart';

/// Serviço responsável por todas as operações CRUD relacionadas a categorias
///
/// Gerencia a persistência de categorias no banco de dados SQLite
/// Fornece métodos para criar, buscar, listar, atualizar e deletar categorias
class CategoriaService {
  /// Cria uma nova categoria no banco de dados
  ///
  /// Se a categoria já existir (mesmo ID), será substituída
  /// [categoria] - Objeto Categoria a ser salvo
  Future<void> criar(Categoria categoria) async {
    final db = await AppDatabase.instance;
    // Insere a categoria na tabela 'categorias'
    // ConflictAlgorithm.replace: se já existir, substitui
    await db.insert(
      'categorias',
      categoria.toMap(), // Converte o objeto para Map
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Busca uma categoria específica pelo seu ID
  ///
  /// [id] - ID da categoria a ser buscada
  /// Retorna a categoria encontrada ou null se não existir
  Future<Categoria?> buscarPorId(String id) async {
    final db = await AppDatabase.instance;
    // Consulta SQL para buscar categoria por ID
    final List<Map<String, dynamic>> maps = await db.query(
      'categorias',
      where: 'id = ?', // Filtro por ID
      whereArgs: [id], // Parâmetro do filtro (previne SQL injection)
      limit: 1, // Limita a 1 resultado
    );

    // Se não encontrou, retorna null
    if (maps.isEmpty) return null;
    // Converte o Map retornado do banco para objeto Categoria
    return Categoria.fromMap(maps.first);
  }

  /// Lista todas as categorias cadastradas
  ///
  /// Retorna lista ordenada alfabeticamente por nome
  /// Útil para exibir todas as categorias disponíveis
  Future<List<Categoria>> listarTodos() async {
    final db = await AppDatabase.instance;
    // Consulta todas as categorias ordenadas por nome
    final List<Map<String, dynamic>> maps = await db.query(
      'categorias',
      orderBy: 'nome ASC', // Ordena alfabeticamente
    );

    // Converte cada Map para objeto Categoria
    return List.generate(maps.length, (i) {
      return Categoria.fromMap(maps[i]);
    });
  }

  /// Lista categorias filtradas por tipo (despesa ou receita)
  ///
  /// [tipo] - String com o tipo: "despesa" ou "receita"
  /// Retorna lista ordenada alfabeticamente por nome
  /// Útil para filtrar categorias quando o usuário seleciona o tipo de transação
  Future<List<Categoria>> listarPorTipo(String tipo) async {
    final db = await AppDatabase.instance;
    // Consulta categorias filtradas por tipo
    final List<Map<String, dynamic>> maps = await db.query(
      'categorias',
      where: 'tipo = ?', // Filtro por tipo
      whereArgs: [tipo], // Parâmetro do filtro
      orderBy: 'nome ASC', // Ordena alfabeticamente
    );

    // Converte cada Map para objeto Categoria
    return List.generate(maps.length, (i) {
      return Categoria.fromMap(maps[i]);
    });
  }

  /// Atualiza uma categoria existente no banco de dados
  ///
  /// [categoria] - Objeto Categoria com os dados atualizados
  /// A categoria é identificada pelo ID, então o ID deve existir
  Future<void> atualizar(Categoria categoria) async {
    final db = await AppDatabase.instance;
    // Atualiza a categoria na tabela
    await db.update(
      'categorias',
      categoria.toMap(), // Dados atualizados
      where: 'id = ?', // Identifica qual categoria atualizar
      whereArgs: [categoria.id], // ID da categoria
    );
  }

  /// Deleta uma categoria do banco de dados
  ///
  /// [id] - ID da categoria a ser deletada
  /// Cuidado: Pode afetar despesas relacionadas (verificar constraints)
  Future<void> deletar(String id) async {
    final db = await AppDatabase.instance;
    // Remove a categoria da tabela
    await db.delete('categorias', where: 'id = ?', whereArgs: [id]);
  }

  /// Verifica se uma categoria existe no banco de dados
  ///
  /// [id] - ID da categoria a ser verificada
  /// Retorna true se existir, false caso contrário
  /// Útil para verificar antes de criar ou deletar
  Future<bool> existe(String id) async {
    // Busca a categoria pelo ID
    final categoria = await buscarPorId(id);
    // Retorna true se encontrou, false se não encontrou (null)
    return categoria != null;
  }

  /// Busca uma categoria pelo seu nome
  ///
  /// [nome] - Nome da categoria a ser buscada
  /// Retorna a primeira categoria encontrada com esse nome ou null
  /// Útil para validações ou buscas por nome
  Future<Categoria?> buscarPorNome(String nome) async {
    final db = await AppDatabase.instance;
    // Consulta categoria por nome exato
    final List<Map<String, dynamic>> maps = await db.query(
      'categorias',
      where: 'nome = ?', // Filtro por nome
      whereArgs: [nome], // Parâmetro do filtro
      limit: 1, // Limita a 1 resultado
    );

    // Se não encontrou, retorna null
    if (maps.isEmpty) return null;
    // Converte o Map para objeto Categoria
    return Categoria.fromMap(maps.first);
  }
}
