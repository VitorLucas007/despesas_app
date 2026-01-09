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

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = const [
      HomePage(),
      HistoricoPage(),
      AddDespesaPage(),
      EstatisticaPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

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
