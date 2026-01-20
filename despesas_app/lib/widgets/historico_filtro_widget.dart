import 'package:despesas_app/models/despesa.dart';
import 'package:flutter/material.dart';

/// Widget que exibe controles de filtro para o histórico de despesas
///
/// Permite filtrar por mês/ano (navegação anterior/próximo) e por tipo
/// (todos, despesas ou receitas). Usa FilterChips para seleção de tipo.
class HistoricoFiltroWidget extends StatelessWidget {
  /// Mês e ano atualmente selecionados para filtro
  final DateTime mesSelecionado;

  /// Tipo de transação selecionado (null = todos, despesa ou receita)
  final TipoTransacao? filtroTipo;

  /// Callback chamado quando o mês selecionado muda
  /// Recebe o novo DateTime com o mês alterado
  final Function(DateTime) onMesChanged;

  /// Callback chamado quando o tipo de filtro muda
  /// Recebe o novo TipoTransacao ou null para "todos"
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
          // Navegação de mês (anterior/próximo)
          Row(
            children: [
              // Botão para voltar um mês
              IconButton(
                onPressed: () {
                  // Cria novo DateTime com mês anterior
                  onMesChanged(
                    DateTime(mesSelecionado.year, mesSelecionado.month - 1),
                  );
                },
                icon: const Icon(Icons.chevron_left),
              ),
              // Exibe mês/ano atual
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Data (Mês - Ano)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Center(
                      child: Text(
                        '${mesSelecionado.month}/${mesSelecionado.year}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              // Botão para avançar um mês
              IconButton(
                onPressed: () {
                  // Cria novo DateTime com próximo mês
                  onMesChanged(
                    DateTime(mesSelecionado.year, mesSelecionado.month + 1),
                  );
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Filtros por tipo (Todos, Despesas, Receitas)
          Wrap(
            spacing: 8, // Espaçamento entre os chips
            children: [
              // Filtro "Todos" - mostra despesas e receitas
              FilterChip(
                label: const Text('Todos'),
                selected:
                    filtroTipo == null, // Selecionado se não houver filtro
                onSelected: (_) => onTipoChanged(null), // Remove filtro
              ),
              // Filtro "Despesas" - mostra apenas despesas
              FilterChip(
                label: const Text('Despesas'),
                selected: filtroTipo == TipoTransacao.despesa,
                onSelected: (_) => onTipoChanged(TipoTransacao.despesa),
              ),
              // Filtro "Receitas" - mostra apenas receitas
              FilterChip(
                label: const Text('Receitas'),
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
