import 'package:despesas_app/models/categoria.dart';
import 'package:despesas_app/models/despesa.dart';

/// Modelo que representa um resumo financeiro calculado a partir de despesas
/// Contém totais de entrada e saída, além das categorias com maior gasto/receita
class ResumoFinanceiro {
  /// Total de todas as receitas (entradas de dinheiro)
  final double entrada;

  /// Total de todas as despesas (saídas de dinheiro)
  final double saida;

  /// Categoria que teve o maior gasto (despesa)
  /// Pode ser null se não houver despesas
  final Categoria? maiorDespesa;

  /// Categoria que teve a maior receita
  /// Pode ser null se não houver receitas
  final Categoria? maiorReceita;

  /// Construtor do resumo financeiro
  /// entrada e saida são obrigatórios, as categorias são opcionais
  ResumoFinanceiro({
    required this.entrada,
    required this.saida,
    this.maiorDespesa,
    this.maiorReceita,
  });

  /// Calcula o saldo financeiro (entrada - saída)
  /// Retorna um valor positivo se houver lucro, negativo se houver prejuízo
  double get saldo => entrada - saida;

  /// Factory constructor que calcula o resumo a partir de uma lista de despesas
  /// Processa todas as transações e calcula totais e categorias mais relevantes
  factory ResumoFinanceiro.fromDespesas(List<Despesa> despesas) {
    // Inicializa os totais
    double entrada = 0;
    double saida = 0;

    // Maps para acumular valores por categoria
    final Map<Categoria, double> despesasPorCategoria = {};
    final Map<Categoria, double> receiasPorCategoria = {};

    // Itera sobre todas as despesas para calcular os totais
    for (final d in despesas) {
      if (d.tipo == TipoTransacao.receita) {
        // Se for receita, adiciona ao total de entrada
        entrada += d.valor;
        // Acumula o valor por categoria de receita
        receiasPorCategoria[d.categoria] =
            (receiasPorCategoria[d.categoria] ?? 0) + d.valor;
      } else {
        // Se for despesa, adiciona ao total de saída
        saida += d.valor;
        // Acumula o valor por categoria de despesa
        despesasPorCategoria[d.categoria] =
            (despesasPorCategoria[d.categoria] ?? 0) + d.valor;
      }
    }

    // Encontra a categoria com maior despesa
    Categoria? maiorDespesa;
    Categoria? maiorReceia;

    // Se houver despesas, encontra a categoria com maior valor
    if (despesasPorCategoria.isNotEmpty) {
      maiorDespesa = despesasPorCategoria.entries
          .reduce(
            (a, b) => a.value > b.value ? a : b,
          ) // Compara valores e pega o maior
          .key; // Retorna apenas a categoria (chave do map)
    }

    // Se houver receitas, encontra a categoria com maior valor
    if (receiasPorCategoria.isNotEmpty) {
      maiorReceia = receiasPorCategoria.entries
          .reduce(
            (a, b) => a.value > b.value ? a : b,
          ) // Compara valores e pega o maior
          .key; // Retorna apenas a categoria (chave do map)
    }

    // Retorna o objeto ResumoFinanceiro com todos os dados calculados
    return ResumoFinanceiro(
      entrada: entrada,
      saida: saida,
      maiorDespesa: maiorDespesa,
      maiorReceita: maiorReceia,
    );
  }
}
