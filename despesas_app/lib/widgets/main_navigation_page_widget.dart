import 'package:despesas_app/models/despesa.dart';
import 'package:despesas_app/pages/add_despesa_page.dart';
import 'package:despesas_app/pages/estatistica_page.dart';
import 'package:despesas_app/pages/historico_page.dart';
import 'package:despesas_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class MainNavigationPageWidget extends StatefulWidget {
  const MainNavigationPageWidget({super.key});

  @override
  State<MainNavigationPageWidget> createState() =>
      _MainNavigationPageWidgetState();
}

class _MainNavigationPageWidgetState extends State<MainNavigationPageWidget> {
  int _currentIndex = 0;

  final List<Despesa> _despesas = [];

  void _adicionarDespesa(Despesa despesa) {
    setState(() {
      _despesas.add(despesa);
      _currentIndex = 0; // volta pra home
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(despesas: _despesas),
      HistoricoPage(despesas: _despesas),
      AddDespesaPage(onSalvar: _adicionarDespesa),
      EstatisticaPage(despesas: _despesas),
    ];

    return Scaffold(
      body: pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Cadastro'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Estatíticas',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
