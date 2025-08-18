import 'package:flutter/material.dart';
// import 'components/routes.dart';  // ไฟล์ เส้นทางแอพ

void main() {
  runApp(const check_in_classAPP());
}

class check_in_classAPP extends StatelessWidget {
  const check_in_classAPP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,         // ปิด banner มุมขวา
      title: 'Attendance App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,         // สีหลักของแอป
        scaffoldBackgroundColor: Colors.white,  // สีพื้นหลัง
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,        // สีตัวอักษรใน AppBar
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,   // สีปุ่มหลัก
            foregroundColor: Colors.white,
          ),
        ),
      ),
      // initialRoute: Routes.dashboard,           // หน้าเริ่มต้น
      // onGenerateRoute: Routes.generateRoute,    // เรียกใช้ไฟล์ routes.dart
    );
  }
}
