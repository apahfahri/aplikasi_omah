import 'dart:convert';

import 'package:aplikasi_omah/kurir/kurir_detail_jemput.dart';
import 'package:aplikasi_omah/kurir/kurir_profil.dart';
import 'package:aplikasi_omah/util/ETTER/model/pesanan_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../util/ETTER/restapi/config.dart';
import '../util/ETTER/restapi/restapi.dart';

class KurirHome extends StatefulWidget {
  final User kurir;

  const KurirHome({super.key, required this.kurir});

  @override
  _KurirHomeState createState() => _KurirHomeState();
}

class _KurirHomeState extends State<KurirHome> {
  bool isLogout = false;
  late User currentUser;
  int _selectedIndex = 0;
  final List<String> _tabs = ["Siap dijemput", "Siap diantar", "Selesai"];

  DataService ds = DataService();
  List data = [];
  List<PesananModel> pesanan = [];

  selectAll() async {
    data = jsonDecode(await ds.selectAll(token, project, 'pesanan', appid));
    pesanan = data.map((e) => PesananModel.fromJson(e)).toList();

    setState(() {
      pesanan = pesanan;
    });
  }

  selectKategori(dynamic value) async {
    data = jsonDecode(await ds.selectWhere(
        token, project, 'pesanan', appid, 'status_pesanan', value));
    pesanan = data.map((e) => PesananModel.fromJson(e)).toList();

    setState(() {
      pesanan = pesanan;
    });
  }

  Future reloadData(dynamic valye) async {
    setState(() {
      selectAll();
    });
  }


  @override
  void initState() {
    currentUser = widget.kurir;
    selectAll();
    super.initState();
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, 'login_screen');
    } catch (e) {
      print('Error logging out: $e');
    }

  List<PesananModel> filterPesanan(String status) {
    return pesanan.where((item) => item.status_pesanan == status).toList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[50],
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilKurirPage()),
                  );
                },
              ),
            ),
            SizedBox(width: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat Datang',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  currentUser.displayName ?? 'Kurir',
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari alamat...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Tab bar untuk "Jemput", "Antar", "Selesai"
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_tabs.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                      selectKategori(_tabs[index]);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 17),
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? Colors.blue[100]
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _tabs[index],
                              style: TextStyle(
                                color: _selectedIndex == index
                                    ? Colors.blue
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pesanan.length,
              itemBuilder: (context, index) {
                final item = pesanan[index];
                return ListTile(
                  title: Text(item.pelanggan),
                  subtitle: Text(item.tgl_penjemputan),
                  onTap: () {
                    Navigator.pushNamed(context, 'kurir_detail_jemput',
                        arguments: [item.id]).then(reloadData);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => kurir_(pesanan: pesanan),
                    //   ),
                    // );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  
}
