import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/promotional_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBanner = 0;
  final PageController _bannerController = PageController();

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Black Friday 2024',
      'subtitle': 'Até 70% de desconto em eletrodomésticos',
      'buttonText': 'Aproveitar',
      'color': const Color(0xFF1A1A2E),
      'icon': Icons.flash_on,
      'promotionId': 'PROMO-BF-2024',
      'promotionName': 'Black Friday 2024',
      'creativeName': 'banner-hero-preto-v1',
      'creativeSlot': 'hero-topo',
      'route': '/catalog',
    },
    {
      'title': 'Festival de Beleza',
      'subtitle': 'Perfumes e cosméticos com frete grátis',
      'buttonText': 'Ver ofertas',
      'color': const Color(0xFF8B1A4A),
      'icon': Icons.auto_awesome,
      'promotionId': 'PROMO-BEAUTY-01',
      'promotionName': 'Festival de Beleza',
      'creativeName': 'banner-hero-rosa-v2',
      'creativeSlot': 'hero-topo',
      'route': '/catalog',
    },
    {
      'title': 'Semana do Esporte',
      'subtitle': 'Tênis e roupas esportivas com até 50% off',
      'buttonText': 'Comprar agora',
      'color': const Color(0xFF0F3460),
      'icon': Icons.sports_basketball,
      'promotionId': 'PROMO-CALCADOS-01',
      'promotionName': 'Semana do Esporte',
      'creativeName': 'banner-hero-azul-v1',
      'creativeSlot': 'hero-topo',
      'route': '/catalog',
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Eletrônicos', 'icon': Icons.phone_android},
    {'name': 'Roupas', 'icon': Icons.checkroom},
    {'name': 'Calçados', 'icon': Icons.hiking},
    {'name': 'Casa', 'icon': Icons.home},
    {'name': 'Beleza', 'icon': Icons.face},
    {'name': 'Esporte', 'icon': Icons.sports},
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('ShopFlow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => context.push('/cart'),
              ),
              if (appState.cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${appState.cartItemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saudação
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, ${appState.userName.isEmpty ? 'visitante' : appState.userName}! 👋',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'O que você está procurando hoje?',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Carrossel de banners
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _bannerController,
                onPageChanged: (i) => setState(() => _currentBanner = i),
                itemCount: _banners.length,
                itemBuilder: (context, index) {
                  final banner = _banners[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 16 : 8,
                      right: index == _banners.length - 1 ? 16 : 8,
                    ),
                    child: PromotionalBanner(
                      title: banner['title'],
                      subtitle: banner['subtitle'],
                      buttonText: banner['buttonText'],
                      backgroundColor: banner['color'],
                      icon: banner['icon'],
                      index: index + 1,
                      onTap: () => context.push(banner['route']),
                    ),
                  );
                },
              ),
            ),

            // Indicadores do carrossel
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _banners.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _currentBanner ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _currentBanner
                          ? const Color(0xFF1A1A2E)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Categorias
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Categorias',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  return GestureDetector(
                    onTap: () => context.push('/catalog'),
                    child: Container(
                      width: 72,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              cat['icon'] as IconData,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat['name'],
                            style: const TextStyle(fontSize: 11),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Mais vendidos
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mais Vendidos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/catalog'),
                    child: const Text('Ver todos'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: mockProducts.length,
                itemBuilder: (context, index) {
                  final product = mockProducts[index];
                  return SizedBox(
                    width: 180,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ProductCard(
                        product: product,
                        index: index + 1,
                        listId: 'mais-vendidos-home',
                        listName: 'Mais Vendidos',
                        onTap: () => context.push('/product/${product.id}'),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Banner secundário
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => context.push('/catalog'),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F3460), Color(0xFF1A1A2E)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Frete Grátis',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Em compras acima de R\$ 200',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Aproveite agora →',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.local_shipping,
                        size: 64,
                        color: Colors.white24,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Recomendados
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Recomendados para Você',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: mockProducts.reversed.toList().length,
              itemBuilder: (context, index) {
                final product = mockProducts.reversed.toList()[index];
                return ProductCard(
                  product: product,
                  index: index + 1,
                  listId: 'recomendados-home',
                  listName: 'Recomendados para Você',
                  onTap: () => context.push('/product/${product.id}'),
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(currentIndex: 0),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;

  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return NavigationBar(
      selectedIndex: currentIndex,
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Início',
        ),
        const NavigationDestination(
          icon: Icon(Icons.grid_view_outlined),
          selectedIcon: Icon(Icons.grid_view),
          label: 'Catálogo',
        ),
        NavigationDestination(
          icon: Badge(
            isLabelVisible: appState.cartItemCount > 0,
            label: Text('${appState.cartItemCount}'),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          selectedIcon: const Icon(Icons.shopping_cart),
          label: 'Carrinho',
        ),
        const NavigationDestination(
          icon: Icon(Icons.favorite_outline),
          selectedIcon: Icon(Icons.favorite),
          label: 'Favoritos',
        ),
        const NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Conta',
        ),
      ],
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/catalog');
            break;
          case 2:
            context.go('/cart');
            break;
          case 3:
            context.go('/wishlist');
            break;
          case 4:
            context.go('/account');
            break;
        }
      },
    );
  }
}
