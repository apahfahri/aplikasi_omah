import 'package:flutter/material.dart';
import 'package:aplikasi_omah/util/ETTER/model/pesanan_model.dart';

class KurirDetailSelesai extends StatelessWidget {
  final PesananModel pesanan;

  const KurirDetailSelesai({super.key, required this.pesanan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF), // Background luar
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
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Watermark ceklis hijau di tengah kontainer
                Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green.withOpacity(0.2),
                    size: 120,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informasi pelanggan
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${pesanan.pelanggan} - ${pesanan.no_telpon}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pesanan.alamat,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Pesanan
                    const Text(
                      'Pemesanan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pesanan.jenis_layanan,
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          '${pesanan.jumlah_layanan}x',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Detail Pembayaran
                    const Text(
                      'Detail Pembayaran',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${pesanan.jenis_layanan} ${pesanan.jumlah_layanan}x',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text('Rp. ${pesanan.total_harga}',
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),                    
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rp. ${pesanan.total_harga}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
