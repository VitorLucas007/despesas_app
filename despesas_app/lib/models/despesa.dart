import 'categoria.dart';

enum TipoTransacao { despesa, receita }

class Despesa {
  final String id;
  final String descricao;
  final double valor;
  final DateTime data;
  final TipoTransacao tipo;
  final Categoria categoria;

  Despesa({
    required this.id,
    required this.descricao,
    required this.valor,
    required this.data,
    required this.tipo,
    required this.categoria,
  });
}
