import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/user/changed_password.dart';
import 'package:flutter_firebase_app/user/dashboard.dart';
import 'package:flutter_firebase_app/user/profile.dart';
//import 'package:flutter/cupertino.dart';

class UserMain extends StatefulWidget {
  const UserMain({Key? key}) : super(key: key);

  @override
  State<UserMain> createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    Profile(),
    ChangePassword(),
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
            label: ' Dashboard '
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: ' Profile '
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: ' Changed Password '
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
