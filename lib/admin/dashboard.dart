import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, 'login_screen'); 
    } catch (e) {
      print('Error logging out: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello World'),
            Text('ini page untuk admin'),
            ElevatedButton(
              onPressed: () {
                _logout();
                Navigator.pushReplacementNamed(context, 'login_screen');
              }, 
              child: Text('logout')
              ),
          ],
        ),
      ),
    );
  }
}
