import 'package:despesas_app/database/app_database.dart';
import 'package:despesas_app/models/despesa.dart';
import 'package:despesas_app/models/resumo_financeiro.dart';
import 'package:despesas_app/services/categoria_service.dart';
import 'package:sqflite/sqflite.dart';

class DespesasService {
  final CategoriaService _categoriaService = CategoriaService();

  // Criar uma nova despesa/receita
  Future<void> criar(Despesa despesa) async {
    final db = await AppDatabase.instance;

    // Verificar se a categoria existe, se não, criar
    final categoriaExiste = await _categoriaService.existe(
      despesa.categoria.id,
    );
    if (!categoriaExiste) {
      await _categoriaService.criar(despesa.categoria);
    }

    await db.insert(
      'despesas',
      despesa.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Buscar uma despesa por ID
  Future<Despesa?> buscarPorId(String id) async {
    final db = await AppDatabase.instance;
    final List<Map<String, dynamic>> maps = await db.query(
      'despesas',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;

    final despesaMap = maps.first;
    final categoria = await _categoriaService.buscarPorId(
      despesaMap['categoria_id'] as String,
    );

    if (categoria == null) return null;

    return Despesa.fromMap(despesaMap, categoria);
  }

  // Listar todas as despesas/receitas
  Future<List<Despesa>> listarTodos() async {
    final db = await AppDatabase.instance;
    final List<Map<String, dynamic>> maps = await db.query(
      'despesas',
      orderBy: 'data DESC, descricao ASC',
    );

    final List<Despesa> despesas = [];

    for (final map in maps) {
      final categoria = await _categoriaService.buscarPorId(
        map['categoria_id'] as String,
      );
      if (categoria != null) {
        despesas.add(Despesa.fromMap(map, categoria));
      }
    }

    return despesas;
  }

  // Listar despesas por tipo
  Future<List<Despesa>> listarPorTipo(String tipo) async {
    final db = await AppDatabase.instance;
    final List<Map<String, dynamic>> maps = await db.query(
      'despesas',
      where: 'tipo = ?',
      whereArgs: [tipo],
      orderBy: 'data DESC, descricao ASC',
    );

    final List<Despesa> despesas = [];

    for (final map in maps) {
      final categoria = await _categoriaService.buscarPorId(
        map['categoria_id'] as String,
      );
      if (categoria != null) {
        despesas.add(Despesa.fromMap(map, categoria));
      }
    }

    return despesas;
  }

  // Listar despesas por categoria
  Future<List<Despesa>> listarPorCategoria(String categoriaId) async {
    final db = await AppDatabase.instance;
    final List<Map<String, dynamic>> maps = await db.query(
      'despesas',
      where: 'categoria_id = ?',
      whereArgs: [categoriaId],
      orderBy: 'data DESC, descricao ASC',
    );

    final categoria = await _categoriaService.buscarPorId(categoriaId);
    if (categoria == null) return [];

    return List.generate(maps.length, (i) {
      return Despesa.fromMap(maps[i], categoria);
    });
  }

  // Listar despesas por período
  Future<List<Despesa>> listarPorPeriodo(DateTime inicio, DateTime fim) async {
    final db = await AppDatabase.instance;
    final List<Map<String, dynamic>> maps = await db.query(
      'despesas',
      where: 'data >= ? AND data <= ?',
      whereArgs: [inicio.toIso8601String(), fim.toIso8601String()],
      orderBy: 'data DESC, descricao ASC',
    );

    final List<Despesa> despesas = [];

    for (final map in maps) {
      final categoria = await _categoriaService.buscarPorId(
        map['categoria_id'] as String,
      );
      if (categoria != null) {
        despesas.add(Despesa.fromMap(map, categoria));
      }
    }

    return despesas;
  }

  // Atualizar uma despesa/receita
  Future<void> atualizar(Despesa despesa) async {
    final db = await AppDatabase.instance;

    // Verificar se a categoria existe, se não, criar
    final categoriaExiste = await _categoriaService.existe(
      despesa.categoria.id,
    );
    if (!categoriaExiste) {
      await _categoriaService.criar(despesa.categoria);
    }

    await db.update(
      'despesas',
      despesa.toMap(),
      where: 'id = ?',
      whereArgs: [despesa.id],
    );
  }

  // Deletar uma despesa/receita
  Future<void> deletar(String id) async {
    final db = await AppDatabase.instance;
    await db.delete('despesas', where: 'id = ?', whereArgs: [id]);
  }

  // Deletar todas as despesas
  Future<void> deletarTodas() async {
    final db = await AppDatabase.instance;
    await db.delete('despesas');
  }

  // Calcular resumo financeiro
  Future<ResumoFinanceiro> calcularResumo() async {
    final despesas = await listarTodos();
    return ResumoFinanceiro.fromDespesas(despesas);
  }

  // Calcular resumo financeiro por período
  Future<ResumoFinanceiro> calcularResumoPorPeriodo(
    DateTime inicio,
    DateTime fim,
  ) async {
    final despesas = await listarPorPeriodo(inicio, fim);
    return ResumoFinanceiro.fromDespesas(despesas);
  }

  // Buscar despesas por descrição (busca parcial)
  Future<List<Despesa>> buscarPorDescricao(String descricao) async {
    final db = await AppDatabase.instance;
    final List<Map<String, dynamic>> maps = await db.query(
      'despesas',
      where: 'descricao LIKE ?',
      whereArgs: ['%$descricao%'],
      orderBy: 'data DESC, descricao ASC',
    );

    final List<Despesa> despesas = [];

    for (final map in maps) {
      final categoria = await _categoriaService.buscarPorId(
        map['categoria_id'] as String,
      );
      if (categoria != null) {
        despesas.add(Despesa.fromMap(map, categoria));
      }
    }

    return despesas;
  }

  // Verificar se despesa existe
  Future<bool> existe(String id) async {
    final despesa = await buscarPorId(id);
    return despesa != null;
  }
}
