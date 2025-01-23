import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'addproduct.dart';
import 'showproductgrid.dart';
import 'showproducttype.dart';

// Method หลักทีRun
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyB-UOcUDBIC1fd1JhxN_EnyYdQ4ZSWzp3g",
            authDomain: "work1-37efb.firebaseapp.com",
            databaseURL:
                "https://work1-37efb-default-rtdb.asia-southeast1.firebasedatabase.app",
            projectId: "work1-37efb",
            storageBucket: "work1-37efb.firebasestorage.app",
            messagingSenderId: "151427635184",
            appId: "1:151427635184:web:b8182b975ec9c593182f35",
            measurementId: "G-YCRY96NN6K"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

// Class stateless สั่งแสดงผลหนาจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: Main(),
    );
  }
}

// Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Main> {
  // ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ww.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                children: [
                  // ส่วนที่เพิ่มโลโก้ด้านบน
                  Container(
                    width: double.infinity,
                    height: 150, // กำหนดความสูงของพื้นที่โลโก้
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/logo.png', // ใช้โลโก้ของคุณที่นี่
                        height: 200, // ขนาดโลโก้
                        width: 200, // ขนาดโลโก้
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'เมนูหลัก',
                        style: TextStyle(
                          fontSize: 24,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the addproduct screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => addproduct()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Set the background to transparent
                      padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 40), // Adjusted padding for button size
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                        side: BorderSide(
                          color: Color.fromARGB(
                              255, 0, 0, 0), // Border color (orange)
                          width: 2, // Border width
                        ),
                      ),
                      elevation: 0, // No shadow effect
                      minimumSize:
                          Size(400, 100), // Minimum button size (width, height)
                    ),
                    child: Text(
                      'บันทึกสินค้า',
                      style: TextStyle(
                        fontSize: 18, // Font size
                        fontWeight: FontWeight.bold, // Bold text
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the addproduct screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowProductgrid()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Set the background to transparent
                      padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 40), // Adjusted padding for button size
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                        side: BorderSide(
                          color: Color.fromARGB(
                              255, 0, 0, 0), // Border color (orange)
                          width: 2, // Border width
                        ),
                      ),
                      elevation: 0, // No shadow effect
                      minimumSize:
                          Size(400, 100), // Minimum button size (width, height)
                    ),
                    child: Text(
                      'แสดงข้อมูลสินค้า',
                      style: TextStyle(
                        fontSize: 18, // Font size
                        fontWeight: FontWeight.bold, // Bold text
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the addproduct screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowProductType()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Set the background to transparent
                      padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 40), // Adjusted padding for button size
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                        side: BorderSide(
                          color: Color.fromARGB(
                              255, 0, 0, 0), // Border color (orange)
                          width: 2, // Border width
                        ),
                      ),
                      elevation: 0, // No shadow effect
                      minimumSize:
                          Size(400, 100), // Minimum button size (width, height)
                    ),
                    child: Text(
                      'ประเภทสินค้า',
                      style: TextStyle(
                        fontSize: 18, // Font size
                        fontWeight: FontWeight.bold, // Bold text
                        color: Colors.white, // Text color
                      ),
                    ),
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
