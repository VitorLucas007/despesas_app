import 'package:despesas_app/models/despesa.dart';
import 'package:despesas_app/widgets/despesas_tile_widget.dart';
import 'package:despesas_app/widgets/historico_filtro_widget.dart';
import 'package:flutter/material.dart';

class HistoricoPage extends StatefulWidget {
  final List<Despesa> despesas;
  const HistoricoPage({super.key, required this.despesas});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  TipoTransacao? _filtroTipo;
  DateTime _mesSelecionado = DateTime.now();

  List<Despesa> get _despesasFiltradas {
    return widget.despesas.where((d) {
      final mesmoMes =
          d.data.month == _mesSelecionado.month &&
          d.data.year == _mesSelecionado.year;

      final tipoOk = _filtroTipo == null || d.tipo == _filtroTipo;

      return mesmoMes && tipoOk;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historico de Movimentação'),
        centerTitle: true,
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
            },
            onTipoChanged: (tipo) {
              setState(() => _filtroTipo = tipo);
            },
          ),
          Expanded(
            child: _despesasFiltradas.isEmpty
                ? Center(child: Text('Nenhuma movimentação...'))
                : ListView.builder(
                    itemCount: _despesasFiltradas.length,
                    itemBuilder: (context, index) {
                      final despesa = _despesasFiltradas[index];
                      return DespesasTileWidget(despesa: despesa);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
