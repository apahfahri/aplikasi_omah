import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:aplikasi_omah/util/ETTER/model/pesanan_model.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/config.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/restapi.dart';
import 'package:aplikasi_omah/admin/dashboard.dart';

class DetailPesananPage extends StatefulWidget {
  final dynamic id;

  const DetailPesananPage({Key? key, required this.id}) : super(key: key);

  @override
  _DetailPesananPageState createState() => _DetailPesananPageState();
}

class _DetailPesananPageState extends State<DetailPesananPage> {
  DataService ds = DataService();

  Future<PesananModel> select1Pesanan(dynamic id) async {
    final response = await ds.selectId(token, project, 'pesanan', appid, id);
    final List data = jsonDecode(response);
    return PesananModel.fromJson(data.first);
  }

  final TextEditingController _priceController = TextEditingController();
  String _selectedStatus = 'Pesanan baru'; // Initial status
  String _selectedKurir = 'Kurir A'; // Initial kurir

  final List<String> _statusOptions = [
    'Pesanan baru',
    'Siap dijemput',
    'Pesanan diproses',
    'Sedang dicuci',
    'Sedang dijemur',
    'Sedang disetrika',
    'Siap diantar',
  ];

  final List<String> _kurirOptions = ['Kurir A', 'Kurir B'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F4FF),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 243, 254),
        elevation: 0,
        title: const Text(
          'DETAIL PESANAN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<PesananModel>(
        future: select1Pesanan(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Pesanan tidak ditemukan'));
          } else {
            final pesanan = snapshot.data!;

            // Calculate the total price dynamically based on user input
            num totalHarga = (int.tryParse(_priceController.text) ?? 0) * (int.tryParse(pesanan.jumlah_layanan.toString()) ?? 0);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('No: ${pesanan.id}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${pesanan.pelanggan} - ${pesanan.no_telpon}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pesanan.alamat ?? 'Alamat tidak tersedia',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const Divider(height: 24),
                        const Text(
                          'Pesanan',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(pesanan.jenis_layanan ?? 'Jenis pesanan tidak tersedia'),
                            Text(
                              '${pesanan.jumlah_layanan ?? 'N/A'}', 
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        const Text(
                          'Harga',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.lightBlue[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: 'Masukkan harga',
                          ),
                          enabled: _selectedStatus == 'Pesanan baru', 
                          onChanged: (value) {
                            setState(() {
                              totalHarga = (int.tryParse(value) ?? 0) * (int.tryParse(pesanan.jumlah_layanan.toString()) ?? 0);
                            });
                          },
                        ),
                        const Divider(height: 24),
                        const Text(
                          'Status',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        DropdownButton<String>(
                          value: _statusOptions.contains(_selectedStatus) ? _selectedStatus : _statusOptions.first,
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedStatus = newValue!;
                            });
                          },
                          items: _statusOptions.map((String status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                        ),
                        const Divider(height: 24),
                        const Text(
                          'Kurir',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        DropdownButton<String>(
                          value: _kurirOptions.contains(_selectedKurir) ? _selectedKurir : _kurirOptions.first,
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedKurir = newValue!;
                            });
                          },
                          items: _kurirOptions.map((String kurir) {
                            return DropdownMenuItem<String>(
                              value: kurir,
                              child: Text(kurir),
                            );
                          }).toList(),
                        ),
                        const Divider(height: 24),
                        const Text(
                          'Total Harga',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Rp. $totalHarga', 
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Update pesanan total_harga in database
                        ds.updateId(
                          'total_harga',
                          totalHarga.toString(),
                          token,
                          project,
                          'pesanan',
                          appid,
                          pesanan.id,
                        );

                        // Update the status
                        ds.updateId(
                          'status_pesanan',
                          _selectedStatus,
                          token,
                          project,
                          'pesanan',
                          appid,
                          pesanan.id,
                        );

                        // After saving, go back to the previous page
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('Simpan Perubahan'),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }
}
