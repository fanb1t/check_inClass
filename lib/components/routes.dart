class Routes {
  static const String dashboard = '/';
  static const String studentList = '/students';
  static const String attendance = '/attendance';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case studentList:
        return MaterialPageRoute(builder: (_) => StudentListScreen());
      case attendance:
        return MaterialPageRoute(builder: (_) => AttendanceScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
