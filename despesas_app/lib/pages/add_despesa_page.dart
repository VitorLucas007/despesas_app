import 'package:despesas_app/models/categoria.dart';
import 'package:despesas_app/models/despesa.dart';
import 'package:despesas_app/services/categoria_service.dart';
import 'package:despesas_app/services/despesas_service.dart';
import 'package:flutter/material.dart';

class AddDespesaPage extends StatefulWidget {
  final DespesasService despesasService;
  final Future<void> Function() onSalvar;
  
  const AddDespesaPage({
    super.key,
    required this.despesasService,
    required this.onSalvar,
  });

  @override
  State<AddDespesaPage> createState() => _AddDespesaPageState();
}

class _AddDespesaPageState extends State<AddDespesaPage> {
  final _formKey = GlobalKey<FormState>();
  final _categoriaService = CategoriaService();

  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();

  TipoTransacao _tipo = TipoTransacao.despesa;
  Categoria? _categoriaSelecionada;
  List<Categoria> _categoriasDisponiveis = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
  }

  Future<void> _carregarCategorias() async {
    final categorias = await _categoriaService.listarPorTipo(_tipo.name);
    setState(() {
      _categoriasDisponiveis = categorias;
      // Se a categoria selecionada não existe mais para o tipo atual, limpa
      if (_categoriaSelecionada != null &&
          !_categoriasDisponiveis.any(
              (c) => c.id == _categoriaSelecionada!.id)) {
        _categoriaSelecionada = null;
      }
    });
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

    setState(() => _isLoading = true);

    try {
      final despesa = Despesa(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        descricao: _descricaoController.text.trim(),
        valor: double.parse(_valorController.text.replaceAll(',', '.')),
        data: DateTime.now(),
        tipo: _tipo,
        categoria: _categoriaSelecionada!,
      );

      await widget.despesasService.criar(despesa);

      // Limpa os campos após salvar
      _descricaoController.clear();
      _valorController.clear();
      setState(() {
        _categoriaSelecionada = null;
        _isLoading = false;
      });

      // Notifica que foi salvo
      await widget.onSalvar();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Despesa salva com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Recarrega categorias quando o tipo muda
    if (_categoriasDisponiveis.isEmpty ||
        _categoriasDisponiveis.first.tipo != _tipo) {
      _carregarCategorias();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Despesa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                  hintText: 'EX: Compras do mês...',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe a descrição'
                    : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _valorController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Valor',
                  border: OutlineInputBorder(),
                  hintText: 'EX: 2500',
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o valor' : null,
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<TipoTransacao>(
                initialValue: _tipo,
                items: [
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
                    _categoriaSelecionada = null; // Reseta categoria ao mudar tipo
                  });
                  _carregarCategorias();
                },
                decoration: InputDecoration(
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                              if (_categoriaSelecionada?.id == categoria.id) {
                                _categoriaSelecionada = null; // Desseleciona
                              } else {
                                _categoriaSelecionada = categoria; // Seleciona
                              }
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
                              mainAxisAlignment: MainAxisAlignment.center,
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

              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _salvar,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
