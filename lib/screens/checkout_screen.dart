import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../services/order_service.dart';
import '../theme/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _orderService = OrderService();

  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;

  String _paymentMethod = 'card';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _addressController = TextEditingController(text: user?.address ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _confirmOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final user = context.read<AuthProvider>().user;
    final cart = context.read<CartProvider>();
    final loc = context.read<LocaleProvider>();

    if (user == null || cart.isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      final cartItems = List.of(cart.items);
      final order = OrderModel(
        id: '',
        buyerId: user.uid,
        buyerName: user.name,
        buyerEmail: user.email,
        shippingAddress: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        paymentMethod: _paymentMethod,
        items: cartItems.map((item) => item.toOrderItemMap()).toList(),
        total: cart.totalAmount,
        createdAt: DateTime.now(),
      );

      final orderId = await _orderService.createOrder(
        order: order,
        cartItems: cartItems,
      );

      cart.clearCart();

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Column(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 54,
              ),
              const SizedBox(height: 12),
              Text(
                loc.t('order_success_title'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.t('order_success_message'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.platinumLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${loc.t('order_id_label')}: #${orderId.substring(0, 8).toUpperCase()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text(loc.t('back_to_store')),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al procesar el pedido: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final loc = context.watch<LocaleProvider>();

    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: '\$',
      decimalDigits: 0,
    );

    final paymentOptions = [
      {'id': 'card', 'label': loc.t('pay_card'), 'icon': Icons.credit_card},
      {
        'id': 'transfer',
        'label': loc.t('pay_transfer'),
        'icon': Icons.account_balance_outlined,
      },
      {
        'id': 'cash',
        'label': loc.t('pay_cash'),
        'icon': Icons.payments_outlined,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t('checkout_title')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                loc.t('shipping_info'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: loc.t('shipping_address'),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? loc.t('address_required')
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: loc.t('phone'),
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? loc.t('phone_required')
                    : null,
              ),
              const SizedBox(height: 26),
              Text(
                loc.t('payment_method'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...paymentOptions.map((option) {
                final id = option['id'] as String;
                final isSelected = _paymentMethod == id;

                return GestureDetector(
                  onTap: () => setState(() => _paymentMethod = id),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.platinumLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.platinumBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          option['icon'] as IconData,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option['label'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: AppTheme.platinumCardDecoration(radius: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.t('order_summary'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ...cart.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.quantity}x ${item.product.title}'
                                '${item.selectedSize != null ? ' (${item.selectedSize})' : ''}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${currencyFormat.format(item.subtotal)} MXN',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loc.t('total'),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${currencyFormat.format(cart.totalAmount)} MXN',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isProcessing ? null : _confirmOrder,
                child: _isProcessing
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(loc.t('confirm_order')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
