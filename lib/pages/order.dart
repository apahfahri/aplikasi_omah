// ignore_for_file: non_constant_identifier_names

import 'package:aplikasi_omah/pages/konfirmasi.dart';
import 'package:aplikasi_omah/util/validator.dart';
import 'package:aplikasi_omah/util/ETTER/model/pesanan_model.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/restapi.dart';
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

  DataService ds = DataService();

  late Future<DateTime?> selectedDate;
  late Future<TimeOfDay?> selectedHour;
  String date = "-";

  late final TextEditingController nama_pelanggan;
  final no_telpon = TextEditingController();
  final alamat = TextEditingController();
  int jumlah_layanan = 1;
  final tgl_penjemputan = TextEditingController();
  var jam_penjemputan = TextEditingController();
  String pilihan_pembayaran = 'COD';

  // Key for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize nama_pelanggan with user display name or empty if null
    nama_pelanggan = TextEditingController(text: widget.user.displayName ?? '');
  }

  @override
  Widget build(BuildContext context) {
    ThemeData.dark(useMaterial3: true);
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF), // Warna latar belakang biru muda
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Isi Data Pesanan',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          color: Colors.lightBlueAccent[50],
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      buildTextFormField('Nama Pelanggan', nama_pelanggan, TextInputType.text),
                      buildTextFormField('Nomor Telepon', no_telpon, TextInputType.phone),
                      buildTextFormField('Alamat', alamat, TextInputType.streetAddress),
                      buildNumberField('Jumlah Layanan', jumlah_layanan),
                      buildTextFormField('Tanggal Penjemputan', tgl_penjemputan, TextInputType.datetime,  onTap: () => showDialogPicker(context)),
                      buildTextFormField('Jam Penjemputan', jam_penjemputan, TextInputType.text,  onTap: () => dialogPickerClock(context)),
                      buildPaymentDropdown(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[900],
                        ),
                        child: const Text(
                          'Pesan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable text field widget
  Widget buildTextFormField(String label, TextEditingController controller, TextInputType keyboardType, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        validator: (controler) {
          switch (label) {
            case 'Nama Pelanggan':
              return Validator.validateName(name: controler);
            case 'Nomor Telepon':
              return Validator.validatePhone(phone: controler);
            case 'Alamat':
              return Validator.validateEmpty(name: controler);
            case 'Tanggal Penjemputan':
              return Validator.validateEmpty(name: controler);
            case 'Jam Penjemputan':
              return Validator.validateEmpty(name: controler);
            default:
              return null;
          }
        },
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(8.5),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  // Reusable number input field
  Widget buildNumberField(String label, int initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextField(
        controller: TextEditingController(text: initialValue.toString()),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
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

  // Payment method dropdown
  Widget buildPaymentDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: false,
          border: const OutlineInputBorder(),
          labelText: 'Metode Pembayaran',
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(8.5),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
        value: pilihan_pembayaran,
        onChanged: (String? newValue) {
          setState(() {
            pilihan_pembayaran = newValue!;
          });
        },
        items: <String>['COD', 'e-Money', 'Transfer Bank']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  // Submit form and navigate to the next page
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      List<PesananModel> pesanan = [
        PesananModel(
          id: '-',
          no: '0',
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
        ),
      ];

      if (pesanan.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Konfirmasi(pesanan: pesanan[0]),
          ),
        );
      }

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Data berhasil diinput'),
      //   ),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data tidak boleh kosong'),
        ),
      );
    }
  }

  // Time picker dialog
  void dialogPickerClock(BuildContext context) {
    selectedHour = showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) return;

      setState(() {
        final String formattedHour = value.format(context);
        jam_penjemputan.text = formattedHour;
      });
      return null;
    });
  }

  // Date picker dialog
  void showDialogPicker(BuildContext context) {
    selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(DateTime.now().year + 20),
    );

    selectedDate.then((value) {
      setState(() {
        if (value == null) return;

        final DateFormat formatter = DateFormat('dd-MMM-yyyy');
        final String formattedDate = formatter.format(value);

        tgl_penjemputan.text = formattedDate;
      });
    });
  }
}
