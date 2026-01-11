import 'package:despesas_app/models/categoria.dart';
import 'package:despesas_app/models/despesa.dart';
import 'package:flutter/material.dart';

final List<Categoria> categoriasFixas = [
  // DESPESAS
  Categoria(
    id: 'casa',
    nome: 'Casa',
    icon: Icons.home,
    tipo: TipoTransacao.despesa,
  ),
  Categoria(
    id: 'alimentacao',
    nome: 'Alimentação',
    icon: Icons.restaurant,
    tipo: TipoTransacao.despesa,
  ),
  Categoria(
    id: 'pet',
    nome: 'Pet',
    icon: Icons.pets,
    tipo: TipoTransacao.despesa,
  ),
  Categoria(
    id: 'carro',
    nome: 'Carro',
    icon: Icons.directions_car,
    tipo: TipoTransacao.despesa,
  ),
  Categoria(
    id: 'moto',
    nome: 'Moto',
    icon: Icons.two_wheeler,
    tipo: TipoTransacao.despesa,
  ),
  Categoria(
    id: 'escola',
    nome: 'Faculdade',
    icon: Icons.school,
    tipo: TipoTransacao.despesa,
  ),
  Categoria(
    id: 'lazer',
    nome: 'Lazer',
    icon: Icons.sports_esports,
    tipo: TipoTransacao.despesa,
  ),
  Categoria(
    id: 'transporte',
    nome: 'Transporte',
    icon: Icons.directions_bus,
    tipo: TipoTransacao.despesa,
  ),
  Categoria(
    id: 'saude',
    nome: 'Saúde',
    icon: Icons.local_hospital,
    tipo: TipoTransacao.despesa,
  ),

  // RECEITAS
  Categoria(
    id: 'salario',
    nome: 'Salário',
    icon: Icons.work,
    tipo: TipoTransacao.receita,
  ),
  Categoria(
    id: 'freela',
    nome: 'Freela',
    icon: Icons.laptop,
    tipo: TipoTransacao.receita,
  ),
  Categoria(
    id: 'servicos',
    nome: 'Serviços',
    icon: Icons.build,
    tipo: TipoTransacao.receita,
  ),
];
