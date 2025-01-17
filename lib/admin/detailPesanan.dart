import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:aplikasi_omah/util/ETTER/model/pesanan_model.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/config.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/restapi.dart';

class DetailPesananPage extends StatefulWidget {
  final PesananModel pesanan; // Objek data dari halaman sebelumnya

  const DetailPesananPage({Key? key, required this.pesanan}) : super(key: key);

  @override
  _DetailPesananPageState createState() => _DetailPesananPageState();
}

class _DetailPesananPageState extends State<DetailPesananPage> {
  DataService ds = DataService();

  // Controller untuk input harga
  final TextEditingController _priceController = TextEditingController();

  // Variabel untuk status, kurir, dan tanggal pengantaran
  late String _selectedStatus;
  late String _selectedKurir;
  DateTime? _selectedDate;

  // Opsi status dan kurir
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
  void initState() {
    super.initState();

    // Set nilai awal untuk status dan kurir dari data pesanan
    _selectedStatus = widget.pesanan.status_pesanan ?? 'Pesanan baru';
    _selectedKurir = widget.pesanan.nama_kurir ?? 'Kurir A';

    // Set nilai awal untuk harga di controller
    _priceController.text = widget.pesanan.total_harga?.toString() ?? '';

    // Set nilai awal untuk tanggal pengantaran jika sudah ada
    _selectedDate = widget.pesanan.tgl_pengantaran != null
        ? DateTime.tryParse(widget.pesanan.tgl_pengantaran!)
        : null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pesanan = widget.pesanan; // Data pesanan diterima dari widget

    // Total harga dihitung berdasarkan input user
    num totalHarga = (int.tryParse(_priceController.text) ?? 0) *
        (int.tryParse(pesanan.jumlah_layanan.toString()) ?? 0);

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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(pesanan.jenis_layanan ??
                          'Jenis pesanan tidak tersedia'),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    onSubmitted: (value) async {
                      setState(() {
                        totalHarga = (int.tryParse(value) ?? 0) *
                            (int.tryParse(
                                    pesanan.jumlah_layanan.toString()) ??
                                0);
                      });

                      // Update harga di database saat pengguna menekan Enter
                      await ds.updateId(
                        'total_harga',
                        totalHarga.toString(),
                        token,
                        project,
                        'pesanan',
                        appid,
                        pesanan.id,
                      );
                    },
                  ),
                  const Divider(height: 24),
                  const Text(
                    'Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: _statusOptions.contains(_selectedStatus)
                        ? _selectedStatus
                        : _statusOptions.first,
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
                    value: _kurirOptions.contains(_selectedKurir)
                        ? _selectedKurir
                        : _kurirOptions.first,
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
                    'Tanggal Pengantaran',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.toLocal()}'.split(' ')[0]
                            : 'Belum dipilih',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: const Text('Pilih Tanggal'),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text(
                    'Total Harga',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                onPressed: () async {
                  // Update data di database
                  await ds.updateId(
                    'status_pesanan',
                    _selectedStatus,
                    token,
                    project,
                    'pesanan',
                    appid,
                    pesanan.id,
                  );

                  if (_selectedDate != null) {
                    await ds.updateId(
                      'tgl_pengantaran',
                      _selectedDate.toString(),
                      token,
                      project,
                      'pesanan',
                      appid,
                      pesanan.id,
                    );
                  }

                  if (mounted) {
                    Navigator.pop(context, true); // Kembali ke halaman sebelumnya
                  }
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
    _priceController.dispose();
    super.dispose();
  }
}
