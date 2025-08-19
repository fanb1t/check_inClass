import 'package:flutter/material.dart';
import 'screen/dashboard.dart';
import 'screen/course_info.dart';


/// จุดเริ่มต้นของแอป
void main() {
  runApp(MyApp());
}

/// คลาสหลักของแอป กำหนดธีมและหน้าแรก
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ระบบเช็คชื่อเข้าเรียน',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF1565C0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF1565C0),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Color(0xFFE3F2FD),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1976D2),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: MainNavigation(),
    );
  }
}

/// คลาสควบคุม Navigation หลักและเมนูต่างๆ
class MainNavigation extends StatefulWidget {
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 1;
  Map<String, dynamic>? _attendanceData;

  void _onAttendanceSaved(Map<String, dynamic> data) {
    setState(() {
      _attendanceData = data;
      _selectedIndex = 0; // ไปยังหน้า สรุปการเข้าเรียน
    });
  }

  final List<String> _titles = [
    'สรุปการเข้าเรียน',
    'เช็คชื่อเข้าเรียน',
    'ข้อมูลรายวิชา',
  ];

  // ปรับขนาด FAB ให้เล็กลง
  Widget _buildFAB() {
    return SizedBox(
      height: 56,
      width: 56,
      child: FloatingActionButton(
        backgroundColor: Color(0xFF1976D2),
        elevation: 6,
        onPressed: () => _onItemTapped(1),
        child: Icon(Icons.checklist, size: 28, color: Colors.white),
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 3)),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      DashboardScreen(attendanceData: _attendanceData),
      AttendanceScreen(onAttendanceSaved: _onAttendanceSaved),
      CourseInfoScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        // เพิ่ม padding ด้านล่างเพื่อกันเนื้อหาถูกบัง
        padding: const EdgeInsets.only(bottom: 60),
        child: _pages[_selectedIndex],
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6,
        color: Color(0xFF1565C0),
        child: SizedBox(
          height: 52, // ปรับความสูงให้เล็กลง
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.dashboard,
                label: 'สรุปการเข้าเรียน',
                index: 0,
              ),
              SizedBox(width: 56), // ช่องว่างสำหรับ FAB
              _buildNavItem(
                icon: Icons.info_outline,
                label: 'ข้อมูลรายวิชา',
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// สร้างปุ่มเมนูแต่ละอันใน BottomNavBar
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.amber : Colors.white70,
            size: 24,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.amber : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// คลาสข้อมูลนักศึกษา
class Student {
  final String id;
  final String name;
  AttendanceStatus status;

  Student({
    required this.id,
    required this.name,
    this.status = AttendanceStatus.absent,
  });
}

/// สถานะการเข้าเรียน
enum AttendanceStatus { present, absent, leave }

/// หน้าสำหรับเช็คชื่อและจัดการนักศึกษา
class AttendanceScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAttendanceSaved;

  AttendanceScreen({required this.onAttendanceSaved});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Student> students = [
    Student(id: '001', name: 'สมชาย ใจดี'),
    Student(id: '002', name: 'สมหญิง รักเรียน'),
    Student(id: '003', name: 'วิชัย เก่งดี'),
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  void _addStudent() {
    if (_nameController.text.isNotEmpty && _idController.text.isNotEmpty) {
      setState(() {
        students.add(
          Student(id: _idController.text, name: _nameController.text),
        );
      });
      _nameController.clear();
      _idController.clear();
      Navigator.of(context).pop();
    }
  }

  void _showAddStudentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เพิ่มนักศึกษา', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF1976D2),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'รหัสนักศึกษา',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อ-นามสกุล',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('ยกเลิก', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: _addStudent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF1976D2),
              ),
              child: Text('เพิ่ม'),
            ),
          ],
        );
      },
    );
  }

  void _saveAttendance() {
    Map<String, dynamic> attendanceData = {
      'date': DateTime.now().toString().split(' ')[0],
      'time': TimeOfDay.now().format(context),
      'students': students
          .map(
            (student) => {
              'id': student.id,
              'name': student.name,
              'status': student.status.toString().split('.').last,
            },
          )
          .toList(),
      'summary': {
        'total': students.length,
        'present': students
            .where((s) => s.status == AttendanceStatus.present)
            .length,
        'absent': students
            .where((s) => s.status == AttendanceStatus.absent)
            .length,
        'leave': students
            .where((s) => s.status == AttendanceStatus.leave)
            .length,
      },
    };

    widget.onAttendanceSaved(attendanceData);
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.leave:
        return Colors.orange;
      case AttendanceStatus.absent:
        return Colors.red;
    }
  }

  String _getStatusText(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return 'มาเรียน';
      case AttendanceStatus.leave:
        return 'ลา';
      case AttendanceStatus.absent:
        return 'ขาดเรียน';
    }
  }

  void _clearAttendance() {
    setState(() {
      for (var student in students) {
        student.status = AttendanceStatus.absent;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFF1976D2),
                    child: Text(
                      student.id,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  title: Text(student.name),
                  subtitle: Row(
                    children: [
                      _buildStatusButton(
                        icon: Icons.check_circle,
                        label: 'มาเรียน',
                        status: AttendanceStatus.present,
                        student: student,
                        index: index,
                      ),
                      SizedBox(width: 8),
                      _buildStatusButton(
                        icon: Icons.schedule,
                        label: 'ลา',
                        status: AttendanceStatus.leave,
                        student: student,
                        index: index,
                      ),
                      SizedBox(width: 8),
                      _buildStatusButton(
                        icon: Icons.cancel,
                        label: 'ขาดเรียน',
                        status: AttendanceStatus.absent,
                        student: student,
                        index: index,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showAddStudentDialog,
                  icon: Icon(Icons.person_add),
                  label: Text('เพิ่มนักศึกษา'),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _clearAttendance,
                  icon: Icon(Icons.refresh),
                  label: Text('ล้างค่า'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saveAttendance,
                  icon: Icon(Icons.save),
                  label: Text('บันทึกและดูสรุป'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// สร้างปุ่มเลือกสถานะการเข้าเรียนแต่ละแบบ
  Widget _buildStatusButton({
    required IconData icon,
    required String label,
    required AttendanceStatus status,
    required Student student,
    required int index,
  }) {
    bool isSelected = student.status == status;
    return GestureDetector(
      onTap: () {
        setState(() {
          students[index].status = status;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? _getStatusColor(status) : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}