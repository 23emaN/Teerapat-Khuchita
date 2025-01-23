import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // For Firebase Database

class ShowProductFormType extends StatefulWidget {
  final String category; // Category passed from the previous screen

  ShowProductFormType({required this.category});

  @override
  _ShowProductFormTypeState createState() => _ShowProductFormTypeState();
}

class _ShowProductFormTypeState extends State<ShowProductFormType> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = []; // To hold product data

  // Fetch products from Firebase based on the category
  Future<void> fetchProducts() async {
    try {
      final query = dbRef.orderByChild('category').equalTo(widget.category);
      final snapshot = await query.get();

      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] =
              child.key; // Store the key for reference (for delete/update)
          loadedProducts.add(product);
        });
        setState(() {
          products = loadedProducts;
        });
        print("Loaded products for ${widget.category}: ${products.length}");
      } else {
        print("No products found for category: ${widget.category}");
        setState(() {
          products = []; // Clear products list if no data found
        });
      }
    } catch (e) {
      print("Error fetching products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 231, 59),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('wg.jpg'), // Set the background image
              fit: BoxFit.cover, // Cover the entire screen
            ),
            color: const Color.fromARGB(255, 255, 255, 255)
                .withOpacity(0.5), // Add semi-transparent overlay color
          ),
          child: products.isEmpty
              ? Align(
                  alignment: Alignment.topCenter, // Align text to the top
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 100.0), // Add top padding to position it
                    child: Text(
                      'ยังไม่มีข้อมูล', // "No data available"
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: const Color.fromARGB(255, 250, 250, 250),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                        side: BorderSide(
                          color: Color.fromARGB(
                              255, 255, 255, 255), // Border color (orange)
                          width: 2, // Border width
                        ),
                      ),
                      elevation: 5,
                      color: Colors
                          .transparent, // Set the background color to transparent
                      child: ListTile(
                        title: Text(
                          product['name'],
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color.fromARGB(
                                255, 255, 255, 255), // White text
                          ),
                        ),
                        subtitle: Text(
                          'Price: ${product['price']} THB',
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color.fromARGB(
                                255, 255, 255, 255), // White text
                          ),
                        ),
                        onTap: () {
                          // Navigate to the product detail screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                product: product, // Pass the selected product
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )),
    );
  }
}

// Product Detail Screen to show more detailed information
class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic>
      product; // The product passed from the previous screen

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 231, 59),
      ),
      body: Container(
        width: double.infinity, // Ensure the container takes up the full width
        height:
            double.infinity, // Ensure the container takes up the full height
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ws.jpg'), // Background image
            fit: BoxFit.cover, // To cover the entire screen
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Product Price
            Text(
              'Price: ${product['price']} THB',
              style: TextStyle(
                  fontSize: 18, color: const Color.fromARGB(255, 0, 0, 0)),
            ),
            SizedBox(height: 10),
            Text(
              'Quantity: ${product['quantity']} ชิ้น',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 10),
            // Product Description (if available)
            product['description'] != null
                ? Text(
                    'Description: ${product['description']}',
                    style: TextStyle(fontSize: 16),
                  )
                : Container(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
