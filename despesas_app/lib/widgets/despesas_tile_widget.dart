import 'package:despesas_app/models/despesa.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget que exibe um item de despesa/receita em formato de lista
///
/// Mostra informações resumidas: ícone da categoria, descrição, categoria,
/// data e valor. Permite editar e deletar através de menu de opções.
class DespesasTileWidget extends StatelessWidget {
  /// Objeto Despesa contendo os dados a serem exibidos
  final Despesa despesa;

  /// Callback opcional chamado quando o usuário clica em "Editar"
  /// Se null, a opção de editar não aparece no menu
  final VoidCallback? onEditar;

  /// Callback opcional chamado quando o usuário clica em "Deletar"
  /// Se null, a opção de deletar não aparece no menu
  final VoidCallback? onDeletar;

  const DespesasTileWidget({
    super.key,
    required this.despesa,
    this.onEditar,
    this.onDeletar,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true, // Layout compacto para economizar espaço
      // Avatar circular com ícone da categoria
      leading: CircleAvatar(
        // Cor de fundo baseada no tipo: vermelho para despesa, verde para receita
        backgroundColor: despesa.tipo == TipoTransacao.despesa
            ? Colors.red[100]
            : Colors.green[100],
        child: Icon(
          despesa.categoria.icon, // Ícone da categoria
          color: despesa.tipo == TipoTransacao.despesa
              ? Colors.red
              : Colors.green,
        ),
      ),
      // Título principal: descrição da despesa
      title: Text(despesa.descricao),
      // Subtítulo: nome da categoria e data formatada
      subtitle: Text(
        '${despesa.categoria.nome}\n${DateFormat('dd/MM/yyyy').format(despesa.data)}',
      ),
      // Área à direita: valor e menu de opções
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Valor formatado em Real (R$)
          Text(
            'R\$ ${despesa.valor.toStringAsFixed(2)}',
            style: TextStyle(
              // Cor baseada no tipo: vermelho para despesa, verde para receita
              color: despesa.tipo == TipoTransacao.despesa
                  ? Colors.red
                  : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Menu de opções (3 pontos) se houver callbacks
          if (onEditar != null || onDeletar != null) ...[
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert), // Ícone de 3 pontos verticais
              onSelected: (value) {
                // Executa o callback correspondente à opção selecionada
                if (value == 'editar' && onEditar != null) {
                  onEditar!();
                } else if (value == 'deletar' && onDeletar != null) {
                  onDeletar!();
                }
              },
              itemBuilder: (context) => [
                // Opção de editar (se callback disponível)
                if (onEditar != null)
                  const PopupMenuItem(
                    value: 'editar',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                // Opção de deletar (se callback disponível)
                if (onDeletar != null)
                  const PopupMenuItem(
                    value: 'deletar',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Deletar', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
      // Ao clicar no item, chama o callback de editar (se disponível)
      onTap: onEditar,
    );
  }
}
