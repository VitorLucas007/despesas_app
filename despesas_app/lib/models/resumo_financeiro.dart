import 'package:despesas_app/models/despesa.dart';

class ResumoFinanceiro {
  final double entrada;
  final double saida;

  ResumoFinanceiro({required this.entrada, required this.saida});

  double get saldo => entrada - saida;

  static ResumoFinanceiro fromDespesas(List<Despesa> despesas) {
    double totalEntrada = 0;
    double totalSaida = 0;

    for (var d in despesas) {
      if (d.tipo == TipoTransacao.receita) {
        totalEntrada += d.valor;
      } else {
        totalSaida += d.valor;
      }
    }

    return ResumoFinanceiro(entrada: totalEntrada, saida: totalSaida);
  }
}
