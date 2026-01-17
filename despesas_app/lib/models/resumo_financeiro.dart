import 'package:despesas_app/models/categoria.dart';
import 'package:despesas_app/models/despesa.dart';

class ResumoFinanceiro {
  final double entrada;
  final double saida;
  final Categoria? maiorDespesa;
  final Categoria? maiorReceita;

  ResumoFinanceiro({
    required this.entrada,
    required this.saida,
    this.maiorDespesa,
    this.maiorReceita,
  });

  double get saldo => entrada - saida;

  factory ResumoFinanceiro.fromDespesas(List<Despesa> despesas) {
    double entrada = 0;
    double saida = 0;

    final Map<Categoria, double> despesasPorCategoria = {};
    final Map<Categoria, double> receiasPorCategoria = {};

    for (final d in despesas) {
      if (d.tipo == TipoTransacao.receita) {
        entrada += d.valor;
        receiasPorCategoria[d.categoria] =
            (receiasPorCategoria[d.categoria] ?? 0) + d.valor;
      } else {
        saida += d.valor;
        despesasPorCategoria[d.categoria] =
            (despesasPorCategoria[d.categoria] ?? 0) + d.valor;
      }
    }

    Categoria? maiorDespesa;
    Categoria? maiorReceia;

    if (despesasPorCategoria.isNotEmpty) {
      maiorDespesa = despesasPorCategoria.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
    }

    if (receiasPorCategoria.isNotEmpty) {
      maiorReceia = receiasPorCategoria.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
    }

    return ResumoFinanceiro(
      entrada: entrada,
      saida: saida,
      maiorDespesa: maiorDespesa,
      maiorReceita: maiorReceia,
    );
  }
}
