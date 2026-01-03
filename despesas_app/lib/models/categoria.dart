import 'package:despesas_app/models/despesa.dart';

class Categoria {
  final String id;
  final String nome;
  final TipoTransacao tipo;

  Categoria({required this.id, required this.nome, required this.tipo});
}
