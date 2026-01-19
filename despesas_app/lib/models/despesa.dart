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

  // Converte Despesa para Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'valor': valor,
      'data': data.toIso8601String(),
      'tipo': tipo.name,
      'categoria_id': categoria.id,
    };
  }

  // Cria Despesa a partir de Map (para ler do banco)
  factory Despesa.fromMap(Map<String, dynamic> map, Categoria categoria) {
    return Despesa(
      id: map['id'] as String,
      descricao: map['descricao'] as String,
      valor: (map['valor'] as num).toDouble(),
      data: DateTime.parse(map['data'] as String),
      tipo: TipoTransacao.values.firstWhere(
        (e) => e.name == map['tipo'],
        orElse: () => TipoTransacao.despesa,
      ),
      categoria: categoria,
    );
  }

  // Cria uma cópia da despesa com campos opcionalmente alterados
  Despesa copyWith({
    String? id,
    String? descricao,
    double? valor,
    DateTime? data,
    TipoTransacao? tipo,
    Categoria? categoria,
  }) {
    return Despesa(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      valor: valor ?? this.valor,
      data: data ?? this.data,
      tipo: tipo ?? this.tipo,
      categoria: categoria ?? this.categoria,
    );
  }
}
