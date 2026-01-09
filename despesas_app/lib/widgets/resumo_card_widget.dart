import 'package:flutter/material.dart';

class ResumoCardWidget extends StatelessWidget {
  final double entrada;
  final double saida;
  const ResumoCardWidget({
    super.key,
    required this.entrada,
    required this.saida,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.green, size: 18),
                    SizedBox(width: 4),
                    Text('Entrada', style: TextStyle(color: Colors.green)),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'R\$ ${entrada.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_downward, color: Colors.red, size: 18),
                    SizedBox(width: 4),
                    Text('Saída', style: TextStyle(color: Colors.red)),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'R\$ ${saida.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
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
