import 'package:despesas_app/pages/add_despesa_page.dart';
import 'package:despesas_app/pages/historico_page.dart';
import 'package:despesas_app/pages/home_page.dart';
import 'package:despesas_app/services/despesas_service.dart';
import 'package:flutter/material.dart';

class MainNavigationPageWidget extends StatefulWidget {
  const MainNavigationPageWidget({super.key});

  @override
  State<MainNavigationPageWidget> createState() =>
      _MainNavigationPageWidgetState();
}

class _MainNavigationPageWidgetState extends State<MainNavigationPageWidget> {
  int _currentIndex = 0;
  final DespesasService _despesasService = DespesasService();

  /// Callback chamado quando uma despesa é salva
  /// Isso força a atualização das páginas que mostram despesas
  Future<void> _onDespesaSalva() async {
    // Se estiver na home ou histórico, força o rebuild
    if (_currentIndex == 0 || _currentIndex == 1) {
      setState(() {});
    }
    // Volta para a home após salvar
    setState(() => _currentIndex = 0);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(despesasService: _despesasService),
      HistoricoPage(despesasService: _despesasService),
      AddDespesaPage(
        despesasService: _despesasService,
        onSalvar: _onDespesaSalva,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Cadastro',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
