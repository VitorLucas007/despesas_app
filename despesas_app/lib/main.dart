import 'package:despesas_app/services/init_service.dart';
import 'package:despesas_app/widgets/main_navigation_page_widget.dart';
import 'package:flutter/material.dart';

/// Função principal da aplicação
/// Inicializa o Flutter e prepara o ambiente antes de executar o app
void main() async {
  // Garante que o Flutter esteja inicializado antes de executar operações assíncronas
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o banco de dados SQLite e carrega as categorias fixas
  // Isso garante que as categorias padrão estejam disponíveis na primeira execução
  final initService = InitService();
  await initService.inicializar();

  // Inicia a aplicação Flutter
  runApp(const MyApp());
}

/// Widget raiz da aplicação
/// Define a configuração principal do MaterialApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Despesas App',
      // Remove o banner de debug no canto superior direito
      debugShowCheckedModeBanner: false,
      // Define a página inicial como a navegação principal
      home: MainNavigationPageWidget(),
    );
  }
}
