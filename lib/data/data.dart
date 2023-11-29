import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class User {
  String username;
  String password;
  User({required this.username, required this.password});
}

var UserList = [
  User(username: 'DuyHoang', password: "123"),
  User(username: 'Phuocdo', password: "123")
];
class MenuItem {
  final String name;
  final String description;
  final String image;
  final double price;

  MenuItem({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
  });
}
class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
class Order {
  final int id;
  final double total;
  final List<Map<String, dynamic>> items;

  Order({required this.id, required this.total, required this.items});
}


class Cart {
  List<CartItem> items = [];
}
class DatabaseProvider {
  static const String _databaseName = 'order_history.db';
  static const int _databaseVersion = 1;

  DatabaseProvider._();

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER,
        name TEXT,
        price REAL,
        quantity INTEGER,
        FOREIGN KEY (order_id) REFERENCES orders (id)
      )
    ''');
  }
}

class CartItem {
  final String name;
  final double price;
  int quantity;

  CartItem({required this.name, required this.price, required this.quantity});
}
List<MenuItem> menuItems = [
  MenuItem(
    name: 'Pizza',
    description: 'Pizza truyền thống với những nguyên liệu yêu thích của bạn',
    image: 'assets/img/pizza.png',
    price: 50000,
  ),
  MenuItem(
    name: 'Phở',
    description: 'Mì phở truyền thống Việt Nam',
    image: 'assets/img/pho.jpg',
    price: 35000,
  ),
  MenuItem(
    name: 'Bánh Mì',
    description: 'Bánh mì Việt Nam với nhiều loại nhân',
    image: 'assets/img/banhmi.jpg',
    price: 15000,
  ),
  MenuItem(
    name: 'Bún Chả',
    description: 'Thịt lợn nướng với bún và rau sống',
    image: 'assets/img/buncha.jpg',
    price: 25000,
  ),
  MenuItem(
    name: 'Cơm Tấm',
    description: 'Cơm tấm với thịt lợn nướng và các món ăn kèm',
    image: 'assets/img/comtam.jpg',
    price: 30000,
  ),
  MenuItem(
    name: 'Gỏi Cuốn',
    description: 'Cuốn gỏi tươi ngon với tôm và rau sống',
    image: 'assets/img/goicuon.jpg',
    price: 20000,
  ),
  MenuItem(
    name: 'Cá Kho Tộ',
    description: 'Cá nước mặn kho tộ trong nồi đất nung',
    image: 'assets/img/cakho.jpg',
    price: 50000,
  ),
  MenuItem(
    name: 'Bò Lúc Lắc',
    description: 'Thịt bò xào với rau sống',
    image: 'assets/img/boluclac.jpg',
    price: 40000,
  ),
  MenuItem(
    name: 'Mì Quảng',
    description: 'Mì Quảng với thịt và rau sống',
    image: 'assets/img/miquang.jpg',
    price: 30000,
  ),
  MenuItem(
    name: 'Nộm Hoa Chuối',
    description: 'Nộm hoa chuối với gà và rau sống',
    image: 'assets/img/nomhoachuoi.jpg',
    price: 25000,
  ),
  MenuItem(
    name: 'Bánh Xèo',
    description: 'Bánh xèo Việt Nam với tôm và thịt lợn',
    image: 'assets/img/banhxeo.jpg',
    price: 7000,
  ),
  MenuItem(
    name: 'Chè Ba Màu',
    description: 'Chè ba màu với đậu và nước cốt dừa',
    image: 'assets/img/chebamau.jpg',
    price: 15000,
  ),
  MenuItem(
    name: 'Cao Lầu',
    description: 'Mì đặc biệt Hội An với thịt và rau sống',
    image: 'assets/img/caolau.jpg',
    price: 30000,
  ),
  MenuItem(
    name: 'Bánh Canh Cua',
    description: 'Bánh canh cua với thịt cua',
    image: 'assets/img/banhcanhcua.jpg',
    price: 70000,
  ),
  MenuItem(
    name: 'Chả Cá Thăng Long',
    description: 'Cá chiên nước mắm thơm lừng',
    image: 'assets/img/chacathanglong.jpg',
    price: 60000,
  ),
];