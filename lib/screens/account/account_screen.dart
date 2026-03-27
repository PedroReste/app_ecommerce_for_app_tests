import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../home_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.shopping_bag_outlined,
        'title': 'Meus pedidos',
        'subtitle': 'Acompanhe suas compras',
        'route': '/orders',
      },
      {
        'icon': Icons.favorite_outline,
        'title': 'Lista de desejos',
        'subtitle': 'Produtos salvos',
        'route': '/wishlist',
      },
      {
        'icon': Icons.location_on_outlined,
        'title': 'Endereços',
        'subtitle': 'Gerenciar endereços de entrega',
        'route': null,
      },
      {
        'icon': Icons.credit_card_outlined,
        'title': 'Formas de pagamento',
        'subtitle': 'Cartões e métodos salvos',
        'route': null,
      },
      {
        'icon': Icons.notifications_outlined,
        'title': 'Notificações',
        'subtitle': 'Preferências de comunicação',
        'route': null,
      },
      {
        'icon': Icons.help_outline,
        'title': 'Ajuda e suporte',
        'subtitle': 'FAQ e atendimento',
        'route': null,
      },
      {
        'icon': Icons.star_outline,
        'title': 'Avaliar o app',
        'subtitle': 'Conte o que achou',
        'route': null,
      },
      {
        'icon': Icons.share_outlined,
        'title': 'Indicar para amigos',
        'subtitle': 'Compartilhe e ganhe benefícios',
        'route': null,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('Minha Conta')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header do perfil
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        appState.userName.isNotEmpty
                            ? appState.userName[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appState.userName.isEmpty
                              ? 'Usuário'
                              : appState.userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'usuario@email.com',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '⭐ Cliente Gold',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Menu de opções
            Container(
              color: Colors.white,
              child: Column(
                children: menuItems.map((item) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          item['icon'] as IconData,
                          color: const Color(0xFF1A1A2E),
                        ),
                        title: Text(
                          item['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          item['subtitle'],
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          if (item['route'] != null) {
                            context.push(item['route'] as String);
                          }
                        },
                      ),
                      Divider(
                        height: 1,
                        indent: 56,
                        color: Colors.grey[100],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Sair
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () {
                  appState.logout();
                  context.go('/login');
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Sair da conta',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(currentIndex: 4),
    );
  }
}
