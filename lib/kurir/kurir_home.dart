import 'dart:convert';

// import 'package:aplikasi_omah/kurir/kurir_detail_antar.dart';
import 'package:aplikasi_omah/kurir/kurir_detail_jemput.dart';
// import 'package:aplikasi_omah/kurir/kurir_detail_selesai.dart';
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
  final List<String> _tabs = [
    "Siap dijemput",
    "Sedang dijemput",
    "Telah dijemput",
    "Siap diantar",
    "Sedang diantar",
    "Selesai"
  ];

  DataService ds = DataService();
  List data = [];
  List<PesananModel> pesanan = [];

  @override
  void initState() {
    currentUser = widget.kurir;
    selectKategori(_tabs[_selectedIndex]);
    super.initState();
  }

  selectKategori(dynamic value) async {
    data = jsonDecode(await ds.selectWhere(
        token, project, 'pesanan', appid, 'status_pesanan', value));
    pesanan = data.map((e) => PesananModel.fromJson(e)).toList();

    setState(() {
      pesanan = pesanan;
    });
  }

  Future<void> reloadData() async {
    // Update status dan reload data berdasarkan kategori yang dipilih
    await selectKategori(_tabs[_selectedIndex]);
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
                    MaterialPageRoute(builder: (context) => ProfilKurirPage(user: currentUser,)),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              reloadData();
            },
          ),
        ],
        // bottom: PreferredSize(
        //   preferredSize: Size.fromHeight(60.0),
        //   child: Padding(
        //     padding: const EdgeInsets.all(10.0),
        //     child: TextField(
        //       decoration: InputDecoration(
        //         hintText: 'Cari alamat...',
        //         prefixIcon: Icon(Icons.search, color: Colors.grey),
        //         border: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(10),
        //           borderSide: BorderSide.none,
        //         ),
        //         filled: true,
        //         fillColor: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Tab bar untuk "Jemput", "Antar", "Selesai"
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
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
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pesanan.length,
              itemBuilder: (context, index) {
                final item = pesanan[index];
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KurirDetailJemput(
                            pesanan: item, reloadData: reloadData),
                      ),
                    );
                    if (result == true) {
                      reloadData();
                    }
                    // if (_tabs[_selectedIndex] == "Siap dijemput" ||
                    //     _tabs[_selectedIndex] == "Sedang dijemput" ||
                    //     _tabs[_selectedIndex] == "Telah dijemput") {
                    //   final result = await Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => KurirDetailJemput(
                    //           pesanan: item, reloadData: reloadData),
                    //     ),
                    //   );
                    //   if (result == true) {
                    //     reloadData();
                    //   }
                    // } else if (_tabs[_selectedIndex] == "Siap diantar") {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => KurirDetailAntar(pesanan: item),
                    //     ),
                    //   );
                    // } else if (_tabs[_selectedIndex] == "Selesai") {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           KurirDetailSelesai(pesanan: item),
                    //     ),
                    //   );
                    // }
                  },
                  // onTap: () async {
                  //   if (_tabs[_selectedIndex] == "Siap dijemput" ||
                  //       _tabs[_selectedIndex] == "Sedang dijemput" ||
                  //       _tabs[_selectedIndex] == "Telah dijemput") {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) =>
                  //             KurirDetailJemput(pesanan: item, reloadData: reloadData),
                  //       ),
                  //     );
                  //   } else if (_tabs[_selectedIndex] == "Siap diantar") {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => KurirDetailAntar(pesanan: item),
                  //       ),
                  //     );
                  //   } else if (_tabs[_selectedIndex] == "Selesai") {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) =>
                  //             KurirDetailSelesai(pesanan: item),
                  //       ),
                  //     );
                  //   }
                  // },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.pelanggan,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Tanggal Penjemputan: ${item.tgl_penjemputan}",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Alamat: ${item.alamat}",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
