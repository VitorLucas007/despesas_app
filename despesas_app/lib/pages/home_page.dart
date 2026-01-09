import 'package:despesas_app/models/despesa.dart';
import 'package:despesas_app/models/resumo_financeiro.dart';
import 'package:despesas_app/pages/add_despesa_page.dart';
import 'package:despesas_app/widgets/despesas_tile_widget.dart';
import 'package:despesas_app/widgets/resumo_card_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Despesa> _despesas = [];

  ResumoFinanceiro get _resumo => ResumoFinanceiro.fromDespesas(_despesas);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Minhas Despesas'), centerTitle: true),
      body: Column(
        children: [
          ResumoCardWidget(entrada: _resumo.entrada, saida: _resumo.saida),
          Expanded(
            child: ListView.builder(
              itemCount: _despesas.length,
              itemBuilder: (context, index) {
                return DespesasTileWidget(despesa: _despesas[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final despesa = await Navigator.push<Despesa>(
            context,
            MaterialPageRoute(builder: (context) => AddDespesaPage()),
          );

          if (despesa != null) {
            setState(() {
              _despesas.add(despesa);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
