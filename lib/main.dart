import 'package:flutter/material.dart';

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
      home: const MyHomePage(title: 'CST2335 Lab 3'),
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
  late TextEditingController _quantityController;
  late TextEditingController _itemController;
  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    super.dispose(); // free memory that was typed
  }

  List<String> items = [];
  List<String> quantities = [];

  Widget listPage() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Shopping List",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _itemController,
                  decoration: InputDecoration(
                    hintText: "Type Item here",
                    border: OutlineInputBorder(),
                    labelText: "Item",
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    hintText: "Type Quantity here",
                    border: OutlineInputBorder(),
                    labelText: "Quantity",
                  ),
                ),
              ),
              ElevatedButton(
                child: Text("Add item"),
                onPressed: () {
                  if (_itemController.text.isNotEmpty &&
                      _quantityController.text.isNotEmpty) {
                    setState(() {
                      items.add(_itemController.value.text);
                      quantities.add(_quantityController.value.text);
                      _quantityController.text = "";
                      _itemController.text = "";
                    });
                  }
                },
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, rowNum) {
              return GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${rowNum + 1}. ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("${items[rowNum]} ", style: TextStyle(fontSize: 20)),
                    Text(
                      "Quantity: ${quantities[rowNum]}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                onLongPress: () {
                  showDialog<String>(
                    context: context,
                    builder:
                        (BuildContext context) => AlertDialog(
                          title: const Text('Delete'),
                          content: const Text('Are you sure?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  items.removeAt(rowNum);
                                  quantities.removeAt(rowNum);
                                });
                                Navigator.pop(context);
                              },
                              child: Text("Yes"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No"),
                            ),
                          ],
                        ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Week 6 Lab"),
      ),

      body: listPage(),
    );
  }
}
