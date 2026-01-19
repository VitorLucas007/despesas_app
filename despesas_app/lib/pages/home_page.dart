import 'package:despesas_app/models/despesa.dart';
import 'package:despesas_app/models/resumo_financeiro.dart';
import 'package:despesas_app/services/despesas_service.dart';
import 'package:despesas_app/widgets/despesas_tile_widget.dart';
import 'package:despesas_app/widgets/resumo_card_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final DespesasService despesasService;

  const HomePage({super.key, required this.despesasService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Despesa> _despesas = [];
  ResumoFinanceiro _resumo = ResumoFinanceiro(entrada: 0, saida: 0);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recarrega os dados quando o widget for atualizado
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _isLoading = true);
    
    try {
      final despesas = await widget.despesasService.listarTodos();
      final resumo = await widget.despesasService.calcularResumo();
      
      setState(() {
        _despesas = despesas;
        _resumo = resumo;
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
        title: const Text('Minhas Despesas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarDados,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ResumoCardWidget(
                  entrada: _resumo.entrada,
                  saida: _resumo.saida,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Resumo Receitas e Despesas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _despesas.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhuma despesa cadastrada ainda.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _despesas.length,
                          itemBuilder: (context, index) {
                            return DespesasTileWidget(
                              despesa: _despesas[index],
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
