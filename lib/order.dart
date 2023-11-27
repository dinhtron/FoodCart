import 'package:flutter/material.dart';
import 'package:flutter_application_3/data/data.dart';
import 'package:sqflite/sqflite.dart';
class OrderRepository {
  static Future<void> saveOrder(Map<String, dynamic> orderData, List<Map<String, dynamic>> itemsData) async {
    final Database db = await DatabaseProvider.database;

    await db.transaction((txn) async {
      int orderId = await txn.insert('orders', orderData);

      for (var itemData in itemsData) {
        itemData['order_id'] = orderId;
        await txn.insert('order_items', itemData);
      }
    });
  }

  static Future<List<Order>> getOrderHistory() async {
    final Database db = await DatabaseProvider.database;

    final List<Map<String, dynamic>> orders = await db.query('orders');
    List<Order> orderHistory = [];

    for (var order in orders) {
      final List<Map<String, dynamic>> items = await db.query('order_items', where: 'order_id = ?', whereArgs: [order['id']]);
      orderHistory.add(Order(id: order['id'], total: order['total'], items: items));
    }

    return orderHistory;
  }
}

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late Future<List<Order>> orderHistory;

  @override
  void initState() {
    super.initState();
    orderHistory = OrderRepository.getOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 208, 190, 210),
        title: Text('Lịch sử'),
      ),
      body: FutureBuilder<List<Order>>(
        future: orderHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Lịch sử trống.'));
          } else {
            List<Order> orders = snapshot.data!;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Đơn: ${orders[index].id}'),
                  subtitle: Text('Tổng: ${orders[index].total.toStringAsFixed(0)}đ'),
                  onTap: () {
                    _showOrderDetails(context, orders[index]);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Đơn Hàng'),
          content: Column(
            children: [
              for (var item in order.items)
                ListTile(
                  title: Text(item['name']),
                  subtitle: Text('Số Lượng: ${item['quantity']}'),
                  trailing: Text('${item['price'] * item['quantity']}đ'),
                ),
              SizedBox(height: 10),
              Text(
                'Tổng: ${order.total.toStringAsFixed(0)}đ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
