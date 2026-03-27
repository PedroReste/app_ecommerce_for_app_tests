import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'checkout_address_screen.dart';

class CheckoutShippingScreen extends StatefulWidget {
  const CheckoutShippingScreen({super.key});

  @override
  State<CheckoutShippingScreen> createState() =>
      _CheckoutShippingScreenState();
}

class _CheckoutShippingScreenState extends State<CheckoutShippingScreen> {
  String _selectedShipping = 'pac';

  final List<Map<String, dynamic>> _shippingOptions = [
    {
      'id': 'pac',
      'name': 'PAC',
      'description': 'Entrega em 5 a 8 dias úteis',
      'price': 19.90,
      'icon': Icons.local_shipping,
    },
    {
      'id': 'sedex',
      'name': 'SEDEX',
      'description': 'Entrega em 1 a 3 dias úteis',
      'price': 39.90,
      'icon': Icons.flash_on,
    },
    {
      'id': 'same-day',
      'name': 'Entrega no mesmo dia',
      'description': 'Receba hoje até às 22h',
      'price': 59.90,
      'icon': Icons.rocket_launch,
    },
    {
      'id': 'retirada-loja',
      'name': 'Retirar na loja',
      'description': 'Disponível em 2 horas',
      'price': 0.0,
      'icon': Icons.store,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forma de entrega'),
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
                  _CheckoutProgress(currentStep: 2),
                  const SizedBox(height: 24),
                  const Text(
                    'Como prefere receber?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._shippingOptions.map(
                    (option) => GestureDetector(
                      onTap: () => setState(
                        () => _selectedShipping = option['id'],
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedShipping == option['id']
                                ? const Color(0xFF1A1A2E)
                                : Colors.grey[300]!,
                            width:
                                _selectedShipping == option['id'] ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: option['id'],
                              groupValue: _selectedShipping,
                              onChanged: (v) =>
                                  setState(() => _selectedShipping = v!),
                            ),
                            Icon(option['icon'] as IconData,
                                color: const Color(0xFF1A1A2E)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    option['description'],
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              option['price'] == 0
                                  ? 'Grátis'
                                  : 'R\$ ${(option['price'] as double).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: option['price'] == 0
                                    ? Colors.green
                                    : const Color(0xFF1A1A2E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => context.push(
                '/checkout/payment',
                extra: {
                  'shippingTier': _selectedShipping,
                  'shippingCost': _shippingOptions
                      .firstWhere(
                        (o) => o['id'] == _selectedShipping,
                      )['price'],
                },
              ),
              child: const Text('Continuar para pagamento'),
            ),
          ),
        ],
      ),
    );
  }
}
