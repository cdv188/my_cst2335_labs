import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:my_cst2335_lab/profile_page.dart';

import 'data_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CST2335',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/', //default load the '/' route
      routes: {
        '/': (context) => MyHomePage(title: 'Title'),
        '/ProfilePage': (context) => ProfilePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _loginController;
  late TextEditingController _passController;
  var img = "images/question-mark.png";

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passController = TextEditingController(); //making _controller

    getSharedPref();
  }

  void getSharedPref() async {
    EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

    String username = await prefs.getString("Username");
    String password = await prefs.getString("Password");

    if (username.isNotEmpty || password.isNotEmpty) {
      _loginController.text = username;
      _passController.text = password;
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passController.dispose();
    super.dispose(); // free memory that was typed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Week 5 lab"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _loginController,
              decoration: InputDecoration(
                hintText: "Type here",
                border: OutlineInputBorder(),
                labelText: "Login",
              ),
            ),

            TextField(
              controller: _passController,
              decoration: InputDecoration(
                hintText: "Type here",
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
              obscureText: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    //loads the encrypted data table
                    if (_passController.value.text == "QWERTY123") {
                      DataRepository.loginName = _loginController.value.text;
                      Navigator.pushNamed(context, '/ProfilePage');
                      EncryptedSharedPreferences prefs =
                          EncryptedSharedPreferences();
                      prefs.setString("Password", _passController.value.text);
                      prefs.setString("Username", _loginController.value.text);
                      setState(() {
                        img = "images/idea.png";
                      });
                    } else {
                      setState(() {
                        img = "images/stop.png";
                      });
                    }
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 30, color: Colors.blue),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    EncryptedSharedPreferences prefs =
                        EncryptedSharedPreferences();

                    prefs.clear(); //remove the data
                  },
                  child: Text(
                    "Clear",
                    style: TextStyle(fontSize: 30, color: Colors.red),
                  ),
                ),
              ],
            ),

            Image.asset(img, width: 300, height: 300),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/
    );
  }
}
