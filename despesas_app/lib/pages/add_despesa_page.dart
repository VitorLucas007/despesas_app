import 'package:despesas_app/models/categoria.dart';
import 'package:despesas_app/models/despesa.dart';
import 'package:despesas_app/utils/categorias_fixas.dart';
import 'package:flutter/material.dart';

class AddDespesaPage extends StatefulWidget {
  final Function(Despesa) onSalvar;
  const AddDespesaPage({super.key, required this.onSalvar});

  @override
  State<AddDespesaPage> createState() => _AddDespesaPageState();
}

class _AddDespesaPageState extends State<AddDespesaPage> {
  final _formKey = GlobalKey<FormState>();

  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();

  TipoTransacao _tipo = TipoTransacao.despesa;
  Categoria? _categoriaSelecionada;

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final despesa = Despesa(
      id: DateTime.now().toString(),
      descricao: _descricaoController.text,
      valor: double.parse(_valorController.text),
      data: DateTime.now(),
      tipo: _tipo,
      categoria: _categoriaSelecionada!,
    );

    widget.onSalvar(despesa);
  }

  @override
  Widget build(BuildContext context) {
    final categoriasFiltradas = categoriasFixas
        .where((c) => c.tipo == _tipo)
        .toList();

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
                  setState(() => _tipo = value!);
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
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: categoriasFiltradas.map((categoria) {
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
                  onPressed: _salvar,
                  child: Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
