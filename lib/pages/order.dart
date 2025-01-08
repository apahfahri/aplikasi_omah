// ignore_for_file: non_constant_identifier_names

import 'package:aplikasi_omah/pages/konfirmasi.dart';
import 'package:aplikasi_omah/util/validator.dart';
import 'package:aplikasi_omah/util/ETTER/model/pesanan_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Order extends StatefulWidget {
  final User user;
  final String pilihan;

  const Order({super.key, required this.user, required this.pilihan});

  @override
  OrderState createState() => OrderState();
}

class OrderState extends State<Order> {
  late User currentUser = widget.user;
  late String pilihan = widget.pilihan;

  final TextEditingController nama_pelanggan = TextEditingController();
  final TextEditingController no_telpon = TextEditingController();
  final TextEditingController alamat = TextEditingController();
  final TextEditingController tgl_penjemputan = TextEditingController();
  final TextEditingController jam_penjemputan = TextEditingController();

  int jumlah_layanan = 1;
  String pilihan_pembayaran = 'COD';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nama_pelanggan.text = widget.user.displayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Isi Data Pesanan',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildTextFormField(
                    'Nama Pelanggan', nama_pelanggan, TextInputType.text),
                buildTextFormField(
                    'Nomor Telepon', no_telpon, TextInputType.phone),
                buildTextFormField(
                    'Alamat', alamat, TextInputType.streetAddress),
                buildNumberField('Jumlah Layanan'),
                buildTimeDateFormField('Tanggal Penjemputan', tgl_penjemputan,
                    const Icon(Icons.calendar_today),
                    onTap: () => showDialogPicker(context)),
                buildTimeDateFormField('Jam Penjemputan', jam_penjemputan,
                    const Icon(Icons.access_time),
                    onTap: () => dialogPickerClock(context)),
                buildPaymentDropdown(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[900]),
                  child: const Text('Pesan',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(String label, TextEditingController controller,
      TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        validator: (value) {
          switch (label) {
            case 'Nama Pelanggan':
              return Validator.validateName(name: value);
            case 'Nomor Telepon':
              return Validator.validatePhone(phone: value);
            case 'Alamat':
              return Validator.validateEmpty(name: value);
            default:
              return null;
          }
        },
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
          labelText: label,
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(8.5),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget buildTimeDateFormField(
      String label, TextEditingController controller, Icon icon,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        validator: (value) => Validator.validateEmpty(name: value),
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
          labelText: label,
          suffixIcon: IconButton(icon: icon, onPressed: onTap),
        ),
        readOnly: true,
        onTap: onTap,
      ),
    );
  }

  Widget buildNumberField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: TextEditingController(text: jumlah_layanan.toString()),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
          labelText: label,
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(8.5),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
        onChanged: (value) {
          setState(() {
            jumlah_layanan = int.tryParse(value) ?? 1;
          });
        },
      ),
    );
  }

  Widget buildPaymentDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
        value: pilihan_pembayaran,
        onChanged: (value) {
          setState(() {
            pilihan_pembayaran = value!;
          });
        },
        items: ['COD', 'e-Money', 'Transfer Bank']
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final pesanan = PesananModel(
        id: '-',
        no: DateTime.now().millisecondsSinceEpoch.toString(),
        pelanggan: nama_pelanggan.text,
        no_telpon: no_telpon.text,
        alamat: alamat.text,
        jenis_layanan: pilihan,
        jumlah_layanan: jumlah_layanan.toString(),
        jam_penjemputan: jam_penjemputan.text,
        tgl_penjemputan: tgl_penjemputan.text,
        tgl_pengantaran: '-',
        status_pesanan: 'Pesanan Baru',
        metode_pembayaran: pilihan_pembayaran,
        status_pembayaran: 'Belum Bayar',
        total_harga: '0',
        nama_kurir: '-',
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Konfirmasi(pesanan: pesanan)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data tidak boleh kosong')),
      );
    }
  }

  void dialogPickerClock(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          jam_penjemputan.text = value.format(context);
        });
      }
    });
  }

  void showDialogPicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    ).then((value) {
      if (value != null) {
        setState(() {
          tgl_penjemputan.text = DateFormat('dd-MMM-yyyy').format(value);
        });
      }
    });
  }
}
