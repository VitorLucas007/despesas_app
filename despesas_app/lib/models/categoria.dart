import 'package:despesas_app/models/despesa.dart';
import 'package:flutter/material.dart';

/// Modelo que representa uma categoria de despesa ou receita
/// Cada categoria possui um identificador único, nome, ícone e tipo de transação
class Categoria {
  /// Identificador único da categoria (usado como chave primária no banco)
  final String id;

  /// Nome da categoria (ex: "Alimentação", "Transporte", "Salário")
  final String nome;

  /// Ícone visual que representa a categoria na interface
  final IconData icon;

  /// Tipo de transação: despesa ou receita
  final TipoTransacao tipo;

  /// Construtor da categoria
  /// Todos os parâmetros são obrigatórios
  Categoria({
    required this.id,
    required this.nome,
    required this.icon,
    required this.tipo,
  });

  /// Converte o objeto Categoria para um Map
  /// Utilizado para persistir os dados no banco de dados SQLite
  /// O ícone é serializado em seus componentes (codePoint, fontFamily, fontPackage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'icon_code_point': icon.codePoint, // Código do ícone
      'icon_font_family': icon.fontFamily, // Família da fonte do ícone
      'icon_font_package': icon.fontPackage, // Pacote da fonte do ícone
      'tipo': tipo.name, // Converte enum para string
    };
  }

  /// Cria uma instância de Categoria a partir de um Map
  /// Utilizado para recuperar dados do banco de dados SQLite
  /// Factory constructor que reconstrói o objeto a partir dos dados serializados
  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map['id'] as String,
      nome: map['nome'] as String,
      // Reconstrói o IconData a partir dos componentes salvos
      icon: IconData(
        map['icon_code_point'] as int,
        fontFamily: map['icon_font_family'] as String?,
        fontPackage: map['icon_font_package'] as String?,
      ),
      // Converte string de volta para enum TipoTransacao
      tipo: TipoTransacao.values.firstWhere(
        (e) => e.name == map['tipo'],
        orElse: () => TipoTransacao.despesa, // Valor padrão se não encontrar
      ),
    );
  }

  /// Cria uma cópia da categoria com campos opcionalmente alterados
  /// Útil para criar uma nova categoria baseada em uma existente
  /// Se um parâmetro for null, mantém o valor original
  Categoria copyWith({
    String? id,
    String? nome,
    IconData? icon,
    TipoTransacao? tipo,
  }) {
    return Categoria(
      id: id ?? this.id, // Se não fornecido, mantém o original
      nome: nome ?? this.nome,
      icon: icon ?? this.icon,
      tipo: tipo ?? this.tipo,
    );
  }
}
