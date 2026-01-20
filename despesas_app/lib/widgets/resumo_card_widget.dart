import 'package:flutter/material.dart';

/// Widget que exibe um resumo financeiro em formato de card
///
/// Mostra totais de entrada (receitas) e saída (despesas) lado a lado
/// Utiliza cores para diferenciação: verde para entradas, vermelho para saídas
class ResumoCardWidget extends StatelessWidget {
  /// Total de todas as receitas (entradas de dinheiro)
  final double entrada;

  /// Total de todas as despesas (saídas de dinheiro)
  final double saida;

  const ResumoCardWidget({
    super.key,
    required this.entrada,
    required this.saida,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16), // Espaçamento externo
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Bordas arredondadas
      ),
      elevation: 2, // Sombra do card
      child: Padding(
        padding: const EdgeInsets.all(16), // Espaçamento interno
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Espaça as colunas
          children: [
            // Coluna da esquerda: Entradas (receitas)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label "Entrada" com ícone
                Row(
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.green, size: 18),
                    const SizedBox(width: 4),
                    Text('Entrada', style: TextStyle(color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 4),
                // Valor formatado em Real (R$)
                Text(
                  'R\$ ${entrada.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Cor verde para entradas
                  ),
                ),
              ],
            ),
            // Coluna da direita: Saídas (despesas)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label "Saída" com ícone
                Row(
                  children: [
                    Icon(Icons.arrow_downward, color: Colors.red, size: 18),
                    const SizedBox(width: 4),
                    Text('Saída', style: TextStyle(color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 4),
                // Valor formatado em Real (R$)
                Text(
                  'R\$ ${saida.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red, // Cor vermelha para saídas
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
