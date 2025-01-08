import 'package:flutter/material.dart';

class DetailPesananPage extends StatefulWidget {
  @override
  _DetailPesananPageState createState() => _DetailPesananPageState();
}

class _DetailPesananPageState extends State<DetailPesananPage> {
  final TextEditingController _quantityController =
      TextEditingController(text: '1');
  String _selectedStatus = 'SIAP DIJEMPUT';
  final List<String> _statusOptions = [
    'PESANAN BARU',
    'SIAP DIJEMPUT',
    'PESANAN DIPROSES',
    'DICUCI',
    'SIAP DIANTAR',
    'SEDANG DIKIRIM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9F4FF),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 235, 243, 254),
        elevation: 0,
        title: Text(
          'DETAIL PESANAN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('No: #001', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Yanti - 083214524241',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    'Jl. Bojongyellow No. 17, Ciblue Barat, Kota Bandung kode pos 54321, depan borma',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Divider(height: 24),
                  Text('Pesanan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Laundry Kiloan'),
                      Row(
                        children: [
                          Container(
                            width: 60,
                            child: TextField(
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.lightBlue[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  // borderSide:
                                  //     BorderSide(color: Colors.lightBlue),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('kg'),
                        ],
                      ),
                    ],
                  ),
                  Divider(height: 24),
                  Text('Status',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.lightBlue.shade500),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedStatus,
                      isExpanded: false,
                      underline: SizedBox(),
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
                  ),
                  Divider(height: 24),
                  Text('Tanggal Antar',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('21/01/2025'),
                  Divider(height: 24),
                  Text('Kurir',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Asep'),
                  Divider(height: 24),
                  Text('Detail Pembayaran',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Laundry Kiloan 1kg'),
                      Text('Rp. 40.000'),
                    ],
                  ),
                  Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Rp. 60.000',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Simpan Perubahan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}
