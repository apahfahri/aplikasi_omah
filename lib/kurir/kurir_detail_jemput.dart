import 'dart:convert';

import 'package:aplikasi_omah/util/ETTER/restapi/config.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/restapi.dart';
import 'package:flutter/material.dart';
import '../util/ETTER/model/pesanan_model.dart';

class KurirDetailJemput extends StatefulWidget {
  final PesananModel pesanan;

  const KurirDetailJemput({super.key, required this.pesanan});

  @override
  DetailJemputState createState() => DetailJemputState();
}

class DetailJemputState extends State<KurirDetailJemput> {
  DataService ds = DataService();
  late PesananModel pesanan;

  @override
  void initState() {
    pesanan = widget.pesanan;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F8FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Detail Pesanan',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${pesanan.pelanggan} - ${pesanan.no_telpon}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pesanan.alamat,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const Divider(
                    height: 24,
                    color: Colors.grey,
                  ),
                  const Text(
                    'Pemesanan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${pesanan.jenis_layanan}', // Jenis layanan
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${pesanan.jumlah_layanan}x', // Jumlah pesanan
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 24,
                    color: Colors.grey,
                  ),
                  const Text(
                    'Total Harga',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${pesanan.total_harga}', // Jenis layanan
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (pesanan.status_pesanan == 'Siap dijemput') {
                    String opsi = 'Sedang dijemput';
                    jsonDecode(await ds.updateId('status_pesanan', opsi, token,
                        project, 'pesanan', appid, pesanan.id));
                  Navigator.pop(context, true);
                  } else if (pesanan.status_pesanan == 'Sedang dijemput') {
                    String opsi = 'Telah dijemput';
                    jsonDecode(await ds.updateId('status_pesanan', opsi, token,
                        project, 'pesanan', appid, pesanan.id));
                  Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700), // Warna kuning
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Konfirmasi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
