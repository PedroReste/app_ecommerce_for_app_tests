class Product {
  final String id;
  final String sku;
  final String name;
  final String brand;
  final String category;
  final String subcategory;
  final String description;
  final double price;
  final double? originalPrice;
  final List<String> images;
  final List<String> variants;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final String? promotionId;
  final String? promotionName;

  const Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.brand,
    required this.category,
    required this.subcategory,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.images,
    required this.variants,
    required this.rating,
    required this.reviewCount,
    this.inStock = true,
    this.promotionId,
    this.promotionName,
  });

  double get discount =>
      originalPrice != null ? originalPrice! - price : 0.0;

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
}

final List<Product> mockProducts = [
  Product(
    id: '1',
    sku: 'SKU-001',
    name: 'Tênis Nike Air Max 90',
    brand: 'Nike',
    category: 'calcados',
    subcategory: 'tenis',
    description:
        'O icônico Air Max 90 traz amortecimento de ar visível no calcanhar para conforto durante todo o dia. Design clássico com materiais premium.',
    price: 599.90,
    originalPrice: 799.90,
    images: [
      'https://picsum.photos/seed/shoe1/400/400',
      'https://picsum.photos/seed/shoe2/400/400',
    ],
    variants: ['37', '38', '39', '40', '41', '42', '43'],
    rating: 4.8,
    reviewCount: 1243,
    promotionId: 'PROMO-CALCADOS-01',
    promotionName: 'Semana do Esporte',
  ),
  Product(
    id: '2',
    sku: 'SKU-002',
    name: 'Smartphone Samsung Galaxy S24',
    brand: 'Samsung',
    category: 'eletronicos',
    subcategory: 'smartphones',
    description:
        'Galaxy S24 com processador de última geração, câmera de 200MP e bateria de longa duração. Experiência premium em suas mãos.',
    price: 3999.00,
    images: [
      'https://picsum.photos/seed/phone1/400/400',
      'https://picsum.photos/seed/phone2/400/400',
    ],
    variants: ['128GB', '256GB', '512GB'],
    rating: 4.9,
    reviewCount: 892,
  ),
  Product(
    id: '3',
    sku: 'SKU-003',
    name: 'Camiseta Polo Lacoste Azul',
    brand: 'Lacoste',
    category: 'roupas',
    subcategory: 'masculino',
    description:
        'Camiseta polo clássica em piquê de algodão com o famoso crocodilo bordado. Conforto e estilo para qualquer ocasião.',
    price: 199.90,
    originalPrice: 249.90,
    images: [
      'https://picsum.photos/seed/shirt1/400/400',
      'https://picsum.photos/seed/shirt2/400/400',
    ],
    variants: ['P', 'M', 'G', 'GG', 'XGG'],
    rating: 4.6,
    reviewCount: 567,
  ),
  Product(
    id: '4',
    sku: 'SKU-004',
    name: 'Notebook Dell XPS 15',
    brand: 'Dell',
    category: 'informatica',
    subcategory: 'notebooks',
    description:
        'Notebook premium com tela OLED 4K, processador Intel Core i9 e placa de vídeo dedicada. Perfeito para criadores de conteúdo.',
    price: 8999.00,
    images: [
      'https://picsum.photos/seed/laptop1/400/400',
      'https://picsum.photos/seed/laptop2/400/400',
    ],
    variants: ['16GB RAM', '32GB RAM', '64GB RAM'],
    rating: 4.7,
    reviewCount: 334,
  ),
  Product(
    id: '5',
    sku: 'SKU-005',
    name: 'Perfume Chanel N°5',
    brand: 'Chanel',
    category: 'perfumaria',
    subcategory: 'feminino',
    description:
        'O perfume mais famoso do mundo. Uma composição floral aldéidica atemporal que representa a elegância e sofisticação.',
    price: 599.90,
    images: [
      'https://picsum.photos/seed/perfume1/400/400',
    ],
    variants: ['30ml', '50ml', '100ml'],
    rating: 4.9,
    reviewCount: 2891,
    promotionId: 'PROMO-BEAUTY-01',
    promotionName: 'Festival de Beleza',
  ),
  Product(
    id: '6',
    sku: 'SKU-006',
    name: 'Air Fryer Philips Walita',
    brand: 'Philips',
    category: 'eletrodomesticos',
    subcategory: 'cozinha',
    description:
        'Air fryer com tecnologia Rapid Air que circula o ar quente para fritar com até 90% menos gordura. Capacidade de 4,1 litros.',
    price: 499.90,
    originalPrice: 699.90,
    images: [
      'https://picsum.photos/seed/airfryer1/400/400',
    ],
    variants: ['Preto', 'Branco'],
    rating: 4.5,
    reviewCount: 4521,
    promotionId: 'PROMO-BF-2024',
    promotionName: 'Black Friday 2024',
  ),
];
