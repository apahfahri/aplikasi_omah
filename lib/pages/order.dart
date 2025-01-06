import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Order extends StatefulWidget {
  final User user;
  final String pilihan;

  Order({super.key, required this.user, required this.pilihan});

  @override
  OrderState createState() => OrderState();
}

class OrderState extends State<Order> {
  late User currentUser = widget.user;
  late String pilihan = widget.pilihan;

  late Future<DateTime?> selectedDate;
  late Future<TimeOfDay?> selectedHour;
  String date = "-";

  final nama_pelanggan = TextEditingController();
  final no_telpon = TextEditingController();
  final alamat = TextEditingController();
  final tgl_penjemputan = TextEditingController();
  var jam_penjemputan = TextEditingController();
  String pilihan_pembayaran = 'COD';

  @override
  Widget build(BuildContext context) {
    ThemeData.dark(useMaterial3: true);
    return Scaffold(
      backgroundColor:
          const Color(0xFFF0F4FF), // Warna latar belakang biru muda
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
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add, color: Colors.black),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          color: Colors.lightBlueAccent[50],
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextField(
                        controller: nama_pelanggan..text = currentUser.displayName ?? '',
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          // hintText: "${currentUser.displayName}",
                          labelText: 'Nama Pelanggan',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextField(
                        controller: no_telpon,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nomor Telepon',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextField(
                        controller: alamat,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Alamat',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextField(
                        controller: tgl_penjemputan,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Tanggal Penjemputan',
                        ),
                        onTap: () {
                          showDialogPicker(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextField(
                        controller: jam_penjemputan,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Jam Penjemputan',
                        ),
                        onTap: () {
                          dialogPickerClock(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          filled: false,
                          // border: InputBorder.none,
                          border: OutlineInputBorder(),
                          labelText: 'Metode Pembayaran',
                        ),
                        value: pilihan_pembayaran,
                        onChanged: (String? newValue) {
                          setState(() {
                            pilihan_pembayaran = newValue!;
                          });
                        },
                        items: <String>['COD', 'e-Money', 'Transefer Bank']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    // const TextField(
                    //   decoration: InputDecoration(
                    //     // hintText: 'Catatan',
                    //     labelText: 'Catatan',
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  void showDialogPicker(BuildContext context) {
    selectedDate = showDatePicker(
      context: context,
      // initialDate: DateTime(date.year - 20, date.month, date.day),
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(DateTime.now().year + 20),
      // lastDate: option == 1 ? DateTime.now() : DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );

    selectedDate.then((value) {
      setState(() {
        if (value == null) return;

        if (kDebugMode) {
          print('Line 230');
        }

        final DateFormat formatter = DateFormat('dd-MMM-yyyy');
        final String formattedDate = formatter.format(value);

        tgl_penjemputan.text = formattedDate;
        // if (option == 1) {
        //   tglDibuat.text = formattedDate;
        // } else {
        //   tglDimulai.text = formattedDate;
        // }
      });

      if (kDebugMode) {
        print('Line 240');
      }
    }, onError: (error) {
      if (kDebugMode) {
        print('Line 244');
        print(error);
      }
    });
  }
}
