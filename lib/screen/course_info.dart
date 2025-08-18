import 'package:flutter/material.dart';

class CourseInfo {
  String courseName;
  String courseCode;
  String instructor;
  String schedule;
  String room;
  String description;

  CourseInfo({
    required this.courseName,
    required this.courseCode,
    required this.instructor,
    required this.schedule,
    required this.room,
    required this.description,
  });
}

class CourseInfoScreen extends StatefulWidget {
  @override
  _CourseInfoScreenState createState() => _CourseInfoScreenState();
}

class _CourseInfoScreenState extends State<CourseInfoScreen> {
  bool isEditing = false;
  CourseInfo courseInfo = CourseInfo(
    courseName: 'การพัฒนาแอปพลิเคชันมือถือ',
    courseCode: 'CS301',
    instructor: 'อาจารย์สมชาย ใจดี',
    schedule: 'จันทร์-พุธ 13:00-15:00',
    room: 'ห้อง 301 อาคารวิทยาศาสตร์',
    description: 'รายวิชานี้เป็นการเรียนรู้การพัฒนาแอปพลิเคชันมือถือด้วย Flutter และ Dart สำหรับระบบปฏิบัติการ Android และ iOS',
  );

  late TextEditingController _courseNameController;
  late TextEditingController _courseCodeController;
  late TextEditingController _instructorController;
  late TextEditingController _scheduleController;
  late TextEditingController _roomController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _courseNameController = TextEditingController(text: courseInfo.courseName);
    _courseCodeController = TextEditingController(text: courseInfo.courseCode);
    _instructorController = TextEditingController(text: courseInfo.instructor);
    _scheduleController = TextEditingController(text: courseInfo.schedule);
    _roomController = TextEditingController(text: courseInfo.room);
    _descriptionController = TextEditingController(text: courseInfo.description);
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseCodeController.dispose();
    _instructorController.dispose();
    _scheduleController.dispose();
    _roomController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (isEditing) {
        // บันทึกข้อมูล
        courseInfo = CourseInfo(
          courseName: _courseNameController.text,
          courseCode: _courseCodeController.text,
          instructor: _instructorController.text,
          schedule: _scheduleController.text,
          room: _roomController.text,
          description: _descriptionController.text,
        );
      }
      isEditing = !isEditing;
    });
  }

  void _cancelEdit() {
    setState(() {
      isEditing = false;
      _initControllers(); // รีเซ็ตค่าในฟิลด์
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลรายวิชา'),
        backgroundColor: Color(0xFF1565C0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: _toggleEdit,
          ),
          if (isEditing)
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: _cancelEdit,
            ),
        ],
      ),
      backgroundColor: Color(0xFFE3F2FD),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 48,
                  ),
                  SizedBox(height: 12),
                  Text(
                    isEditing ? 'แก้ไขข้อมูลรายวิชา' : 'ข้อมูลรายวิชา',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // ข้อมูลรายวิชา
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoField(
                    'ชื่อรายวิชา',
                    _courseNameController,
                    courseInfo.courseName,
                    Icons.book,
                  ),
                  SizedBox(height: 16),
                  _buildInfoField(
                    'รหัสวิชา',
                    _courseCodeController,
                    courseInfo.courseCode,
                    Icons.code,
                  ),
                  SizedBox(height: 16),
                  _buildInfoField(
                    'อาจารย์ผู้สอน',
                    _instructorController,
                    courseInfo.instructor,
                    Icons.person,
                  ),
                  SizedBox(height: 16),
                  _buildInfoField(
                    'วันเวลาเรียน',
                    _scheduleController,
                    courseInfo.schedule,
                    Icons.schedule,
                  ),
                  SizedBox(height: 16),
                  _buildInfoField(
                    'ห้องเรียน',
                    _roomController,
                    courseInfo.room,
                    Icons.location_on,
                  ),
                  SizedBox(height: 16),
                  _buildInfoField(
                    'คำอธิบายรายวิชา',
                    _descriptionController,
                    courseInfo.description,
                    Icons.description,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(
    String label,
    TextEditingController controller,
    String value,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Color(0xFF1976D2),
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D47A1),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isEditing ? Color(0xFF1976D2) : Colors.transparent,
              width: 2,
            ),
          ),
          child: isEditing
              ? TextField(
                  controller: controller,
                  maxLines: maxLines,
                  style: TextStyle(
                    color: Color(0xFF0D47A1),
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(
                    color: Color(0xFF0D47A1),
                    fontSize: 14,
                  ),
                ),
        ),
      ],
    );
  }
}