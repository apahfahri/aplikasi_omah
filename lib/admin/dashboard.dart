import 'package:aplikasi_omah/admin/analisis.dart';
import 'package:aplikasi_omah/admin/pesanan.dart';
import 'package:aplikasi_omah/admin/profileAdmin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final User Admin;

  const Dashboard({super.key, required this.Admin});
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
      backgroundColor: Color(0xFFE9F4FF),
      appBar: AppBar(
        backgroundColor: Color(0xFFE9F4FF),
        elevation: 0,
        title: Row(
          children: [
            // Icon(Icons.menu, color: Colors.black),
            // SizedBox(width: 10),
            Text(
              'Hello, Admin',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileAdminPage()),
                );
              },
              child: UserAccountsDrawerHeader(
                accountName: Text('Admin'),
                accountEmail: Text('admin@example.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.black),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('Pesanan'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PesananPage()),
                  );
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Selesai'),
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => SelesaiPage()),
                //   );
              },
            ),
            ListTile(
              leading: Icon(Icons.delivery_dining),
              title: Text('Kurir'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KurirPage()),
                  );
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Analisis'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnalyticsChart()),
                  );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.search, color: Colors.grey),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton('Order', Colors.lightBlueAccent, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PesananPage()),
                  );
                }),
                _buildButton('Kurir', Colors.lightBlueAccent, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KurirPage()),
                  );
                }),
                _buildButton('Income', Colors.lightBlueAccent, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IncomePage()),
                  );
                }),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Table(
                        columnWidths: {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(2),
                        },
                        border: TableBorder.all(color: Colors.grey),
                        children: [
                          TableRow(children: [
                            _buildTableHeader('Order ID'),
                            _buildTableHeader('Status'),
                            _buildTableHeader('Date'),
                          ]),
                          ...List.generate(
                            20,
                            (index) => TableRow(children: [
                              _buildTableCell('ID-${index + 1}'),
                              _buildTableCell(
                                  index % 2 == 0 ? 'Pending' : 'Completed'),
                              _buildTableCell('2025-01-0${index + 1}'),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 110,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(text)),
    );
  }
}

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Page'),
      ),
      body: Center(
        child: Text('Welcome to the Order Page!'),
      ),
    );
  }
}

class KurirPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kurir Page'),
      ),
      body: Center(
        child: Text('Welcome to the Kurir Page!'),
      ),
    );
  }
}

class IncomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Income Page'),
      ),
      body: Center(
        child: Text('Welcome to the Income Page!'),
      ),
    );
  }
}
