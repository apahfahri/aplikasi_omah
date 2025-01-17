import 'dart:convert';

import 'package:aplikasi_omah/util/ETTER/model/pesanan_model.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/config.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/restapi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Riwayat extends StatefulWidget {
  final User user;

  const Riwayat({Key? key, required this.user}) : super(key: key);

  @override
  _RiwayatState createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
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

  selectWhere(String value) async {
    data = jsonDecode(await ds.selectWhere(
        token, project, 'pesanan', appid, 'uid_pelanggan', value));
    pesanan = data.map((e) => PesananModel.fromJson(e)).toList();

    setState(() {
      pesanan = pesanan;
    });
  }

  // void filterpesanan(String enteredKeyword) {

  //   if (enteredKeyword.isEmpty) {
  //     search_data = data.map((e) => pesananModel.fromJson(e)).toList();
  //   } else {
  //     search_data_pre = data.map((e) => pesananModel.fromJson(e)).toList();
  //     search_data = search_data_pre
  //         .where((user) =>
  //             user.deskripsi.toLowerCase().contains(enteredKeyword.toLowerCase()))
  //         .toList();
  //   }

  //   setState(() {
  //     pesanan = search_data;
  //   });
  // }

  Future reloadData(dynamic valye) async {
    setState(() {
      selectWhere(widget.user.uid);
    });
  }

  @override
  void initState() {
    selectWhere(widget.user.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 243, 254),
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 235, 243, 254),
      ),
      body: pesanan.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pesanan.length,
              itemBuilder: (context, index) {
                final item = pesanan[index];

                // return ListTile(
                //   title: Text(item.jenis_layanan),
                //   subtitle: Text(item.status_pesanan),
                //   onTap: () {},
                // );

                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Data Pesanan:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text('Nama Pelanggan\t: ${item.pelanggan}'),
                        Text('Jenis Layanan\t: ${item.jenis_layanan} ${item.jumlah_layanan}x'),
                        Text('Harga\t: ${item.total_harga}'),
                        // Text('Tanggal Penjemputan\t: ${item.tgl_penjemputan}'),
                        // Text('Tanggal Pengantaran\t: ${item.tgl_pengantaran}'),
                        Text('Status Pesanan\t: ${item.status_pesanan}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
