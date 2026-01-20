import 'package:despesas_app/pages/add_despesa_page.dart';
import 'package:despesas_app/pages/historico_page.dart';
import 'package:despesas_app/pages/home_page.dart';
import 'package:despesas_app/services/despesas_service.dart';
import 'package:flutter/material.dart';

/// Widget principal de navegação da aplicação
///
/// Gerencia a navegação entre as páginas principais usando BottomNavigationBar
/// Mantém uma única instância do DespesasService compartilhada entre as páginas
/// Índices das páginas: 0=Home, 1=Histórico, 2=Cadastro
class MainNavigationPageWidget extends StatefulWidget {
  const MainNavigationPageWidget({super.key});

  @override
  State<MainNavigationPageWidget> createState() =>
      _MainNavigationPageWidgetState();
}

class _MainNavigationPageWidgetState extends State<MainNavigationPageWidget> {
  /// Índice da página atualmente selecionada (0=Home, 1=Histórico, 2=Cadastro)
  int _currentIndex = 0;

  /// Instância única do serviço de despesas compartilhada entre todas as páginas
  /// Isso garante consistência dos dados e evita múltiplas conexões ao banco
  final DespesasService _despesasService = DespesasService();

  /// Callback chamado quando uma despesa é salva na página de cadastro
  ///
  /// Força a atualização das páginas que mostram despesas (Home e Histórico)
  /// e retorna automaticamente para a página Home após salvar
  Future<void> _onDespesaSalva() async {
    // Se estiver na home (0) ou histórico (1), força o rebuild para atualizar dados
    if (_currentIndex == 0 || _currentIndex == 1) {
      setState(() {});
    }
    // Volta para a home (índice 0) após salvar uma nova despesa
    setState(() => _currentIndex = 0);
  }

  @override
  Widget build(BuildContext context) {
    // Lista de todas as páginas disponíveis na navegação
    final pages = [
      HomePage(despesasService: _despesasService), // Página inicial (índice 0)
      HistoricoPage(despesasService: _despesasService), // Histórico (índice 1)
      AddDespesaPage(
        despesasService: _despesasService,
        onSalvar:
            _onDespesaSalva, // Callback para atualizar outras páginas após salvar
      ), // Cadastro (índice 2)
    ];

    return Scaffold(
      // Exibe a página correspondente ao índice atual
      body: pages[_currentIndex],
      // Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Página atualmente selecionada
        onTap: (index) {
          // Atualiza a página selecionada quando o usuário toca em um item
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed, // Mantém todos os itens visíveis
        selectedItemColor: Colors.green, // Cor do item selecionado
        unselectedItemColor: Colors.grey, // Cor dos itens não selecionados
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Cadastro'),
        ],
      ),
    );
  }
}
