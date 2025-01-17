import 'package:aplikasi_omah/pages/bayar.dart';
import 'package:aplikasi_omah/util/ETTER/model/pesanan_model.dart';
import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  final PesananModel pesanan;

  const Detail({super.key, required this.pesanan});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
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
                    pesanan.alamat,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const Divider(height: 24),
                  const Text('Pesanan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${pesanan.jenis_layanan} - ${pesanan.jumlah_layanan}x'),
                  const Divider(height: 24),
                  const Text('Status',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(pesanan.status_pesanan),
                  const Divider(height: 24),
                  const Text('Tanggal Antar',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(pesanan.tgl_pengantaran),
                  const Divider(height: 24),
                  const Text('Kurir',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(pesanan.nama_kurir),
                  const Divider(height: 24),
                  const Text('Status Pembayaran',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(pesanan.status_pembayaran),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Rp. ${pesanan.total_harga}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            pesanan.total_harga == '0'
                ? const SizedBox()
                : pesanan.status_pembayaran != 'Belum Bayar'
                    ? const SizedBox()
                    : pesanan.metode_pembayaran == 'COD'
                        ? const SizedBox()
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Bayar(pesanan: pesanan),
                                    ),
                                  );
                                },
                                child: const Text('Bayar'),
                              ),
                            ),
                          ),
          ],
        ),
      ),
    );
  }
}
