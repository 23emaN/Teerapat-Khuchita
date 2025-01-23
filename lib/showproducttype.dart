import 'package:flutter/material.dart';
import 'showfiltertype.dart'; // Import the ShowProductFormType page

class ShowProductType extends StatefulWidget {
  @override
  _ShowProductTypeState createState() => _ShowProductTypeState();
}

class _ShowProductTypeState extends State<ShowProductType> {
  List<String> categories = [
    'Electronics',
    'Clothing',
    'Food',
    'Books'
  ]; // List of categories

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 250, 231, 59)),
      body: Container(
        width: double.infinity, // Ensures the container takes up the full width
        height: MediaQuery.of(context).size.height, // Full height of the screen
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wl.jpg'), // Background image
            fit: BoxFit.cover, // Make the image cover the entire screen
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ประเภทสินค้า',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor:
                          Colors.transparent, // Set background to transparent
                      side: BorderSide(
                        color: const Color.fromARGB(255, 255, 231,
                            15), // Optional: Border color to make it visible
                        width: 1,
                      ),
                    ),
                    onPressed: () {
                      // Navigate to ShowProductFormType page and pass the selected category
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ShowProductFormType(category: categories[index]),
                        ),
                      );
                    },
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .white, // Ensure text is visible on the button
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
