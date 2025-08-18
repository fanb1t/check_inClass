import 'package:flutter/material.dart';
import 'screen/dashboard.dart';
import 'screen/course_info.dart';

void main() {
  runApp(MyApp());
}

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

// เพิ่ม MainNavigation สำหรับควบคุมหน้าและเมนูด้านล่าง
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
      _selectedIndex = 0; // ไปยังหน้า Dashboard
    });
  }

  final List<String> _titles = [
    'Dashboard การเข้าเรียน',
    'เช็คชื่อเข้าเรียน',
    'ข้อมูลรายวิชา',
  ];

  // FloatingActionButton สำหรับปุ่มเช็คชื่อ
  Widget _buildFAB() {
    return Container(
      height: 72,
      width: 72,
      child: FloatingActionButton(
        backgroundColor: Color(0xFF1976D2),
        elevation: 8,
        onPressed: () => _onItemTapped(1),
        child: Icon(Icons.checklist, size: 36, color: Colors.white),
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 4)),
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
      body: _pages[_selectedIndex],
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        color: Color(0xFF1565C0),
        child: Container(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.dashboard,
                label: 'Dashboard',
                index: 0,
              ),
              SizedBox(width: 72), // ช่องว่างสำหรับ FAB
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
            size: 28,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.amber : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

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

enum AttendanceStatus { present, absent, leave }

// ปรับ AttendanceScreen ให้รองรับปุ่มล้างค่า
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
    return Scaffold(
      appBar: AppBar(
        title: Text('เช็คชื่อเข้าเรียน'),
        automaticallyImplyLeading: false, // ไม่แสดงปุ่ม back
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CourseInfoScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1976D2),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'วันที่: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      'เวลา: ${TimeOfDay.now().format(context)}',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  'จำนวนนักศึกษา: ${students.length}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 8),
                  elevation: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFBBDEFB), Color(0xFFE1F5FE)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFF1976D2),
                        child: Text(
                          student.id,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      title: Text(
                        student.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                      subtitle: Text(
                        'สถานะ: ${_getStatusText(student.status)}',
                        style: TextStyle(
                          color: _getStatusColor(student.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStatusButton(
                            icon: Icons.check_circle,
                            label: 'มา',
                            status: AttendanceStatus.present,
                            student: student,
                            index: index,
                          ),
                          SizedBox(width: 4),
                          _buildStatusButton(
                            icon: Icons.schedule,
                            label: 'ลา',
                            status: AttendanceStatus.leave,
                            student: student,
                            index: index,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showAddStudentDialog,
                    icon: Icon(Icons.person_add),
                    label: Text('เพิ่มนักศึกษา'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
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
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveAttendance,
                    icon: Icon(Icons.save),
                    label: Text('บันทึกและดู Dashboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0D47A1),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
