import 'package:despesas_app/models/despesa.dart';
import 'package:despesas_app/models/resumo_financeiro.dart';

class DespesasService {
  final List<Despesa> _despesas = [];

  void adicionar(Despesa despesa) {
    _despesas.add(despesa);
  }

  void remover(String id) {
    _despesas.removeWhere((d) => d.id == id);
  }

  List<Despesa> listar() {
    return _despesas;
  }

  ResumoFinanceiro calcularResumo() {
    double receitas = 0;
    double despesas = 0;

    for (var d in _despesas) {
      if (d.tipo == TipoTransacao.receita) {
        receitas += d.valor;
      } else {
        despesas += d.valor;
      }
    }
    return ResumoFinanceiro(entrada: receitas, saida: despesas);
  }
}
