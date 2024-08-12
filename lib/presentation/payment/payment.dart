import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../configs/theme/app_colors.dart';
import '../cart/provider.dart';
import 'components/category_payment_selector.dart';

import 'components/method_payment_selector.dart';
import 'payment_success.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _selectedPaymentCategoryIndex = 0;
  int _selectedBankMethodIndex = -1;
  int _selectedEWalletMethodIndex = -1;
  String _selectedPaymentMethod = '';

  void _resetPaymentMethodSelection() {
    setState(() {
      _selectedBankMethodIndex = -1;
      _selectedEWalletMethodIndex = -1;
      _selectedPaymentMethod = '';
    });
  }

  void _saveOrderToFirestore(BuildContext context) async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final orderData = {
      'items': cart.items
          .map((item) => {
                'title': item.product['title'],
                'quantity': item.quantity,
                'price': item.product['price'],
                'imageUrl': item.product['imageUrl'],
              })
          .toList(),
      'totalPrice': cart.getTotalPrice(),
      'paymentMethod': _selectedPaymentMethod,
      'status': 'Success',
      'timestamp': Timestamp.now(),
    };

    try {
      final docRef =
          await FirebaseFirestore.instance.collection('orders').add(orderData);
      print('Order saved successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order saved successfully'),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessPage(
            orderDetails: {
              'orderId': docRef.id,
              ...orderData,
            },
            paymentMethod: _selectedPaymentMethod,
            cartItems: cart.items,
            finalAmount: cart.getTotalPrice(),
          ),
        ),
      );
    } catch (e) {
      print('Failed to save order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save order: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final totalPrice = cart.getTotalPrice();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Payment',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryPaymentSelector(
              selectedPaymentCategoryIndex: _selectedPaymentCategoryIndex,
              onPaymentCategorySelected: (index) {
                if (_selectedPaymentCategoryIndex != index) {
                  _resetPaymentMethodSelection();
                }
                setState(() {
                  _selectedPaymentCategoryIndex = index;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Payment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedPaymentCategoryIndex == 0)
              BankPaymentSelector(
                selectedBankMethodIndex: _selectedBankMethodIndex,
                onBankMethodSelected: (index) {
                  setState(() {
                    _selectedBankMethodIndex = index;
                    _selectedPaymentMethod = ['BRI', 'BCA', 'Mandiri'][index];
                  });
                },
              ),
            if (_selectedPaymentCategoryIndex == 1)
              EWalletPaymentSelector(
                selectedEWalletMethodIndex: _selectedEWalletMethodIndex,
                onEWalletMethodSelected: (index) {
                  setState(() {
                    _selectedEWalletMethodIndex = index;
                    _selectedPaymentMethod = ['OVO', 'GoPay', 'Dana'][index];
                  });
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (_selectedPaymentMethod.isNotEmpty) {
                _saveOrderToFirestore(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a payment method'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: AppColors.primary,
            ),
            child: const Text(
              'Confirm Payment',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
