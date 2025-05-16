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
    _passController = TextEditingController();//making _controller
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
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(controller: _loginController,
              decoration: InputDecoration(
                  hintText: "Type here",
                  border: OutlineInputBorder(),
                  labelText: "Login"
              ),
            ),

            TextField(controller: _passController,
              decoration: InputDecoration(
                hintText: "Type here",
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
              obscureText: true,
            ),

            ElevatedButton( onPressed: () {
              if(_passController.value.text == "QWERTY123"){
                setState(() {
                  img = "images/idea.png";
                });
              }else{
                setState(() {
                  img = "images/stop.png";
                });
              }
            },
              child: Text("Login",
                  style: TextStyle(fontSize: 30, color: Colors.blue)),
            ),
            Image.asset(img, width: 300, height: 300,)
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