import 'package:flutter/material.dart';
import 'package:flutter_application_3/data/data.dart';
import 'package:flutter_application_3/menu.dart';

class Login extends StatefulWidget {
  Login({Key? key});
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  TextEditingController UsernameController = new TextEditingController();
  TextEditingController PasswordController = new TextEditingController();

  bool _validate = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 10.0, right: 10.0, bottom: 0.0),
              child: Text(
                'Food Cart',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 10.0, right: 10.0, bottom: 0.0),
              child: Text(
                'Thực đơn nhà hàng ',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 5.0, right: 10.0, bottom: 0.0),
              child: IconButton(
                iconSize: 200,
                onPressed: () {},
                icon: CircleAvatar(
                    radius: 150,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage("assets/img/login.jpg")),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 20.0, right: 10.0, bottom: 0.0),
              child: Text(
                'Đăng nhập',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 20, bottom: 10),
              child: TextFormField(
                controller: UsernameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: 'Tên đăng nhập',
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 20, bottom: 0),
              child: TextFormField(
                controller: PasswordController,
                obscureText: true,
                onChanged: (text) {},
                decoration: InputDecoration(
                  icon: Icon(Icons.password_sharp),
                  labelText: 'Mật khẩu',
                  errorText: _validate ? null : 'Wrong user name or password ',
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  User? user;
                  try {
                    user = UserList.firstWhere((element) =>
                        element.username == UsernameController.text);
                  } catch (e) {
                    if (user == null) {
                      setInputValidation(false);
                      return;
                    }
                  }
                  if (user.password == PasswordController.text) {
                    setInputValidation(true);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Menu()));
                  } else {
                    setInputValidation(false);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 30.0, right: 30.0, top: 10, bottom: 10),
                  child: Text(
                    'Đăng nhập',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  setInputValidation(bool valid) {
    setState(() {
      _validate = valid;
    });
  }

  @override
  void dispose() {
    UsernameController.dispose();
    PasswordController.dispose();
    super.dispose();
  }
}
