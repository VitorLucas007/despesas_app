import 'package:despesas_app/models/categoria.dart';
import 'package:despesas_app/models/despesa.dart';
import 'package:despesas_app/services/categoria_service.dart';
import 'package:despesas_app/services/despesas_service.dart';
import 'package:flutter/material.dart';

class EditDespesaPage extends StatefulWidget {
  final DespesasService despesasService;
  final String despesaId;
  final Future<void> Function() onSalvar;

  const EditDespesaPage({
    super.key,
    required this.despesasService,
    required this.despesaId,
    required this.onSalvar,
  });

  @override
  State<EditDespesaPage> createState() => _EditDespesaPageState();
}

class _EditDespesaPageState extends State<EditDespesaPage> {
  final _formKey = GlobalKey<FormState>();
  final _categoriaService = CategoriaService();

  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final _dataController = TextEditingController();

  Despesa? _despesaOriginal;
  TipoTransacao _tipo = TipoTransacao.despesa;
  Categoria? _categoriaSelecionada;
  List<Categoria> _categoriasDisponiveis = [];
  bool _isLoading = true;
  bool _isSaving = false;
  DateTime _dataSelecionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    _carregarDespesa();
  }

  Future<void> _carregarDespesa() async {
    setState(() => _isLoading = true);

    try {
      final despesa = await widget.despesasService.buscarPorId(widget.despesaId);

      if (despesa == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Despesa não encontrada'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.of(context).pop();
        }
        return;
      }

      setState(() {
        _despesaOriginal = despesa;
        _descricaoController.text = despesa.descricao;
        _valorController.text = despesa.valor.toStringAsFixed(2);
        _dataSelecionada = despesa.data;
        _dataController.text =
            '${despesa.data.day}/${despesa.data.month}/${despesa.data.year}';
        _tipo = despesa.tipo;
        _categoriaSelecionada = despesa.categoria;
        _isLoading = false;
      });

      await _carregarCategorias();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar despesa: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _carregarCategorias() async {
    final categorias = await _categoriaService.listarPorTipo(_tipo.name);
    setState(() {
      _categoriasDisponiveis = categorias;
      // Garante que a categoria selecionada esteja disponível
      if (_categoriaSelecionada != null &&
          !_categoriasDisponiveis.any(
              (c) => c.id == _categoriaSelecionada!.id)) {
        _categoriaSelecionada = null;
      }
    });
  }

  Future<void> _selecionarData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dataSelecionada = picked;
        _dataController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoriaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma categoria'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final despesaAtualizada = _despesaOriginal!.copyWith(
        descricao: _descricaoController.text.trim(),
        valor: double.parse(_valorController.text.replaceAll(',', '.')),
        data: _dataSelecionada,
        tipo: _tipo,
        categoria: _categoriaSelecionada!,
      );

      await widget.despesasService.atualizar(despesaAtualizada);

      await widget.onSalvar();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Despesa atualizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editar Despesa')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Despesa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                    hintText: 'EX: Compras do mês...',
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty
                          ? 'Informe a descrição'
                          : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _valorController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    border: OutlineInputBorder(),
                    hintText: 'EX: 2500',
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty
                          ? 'Informe o valor'
                          : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dataController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: _selecionarData,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TipoTransacao>(
                  value: _tipo,
                  items: const [
                    DropdownMenuItem(
                      value: TipoTransacao.despesa,
                      child: Text('Despesa'),
                    ),
                    DropdownMenuItem(
                      value: TipoTransacao.receita,
                      child: Text('Receita'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _tipo = value!;
                      _categoriaSelecionada = null;
                    });
                    _carregarCategorias();
                  },
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Categorias',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 90,
                      child: _categoriasDisponiveis.isEmpty
                          ? const Center(
                              child: Text('Carregando categorias...'),
                            )
                          : ListView(
                              scrollDirection: Axis.horizontal,
                              children: _categoriasDisponiveis.map((categoria) {
                                final selecionado =
                                    _categoriaSelecionada?.id == categoria.id;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _categoriaSelecionada = categoria;
                                    });
                                  },
                                  child: Container(
                                    width: 90,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: selecionado
                                          ? Colors.green.withOpacity(0.15)
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: selecionado
                                            ? Colors.green
                                            : Colors.grey.shade300,
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          categoria.icon,
                                          size: 32,
                                          color: selecionado
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          categoria.nome,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: selecionado
                                                ? Colors.green
                                                : Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                    if (_categoriaSelecionada == null)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Selecione uma categoria',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _salvar,
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Salvar Alterações'),
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
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    _dataController.dispose();
    super.dispose();
  }
}
