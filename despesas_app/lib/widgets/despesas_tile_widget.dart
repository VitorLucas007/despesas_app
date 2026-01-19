import 'package:despesas_app/models/despesa.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DespesasTileWidget extends StatelessWidget {
  final Despesa despesa;
  final VoidCallback? onEditar;
  final VoidCallback? onDeletar;

  const DespesasTileWidget({
    super.key,
    required this.despesa,
    this.onEditar,
    this.onDeletar,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: despesa.tipo == TipoTransacao.despesa
            ? Colors.red[100]
            : Colors.green[100],
        child: Icon(
          despesa.categoria.icon,
          color: despesa.tipo == TipoTransacao.despesa
              ? Colors.red
              : Colors.green,
        ),
      ),
      title: Text(despesa.descricao),
      subtitle: Text(
        '${despesa.categoria.nome}\n${DateFormat('dd/MM/yyyy').format(despesa.data)}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'R\$ ${despesa.valor.toStringAsFixed(2)}',
            style: TextStyle(
              color: despesa.tipo == TipoTransacao.despesa
                  ? Colors.red
                  : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onEditar != null || onDeletar != null) ...[
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'editar' && onEditar != null) {
                  onEditar!();
                } else if (value == 'deletar' && onDeletar != null) {
                  onDeletar!();
                }
              },
              itemBuilder: (context) => [
                if (onEditar != null)
                  const PopupMenuItem(
                    value: 'editar',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                if (onDeletar != null)
                  const PopupMenuItem(
                    value: 'deletar',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Deletar', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
      onTap: onEditar,
    );
  }
}
