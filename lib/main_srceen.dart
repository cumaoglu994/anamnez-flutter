import 'package:e_anamnez/navigation_Screens/notification_srceen.dart';
import 'package:e_anamnez/navigation_Screens/user_screen.dart';
import 'package:e_anamnez/navigation_Screens/sikayetlerim_page.dart';
import 'package:e_anamnez/navigation_Screens/home_srceen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static String id = 'MainScreen';

  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MainScreen> {
  int _pageindex = 0;

  // HomeScreen'i kendisiyle tekrar çağırmamak için buraya başka bir ekran ekleyin
  final List<Widget> _pages = [
    HomeScreen(),
    //   CategoriesSrceen(),
    //  TasksScreen(),

    SikayetlerimPage(),
    NotificationsScreen(),
    UserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageindex,
        onTap: (value) {
          setState(() {
            _pageindex = value;
          });
        },
        unselectedItemColor: Color.fromARGB(255, 127, 127, 127),
        selectedItemColor: Colors.green,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              weight: 20,
              size: 40,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment,
              size: 40,
            ),
            label: 'Patient Registration',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              size: 40,
            ),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 40,
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
