import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/configs/theme/app_colors.dart';
import 'order_report_details.dart';

class OrderReportPage extends StatefulWidget {
  @override
  _OrderReportPageState createState() => _OrderReportPageState();
}

class _OrderReportPageState extends State<OrderReportPage> {
  String _selectedFilter = 'All';
  List<Map<String, dynamic>> _orders = [];

  Future<void> _fetchOrders() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .orderBy('timestamp', descending: _selectedFilter == 'Newest')
          .get();

      final List<Map<String, dynamic>> orders = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();

      setState(() {
        _orders = orders;
      });
    } catch (e) {
      print('Failed to fetch orders: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Order List',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
                _fetchOrders();
              });
            },
            itemBuilder: (BuildContext context) {
              return {'All', 'Newest', 'Oldest'}.map((filter) {
                return PopupMenuItem<String>(
                  value: filter,
                  child: Text(filter),
                );
              }).toList();
            },
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          final DateTime orderDateTime =
              (order['timestamp'] as Timestamp).toDate();
          final int totalQuantity = order['items']
              .fold(0, (sum, item) => sum + (item['quantity'] ?? 0));

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 5,
            color: AppColors.grey,
            child: ListTile(
              leading: Image.network(
                order['items'][0]['imageUrl'],
                width: 50,
                height: 50,
                fit: BoxFit.scaleDown,
              ),
              title: Text('Order ID: ${order['id']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Total Price: \$${order['totalPrice'].toStringAsFixed(2)}'),
                  Text('Qty: $totalQuantity items'),
                  Text('Order Date: ${orderDateTime.toLocal()}'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsPage(order: order),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
