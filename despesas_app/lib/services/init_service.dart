import 'package:despesas_app/database/app_database.dart';
import 'package:despesas_app/services/categoria_service.dart';
import 'package:despesas_app/utils/categorias_fixas.dart';

/// Serviço responsável por inicializar o banco de dados
/// e garantir que as categorias fixas estejam carregadas
class InitService {
  final CategoriaService _categoriaService = CategoriaService();

  /// Inicializa o banco de dados e carrega as categorias fixas
  /// se ainda não existirem
  Future<void> inicializar() async {
    // Garante que o banco de dados seja criado/aberto
    await AppDatabase.instance;

    // Carrega as categorias fixas se ainda não existirem
    await _carregarCategoriasFixas();
  }

  /// Carrega as categorias fixas no banco de dados
  /// apenas se elas ainda não existirem
  Future<void> _carregarCategoriasFixas() async {
    for (final categoria in categoriasFixas) {
      final existe = await _categoriaService.existe(categoria.id);
      if (!existe) {
        await _categoriaService.criar(categoria);
      }
    }
  }
}
