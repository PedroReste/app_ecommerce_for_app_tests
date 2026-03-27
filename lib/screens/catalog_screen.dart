import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'home_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _selectedCategory = 'Todos';
  String _sortBy = 'relevancia';

  final List<String> _categories = [
    'Todos',
    'Eletrônicos',
    'Roupas',
    'Calçados',
    'Perfumaria',
    'Eletrodomésticos',
    'Informática',
  ];

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'Todos') return mockProducts;
    return mockProducts.where((p) {
      switch (_selectedCategory) {
        case 'Eletrônicos':
          return p.category == 'eletronicos';
        case 'Roupas':
          return p.category == 'roupas';
        case 'Calçados':
          return p.category == 'calcados';
        case 'Perfumaria':
          return p.category == 'perfumaria';
        case 'Eletrodomésticos':
          return p.category == 'eletrodomesticos';
        case 'Informática':
          return p.category == 'informatica';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Catálogo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtro de categorias
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1A1A2E)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1A1A2E)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Contador de resultados
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredProducts.length} produtos encontrados',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                DropdownButton<String>(
                  value: _sortBy,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: 'relevancia',
                      child: Text('Relevância'),
                    ),
                    DropdownMenuItem(
                      value: 'menor-preco',
                      child: Text('Menor preço'),
                    ),
                    DropdownMenuItem(
                      value: 'maior-preco',
                      child: Text('Maior preço'),
                    ),
                    DropdownMenuItem(
                      value: 'avaliacao',
                      child: Text('Avaliação'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _sortBy = v!),
                ),
              ],
            ),
          ),

          // Grid de produtos
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ProductCard(
                  product: product,
                  index: index + 1,
                  listId: 'catalogo-${_selectedCategory.toLowerCase()}',
                  listName: 'Catálogo $_selectedCategory',
                  onTap: () => context.push('/product/${product.id}'),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(currentIndex: 1),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtros',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Faixa de preço',
                style: TextStyle(fontWeight: FontWeight.w600)),
            RangeSlider(
              values: const RangeValues(0, 5000),
              min: 0,
              max: 10000,
              divisions: 20,
              labels: const RangeLabels('R\$ 0', 'R\$ 5.000'),
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aplicar filtros'),
            ),
          ],
        ),
      ),
    );
  }
}
