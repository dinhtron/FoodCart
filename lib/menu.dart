import 'package:flutter/material.dart';
import 'package:flutter_application_3/data/data.dart';
import 'package:flutter_application_3/order.dart';
import 'package:flutter_application_3/cart.dart';
class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}
class _MenuState extends State<Menu> {
    final Cart cart = Cart();
  late Future<List<Order>> orderHistory;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    orderHistory = OrderRepository.getOrderHistory();
    searchController = TextEditingController();
  }


  List<MenuItem> filteredMenuItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 208, 190, 210),
        title: Text('Menu'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cart: cart, onPlaceOrder: _placeOrder),
                ),
              );
            },
            icon: Icon(Icons.shopping_cart),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderHistoryPage(),
                ),
              );
            },
            icon: Icon(Icons.history),
          ),
        ],
      ),
      body: Column(
        children: [
            Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterMenuItems,
              decoration: InputDecoration(
                icon: Icon(Icons.search),
                labelText: 'Tìm kiếm món ăn',
                border: InputBorder.none, 
                suffixIcon: ElevatedButton(
                onPressed: () {
                searchController.clear();
                _filterMenuItems('');
                },
                child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                Text(
                  'Danh sách món',
                  style: TextStyle(color: Colors.black),
                ),
                ],
               ),),),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMenuItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(filteredMenuItems[index].image),
                    radius: 50,
                  ),
                  title: Text(filteredMenuItems[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(filteredMenuItems[index].description),
                      Text('Giá: ${filteredMenuItems[index].price.toStringAsFixed(0)}đ'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      cart.items.add(CartItem(
                        name: filteredMenuItems[index].name,
                        price: filteredMenuItems[index].price,
                        quantity: 1,
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${filteredMenuItems[index].name} đã được thêm vào giỏ hàng.'),
                        ),
                      );
                    },
                    child: Text('Thêm'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _filterMenuItems(String query) {
    setState(() {
      filteredMenuItems = menuItems
          .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }


  void _placeOrder() async {
    double total = 0.0;
    List<CartItem> items = List.from(cart.items);

    for (var item in cart.items) {
      total += item.price * item.quantity;
    }

    Map<String, dynamic> orderData = {'total': total};
    List<Map<String, dynamic>> itemsData = [];

    for (var item in items) {
      itemsData.add({
        'name': item.name,
        'price': item.price,
        'quantity': item.quantity,
      });
    }

    await OrderRepository.saveOrder(orderData, itemsData);
    setState(() {
      orderHistory = OrderRepository.getOrderHistory();
    });
    cart.items.clear();
  }
}

