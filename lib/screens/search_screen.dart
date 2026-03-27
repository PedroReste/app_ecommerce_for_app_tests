import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Product> _results = [];
  bool _hasSearched = false;

  final List<String> _recentSearches = [
    'tênis nike',
    'smartphone samsung',
    'air fryer',
  ];

  final List<String> _trending = [
    'Black Friday',
    'iPhone',
    'Notebook',
    'Perfume',
    'Camiseta polo',
  ];

  void _search(String term) {
    if (term.trim().isEmpty) return;
    setState(() {
      _hasSearched = true;
      _results = mockProducts
          .where(
            (p) =>
                p.name.toLowerCase().contains(term.toLowerCase()) ||
                p.brand.toLowerCase().contains(term.toLowerCase()) ||
                p.category.toLowerCase().contains(term.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Buscar produtos, marcas...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: const TextStyle(color: Colors.white),
          onSubmitted: _search,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _results = [];
                  _hasSearched = false;
                });
              },
            ),
        ],
      ),
      body: !_hasSearched
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Buscas recentes
                  const Text(
                    'Buscas recentes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._recentSearches.map(
                    (term) => ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(term),
                      trailing: const Icon(
                        Icons.north_west,
                        size: 16,
                      ),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        _searchController.text = term;
                        _search(term);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tendências
                  const Text(
                    'Em alta agora 🔥',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _trending.map((term) {
                      return GestureDetector(
                        onTap: () {
                          _searchController.text = term;
                          _search(term);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.trending_up,
                                size: 16,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(term),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            )
          : _results.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Nenhum produto encontrado',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tente buscar por outro termo',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final product = _results[index];
                    return ProductCard(
                      product: product,
                      index: index + 1,
                      listId: 'busca-${_searchController.text.toLowerCase().replaceAll(' ', '-')}',
                      listName:
                          'Resultados para ${_searchController.text}',
                      onTap: () =>
                          context.push('/product/${product.id}'),
                    );
                  },
                ),
    );
  }
}
