import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'showproductgrid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 57, 199, 255)),
        useMaterial3: true,
      ),
      home: addproduct(),
    );
  }
}

class addproduct extends StatefulWidget {
  @override
  State<addproduct> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<addproduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quaController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final categories = ['Electronics', 'Clothing', 'Food', 'Books'];
  String? selectedCategory;
  DateTime? productionDate;

  Future<void> pickProductionDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: productionDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != productionDate) {
      setState(() {
        productionDate = pickedDate;
        dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  int? selectedQuantity;

  void _clearForm() {
    nameController.clear();
    desController.clear();
    priceController.clear();
    quaController.clear();
    dateController.clear();

    setState(() {
      selectedCategory = null;
      productionDate = null;
    });

    setState(() {
      selectedQuantity = null;
    });
  }

  Future<void> saveProductToDatabase() async {
    try {
// สร้าง reference ไปยัง Firebase Realtime Database
      DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
//ข้อมูลสินค้าที่จะจัดเก็บในรูปแบบ Map
      //ชื่อตัวแปรที่รับค่าที่ผู้ใช้ป้อนจากฟอร์มต้องตรงกับชื่อตัวแปรที่ตั้งตอนสร้างฟอร์มเพื่อรับค่า
      Map<String, dynamic> productData = {
        'name': nameController.text,
        'description': desController.text,
        'category': selectedCategory,
        'productionDate': productionDate?.toIso8601String(),
        'price': double.parse(priceController.text),
        'quantity': int.parse(quaController.text),
        'discount': selectedQuantity,
      };
//ใช้คําสั่ง push() เพื่อสร้าง key อัตโนมัติสําหรับสินค้าใหม่
      await dbRef.push().set(productData);
//แจ้งเตือนเมื่อบันทึกสําเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลสําเร็จ')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShowProductgrid()),
      );
// รีเซ็ตฟอร์ม
      _formKey.currentState?.reset();
      nameController.clear();
      desController.clear();
      priceController.clear();
      quaController.clear();
      dateController.clear();
      setState(() {
        selectedCategory = null;
        productionDate = null;
        selectedQuantity = null;
      });
    } catch (e) {
//แจ้งเตือนเมื่อเกิดข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 250, 231, 59)),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wp.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'บันทึกข้อมูลสินค้า',
                        style: TextStyle(
                          fontSize: 24,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  // ชื่อสินค้า
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อสินค้า',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(
                            255, 255, 255, 255), // สีของป้ายข้อความ
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20), // ขอบของช่องใส่ข้อมูล
                      ),
                      fillColor: Colors.transparent, // ทำให้พื้นหลังโปร่งใส
                      filled: true, // ใช้พื้นหลังที่กำหนด (โปร่งใส)
                    ),
                    style: TextStyle(
                      color: const Color.fromARGB(
                          255, 0, 0, 0), // สีข้อความที่ป้อน
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกชื่อสินค้า';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  // รายละเอียดสินค้า
                  TextFormField(
                    controller: desController,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'รายละเอียดสินค้า',
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(
                              255, 253, 253, 253)), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Colors.transparent, // ทำให้พื้นหลังโปร่งใส
                      filled: true, // ใช้พื้นหลังที่กำหนด (โปร่งใส)
                    ),
                    style: TextStyle(
                        color: const Color.fromARGB(
                            255, 0, 0, 0)), // Input text color
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกชื่อรายละเอียดสินค้า';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // ประเภทสินค้า (Dropdown)
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'ประเภทสินค้า',
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(
                              255, 255, 255, 255)), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Colors.transparent, // ทำให้พื้นหลังโปร่งใส
                      filled: true, // ใช้พื้นหลังที่กำหนด (โปร่งใส)
                    ),
                    items: categories
                        .map((category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาเลือกประเภทสินค้า';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // วันที่ผลิต
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'วันที่ผลิตสินค้า',
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(
                              255, 255, 255, 255)), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => pickProductionDate(context),
                      ),
                      fillColor: Colors.transparent, // ทำให้พื้นหลังโปร่งใส
                      filled: true, // ใช้พื้นหลังที่กำหนด (โปร่งใส)
                    ),
                    style: TextStyle(
                        color: const Color.fromARGB(
                            255, 0, 0, 0)), // Input text color
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกวันที่ผลิตสินค้า';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // ราคา
                  TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: 'ราคาสินค้า',
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(
                              255, 253, 253, 253)), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Colors.transparent, // ทำให้พื้นหลังโปร่งใส
                      filled: true, // ใช้พื้นหลังที่กำหนด (โปร่งใส)
                    ),
                    style: TextStyle(
                        color: const Color.fromARGB(
                            255, 0, 0, 0)), // Input text color
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกราคาสินค้า';
                      }
                      if (int.tryParse(value) == null) {
                        return 'กรุณากรอกราคาสินค้าเป็นตัวเลข';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // จำนวนสินค้า
                  TextFormField(
                    controller: quaController,
                    decoration: InputDecoration(
                      labelText: 'จำนวนสินค้า',
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(
                              255, 255, 255, 255)), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Colors.transparent, // ทำให้พื้นหลังโปร่งใส
                      filled: true, // ใช้พื้นหลังที่กำหนด (โปร่งใส)
                    ),
                    style: TextStyle(
                        color: const Color.fromARGB(
                            255, 0, 0, 0)), // Input text color
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกจำนวนสินค้า';
                      }
                      if (int.tryParse(value) == null) {
                        return 'กรุณากรอกจำนวนสินค้าเป็นตัวเลข';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // ส่วนลด
                  FormField<int>(
                    initialValue: selectedQuantity,
                    validator: (value) {
                      if (value == null) {
                        return 'กรุณาเลือกส่วนลด';
                      }
                      return null;
                    },
                    builder: (FormFieldState<int> state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('ส่วนลด',
                              style: TextStyle(
                                  color: const Color.fromARGB(
                                      255, 255, 255, 255))),
                          Row(
                            children: [
                              Radio<int>(
                                value: 1,
                                groupValue: selectedQuantity,
                                onChanged: (int? value) {
                                  selectedQuantity = value;
                                  state.didChange(value);
                                },
                              ),
                              Text('ไม่ให้ส่วนลด',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255))),
                              Radio<int>(
                                value: 2,
                                groupValue: selectedQuantity,
                                onChanged: (int? value) {
                                  selectedQuantity = value;
                                  state.didChange(value);
                                },
                              ),
                              Text('ให้ส่วนลด',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255))),
                            ],
                          ),
                          if (state.hasError)
                            Text(
                              state.errorText ?? '',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // ปุ่มบันทึกและปุ่มเคลียร์ข้อมูล
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                saveProductToDatabase();
                                // ดำเนินการเมื่อฟอร์มผ่านการตรวจสอบ
                              }
                            },
                            child: Text(
                              'บันทึกสินค้า',
                              style: TextStyle(
                                fontSize: 14, // Font size
                                fontWeight: FontWeight.bold, // Bold text
                                color: const Color.fromARGB(255, 0, 0,
                                    0), // Text color changed to white
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 250, 231,
                                  59), // Background color (orange)
                              padding: EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal:
                                      40), // Adjusted padding for button size
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30), // Rounded corners
                              ),
                              elevation: 5, // Shadow effect
                              shadowColor:
                                  Color.fromARGB(255, 0, 0, 0), // Shadow color
                            ),
                          )),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: _clearForm,
                          child: Text(
                            'เคลียร์ข้อมูล',
                            style: TextStyle(
                              fontSize: 14, // Font size
                              fontWeight: FontWeight.bold, // Bold text
                              color: const Color.fromARGB(
                                  255, 0, 0, 0), // Text color changed to white
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(
                                255, 250, 231, 59), // Background color (orange)
                            padding: EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal:
                                    40), // Adjusted padding for button size
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Rounded corners
                            ),
                            elevation: 5, // Shadow effect
                            shadowColor:
                                Color.fromARGB(255, 0, 0, 0), // Shadow color
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
