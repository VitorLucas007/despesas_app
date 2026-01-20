import 'package:despesas_app/database/app_database.dart';
import 'package:despesas_app/models/despesa.dart';
import 'package:despesas_app/models/resumo_financeiro.dart';
import 'package:despesas_app/services/categoria_service.dart';
import 'package:sqflite/sqflite.dart';

/// Serviço responsável por todas as operações CRUD relacionadas a despesas e receitas
///
/// Gerencia a persistência de transações financeiras no banco de dados SQLite
/// Fornece métodos para criar, buscar, listar, atualizar, deletar e calcular resumos
/// Também gerencia automaticamente as categorias relacionadas
class DespesasService {
  /// Instância do serviço de categorias para gerenciar categorias relacionadas
  final CategoriaService _categoriaService = CategoriaService();

  /// Cria uma nova despesa ou receita no banco de dados
  ///
  /// Garante que a categoria associada exista no banco antes de salvar
  /// Se a categoria não existir, ela é criada automaticamente
  /// [despesa] - Objeto Despesa a ser salvo
  Future<void> criar(Despesa despesa) async {
    final db = await AppDatabase.instance;

    // Verificar se a categoria existe, se não, criar
    // Isso garante integridade referencial e evita erros
    final categoriaExiste = await _categoriaService.existe(
      despesa.categoria.id,
    );
    // Se a categoria não existir, cria ela primeiro
    if (!categoriaExiste) {
      await _categoriaService.criar(despesa.categoria);
    }

    // Insere a despesa na tabela 'despesas'
    // ConflictAlgorithm.replace: se já existir (mesmo ID), substitui
    await db.insert(
      'despesas',
      despesa.toMap(), // Converte o objeto para Map
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Busca uma despesa específica pelo seu ID
  ///
  /// Recupera a despesa e sua categoria relacionada do banco
  /// [id] - ID da despesa a ser buscada
  /// Retorna a despesa encontrada ou null se não existir
  Future<Despesa?> buscarPorId(String id) async {
    final db = await AppDatabase.instance;
    // Consulta SQL para buscar despesa por ID
    final List<Map<String, dynamic>> maps = await db.query(
      'despesas',
      where: 'id = ?', // Filtro por ID
      whereArgs: [id], // Parâmetro do filtro
      limit: 1, // Limita a 1 resultado
    );

    // Se não encontrou, retorna null
    if (maps.isEmpty) return null;

    // Obtém o primeiro resultado
    final despesaMap = maps.first;
    // Busca a categoria relacionada usando o categoria_id
    final categoria = await _categoriaService.buscarPorId(
      despesaMap['categoria_id'] as String,
    );

    // Se a categoria não existir, retorna null (dados inconsistentes)
    if (categoria == null) return null;

    // Converte o Map para objeto Despesa com a categoria completa
    return Despesa.fromMap(despesaMap, categoria);
  }

  /// Lista todas as despesas e receitas cadastradas
  ///
  /// Retorna lista ordenada por data (mais recentes primeiro) e depois por descrição
  /// Para cada despesa, busca e inclui a categoria relacionada
  /// Útil para exibir todas as transações na tela inicial
  Future<List<Despesa>> listarTodos() async {
    final db = await AppDatabase.instance;
    // Consulta todas as despesas ordenadas por data (mais recentes primeiro)
    final List<Map<String, dynamic>> maps = await db.query(
      'despesas',
      orderBy:
          'data DESC, descricao ASC', // Ordena por data decrescente, depois por descrição
    );

    final List<Despesa> despesas = [];

    // Para cada despesa encontrada, busca sua categoria e cria o objeto completo
    for (final map in maps) {
      final categoria = await _categoriaService.buscarPorId(
        map['categoria_id'] as String,
      );
      // Só adiciona se a categoria existir (integridade referencial)
      if (categoria != null) {
        despesas.add(Despesa.fromMap(map, categoria));
      }
    }

    return despesas;
  }

  /// Lista despesas filtradas por tipo (despesa ou receita)
  ///
  /// [tipo] - String com o tipo: "despesa" ou "receita"
  /// Retorna lista ordenada por data (mais recentes primeiro) e depois por descrição
  /// Útil para filtrar apenas despesas ou apenas receitas
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

  /// Lista despesas filtradas por categoria específica
  ///
  /// [categoriaId] - ID da categoria para filtrar
  /// Retorna lista ordenada por data (mais recentes primeiro) e depois por descrição
  /// Se a categoria não existir, retorna lista vazia
  /// Útil para filtrar despesas de uma categoria específica (ex: todas de "Alimentação")
  Future<List<Despesa>> listarPorCategoria(String categoriaId) async {
    final db = await AppDatabase.instance;
    // Consulta despesas filtradas por categoria
    final List<Map<String, dynamic>> maps = await db.query(
      'despesas',
      where: 'categoria_id = ?', // Filtro por categoria
      whereArgs: [categoriaId], // Parâmetro do filtro
      orderBy: 'data DESC, descricao ASC', // Ordena por data decrescente
    );

    // Busca a categoria uma vez (é a mesma para todas as despesas)
    final categoria = await _categoriaService.buscarPorId(categoriaId);
    // Se a categoria não existir, retorna lista vazia
    if (categoria == null) return [];

    // Converte cada Map para objeto Despesa usando a mesma categoria
    return List.generate(maps.length, (i) {
      return Despesa.fromMap(maps[i], categoria);
    });
  }

  /// Lista despesas filtradas por período de datas
  ///
  /// [inicio] - Data inicial do período (inclusiva)
  /// [fim] - Data final do período (inclusiva)
  /// Retorna lista ordenada por data (mais recentes primeiro) e depois por descrição
  /// Útil para filtrar despesas de um mês específico ou período customizado
  Future<List<Despesa>> listarPorPeriodo(DateTime inicio, DateTime fim) async {
    final db = await AppDatabase.instance;
    // Consulta despesas no intervalo de datas especificado
    final List<Map<String, dynamic>> maps = await db.query(
      'despesas',
      where: 'data >= ? AND data <= ?', // Filtro por período
      whereArgs: [
        inicio.toIso8601String(), // Converte data para string ISO
        fim.toIso8601String(),
      ],
      orderBy: 'data DESC, descricao ASC', // Ordena por data decrescente
    );

    final List<Despesa> despesas = [];

    // Para cada despesa encontrada, busca sua categoria
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

  /// Atualiza uma despesa existente no banco de dados
  ///
  /// Garante que a categoria associada exista antes de atualizar
  /// Se a categoria não existir, ela é criada automaticamente
  /// [despesa] - Objeto Despesa com os dados atualizados
  /// A despesa é identificada pelo ID, então o ID deve existir
  Future<void> atualizar(Despesa despesa) async {
    final db = await AppDatabase.instance;

    // Verificar se a categoria existe, se não, criar
    // Garante integridade referencial ao atualizar
    final categoriaExiste = await _categoriaService.existe(
      despesa.categoria.id,
    );
    if (!categoriaExiste) {
      await _categoriaService.criar(despesa.categoria);
    }

    // Atualiza a despesa na tabela
    await db.update(
      'despesas',
      despesa.toMap(), // Dados atualizados
      where: 'id = ?', // Identifica qual despesa atualizar
      whereArgs: [despesa.id], // ID da despesa
    );
  }

  /// Deleta uma despesa específica do banco de dados
  ///
  /// [id] - ID da despesa a ser deletada
  /// Remove permanentemente a despesa do banco
  Future<void> deletar(String id) async {
    final db = await AppDatabase.instance;
    // Remove a despesa da tabela
    await db.delete('despesas', where: 'id = ?', whereArgs: [id]);
  }

  /// Deleta todas as despesas do banco de dados
  ///
  /// ATENÇÃO: Esta operação é irreversível
  /// Remove todas as transações financeiras cadastradas
  /// Útil para resetar completamente os dados da aplicação
  Future<void> deletarTodas() async {
    final db = await AppDatabase.instance;
    // Remove todas as linhas da tabela despesas
    await db.delete('despesas');
  }

  /// Calcula o resumo financeiro geral (todas as despesas e receitas)
  ///
  /// Retorna um objeto ResumoFinanceiro contendo:
  /// - Total de entradas (receitas)
  /// - Total de saídas (despesas)
  /// - Saldo (entrada - saída)
  /// - Categorias com maiores valores
  Future<ResumoFinanceiro> calcularResumo() async {
    // Busca todas as despesas
    final despesas = await listarTodos();
    // Calcula e retorna o resumo
    return ResumoFinanceiro.fromDespesas(despesas);
  }

  /// Calcula o resumo financeiro para um período específico
  ///
  /// [inicio] - Data inicial do período
  /// [fim] - Data final do período
  /// Retorna um objeto ResumoFinanceiro apenas com as transações do período
  /// Útil para análises mensais ou por períodos customizados
  Future<ResumoFinanceiro> calcularResumoPorPeriodo(
    DateTime inicio,
    DateTime fim,
  ) async {
    // Busca despesas apenas do período especificado
    final despesas = await listarPorPeriodo(inicio, fim);
    // Calcula e retorna o resumo do período
    return ResumoFinanceiro.fromDespesas(despesas);
  }

  /// Busca despesas que contenham o termo na descrição (busca parcial)
  ///
  /// [descricao] - Termo a ser buscado na descrição (não precisa ser exato)
  /// Retorna lista ordenada por data (mais recentes primeiro) e depois por descrição
  /// A busca é case-insensitive (não diferencia maiúsculas/minúsculas)
  /// Útil para encontrar despesas específicas através da descrição
  Future<List<Despesa>> buscarPorDescricao(String descricao) async {
    final db = await AppDatabase.instance;
    // Consulta usando LIKE para busca parcial (não precisa ser exato)
    final List<Map<String, dynamic>> maps = await db.query(
      'despesas',
      where: 'descricao LIKE ?', // Busca parcial (contém o termo)
      whereArgs: ['%$descricao%'], // % antes e depois permite busca parcial
      orderBy: 'data DESC, descricao ASC', // Ordena por data decrescente
    );

    final List<Despesa> despesas = [];

    // Para cada despesa encontrada, busca sua categoria
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

  /// Verifica se uma despesa existe no banco de dados
  ///
  /// [id] - ID da despesa a ser verificada
  /// Retorna true se existir, false caso contrário
  /// Útil para validações antes de atualizar ou deletar
  Future<bool> existe(String id) async {
    // Busca a despesa pelo ID
    final despesa = await buscarPorId(id);
    // Retorna true se encontrou, false se não encontrou (null)
    return despesa != null;
  }
}
