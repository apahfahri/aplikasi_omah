import 'dart:convert';

// import 'package:aplikasi_omah/util/ETTER/model/layanan_dipilih.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/config.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/restapi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Keranjang extends StatefulWidget {
  final User user;
  final String layan;
  Keranjang({super.key, required this.layan, required this.user});

  @override
  KeranjangState createState() => KeranjangState();
}

class KeranjangState extends State<Keranjang> {

  late User user;
  DataService ds = DataService();
  List data = [];
  // List<LayananDipilihModel> layanan = [];
  // List<LayananDipilihModel> layanan_pre = [];

  tampil() async {
    data = jsonDecode(await ds.selectWhere(token, project, 'layanan_dipilih',
        appid, 'pelanggan', widget.user.displayName.toString()));
    // data = jsonDecode(
    //     await ds.selectAll(token, project, 'layanan_dipilih', appid));
    // layanan = data.map((e) => LayananDipilihModel.fromJson(e)).toList();

    setState(() {
      // layanan = layanan;
    });
  }

  // tambahLayanan(String namaPelanggan, String jenisLayanan, int jumlah) async {
  //   data = jsonDecode(await ds.insertLayananDipilih(
  //       appid, namaPelanggan, jenisLayanan, jumlah.toString()));
  //   layanan = data.map((e) => LayananDipilihModel.fromJson(e)).toList();

  //   setState(() {
  //     layanan = layanan;
  //   });
  // }

  // updateLayanan(String namaPelanggan, String jenisLayanan, int jumlah)async{
  //   data = jsonDecode(await ds.updateWhere('pelanggan', namaPelanggan, 'jumlah', jumlah.toString(), token, project, 'layanan_dipilih', appid));
  //   layanan = data.map((e) => LayananDipilihModel.fromJson(e)).toList();

  //   setState(() {
  //     layanan = layanan;
  //   });
  // }

  Future reloadData(dynamic valye) async {
    setState(() {
      tampil();
    });
  }

  @override
  void initState() {
    user = widget.user;
    // tambahLayanan(user.displayName.toString(), widget.layan, 1);
    tampil();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF0F4FF), // Warna latar belakang biru muda
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Tambah Pesanan',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: layanan.length,
            //     itemBuilder: (context, index) {
            //       final item = layanan[index];

            //       return Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 8.0),
            //         child: Card(
            //           elevation: 4,
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //           child: Padding(
            //             padding: const EdgeInsets.all(16.0),
            //             child: Row(
            //               children: [
            //                 ClipRRect(
            //                   borderRadius: BorderRadius.circular(12),
            //                   child: Image.asset(
            //                     // 'assets/images/layanan/${item.layanan}.png', // Ganti sesuai nama gambar
            //                     'assets/images/layanan/boneka.png', // Ganti sesuai nama gambar
            //                     width: 60,
            //                     height: 60,
            //                     fit: BoxFit.cover,
            //                   ),
            //                 ),
            //                 const SizedBox(width: 16),
            //                 Expanded(
            //                   child: Text(
            //                     item.layanan,
            //                     style: const TextStyle(
            //                       fontSize: 18,
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   ),
            //                 ),
            //                 Row(
            //                   children: [
            //                     IconButton(
            //                       onPressed: () {
            //                         int hitung = item.jumlah + 1;
            //                         updateLayanan(user.displayName!, item.layanan, hitung);
            //                       },
            //                       icon: const Icon(Icons.remove,
            //                           color: Colors.grey),
            //                     ),
            //                     Container(
            //                       width: 32,
            //                       height: 32,
            //                       decoration: BoxDecoration(
            //                         color: Colors.white,
            //                         borderRadius: BorderRadius.circular(8),
            //                         border: Border.all(color: Colors.grey),
            //                       ),
            //                       child: Center(
            //                         child: Text(
            //                           item.jumlah as String,
            //                           style: const TextStyle(
            //                               fontSize: 16,
            //                               fontWeight: FontWeight.bold),
            //                         ),
            //                       ),
            //                     ),
            //                     IconButton(
            //                       onPressed: () {},
            //                       icon:
            //                           const Icon(Icons.add, color: Colors.grey),
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Tambah aksi checkout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB3D9FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
