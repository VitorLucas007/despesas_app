import 'package:despesas_app/services/init_service.dart';
import 'package:despesas_app/widgets/main_navigation_page_widget.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o banco de dados e carrega categorias fixas
  final initService = InitService();
  await initService.inicializar();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Despesas App',
      debugShowCheckedModeBanner: false,
      home: MainNavigationPageWidget(),
    );
  }
}
