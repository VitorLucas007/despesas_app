import 'package:despesas_app/models/despesa.dart';
import 'package:despesas_app/models/resumo_financeiro.dart';
import 'package:despesas_app/widgets/despesas_tile_widget.dart';
import 'package:despesas_app/widgets/resumo_card_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Despesa> despesas;

  const HomePage({super.key, required this.despesas});

  @override
  Widget build(BuildContext context) {
    final resumo = ResumoFinanceiro.fromDespesas(despesas);

    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Despesas')),
      body: Column(
        children: [
          ResumoCardWidget(entrada: resumo.entrada, saida: resumo.saida),
          Expanded(
            child: ListView.builder(
              itemCount: despesas.length,
              itemBuilder: (context, index) {
                return DespesasTileWidget(despesa: despesas[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
