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
}
