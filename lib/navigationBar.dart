import 'package:flutter/material.dart';
import 'package:supa/file_list.dart';
import 'package:supa/home.dart';
import 'package:supa/profile_page.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({Key? key}) : super(key: key);

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

int _selectedIndex = 0;
class _MyNavigationBarState extends State<MyNavigationBar> {

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return; // Do nothing if the selected index is already the current index
    }

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FileListPage()),
        );
        break;
      case 2:
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }

    setState(() {
      _selectedIndex = index; // Update the selected index after navigation
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'List Files',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'About',
        ),
      ],
      currentIndex: _selectedIndex,
      backgroundColor: Colors.blueGrey[900],
      selectedItemColor: Colors.greenAccent,
      unselectedItemColor: Colors.grey[300],
      onTap: _onItemTapped,
    );
  }
}