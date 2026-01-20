import 'package:despesas_app/models/despesa.dart';
import 'package:despesas_app/models/resumo_financeiro.dart';
import 'package:despesas_app/pages/edit_despesa_page.dart';
import 'package:despesas_app/services/despesas_service.dart';
import 'package:despesas_app/widgets/despesas_tile_widget.dart';
import 'package:despesas_app/widgets/resumo_card_widget.dart';
import 'package:flutter/material.dart';

/// Página inicial da aplicação
///
/// Exibe o resumo financeiro (entradas e saídas) e lista todas as despesas/receitas
/// Permite buscar por descrição, editar e deletar despesas
class HomePage extends StatefulWidget {
  /// Serviço para operações com despesas no banco de dados
  final DespesasService despesasService;

  const HomePage({super.key, required this.despesasService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Lista de despesas/receitas a serem exibidas
  List<Despesa> _despesas = [];

  /// Resumo financeiro calculado a partir das despesas
  ResumoFinanceiro _resumo = ResumoFinanceiro(entrada: 0, saida: 0);

  /// Indica se os dados estão sendo carregados do banco
  bool _isLoading = true;

  /// Termo de busca para filtrar despesas por descrição
  String _termoBusca = '';

  @override
  void initState() {
    super.initState();
    // Carrega os dados ao inicializar a página
    _carregarDados();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recarrega os dados quando o widget for atualizado (ex: após salvar uma despesa)
    _carregarDados();
  }

  /// Carrega as despesas e o resumo financeiro do banco de dados
  ///
  /// Se houver termo de busca, filtra por descrição
  /// Atualiza o estado de loading e exibe erros se houver
  Future<void> _carregarDados() async {
    setState(() => _isLoading = true);

    try {
      List<Despesa> despesas;
      if (_termoBusca.isNotEmpty) {
        despesas = await widget.despesasService.buscarPorDescricao(_termoBusca);
      } else {
        despesas = await widget.despesasService.listarTodos();
      }

      final resumo = await widget.despesasService.calcularResumo();

      setState(() {
        _despesas = despesas;
        _resumo = resumo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao carregar dados: $e')));
      }
    }
  }

  Future<void> _abrirBusca() async {
    final termo = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _termoBusca);
        return AlertDialog(
          title: const Text('Buscar Despesas'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Digite a descrição',
              hintText: 'Ex: Compras, Salário...',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => _termoBusca = '');
                Navigator.of(context).pop('');
              },
              child: const Text('Limpar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Buscar'),
            ),
          ],
        );
      },
    );

    if (termo != null) {
      setState(() => _termoBusca = termo);
      _carregarDados();
    }
  }

  Future<void> _editarDespesa(String id) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditDespesaPage(
          despesasService: widget.despesasService,
          despesaId: id,
          onSalvar: _carregarDados,
        ),
      ),
    );
    if (result == true || mounted) {
      _carregarDados();
    }
  }

  Future<void> _deletarDespesa(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir esta despesa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await widget.despesasService.deletar(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Despesa excluída com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _carregarDados();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
            icon: const Icon(Icons.search),
            onPressed: _abrirBusca,
            tooltip: 'Buscar',
          ),
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
                            final despesa = _despesas[index];
                            return DespesasTileWidget(
                              despesa: despesa,
                              onEditar: () => _editarDespesa(despesa.id),
                              onDeletar: () => _deletarDespesa(despesa.id),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
