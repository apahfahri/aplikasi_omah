import 'package:flutter/material.dart';

class KurirHome extends StatefulWidget {
  
  @override
  KurirHomeState createState() => KurirHomeState();
}

class KurirHomeState extends State<KurirHome> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Hello World'),
            Text('ini page untuk kurir'),
          ],
        ),
      ),
    );
  }
}