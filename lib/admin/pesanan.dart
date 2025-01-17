import 'dart:convert';

import 'package:aplikasi_omah/admin/detailPesanan.dart';
import 'package:aplikasi_omah/util/ETTER/model/pesanan_model.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/config.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/restapi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  _PesananState createState() => _PesananState();
}

class _PesananState extends State<PesananPage> {
  DataService ds = DataService();
  late User currentUser;

  List data = [];
  List<PesananModel> pesanan = [];
  List<PesananModel> filteredPesanan = [];

  // List<PesananModel> orders = [];
  String searchQuery = "";
  String selectedSort = 'Semua';

  selectAll() async {
    data = jsonDecode(await ds.selectAll(token, project, 'pesanan', appid));
    List<PesananModel> allPesanan =
        data.map((e) => PesananModel.fromJson(e)).toList();
    pesanan =
        allPesanan.where((item) => item.status_pesanan != 'Selesai').toList();
    filteredPesanan = pesanan;

    setState(() {
      pesanan = pesanan;
    });
  }

  void searchPesanan(String query) {
    List<PesananModel> searchResult = pesanan.where((item) {
      return item.pelanggan.toLowerCase().contains(query.toLowerCase()) ||
          item.jenis_layanan.toLowerCase().contains(query.toLowerCase()) ||
          item.status_pesanan.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchQuery = query;
      filteredPesanan = searchResult;
    });
  }

  void sortPesanan(String status) {
    List<PesananModel> sortedResult;
    if (status == 'Semua') {
      sortedResult = pesanan;
    } else {
      sortedResult = pesanan
          .where((item) => item.status_pesanan.toLowerCase() == status.toLowerCase())
          .toList();
    }

    setState(() {
      selectedSort = status;
      filteredPesanan = sortedResult;
    });
  }

  @override
  void initState() {
    super.initState();
    selectAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE9F4FF),
        elevation: 0,
        title: const Text(
          'PESANAN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      searchPesanan(value);
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                DropdownButton<String>(
                  value: selectedSort,
                  items: <String>[
                    'Semua',
                    'Siap dijemput',
                    'Pesanan diproses',
                    'Sedang dicuci',
                    'Sedang dijemur',
                    'Sedang disetrika',
                    'Siap diantar'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 10),),
                    );
                  }).toList(),
                  onChanged: (value) {
                    sortPesanan(value!);
                  },
                  isDense: true,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredPesanan.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada pesanan yang terkonfirmasi.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredPesanan.length,
                      itemBuilder: (context, index) {
                        final item = filteredPesanan[index];
                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPesananPage(id: item.id),
                              ),
                            );
                            if (result == true) {
                              selectAll();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 0.3,
                                  blurRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.pelanggan ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 16.0,  
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${item.jenis_layanan ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 12.0,  
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${item.status_pesanan ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 12.0,  
                                    color: Colors.blue,
                                  ),
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
      ),
    );
  }
}
