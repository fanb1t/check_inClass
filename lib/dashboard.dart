import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final Map<String, dynamic>? attendanceData;

  const DashboardScreen({Key? key, required this.attendanceData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (attendanceData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: Colors.grey, size: 80),
            SizedBox(height: 16),
            Text(
              'ยังไม่มีข้อมูลการเช็คชื่อ',
              style: TextStyle(fontSize: 20, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Text(
              'กรุณาบันทึกการเช็คชื่อก่อน',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    final summary = attendanceData!['summary'];
    final students = attendanceData!['students'] as List;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // สรุปการเข้าเรียน
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
                Text(
                  'สรุปการเข้าเรียน',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'วันที่: ${attendanceData!['date']} เวลา: ${attendanceData!['time']}',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSummaryCard(
                      'ทั้งหมด',
                      summary['total'].toString(),
                      Icons.people,
                      Colors.white,
                    ),
                    _buildSummaryCard(
                      'มาเรียน',
                      summary['present'].toString(),
                      Icons.check_circle,
                      Colors.greenAccent,
                    ),
                    _buildSummaryCard(
                      'ลา',
                      summary['leave'].toString(),
                      Icons.schedule,
                      Colors.orangeAccent,
                    ),
                    _buildSummaryCard(
                      'ขาดเรียน',
                      summary['absent'].toString(),
                      Icons.cancel,
                      Colors.redAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          
          // รายละเอียดนักศึกษา
          Container(
            padding: EdgeInsets.all(16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'รายละเอียดการเข้าเรียน',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                SizedBox(height: 16),
                ...students.map((student) => _buildStudentCard(student)).toList(),
              ],
            ),
          ),
          SizedBox(height: 24),
          
          // กราฟสถิติ
          Container(
            height: 200,
            padding: EdgeInsets.all(16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'สถิติการเข้าเรียน',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildStatBar('มาเรียน', summary['present'], summary['total'], Colors.green),
                      _buildStatBar('ลา', summary['leave'], summary['total'], Colors.orange),
                      _buildStatBar('ขาดเรียน', summary['absent'], summary['total'], Colors.red),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    Color statusColor;
    IconData statusIcon;
    
    switch (student['status']) {
      case 'present':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'leave':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      default:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor, width: 2),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFF1976D2),
            child: Text(
              student['id'],
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              student['name'],
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D47A1),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  _getStatusTextFromString(student['status']),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBar(String label, int value, int total, Color color) {
    double percentage = total > 0 ? (value / total) : 0;
    
    return Column(
      children: [
        Expanded(
          child: Container(
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          value.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D47A1),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF1976D2),
          ),
        ),
      ],
    );
  }

  String _getStatusTextFromString(String status) {
    switch (status) {
      case 'present':
        return 'มาเรียน';
      case 'leave':
        return 'ลา';
      case 'absent':
        return 'ขาดเรียน';
      default:
        return 'ขาดเรียน';
    }
  }
}