import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:aplikasi_omah/util/ETTER/model/pesanan_model.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/config.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/restapi.dart';

class DetailPesananPage extends StatefulWidget {
  final dynamic id;

  const DetailPesananPage({Key? key, required this.id}) : super(key: key);

  @override
  _DetailPesananPageState createState() => _DetailPesananPageState();
}

class _DetailPesananPageState extends State<DetailPesananPage> {
  DataService ds = DataService();

  late dynamic id;

  List data = [];
  late PesananModel pesanan ;

  select1Pesanan(dynamic id)async{
    data = jsonDecode(await ds.selectId(token, project, 'pesanan', appid, id));
    pesanan = data.map((e) => PesananModel.fromJson(e)) as PesananModel;

    setState(() {
      pesanan = pesanan;
    });
  }

  String searchQuery = "";
  final TextEditingController _quantityController = TextEditingController();
  String _selectedStatus = 'Proses Cuci';
  String _selectedKurir = 'Kurir A';

  final List<String> _statusOptions = [
    'Proses Cuci',
    'Selesai',
    'Dikirim',
    'Dibatalkan',
  ];

  final List<String> _kurirOptions = ['Kurir A', 'Kurir B'];

  @override
  void initState() {
    super.initState();
    id = widget.id;
    select1Pesanan(id);
  }

  @override
  Widget build(BuildContext context) {
    // final order = pesanan;
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
      body: SingleChildScrollView(
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
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pesanan.alamat ?? 'Alamat tidak tersedia',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const Divider(height: 24),
                  const Text(
                    'Pesanan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(pesanan.jenis_layanan ?? 'Jenis pesanan tidak tersedia'),
                      Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: TextField(
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.lightBlue[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('kg'),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text(
                    'Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: _selectedStatus,
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: _selectedKurir,
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
                    'Tanggal Antar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(pesanan.tgl_pengantaran ?? 'Tanggal tidak tersedia'),
                  const Divider(height: 24),
                  const Text(
                    'Detail Pembayaran',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${pesanan.jenis_layanan} ${_quantityController.text} kg'),
                      Text(
                        'Rp. ${(int.tryParse(_quantityController.text) ?? 1) * 7000}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Update the pesanan data with new values
                  // widget.pesanan['status_pesanan'] = _selectedStatus;
                  // widget.pesanan['kurir'] = _selectedKurir;
                  // widget.pesanan['jumlah'] = int.tryParse(_quantityController.text) ?? 1;

                  // // Pop the page and return the updated data
                  // Navigator.pop(context, widget.pesanan); // Mengirim data kembali
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
      ),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}
