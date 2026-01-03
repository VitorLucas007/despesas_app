import 'package:despesas_app/models/categoria.dart';
import 'package:despesas_app/models/despesa.dart';
import 'package:flutter/material.dart';

class AddDespesaPage extends StatefulWidget {
  const AddDespesaPage({super.key});

  @override
  State<AddDespesaPage> createState() => _AddDespesaPageState();
}

class _AddDespesaPageState extends State<AddDespesaPage> {
  final _formKey = GlobalKey<FormState>();

  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();

  TipoTransacao _tipo = TipoTransacao.despesa;
  Categoria? _categoriaSelecionada;

  final List<Categoria> _categorias = [
    Categoria(id: '1', nome: 'Alimentação', tipo: TipoTransacao.despesa),
    Categoria(id: '2', nome: 'Transporte', tipo: TipoTransacao.despesa),
    Categoria(id: '3', nome: 'Salário', tipo: TipoTransacao.receita),
  ];

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

    Navigator.pop(context, despesa);
  }

  @override
  Widget build(BuildContext context) {
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

              DropdownButtonFormField<Categoria>(
                initialValue: _categoriaSelecionada,
                items: _categorias.where((c) => c.tipo == _tipo).map((
                  categoria,
                ) {
                  return DropdownMenuItem(
                    value: categoria,
                    child: Text(categoria.nome),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _categoriaSelecionada = value);
                },
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null ? 'Selecione uma categoria' : null,
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
