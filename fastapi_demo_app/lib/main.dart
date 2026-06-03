import 'package:flutter/material.dart';
import 'controller.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final HomeController _controller = HomeController();
  List<dynamic> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    final products = await _controller.getAllProducts();
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  void _showProductDialog([Map<String, dynamic>? product]) {
    final isEditing = product != null;
    final idController = TextEditingController(text: product?['id']?.toString() ?? '');
    final nameController = TextEditingController(text: product?['name'] ?? '');
    final priceController = TextEditingController(text: product?['price']?.toString() ?? '');
    final descriptionController = TextEditingController(text: product?['des'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Product' : 'Add Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isEditing)
                  TextField(
                    controller: idController,
                    decoration: const InputDecoration(labelText: 'ID (Integer)'),
                    keyboardType: TextInputType.number,
                  ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description (des)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                
                final data = {
                  'name': nameController.text,
                  'price': double.tryParse(priceController.text) ?? 0,
                  'des': descriptionController.text,
                };

                bool success;
                if (isEditing) {
                  final id = product['id'] ?? product['_id'];
                  data['userid'] = id; // Add userid internally
                  success = await _controller.updateProduct(id, data);
                } else {
                  final newId = int.tryParse(idController.text) ?? 0;
                  data['id'] = newId;
                  data['userid'] = newId; // Add userid internally matching the ID
                  success = await _controller.addProduct(data);
                }
                
                if (success) {
                  navigator.pop();
                  _fetchProducts();
                } else {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Operation failed')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            onPressed: () => _fetchProducts(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () => _showProductDialog(),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text("No products found."))
              : ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: ListTile(
                        title: Text(product['name'] ?? 'Unknown'),
                        subtitle: Text('ID: ${product['id'] ?? '?'}\nPrice: \$${product['price'] ?? 0}\n${product['des'] ?? ''}'),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showProductDialog(product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final id = product['id'] ?? product['_id'];
                                if (id != null) {
                                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                                  // Pass id twice since userid is the same as id
                                  final success = await _controller.deleteProduct(id, id);
                                  if (success) {
                                    _fetchProducts();
                                  } else {
                                    scaffoldMessenger.showSnackBar(
                                      const SnackBar(content: Text('Delete failed')),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}