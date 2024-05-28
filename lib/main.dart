import 'package:flutter/material.dart';
import 'dart:convert';
import 'models/company.dart';
import 'models/employe.dart'; // Ensure the path to your Employee model is correct
import 'models/product.dart'; // Ensure the path to your Product model is correct

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Company Info',
      theme: ThemeData(colorScheme: ColorScheme.dark(background: Colors.black)),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Company> futureCompany;
  late Company company;
  List<Employee> employees = [];
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    futureCompany = fetchCompany();
  }

  Future<Company> fetchCompany() async {
    const jsonString = '''
    {
      "company": "Tech Solutions",
      "location": "San Francisco",
      "employees": [
        {
          "name": "Alice",
          "age": 30,
          "position": "Developer",
          "skills": ["Dart", "Flutter", "Firebase"]
        },
        {
          "name": "Bob",
          "age": 25,
          "position": "Designer",
          "skills": ["Photoshop", "Illustrator"]
        }
      ],
      "products": [
        {
          "id": "1",
          "title": "Product A",
          "description": "Description for Product A",
          "price": 29.99,
          "imageUrl": "https://cdn.shopify.com/s/files/1/0070/7032/files/product_20research.png?v=1702995315",
          "inStock": true
        },
        {
          "id": "2",
          "title": "Product B",
          "description": "Description for Product B",
          "price": 49.99,
          "imageUrl": "https://cdn.shopify.com/s/files/1/0070/7032/files/product_20research.png?v=1702995315",
          "inStock": false
        }
      ]
    }
    ''';

    return Company.fromJson(jsonDecode(jsonString));
  }

  void addEmployee(String name, String position, int age) {
    setState(() {
      employees.add(Employee(name: name, age: age, position: position, skills: []));
    });
  }

  void deleteEmployee(int index) {
    setState(() {
      employees.removeAt(index);
    });
  }

  void addProduct(String title, String description, double price, bool inStock) {
    setState(() {
      products.add(Product(id: DateTime.now().toString(), title: title, description: description, price: price, imageUrl: '', inStock: inStock));
    });
  }

  void deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Info'),
      ),
      body: FutureBuilder<Company>(
        future: futureCompany,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No Data Found'));
          } else {
            company = snapshot.data!;
            employees = company.employees;
            products = company.products;
            return ListView(
              children: [
                Card(
                  child: ListTile(
                    title: Text('Company: ${company.company}'),
                    subtitle: Text('Location: ${company.location}'),
                  ),
                ),
                ...employees.asMap().entries.map((entry) {
                  int index = entry.key;
                  var employee = entry.value;
                  return EmployeeCard(
                    key: ValueKey(employee.name),
                    employee: employee,
                    onDelete: () {
                      deleteEmployee(index);
                    },
                  );
                }).toList(),
                AddEmployeeForm(onAdd: addEmployee),
                ...products.asMap().entries.map((entry) {
                  int index = entry.key;
                  var product = entry.value;
                  return ProductCard(
                    key: ValueKey(product.id),
                    product: product,
                    onDelete: () {
                      deleteProduct(index);
                    },
                  );
                }).toList(),
                AddProductForm(onAdd: addProduct),
              ],
            );
          }
        },
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onDelete;

  EmployeeCard({
    required Key key,
    required this.employee,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Name: ${employee.name}'),
            subtitle: Text('Position: ${employee.position}\nAge: ${employee.age}'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddEmployeeForm extends StatefulWidget {
  final Function(String, String, int) onAdd;

  AddEmployeeForm({required this.onAdd});

  @override
  _AddEmployeeFormState createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends State<AddEmployeeForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  void addEmployee() {
    final String name = nameController.text;
    final String position = positionController.text;
    final int age = int.parse(ageController.text);

    widget.onAdd(name, position, age);

    nameController.clear();
    positionController.clear();
    ageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: positionController,
              decoration: InputDecoration(labelText: 'Position'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addEmployee,
              child: Text('Add Employee'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  ProductCard({
    required Key key,
    required this.product,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Title: ${product.title}'),
            subtitle: Text(
                'Description: ${product.description}\nPrice: \$${product.price}\nIn Stock: ${product.inStock}'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddProductForm extends StatefulWidget {
  final Function(String, String, double, bool) onAdd;

  AddProductForm({required this.onAdd});

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  bool inStock = false;

  void addProduct() {
    final String title = titleController.text;
    final String description = descriptionController.text;
    final double price = double.parse(priceController.text);

    widget.onAdd(title, description, price, inStock);

    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    setState(() {
      inStock = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Checkbox(
                  value: inStock,
                  onChanged: (bool? value) {
                    setState(() {
                      inStock = value ?? false;
                    });
                  },
                ),
                Text('In Stock'),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addProduct,
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
