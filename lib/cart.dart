import 'package:flutter/material.dart';
import 'package:flutter_application_3/data/data.dart';
class CartPage extends StatefulWidget {
  final Cart cart;
  final VoidCallback onPlaceOrder;
  CartPage({required this.cart, required this.onPlaceOrder});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _increaseQuantity(int index) {
    setState(() {
      widget.cart.items[index].quantity++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (widget.cart.items[index].quantity > 1) {
        widget.cart.items[index].quantity--;
      } else {
        widget.cart.items.removeAt(index);
      }
    });
  }

  void _clearAndClose(BuildContext context) {
    setState(() {
      widget.cart.items.clear();
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double total = 0.0;

    for (var item in widget.cart.items) {
      total += item.price * item.quantity;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 208, 190, 210),
        title: Text('Giỏ Hàng'),
      ),
      body: ListView.builder(
        itemCount: widget.cart.items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.cart.items[index].name),
            subtitle: Text('Số lượng: ${widget.cart.items[index].quantity}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    _decreaseQuantity(index);
                  },
                ),
                Text('${widget.cart.items[index].quantity}'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _increaseQuantity(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng: ${total.toStringAsFixed(0)}đ',
                style: TextStyle(fontSize: 18.0),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _clearAndClose(context);
                    },
                    child: Text('Xóa'),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      widget.onPlaceOrder();
                      Navigator.pop(context);
                    },
                    child: Text('Đặt Đơn'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
