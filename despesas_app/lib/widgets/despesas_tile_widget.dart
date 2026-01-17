import 'package:despesas_app/models/despesa.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DespesasTileWidget extends StatelessWidget {
  final Despesa despesa;
  const DespesasTileWidget({super.key, required this.despesa});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: despesa.tipo == TipoTransacao.despesa
            ? Colors.red[100]
            : Colors.green[100],
        child: Icon(
          despesa.tipo == TipoTransacao.despesa
              ? Icons.arrow_downward
              : Icons.arrow_upward,
          color: despesa.tipo == TipoTransacao.despesa
              ? Colors.red
              : Colors.green,
        ),
      ),
      title: Text(despesa.descricao),
      subtitle: Text(
        '${despesa.categoria.nome}\n${DateFormat('dd/MM/yyyy').format(despesa.data)}',
      ),
      trailing: Text(
        'R\$ ${despesa.valor.toStringAsFixed(2)}',
        style: TextStyle(
          color: despesa.tipo == TipoTransacao.despesa
              ? Colors.red
              : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
