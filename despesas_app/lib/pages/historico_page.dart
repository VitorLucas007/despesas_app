import 'package:despesas_app/models/despesa.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoricoPage extends StatelessWidget {
  final List<Despesa> despesas;
  const HistoricoPage({super.key, required this.despesas});

  @override
  Widget build(BuildContext context) {
    if (despesas.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma movimentação registrada',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Historico de Movimentação'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: despesas.length,
        separatorBuilder: (_, _) => SizedBox(height: 8),
        itemBuilder: (context, index) {
          final despesa = despesas[index];
          final isReceita = despesa.tipo == TipoTransacao.receita;

          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isReceita
                    ? Colors.green.withOpacity(0.15)
                    : Colors.red.withOpacity(0.15),
                child: Icon(
                  despesa.categoria.icon,
                  color: isReceita ? Colors.green : Colors.red,
                ),
              ),
              title: Text(
                despesa.descricao,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(despesa.data)),
              trailing: Text(
                '${isReceita ? '+' : '-'} R\$ ${despesa.valor.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isReceita ? Colors.green : Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
