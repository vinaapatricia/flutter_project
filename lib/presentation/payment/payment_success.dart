import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/configs/assets/app_images.dart';
import 'package:flutter_project/presentation/cashier/pages/cashier_page.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../configs/theme/app_colors.dart';
import '../order_report/order_report.dart';

class PaymentSuccessPage extends StatelessWidget {
  final Map<String, dynamic> orderDetails;
  final String paymentMethod;
  final List cartItems;
  final double finalAmount;

  PaymentSuccessPage({
    required this.orderDetails,
    required this.paymentMethod,
    required this.cartItems,
    required this.finalAmount,
  });

  Future<void> _generatePdfAndDownload() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Order ID: ${orderDetails['orderId']}',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Payment Method: $paymentMethod',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 16),
              pw.Text('Total Amount: \$${finalAmount.toStringAsFixed(2)}',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 16),
              pw.Text('Order Details:',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              ...cartItems.map<pw.Widget>((item) {
                return pw.Container(
                  margin: const pw.EdgeInsets.symmetric(vertical: 8),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      // pw.Container(
                      //   width: 50,
                      //   height: 50,
                      //   decoration: pw.BoxDecoration(
                      //     border: pw.Border.all(width: 1),
                      //     image: pw.DecorationImage(
                      //       image: pw.NetworkImage(
                      //         item.product['imageUrl'],
                      //       ),
                      //       fit: pw.BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                      pw.SizedBox(width: 16),
                      pw.Expanded(
                        child: pw.Text(
                          item.product['title'],
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                      ),
                      pw.Text(
                        'Quantity: ${item.quantity}',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        '\$${(double.tryParse(item.product['price'].toString()) ?? 0).toStringAsFixed(2)}',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.payment_success_icon,
              height: 96,
              width: 96,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Payment Success!',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _generatePdfAndDownload,
                  child: const Text(
                    'Download Receipt',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: AppColors.primary),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CashierPage()));
                  },
                  child: const Text(
                    'Ok, back to cashier',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrderReportPage()));
              },
              child: const Text(
                'Check My Order Status',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: AppColors.primary),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child:
      // ),
    );
  }
}
