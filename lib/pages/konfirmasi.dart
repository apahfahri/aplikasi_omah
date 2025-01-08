import 'dart:convert';

import 'package:aplikasi_omah/util/ETTER/model/pesanan_model.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/config.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/restapi.dart';
import 'package:flutter/material.dart';

class Konfirmasi extends StatefulWidget {
  final PesananModel pesanan;

  const Konfirmasi({super.key, required this.pesanan});

  @override
  _KonfirmasiState createState() => _KonfirmasiState();
}

class _KonfirmasiState extends State<Konfirmasi> {
  DataService ds = DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 243, 254),
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 235, 243, 254),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data Diri:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text('Nama\t\t: ${widget.pesanan.pelanggan}'),
                  Text('No. Telpon: ${widget.pesanan.no_telpon}'),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Alamat:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(widget.pesanan.alamat),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Layanan:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    children: [
                      Text(widget.pesanan.jenis_layanan),
                      const Spacer(),
                      Text('${widget.pesanan.jumlah_layanan}x'),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Penjemputan:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text('Tanggal\t: ${widget.pesanan.tgl_penjemputan}'),
                  Text('Jam\t\t: ${widget.pesanan.jam_penjemputan}'),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Metode Pembayaran:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(widget.pesanan.metode_pembayaran),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Konfirmasi Pesanan'),
                          content: const Text(
                              'Apakah anda yakin ingin memesan layanan ini?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('Tidak'),
                            ),
                            TextButton(
                              onPressed: () async {
                                jsonDecode(await ds.insertPesanan(
                                  appid,
                                  '',
                                  widget.pesanan.pelanggan,
                                  widget.pesanan.no_telpon,
                                  widget.pesanan.alamat,
                                  widget.pesanan.jenis_layanan,
                                  widget.pesanan.jumlah_layanan.toString(),
                                  widget.pesanan.jam_penjemputan,
                                  widget.pesanan.tgl_penjemputan,
                                  widget.pesanan.tgl_pengantaran,
                                  widget.pesanan.status_pesanan,
                                  widget.pesanan.metode_pembayaran,
                                  widget.pesanan.status_pembayaran,
                                  '0',
                                  widget.pesanan.nama_kurir,
                                ));
                                // List<PesananModel> konfirmasiPesanan = pesanan
                                //     .map((e) => PesananModel.fromJson(e))
                                //     .toList();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Pesanan berhasil dilakukan!'),
                                  ),
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('Ya'),
                            ),
                          ],
                        ));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Pesan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
