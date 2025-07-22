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
      home: const MyHomePage(title: 'CST2335 Lab 9'),
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

  var selectedItem;

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
          content: Text("Item and Quantity must not be blank!"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _deleteItem() {
    dao.deleteItem(selectedItem).then((_) {
      setState(() {
        shoppingList.removeWhere((item) => item.id == selectedItem.id);
        selectedItem = null;
      });
    });
  }

  Widget ListPage() {
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
                onTap: () {
                  setState(() {
                    selectedItem = item;
                  });
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

  Widget DetailsPage() {
    if (selectedItem != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Item Details",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Item Name: ${selectedItem.name}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Quantity: ${selectedItem.quantity}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Database ID: ${selectedItem.id}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _deleteItem();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                // Close button as per requirement 4
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedItem = null;
                    });
                  },
                  child: const Text("Close"),
                ),
              ],
            ),
          ],
        ),
      );
    }
    return const Center(child: Text("No item selected"));
  }

  Widget reactiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    if ((width > height) && (width > 720)) {
      return Row(
        children: [
          Expanded(flex: 1, child: ListPage()),
          Expanded(flex: 1, child: DetailsPage()),
        ],
      );
    } else {
      if (selectedItem == null) {
        return ListPage();
      } else {
        return DetailsPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: reactiveLayout(),
    );
  }
}
