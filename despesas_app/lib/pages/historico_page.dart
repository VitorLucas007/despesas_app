import 'package:despesas_app/models/despesa.dart';
import 'package:despesas_app/services/despesas_service.dart';
import 'package:despesas_app/widgets/despesas_tile_widget.dart';
import 'package:despesas_app/widgets/historico_filtro_widget.dart';
import 'package:flutter/material.dart';

class HistoricoPage extends StatefulWidget {
  final DespesasService despesasService;
  const HistoricoPage({super.key, required this.despesasService});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  TipoTransacao? _filtroTipo;
  DateTime _mesSelecionado = DateTime.now();
  List<Despesa> _despesas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void didUpdateWidget(HistoricoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recarrega os dados quando o widget for atualizado
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _isLoading = true);

    try {
      // Calcula o início e fim do mês selecionado
      final inicio = DateTime(_mesSelecionado.year, _mesSelecionado.month, 1);
      final fim = DateTime(
        _mesSelecionado.year,
        _mesSelecionado.month + 1,
        0,
        23,
        59,
        59,
      );

      List<Despesa> despesas;
      if (_filtroTipo != null) {
        // Lista todas do tipo e filtra pelo período
        final todasDespesas =
            await widget.despesasService.listarPorTipo(_filtroTipo!.name);
        despesas = todasDespesas.where((d) {
          return d.data.isAfter(inicio.subtract(const Duration(days: 1))) &&
              d.data.isBefore(fim.add(const Duration(days: 1)));
        }).toList();
      } else {
        // Lista todas do período
        despesas = await widget.despesasService.listarPorPeriodo(inicio, fim);
      }

      setState(() {
        _despesas = despesas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historico de Movimentação'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarDados,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          HistoricoFiltroWidget(
            mesSelecionado: _mesSelecionado,
            filtroTipo: _filtroTipo,
            onMesChanged: (mes) {
              setState(() {
                _mesSelecionado = mes;
              });
              _carregarDados();
            },
            onTipoChanged: (tipo) {
              setState(() => _filtroTipo = tipo);
              _carregarDados();
            },
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _despesas.isEmpty
                    ? const Center(
                        child: Text('Nenhuma movimentação...'),
                      )
                    : ListView.builder(
                        itemCount: _despesas.length,
                        itemBuilder: (context, index) {
                          final despesa = _despesas[index];
                          return DespesasTileWidget(despesa: despesa);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
