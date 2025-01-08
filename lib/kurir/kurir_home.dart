import 'dart:convert';

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

class _KurirHomeState extends State<KurirHome> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late User currentUser;

  DataService ds = DataService();
  List<PesananModel> pesanan = [];

  @override
  void initState() {
    currentUser = widget.kurir;
    _tabController = TabController(length: 3, vsync: this);
    selectAll();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> selectAll() async {
    final data = jsonDecode(await ds.selectAll(token, project, 'pesanan', appid));
    setState(() {
      pesanan = data.map<PesananModel>((e) => PesananModel.fromJson(e)).toList();
    });
  }

  List<PesananModel> filterPesanan(String status) {
    return pesanan.where((item) => item.status_cuci == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[50],
        elevation: 0,
        title: Row(
          children: [
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
            const Spacer(),
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  // Tambahkan navigasi ke halaman profil
                },
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: "Jemput"),
            Tab(text: "Antar"),
            Tab(text: "Selesai"),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildPesananList(filterPesanan("Jemput")),
          buildPesananList(filterPesanan("Antar")),
          buildPesananList(filterPesanan("Selesai")),
        ],
      ),
    );
  }

  Widget buildPesananList(List<PesananModel> pesananList) {
    if (pesananList.isEmpty) {
      return const Center(
        child: Text("Tidak ada pesanan"),
      );
    }

    return ListView.builder(
      itemCount: pesananList.length,
      itemBuilder: (context, index) {
        final pesanan = pesananList[index];
        return ListTile(
          title: Text(pesanan.nama_kurir),
          subtitle: Text(pesanan.alamat),
          onTap: () {
            // Tambahkan navigasi ke detail pesanan
          },
        );
      },
    );
  }
}
