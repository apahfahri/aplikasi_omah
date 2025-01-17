import 'dart:convert';

import 'package:aplikasi_omah/util/ETTER/model/pesanan_model.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/config.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/restapi.dart';
import 'package:flutter/material.dart';

class Bayar extends StatefulWidget {
  final PesananModel pesanan;

  const Bayar({super.key, required this.pesanan});

  @override
  _BayarState createState() => _BayarState();
}

class _BayarState extends State<Bayar> {
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
      backgroundColor: const Color(0xFFE9F4FF),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 243, 254),
        elevation: 0,
        title: const Text(
          'PEMBAYARAN',
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
            Text('No: #${pesanan.no}', style: const TextStyle(fontSize: 16)),
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
                  Text('${pesanan.pelanggan} - ${pesanan.no_telpon}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                      'Jumlah: ${pesanan.jenis_layanan}-${pesanan.jumlah_layanan}x',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Total: Rp. ${pesanan.total_harga}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  const Divider(height: 24),
                  const Text('Pembayaran via E-money:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Center(
                    child: Image.asset(
                      'assets/images/Qris.jpg',
                      width: 300,
                      height: 300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 24),
                  const Text('Pembayaran via transfer bank:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text('BNI: 1525960955 a/n PT. Omah Laundry'),
                  const Text('BRI: 0005 0116 3243 501 a/n PT. Omah Laundry'),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Pembayaran Berhasil'),
                                content: const Text(
                                    'Terima kasih telah melakukan pembayaran'),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      jsonDecode(await ds.updateId(
                                          'status_pembayaran',
                                          'Lunas',
                                          token,
                                          project,
                                          'pesanan',
                                          appid,
                                          pesanan.id));
                                    },
                                    child: const Text('OK'),
                                  )
                                ],
                              );
                            });
                        // Navigator.pop(context);
                      },
                      child: const Text('Bayar'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
