import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  String? _selectedVariant;
  int _quantity = 1;
  bool _descriptionExpanded = false;

  Product? get _product =>
      mockProducts.where((p) => p.id == widget.productId).firstOrNull;

  @override
  void initState() {
    super.initState();
    if (_product != null && _product!.variants.isNotEmpty) {
      _selectedVariant = _product!.variants.first;
    }
  }

  void _addToCart() {
    if (_selectedVariant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma variante')),
      );
      return;
    }
    context.read<AppState>().addToCart(
          _product!,
          _selectedVariant!,
          quantity: _quantity,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Produto adicionado ao carrinho!'),
        action: SnackBarAction(
          label: 'Ver carrinho',
          onPressed: () => context.push('/cart'),
        ),
      ),
    );
  }

  void _buyNow() {
    if (_selectedVariant == null) return;
    context.read<AppState>().addToCart(
          _product!,
          _selectedVariant!,
          quantity: _quantity,
        );
    context.push('/cart');
  }

  @override
  Widget build(BuildContext context) {
    final product = _product;
    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Produto não encontrado')),
      );
    }

    final appState = context.watch<AppState>();
    final isFavorite = appState.isInWishlist(product);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () => appState.toggleWishlist(product),
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _showShareSheet(context, product),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    onPageChanged: (i) =>
                        setState(() => _selectedImageIndex = i),
                    itemCount: product.images.length,
                    itemBuilder: (_, i) => Image.network(
                      product.images[i],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 80),
                      ),
                    ),
                  ),
                  if (product.images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          product.images.length,
                          (i) => Container(
                            width: 8,
                            height: 8,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i == _selectedImageIndex
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (product.hasDiscount)
                    Positioned(
                      top: 80,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${((product.discount / product.originalPrice!) * 100).round()}% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Marca e avaliação
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.brand,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${product.rating} (${product.reviewCount} avaliações)',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Nome
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Preço
                  if (product.hasDiscount)
                    Text(
                      'R\$ ${product.originalPrice!.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    'R\$ ${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  if (product.hasDiscount)
                    Text(
                      'Você economiza R\$ ${product.discount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Variantes
                  Text(
                    product.category == 'calcados' ||
                            product.category == 'roupas'
                        ? 'Tamanho'
                        : 'Variante',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: product.variants.map((variant) {
                      final isSelected = variant == _selectedVariant;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedVariant = variant),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF1A1A2E)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF1A1A2E)
                                  : Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            variant,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Quantidade
                  Row(
                    children: [
                      const Text(
                        'Quantidade',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _quantity > 1
                                  ? () =>
                                      setState(() => _quantity--)
                                  : null,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () =>
                                  setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Descrição
                  const Text(
                    'Descrição',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedCrossFade(
                    firstChild: Text(
                      product.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                    secondChild: Text(
                      product.description,
                      style: TextStyle(
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                    crossFadeState: _descriptionExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),
                  TextButton(
                    onPressed: () => setState(
                      () => _descriptionExpanded = !_descriptionExpanded,
                    ),
                    child: Text(
                      _descriptionExpanded ? 'Ver menos' : 'Ver mais',
                    ),
                  ),

                  // Informações de entrega
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.local_shipping,
                            color: Colors.green),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Entrega grátis',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                'Para compras acima de R\$ 200',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _addToCart,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Adicionar ao carrinho'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _buyNow,
                child: const Text('Comprar agora'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareSheet(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Compartilhar produto',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ShareOption(
                  icon: Icons.message,
                  label: 'WhatsApp',
                  color: Colors.green,
                  onTap: () => Navigator.pop(context),
                ),
                _ShareOption(
                  icon: Icons.camera_alt,
                  label: 'Instagram',
                  color: Colors.purple,
                  onTap: () => Navigator.pop(context),
                ),
                _ShareOption(
                  icon: Icons.link,
                  label: 'Copiar link',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Link copiado!'),
                      ),
                    );
                  },
                ),
                _ShareOption(
                  icon: Icons.email,
                  label: 'E-mail',
                  color: Colors.orange,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
