// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

// import 'package:aplikasi_omah/pages/keranjang.dart';
import 'package:aplikasi_omah/pages/order.dart';
import 'package:aplikasi_omah/util/ETTER/model/pesanan_model.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/restapi.dart';
import 'package:aplikasi_omah/util/fire_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../util/ETTER/restapi/config.dart';

class Home extends StatefulWidget {
  final User user;

  const Home({super.key, required this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLogout = false;

  late User currentUser;

  DataService ds = DataService();
  List data = [];
  List<PesananModel> pesanan = [];

  // selectAll() async {
  //   data = jsonDecode(await ds.selectAll(token, project, 'pesanan', appid));
  //   pesanan = data.map((e) => PesananModel.fromJson(e)).toList();

  //   setState(() {
  //     pesanan = pesanan;
  //   });
  // }

  selectOne() async {
    data = jsonDecode(await ds.selectWhere(token, project, 'pesanan', appid,
        'pelanggan', currentUser.displayName.toString()));
    pesanan = data.map((e) => PesananModel.fromJson(e)).toList();

    setState(() {
      pesanan = pesanan;
    });
  }

  Future reloadData(dynamic valye) async {
    setState(() {
      selectOne();
    });
  }

  @override
  void initState() {
    currentUser = widget.user;
    // selectOne();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[50],
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            Text(
              currentUser.displayName ?? 'Pelanggan',
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              accountName: Text(currentUser.displayName ?? 'Username'),
              accountEmail: Text(currentUser.email ?? 'Email'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.blue),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Aksi sesuai
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Aksi sesuai
              },
            ),
            isLogout
                ? const CircularProgressIndicator()
                : ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      FireAuth.logout();
                      Navigator.of(context)
                          .pushReplacementNamed('login_screen');
                    },
                  ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Layanan Kami',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  padding: const EdgeInsets.all(10),
                  children: [
                    buildServiceItem(
                        "assets/images/layanan/kiloan.png", "Cuci Kiloan"),
                    buildServiceItem(
                        "assets/images/layanan/bed cover.png", "Bed Cover"),
                    buildServiceItem(
                        "assets/images/layanan/boneka.png", "Boneka"),
                    buildServiceItem(
                        "assets/images/layanan/karpet.png", "Karpet"),
                    buildServiceItem(
                        "assets/images/layanan/sepatu.png", "Sepatu"),
                    buildServiceItem(
                        "assets/images/layanan/koper.png", "Koper"),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 8),
              // ListView.builder(
              //   itemCount: pesanan.length,
              //   scrollDirection: Axis.horizontal,
              //   // shrinkWrap:
              //   //     true, // Tambahkan agar ListView bisa digunakan dalam Column
              //   // physics:
              //   //     const NeverScrollableScrollPhysics(), // Nonaktifkan scroll ListView karena sudah ada parent scroll
              //   itemBuilder: (context, index) {
              //     final item = pesanan[index];

              //     return Card(
              //       elevation: 4,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       child: ListTile(
              //         leading: ClipRRect(
              //           borderRadius: BorderRadius.circular(8),
              //           child: Image.asset(
              //             "assets/images/delivery-truck.png",
              //             width: 40,
              //             height: 40,
              //             fit: BoxFit.cover,
              //           ),
              //         ),
              //         title: Text(
              //           "Order No: #${item.no}",
              //           style: const TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //         subtitle: Text(
              //           "${item.status_pengiriman}",
              //           style: const TextStyle(color: Colors.blue),
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 130,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pesanan Saat Ini',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/images/delivery-truck.png",
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  "Order No: #",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'tahi',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildServiceItem(String imagePath, String title) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
      ),
      onPressed: () {
        // //wacana keranjang
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             Keranjang(layan: title, user: currentUser)));

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Order(user: currentUser, pilihan: title)));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 90,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
