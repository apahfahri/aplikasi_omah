import 'dart:convert';
import 'package:aplikasi_omah/admin/detailPesanan.dart';
import 'package:aplikasi_omah/admin/kurir.dart';
import 'package:aplikasi_omah/util/ETTER/model/pesanan_model.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/config.dart';
import 'package:aplikasi_omah/util/fire_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/restapi.dart';
import 'package:aplikasi_omah/admin/profileAdmin.dart';
import 'package:aplikasi_omah/admin/analisis.dart';
import 'package:aplikasi_omah/admin/pesanan.dart';

class Dashboard extends StatefulWidget {
  final User Admin;

  const Dashboard({super.key, required this.Admin});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DataService ds = DataService();
  late User currentUser;

  List data = [];
  List<PesananModel> pesanan = [];

  // List<PesananModel> orders = [];
  String searchQuery = "";

  selectAll() async {
    data = jsonDecode(await ds.selectAll(token, project, 'pesanan', appid));
    pesanan = data.map((e) => PesananModel.fromJson(e)).toList();

    setState(() {
      pesanan = pesanan;
    });
  }

  selectFiltered() async {
    data = jsonDecode(await ds.selectWhere(
        token, project, 'pesanan', appid, 'status_pesanan', 'Pesanan Baru'));
    pesanan = data.map((e) => PesananModel.fromJson(e)).toList();

    setState(() {
      pesanan = pesanan;
    });
  }

  konfirmasi(dynamic id) async {
    data = jsonDecode(await ds.updateId('status_pesanan', 'Siap dijemput',
        token, project, 'pesanan', appid, id));
    pesanan = data.map((e) => PesananModel.fromJson(e)).toList();

    setState(() {
      pesanan = pesanan;
    });
  }

  Future reload(dynamic value) async {
    setState(() {
      selectFiltered();
    });
  }

  @override
  void initState() {
    super.initState();
    currentUser = widget.Admin;
    selectFiltered();
  }

  void _filterOrders(String query) {
    setState(() {
      searchQuery = query;
      pesanan = pesanan
          .where((pesanan) =>
              pesanan.pelanggan
                  ?.toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ??
              false ||
                  (pesanan.status_pesanan != null &&
                      pesanan.status_pesanan
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase())) ||
                  false ||
                  (pesanan.tgl_penjemputan != null &&
                      pesanan.tgl_penjemputan
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase())) ||
                  false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F4FF),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 243, 254),
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Hello, ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              currentUser.displayName ?? 'Admin',
              style: const TextStyle(
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
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue[500]),
              accountName: Text(currentUser.displayName ?? 'Username'),
              accountEmail: Text(currentUser.email ?? 'Email'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.blue),
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
              leading: Icon(Icons.bar_chart),
              title: Text('Analisis'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnalisisPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Kurir'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KurirPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                FireAuth.logout();
                Navigator.of(context).pushReplacementNamed('login_screen');
              },
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
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: _filterOrders,
                      ),
                    ),
                  ),
                  const Icon(Icons.search, color: Colors.grey),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton('Total Pesanan', Colors.lightBlueAccent, () {}),
                _buildButton(' Total Income', Colors.lightBlueAccent, () {}),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID Pesanan')),
                      DataColumn(label: Text('Layanan')),
                      DataColumn(label: Text('Konfirmasi')),
                    ],
                    rows: pesanan.map((pesanan) {
                      return DataRow(
                        cells: [
                          DataCell(Text(pesanan.pelanggan ?? 'N/A')),
                          DataCell(Text(pesanan.jenis_layanan ?? 'N/A')),
                          DataCell(
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPesananPage(
                                      id: pesanan.id,
                                    ),
                                  ),
                                ).then((value) => reload(value));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                              ),
                              child: const Text(
                                'Konfirmasi',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
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
        width: 173,
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
}
