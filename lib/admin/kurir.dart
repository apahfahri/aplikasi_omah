import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KurirPage extends StatefulWidget {
  @override
  _DaftarKurirPageState createState() => _DaftarKurirPageState();
}

class _DaftarKurirPageState extends State<KurirPage> {
  late Stream<QuerySnapshot> _kurirStream;

  @override
  void initState() {
    super.initState();
    _kurirStream = FirebaseFirestore.instance
        .collection('role profile') 
        .where('role', isEqualTo: 'kurir') 
        .snapshots();
  }

  void _showDetailKurir(BuildContext context, String name, String uid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 60, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'UID: $uid',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Belum Dijemput'),
                  Text('4'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Belum Diantar'),
                  Text('2'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Selesai'),
                  Text('3'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9F4FF),
      appBar: AppBar(
        backgroundColor: Color(0xFFE9F4FF),
        elevation: 0,
        title: Text(
          'DAFTAR KURIR',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _kurirStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final kurirDocs = snapshot.data?.docs ?? [];

          if (kurirDocs.isEmpty) {
            return Center(child: Text('Tidak ada kurir ditemukan'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: kurirDocs.length,
            itemBuilder: (context, index) {
              final kurir = kurirDocs[index];
              final name = kurir['name'] ?? 'Tanpa Nama';
              final uid = kurir['uid'] ?? '-';

              return GestureDetector(
                onTap: () => _showDetailKurir(context, name, uid),
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Detail',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
