import 'dart:convert';

import 'package:aplikasi_omah/util/ETTER/restapi/config.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/restapi.dart';
import 'package:flutter/material.dart';
import '../util/ETTER/model/pesanan_model.dart';

class KurirDetailJemput extends StatefulWidget {
  final PesananModel pesanan;
  final Function reloadData; // Menambahkan callback untuk reload data

  const KurirDetailJemput(
      {super.key, required this.pesanan, required this.reloadData});

  @override
  DetailJemputState createState() => DetailJemputState();
}

class DetailJemputState extends State<KurirDetailJemput> {
  DataService ds = DataService();
  late PesananModel pesanan;
  late String status;

  @override
  void initState() {
    pesanan = widget.pesanan;
    status = widget.pesanan.status_pesanan;
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
                        pesanan.jenis_layanan, // Jenis layanan
                        style: const TextStyle(fontSize: 14),
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
                    'Tanggal Penjemputan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    pesanan.tgl_penjemputan,
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
                    'Tanggal Pengantaran',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    pesanan.tgl_pengantaran,
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
                    'Status Pesanan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  // Text(
                  //   pesanan.status_pesanan,
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: Colors.grey[700],
                  //   ),
                  // ),
                  DropdownButtonFormField(
                    value: status,
                    onChanged: (String? value) {
                      setState(() {
                        status = value!;
                      });
                    },
                    items: <String>[
                      'Siap dijemput',
                      'Sedang dijemput',
                      'Telah dijemput',
                      'Siap diantar',
                      'Sedang diantar',
                      'Selesai',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
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
                        'Rp. ${pesanan.total_harga}', // Jenis layanan
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 24,
                    color: Colors.grey,
                  ),
                  const Text(
                    'Status Pembayaran',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    pesanan.status_pembayaran,
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
                    'Metode Pembayaran',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    pesanan.metode_pembayaran,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            pesanan.status_pembayaran == 'Belum Bayar'
                ? pesanan.metode_pembayaran == 'COD'
                    ? Center(
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Konfirmasi Pembayaran'),
                                  content: const Text(
                                      'Apakah anda yakin ingin mengkonfirmasi pembayaran?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        bool result = jsonDecode(
                                            await ds.updateId(
                                                'status_pembayaran',
                                                'Lunas',
                                                token,
                                                project,
                                                'pesanan',
                                                appid,
                                                pesanan.id));
                                        if (result) {
                                          widget.reloadData();
                                        }
                                      },
                                      child: const Text('Konfirmasi'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(16),
                          ),
                          child: const Text(
                            'konfirmasi pembayaran',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox()
                : const SizedBox(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).maybePop();
                  bool result = jsonDecode(await ds.updateId('status_pesanan',
                      status, token, project, 'pesanan', appid, pesanan.id));
                  if (result) {
                    widget.reloadData();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
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
