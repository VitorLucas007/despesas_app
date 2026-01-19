import 'package:despesas_app/models/despesa.dart';
import 'package:flutter/material.dart';

class Categoria {
  final String id;
  final String nome;
  final IconData icon;
  final TipoTransacao tipo;

  Categoria({
    required this.id,
    required this.nome,
    required this.icon,
    required this.tipo,
  });

  // Converte Categoria para Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'icon_code_point': icon.codePoint,
      'icon_font_family': icon.fontFamily,
      'icon_font_package': icon.fontPackage,
      'tipo': tipo.name,
    };
  }

  // Cria Categoria a partir de Map (para ler do banco)
  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map['id'] as String,
      nome: map['nome'] as String,
      icon: IconData(
        map['icon_code_point'] as int,
        fontFamily: map['icon_font_family'] as String?,
        fontPackage: map['icon_font_package'] as String?,
      ),
      tipo: TipoTransacao.values.firstWhere(
        (e) => e.name == map['tipo'],
        orElse: () => TipoTransacao.despesa,
      ),
    );
  }

  // Cria uma cópia da categoria com campos opcionalmente alterados
  Categoria copyWith({
    String? id,
    String? nome,
    IconData? icon,
    TipoTransacao? tipo,
  }) {
    return Categoria(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      icon: icon ?? this.icon,
      tipo: tipo ?? this.tipo,
    );
  }
}
