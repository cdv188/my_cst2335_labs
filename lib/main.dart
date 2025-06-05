import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CST2335',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'CST2335 Lab 2'),
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
    Future.delayed(Duration.zero, () async {
      EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
      var usr = prefs.getString("Username");
      var pass = prefs.getString("Password");

      if (await usr != '' || await usr != '') {
        var snackBar = SnackBar(
          content: Text("Username: ${await usr} Password: ${await pass}"),
          duration: Duration(seconds: 5),
          action: SnackBarAction(label: 'Close', onPressed: () {}),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        var snackBar = SnackBar(
          content: Text("Nothing was Found"),
          duration: Duration(seconds: 5),
          action: SnackBarAction(label: 'Close', onPressed: () {}),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passController.dispose();
    super.dispose(); // free memory that was typed
  }

  void getSharedPref() async {
    EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

    var username = await prefs.getString("Username");
    var password = await prefs.getString("Password");

    if (username != '' || password != '') {
      _loginController.text = username;
      _passController.text = password;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Week 4 lab"),
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

            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      title: Text("Question?"),
                      content: Text("Do you want to save this?"),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            //loads the encrypted data table
                            if (_passController.value.text == "QWERTY123") {
                              EncryptedSharedPreferences prefs =
                                  EncryptedSharedPreferences();
                              prefs.setString(
                                "Password",
                                _passController.value.text,
                              );
                              prefs.setString(
                                "Username",
                                _loginController.value.text,
                              );
                              setState(() {
                                img = "images/idea.png";
                              });
                            } else {
                              setState(() {
                                img = "images/stop.png";
                              });
                            }
                            Navigator.pop(ctx);
                          },
                          child: Text('Yes'),
                        ),

                        FilledButton(
                          onPressed: () {
                            EncryptedSharedPreferences prefs =
                                EncryptedSharedPreferences();

                            prefs.clear(); //remove the data

                            Navigator.pop(ctx);
                          },
                          child: Text('No'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                "Login",
                style: TextStyle(fontSize: 30, color: Colors.blue),
              ),
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
