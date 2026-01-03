import 'package:despesas_app/models/despesa.dart';

class ResumoFinanceiro {
  final double totalReceitas;
  final double totalDespesas;

  ResumoFinanceiro({required this.totalReceitas, required this.totalDespesas});

  double get saldo => totalReceitas - totalDespesas;

  static ResumoFinanceiro fromDespesas(List<Despesa> despesas) {
    double receitas = 0;
    double gastos = 0;

    for (var d in despesas) {
      if (d.tipo == TipoTransacao.receita) {
        receitas += d.valor;
      } else {
        gastos += d.valor;
      }
    }

    return ResumoFinanceiro(totalReceitas: receitas, totalDespesas: gastos);
  }
}
