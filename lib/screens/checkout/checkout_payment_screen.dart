import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../models/order.dart';
import 'checkout_address_screen.dart';

class CheckoutPaymentScreen extends StatefulWidget {
  const CheckoutPaymentScreen({super.key});

  @override
  State<CheckoutPaymentScreen> createState() =>
      _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {
  String _selectedPayment = 'cartao-credito';
  int _installments = 1;
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'cartao-credito',
      'name': 'Cartão de Crédito',
      'icon': Icons.credit_card,
      'description': 'Visa, Mastercard, Elo, Amex',
    },
    {
      'id': 'cartao-debito',
      'name': 'Cartão de Débito',
      'icon': Icons.payment,
      'description': 'Débito à vista',
    },
    {
      'id': 'pix',
      'name': 'Pix',
      'icon': Icons.qr_code,
      'description': 'Aprovação imediata',
    },
    {
      'id': 'boleto',
      'name': 'Boleto Bancário',
      'icon': Icons.receipt,
      'description': 'Vencimento em 3 dias úteis',
    },
  ];

  Future<void> _confirmPurchase() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final extra = ModalRoute.of(context)?.settings.arguments as Map?;
    final shippingCost =
        (extra?['shippingCost'] as double?) ?? 19.90;
    final shippingTier =
        (extra?['shippingTier'] as String?) ?? 'pac';

    final order = context.read<AppState>().placeOrder(
          shipping: shippingCost,
          shippingTier: shippingTier,
          paymentMethod: _selectedPayment,
        );

    if (!mounted) return;
    context.go('/order-confirmation', extra: order);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CheckoutProgress(currentStep: 3),
                  const SizedBox(height: 24),
                  const Text(
                    'Como quer pagar?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._paymentMethods.map(
                    (method) => GestureDetector(
                      onTap: () => setState(
                        () => _selectedPayment = method['id'],
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedPayment == method['id']
                                ? const Color(0xFF1A1A2E)
                                : Colors.grey[300]!,
                            width:
                                _selectedPayment == method['id'] ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: method['id'],
                              groupValue: _selectedPayment,
                              onChanged: (v) =>
                                  setState(() => _selectedPayment = v!),
                            ),
                            Icon(
                              method['icon'] as IconData,
                              color: const Color(0xFF1A1A2E),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    method['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    method['description'],
                                    style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Parcelamento — apenas para cartão de crédito
                  if (_selectedPayment == 'cartao-credito') ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Parcelamento',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: _installments,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: List.generate(12, (i) {
                        final n = i + 1;
                        final value = appState.cartTotal / n;
                        return DropdownMenuItem(
                          value: n,
                          child: Text(
                            n == 1
                                ? '1x de R\$ ${value.toStringAsFixed(2)} (à vista)'
                                : '${n}x de R\$ ${value.toStringAsFixed(2)} sem juros',
                          ),
                        );
                      }),
                      onChanged: (v) =>
                          setState(() => _installments = v!),
                    ),
                  ],

                  // Dados do cartão — apenas para cartão
                  if (_selectedPayment == 'cartao-credito' ||
                      _selectedPayment == 'cartao-debito') ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Número do cartão',
                        prefixIcon: const Icon(Icons.credit_card),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nome no cartão',
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Validade',
                              hintText: 'MM/AA',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                          ),
                        ),
                      ],
                    ),
                  ],

                  // QR Code Pix
                  if (_selectedPayment == 'pix') ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.qr_code_2,
                            size: 120,
                            color: Color(0xFF1A1A2E),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Escaneie o QR Code ou copie a chave Pix',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Chave Pix copiada!'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.copy),
                            label: const Text('Copiar chave Pix'),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Resumo do pedido
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resumo do pedido',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Produtos'),
                            Text(
                              'R\$ ${appState.cartSubtotal.toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                        if (appState.appliedCoupon != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Cupom (${appState.appliedCoupon})',
                                style: const TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                '- R\$ ${(appState.cartSubtotal - appState.cartTotal).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 4),
                        const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Frete'),
                            Text('A calcular'),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'R\$ ${appState.cartTotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _confirmPurchase,
              child: _isProcessing
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Processando pagamento...'),
                      ],
                    )
                  : const Text('Confirmar pedido'),
            ),
          ),
        ],
      ),
    );
  }
}
