import 'package:despesas_app/models/despesa.dart';
import 'package:flutter/material.dart';

class HistoricoFiltroWidget extends StatelessWidget {
  final DateTime mesSelecionado;
  final TipoTransacao? filtroTipo;
  final Function(DateTime) onMesChanged;
  final Function(TipoTransacao?) onTipoChanged;
  const HistoricoFiltroWidget({
    super.key,
    required this.mesSelecionado,
    required this.filtroTipo,
    required this.onMesChanged,
    required this.onTipoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  onMesChanged(
                    DateTime(mesSelecionado.year, mesSelecionado.month - 1),
                  );
                },
                icon: Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Data (Mês - Ano)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Center(
                      child: Text(
                        '${mesSelecionado.month}/${mesSelecionado.year}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  onMesChanged(
                    DateTime(mesSelecionado.year, mesSelecionado.month + 1),
                  );
                },
                icon: Icon(Icons.chevron_right),
              ),
            ],
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: Text('Todos'),
                selected: filtroTipo == null,
                onSelected: (_) => onTipoChanged(null),
              ),
              FilterChip(
                label: Text('Despesas'),
                selected: filtroTipo == TipoTransacao.despesa,
                onSelected: (_) => onTipoChanged(TipoTransacao.despesa),
              ),
              FilterChip(
                label: Text('Receitas'),
                selected: filtroTipo == TipoTransacao.receita,
                onSelected: (_) => onTipoChanged(TipoTransacao.receita),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
