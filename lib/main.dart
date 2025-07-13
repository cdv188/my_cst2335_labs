import 'package:flutter/material.dart';
import 'package:my_cst2335_lab/app_database.dart';
import 'package:my_cst2335_lab/shopping_item.dart';
import 'package:my_cst2335_lab/shopping_item_dao.dart';

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
      home: const MyHomePage(title: 'CST2335 Lab 8'),
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
  late TextEditingController _itemController;
  late TextEditingController _quantityController;

  late AppDatabase database;
  late ShoppingItemDao dao;
  List<ShoppingItem> shoppingList = [];

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController();
    _quantityController = TextEditingController();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    database =
        await $FloorAppDatabase.databaseBuilder('shopping_list.db').build();
    dao = database.shoppingItemDao;
    final items = await dao.findAllItems();
    setState(() {
      shoppingList = items;
    });
  }

  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _addItem() async {
    final itemText = _itemController.text.trim();
    final quantityText = _quantityController.text.trim();

    if (itemText.isNotEmpty && quantityText.isNotEmpty) {
      final item = ShoppingItem(ShoppingItem.ID++, itemText, quantityText);
      await dao.insertItem(item).then((_) {
        setState(() {
          shoppingList.add(item);
          _itemController.clear();
          _quantityController.clear();
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item and Quantity must not be blank"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _deleteItem(int index) {
    final item = shoppingList[index];
    dao.deleteItem(item).then((_) {
      setState(() {
        shoppingList.removeAt(index);
      });
    });
  }

  Widget _buildListView() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Shopping List",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _itemController,
                  decoration: const InputDecoration(
                    hintText: "Enter item",
                    labelText: "Item",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    hintText: "Enter quantity",
                    labelText: "Quantity",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _addItem, child: const Text("Add")),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: shoppingList.length,
            itemBuilder: (context, index) {
              final item = shoppingList[index];
              return GestureDetector(
                onLongPress: () {
                  showDialog<String>(
                    context: context,
                    builder:
                        (BuildContext context) => AlertDialog(
                          title: const Text('Delete'),
                          content: const Text(
                            'Are you sure you want to delete this item?',
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                _deleteItem(index);
                                Navigator.pop(context);
                              },
                              child: const Text("Yes"),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("No"),
                            ),
                          ],
                        ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "${index + 1}. ",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${item.name} - Quantity: ${item.quantity}",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
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
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildListView(),
    );
  }
}
