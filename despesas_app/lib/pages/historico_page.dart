import 'package:despesas_app/models/categoria.dart';
import 'package:despesas_app/models/despesa.dart';
import 'package:despesas_app/models/resumo_financeiro.dart';
import 'package:despesas_app/pages/edit_despesa_page.dart';
import 'package:despesas_app/services/categoria_service.dart';
import 'package:despesas_app/services/despesas_service.dart';
import 'package:despesas_app/widgets/despesas_tile_widget.dart';
import 'package:despesas_app/widgets/historico_filtro_widget.dart';
import 'package:despesas_app/widgets/resumo_card_widget.dart';
import 'package:flutter/material.dart';

class HistoricoPage extends StatefulWidget {
  final DespesasService despesasService;
  const HistoricoPage({super.key, required this.despesasService});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  final _categoriaService = CategoriaService();

  TipoTransacao? _filtroTipo;
  Categoria? _filtroCategoria;
  DateTime _mesSelecionado = DateTime.now();
  List<Despesa> _despesas = [];
  List<Categoria> _categorias = [];
  ResumoFinanceiro? _resumoPeriodo;
  bool _isLoading = true;
  String _termoBusca = '';

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
    _carregarDados();
  }

  Future<void> _carregarCategorias() async {
    try {
      final categorias = await _categoriaService.listarTodos();
      setState(() {
        _categorias = categorias;
      });
    } catch (e) {
      // Erro silencioso
    }
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

      // Filtro por categoria tem prioridade
      if (_filtroCategoria != null) {
        despesas = await widget.despesasService.listarPorCategoria(
          _filtroCategoria!.id,
        );
        // Filtra pelo período e tipo
        despesas = despesas.where((d) {
          final mesmoMes =
              d.data.month == _mesSelecionado.month &&
              d.data.year == _mesSelecionado.year;
          final tipoOk = _filtroTipo == null || d.tipo == _filtroTipo;
          return mesmoMes && tipoOk;
        }).toList();
      } else if (_filtroTipo != null) {
        // Lista todas do tipo e filtra pelo período
        final todasDespesas = await widget.despesasService.listarPorTipo(
          _filtroTipo!.name,
        );
        despesas = todasDespesas.where((d) {
          return d.data.isAfter(inicio.subtract(const Duration(days: 1))) &&
              d.data.isBefore(fim.add(const Duration(days: 1)));
        }).toList();
      } else {
        // Lista todas do período
        despesas = await widget.despesasService.listarPorPeriodo(inicio, fim);
      }

      // Aplica busca por descrição se houver termo
      if (_termoBusca.isNotEmpty) {
        despesas = despesas
            .where(
              (d) =>
                  d.descricao.toLowerCase().contains(_termoBusca.toLowerCase()),
            )
            .toList();
      }

      // Calcula resumo do período
      final resumo = await widget.despesasService.calcularResumoPorPeriodo(
        inicio,
        fim,
      );

      setState(() {
        _despesas = despesas;
        _resumoPeriodo = resumo;
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

  Future<void> _editarDespesa(String id) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditDespesaPage(
          despesasService: widget.despesasService,
          despesaId: id,
          onSalvar: _carregarDados,
        ),
      ),
    );
    if (mounted) {
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

  void _mostrarFiltroCategoria() {
    // Agrupa categorias por tipo
    final categoriasDespesa = _categorias
        .where((c) => c.tipo == TipoTransacao.despesa)
        .toList();
    final categoriasReceita = _categorias
        .where((c) => c.tipo == TipoTransacao.receita)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  // Handle para arrastar
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  // Cabeçalho
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_alt,
                          color: Theme.of(context).primaryColor,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Filtrar por Categoria',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).textTheme.titleLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Lista de categorias
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: [
                        // Opção "Todas"
                        _buildCategoriaTile(
                          context: context,
                          title: 'Todas as categorias',
                          icon: Icons.all_inclusive,
                          iconColor: Colors.blue,
                          isSelected: _filtroCategoria == null,
                          onTap: () {
                            setState(() => _filtroCategoria = null);
                            Navigator.pop(context);
                            _carregarDados();
                          },
                        ),
                        const SizedBox(height: 8),
                        // Seção de Despesas
                        if (categoriasDespesa.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_downward,
                                  color: Colors.red[400],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Despesas',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...categoriasDespesa.map(
                            (categoria) => _buildCategoriaTile(
                              context: context,
                              categoria: categoria,
                              isSelected: _filtroCategoria?.id == categoria.id,
                              onTap: () {
                                setState(() => _filtroCategoria = categoria);
                                Navigator.pop(context);
                                _carregarDados();
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        // Seção de Receitas
                        if (categoriasReceita.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_upward,
                                  color: Colors.green[400],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Receitas',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...categoriasReceita.map(
                            (categoria) => _buildCategoriaTile(
                              context: context,
                              categoria: categoria,
                              isSelected: _filtroCategoria?.id == categoria.id,
                              onTap: () {
                                setState(() => _filtroCategoria = categoria);
                                Navigator.pop(context);
                                _carregarDados();
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom + 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoriaTile({
    required BuildContext context,
    Categoria? categoria,
    String? title,
    IconData? icon,
    Color? iconColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final finalTitle = title ?? categoria?.nome ?? '';
    final finalIcon = icon ?? categoria?.icon ?? Icons.category;
    final finalIconColor =
        iconColor ??
        (categoria?.tipo == TipoTransacao.despesa
            ? Colors.red[400]
            : Colors.green[400]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: isSelected
            ? (categoria?.tipo == TipoTransacao.despesa
                  ? Colors.red[50]
                  : Colors.green[50])
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? (categoria?.tipo == TipoTransacao.despesa
                          ? Colors.red[300]!
                          : Colors.green[300]!)
                    : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? finalIconColor?.withOpacity(0.2)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    finalIcon,
                    color: isSelected ? finalIconColor : Colors.grey[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    finalTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? (categoria?.tipo == TipoTransacao.despesa
                                ? Colors.red[900]
                                : Colors.green[900])
                          : Colors.grey[800],
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: finalIconColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historico de Movimentação'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _abrirBusca,
            tooltip: 'Buscar',
          ),
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: _mostrarFiltroCategoria,
            tooltip: 'Filtrar por categoria',
          ),
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
          if (_filtroCategoria != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.blue.shade50,
              child: Row(
                children: [
                  Icon(_filtroCategoria!.icon, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Filtro: ${_filtroCategoria!.nome}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => _filtroCategoria = null);
                      _carregarDados();
                    },
                    child: const Text('Remover'),
                  ),
                ],
              ),
            ),
          if (_resumoPeriodo != null && _despesas.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ResumoCardWidget(
                entrada: _resumoPeriodo!.entrada,
                saida: _resumoPeriodo!.saida,
              ),
            ),
          if (_termoBusca.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Chip(
                label: Text('Busca: "$_termoBusca"'),
                onDeleted: () {
                  setState(() => _termoBusca = '');
                  _carregarDados();
                },
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _despesas.isEmpty
                ? const Center(child: Text('Nenhuma movimentação...'))
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
