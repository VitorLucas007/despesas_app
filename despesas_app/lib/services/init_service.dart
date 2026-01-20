import 'package:despesas_app/database/app_database.dart';
import 'package:despesas_app/services/categoria_service.dart';
import 'package:despesas_app/utils/categorias_fixas.dart';

/// Serviço responsável por inicializar o banco de dados
/// e garantir que as categorias fixas estejam carregadas
///
/// Este serviço é executado uma vez na inicialização da aplicação
/// para garantir que o banco de dados esteja pronto e que as categorias
/// padrão (Alimentação, Transporte, etc.) estejam disponíveis
class InitService {
  /// Instância do serviço de categorias para gerenciar categorias no banco
  final CategoriaService _categoriaService = CategoriaService();

  /// Inicializa o banco de dados e carrega as categorias fixas
  /// Este método deve ser chamado no início da aplicação (main.dart)
  ///
  /// Passos executados:
  /// 1. Cria/abre a conexão com o banco de dados SQLite
  /// 2. Carrega as categorias padrão se ainda não existirem
  Future<void> inicializar() async {
    // Garante que o banco de dados seja criado/aberto
    // Se for a primeira execução, cria as tabelas automaticamente
    await AppDatabase.instance;

    // Carrega as categorias fixas se ainda não existirem
    // Isso garante que o usuário sempre tenha categorias disponíveis
    await _carregarCategoriasFixas();
  }

  /// Carrega as categorias fixas no banco de dados
  /// Verifica se cada categoria já existe antes de criar
  ///
  /// As categorias fixas são definidas em utils/categorias_fixas.dart
  /// e incluem categorias como: Casa, Alimentação, Transporte, Salário, etc.
  Future<void> _carregarCategoriasFixas() async {
    // Itera sobre todas as categorias fixas definidas
    for (final categoria in categoriasFixas) {
      // Verifica se a categoria já existe no banco
      final existe = await _categoriaService.existe(categoria.id);
      // Se não existir, cria a categoria no banco
      if (!existe) {
        await _categoriaService.criar(categoria);
      }
    }
  }
}
