import 'categoria.dart';

/// Enum que define os tipos de transação financeira
enum TipoTransacao {
  despesa, // Gasto/saída de dinheiro
  receita, // Entrada de dinheiro
}

/// Modelo que representa uma transação financeira (despesa ou receita)
/// Cada transação possui uma descrição, valor, data, tipo e categoria associada
class Despesa {
  /// Identificador único da despesa (usado como chave primária no banco)
  final String id;

  /// Descrição textual da transação (ex: "Compras no supermercado")
  final String descricao;

  /// Valor monetário da transação (em reais)
  final double valor;

  /// Data em que a transação ocorreu
  final DateTime data;

  /// Tipo da transação: despesa ou receita
  final TipoTransacao tipo;

  /// Categoria à qual a transação pertence (ex: Alimentação, Transporte)
  final Categoria categoria;

  /// Construtor da despesa
  /// Todos os parâmetros são obrigatórios
  Despesa({
    required this.id,
    required this.descricao,
    required this.valor,
    required this.data,
    required this.tipo,
    required this.categoria,
  });

  /// Converte o objeto Despesa para um Map
  /// Utilizado para persistir os dados no banco de dados SQLite
  /// A categoria é armazenada apenas pelo ID (chave estrangeira)
  /// A data é convertida para formato ISO8601 string para armazenamento
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'valor': valor,
      'data': data.toIso8601String(), // Converte DateTime para string ISO
      'tipo': tipo.name, // Converte enum para string
      'categoria_id': categoria.id, // Armazena apenas o ID da categoria
    };
  }

  /// Cria uma instância de Despesa a partir de um Map
  /// Utilizado para recuperar dados do banco de dados SQLite
  /// Requer a categoria completa como parâmetro (obtida através do categoria_id)
  factory Despesa.fromMap(Map<String, dynamic> map, Categoria categoria) {
    return Despesa(
      id: map['id'] as String,
      descricao: map['descricao'] as String,
      valor: (map['valor'] as num).toDouble(), // Converte para double
      data: DateTime.parse(
        map['data'] as String,
      ), // Converte string ISO para DateTime
      tipo: TipoTransacao.values.firstWhere(
        (e) => e.name == map['tipo'], // Converte string para enum
        orElse: () => TipoTransacao.despesa, // Valor padrão se não encontrar
      ),
      categoria: categoria, // Categoria completa passada como parâmetro
    );
  }

  /// Cria uma cópia da despesa com campos opcionalmente alterados
  /// Útil para atualizar uma despesa existente
  /// Se um parâmetro for null, mantém o valor original
  Despesa copyWith({
    String? id,
    String? descricao,
    double? valor,
    DateTime? data,
    TipoTransacao? tipo,
    Categoria? categoria,
  }) {
    return Despesa(
      id: id ?? this.id, // Se não fornecido, mantém o original
      descricao: descricao ?? this.descricao,
      valor: valor ?? this.valor,
      data: data ?? this.data,
      tipo: tipo ?? this.tipo,
      categoria: categoria ?? this.categoria,
    );
  }
}
