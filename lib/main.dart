import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'models/product.dart';
import 'models/cart_item.dart';
import 'models/order.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/search_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout/checkout_address_screen.dart';
import 'screens/checkout/checkout_shipping_screen.dart';
import 'screens/checkout/checkout_payment_screen.dart';
import 'screens/checkout/order_confirmation_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/account/account_screen.dart';
import 'screens/account/orders_screen.dart';

// ==========================================
// APP STATE
// ==========================================

class AppState extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _onboardingComplete = false;
  String _userName = '';
  final List<CartItem> _cart = [];
  final List<Product> _wishlist = [];
  final List<Order> _orders = [];
  String? _appliedCoupon;

  bool get isLoggedIn => _isLoggedIn;
  bool get onboardingComplete => _onboardingComplete;
  String get userName => _userName;
  List<CartItem> get cart => List.unmodifiable(_cart);
  List<Product> get wishlist => List.unmodifiable(_wishlist);
  List<Order> get orders => List.unmodifiable(_orders);
  String? get appliedCoupon => _appliedCoupon;

  int get cartItemCount =>
      _cart.fold(0, (sum, item) => sum + item.quantity);

  double get cartSubtotal =>
      _cart.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get cartTotal {
    double total = cartSubtotal;
    if (_appliedCoupon == 'BEMVINDO15') total *= 0.85;
    if (_appliedCoupon == 'BLACKFRIDAY30') total *= 0.70;
    return total;
  }

  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }

  void login(String name, {String method = 'email'}) {
    _isLoggedIn = true;
    _userName = name;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userName = '';
    notifyListeners();
  }

  void addToCart(Product product, String variant, {int quantity = 1}) {
    final existing = _cart.where(
      (i) => i.product.id == product.id && i.selectedVariant == variant,
    );
    if (existing.isNotEmpty) {
      existing.first.quantity += quantity;
    } else {
      _cart.add(CartItem(
        product: product,
        selectedVariant: variant,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void updateQuantity(CartItem item, int quantity) {
    if (quantity <= 0) {
      _cart.remove(item);
    } else {
      item.quantity = quantity;
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _appliedCoupon = null;
    notifyListeners();
  }

  void applyCoupon(String code) {
    _appliedCoupon = code;
    notifyListeners();
  }

  void removeCoupon() {
    _appliedCoupon = null;
    notifyListeners();
  }

  bool isInWishlist(Product product) =>
      _wishlist.any((p) => p.id == product.id);

  void toggleWishlist(Product product) {
    if (isInWishlist(product)) {
      _wishlist.removeWhere((p) => p.id == product.id);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();
  }

  Order placeOrder({
    required double shipping,
    required String shippingTier,
    required String paymentMethod,
  }) {
    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      transactionId: 'TRX-${DateTime.now().millisecondsSinceEpoch}',
      items: _cart
          .map((i) => OrderItem(
                sku: i.product.sku,
                name: i.product.name,
                brand: i.product.brand,
                category: i.product.category,
                price: i.product.price,
                quantity: i.quantity,
                variant: i.selectedVariant,
              ))
          .toList(),
      subtotal: cartTotal,
      shipping: shipping,
      tax: 0,
      total: cartTotal + shipping,
      paymentMethod: paymentMethod,
      shippingTier: shippingTier,
      couponCode: _appliedCoupon,
      createdAt: DateTime.now(),
      status: 'confirmado',
    );
    _orders.add(order);
    clearCart();
    return order;
  }
}

// ==========================================
// ROUTER
// ==========================================

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/catalog', builder: (_, __) => const CatalogScreen()),
    GoRoute(
      path: '/product/:id',
      builder: (_, state) =>
          ProductDetailScreen(productId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
    GoRoute(path: '/cart', builder: (_, __) => const CartScreen()),
    GoRoute(
      path: '/checkout/address',
      builder: (_, __) => const CheckoutAddressScreen(),
    ),
    GoRoute(
      path: '/checkout/shipping',
      builder: (_, __) => const CheckoutShippingScreen(),
    ),
    GoRoute(
      path: '/checkout/payment',
      builder: (_, __) => const CheckoutPaymentScreen(),
    ),
    GoRoute(
      path: '/order-confirmation',
      builder: (_, state) => OrderConfirmationScreen(
        order: state.extra as Order,
      ),
    ),
    GoRoute(path: '/wishlist', builder: (_, __) => const WishlistScreen()),
    GoRoute(path: '/account', builder: (_, __) => const AccountScreen()),
    GoRoute(path: '/orders', builder: (_, __) => const OrdersScreen()),
  ],
);

// ==========================================
// MAIN
// ==========================================

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const ShopFlowApp(),
    ),
  );
}

class ShopFlowApp extends StatelessWidget {
  const ShopFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ShopFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A1A2E)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A2E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1A2E),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}
