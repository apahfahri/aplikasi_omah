import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/config.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/restapi.dart';


class ProfileAdminPage extends StatelessWidget {
  final User Admin;

  ProfileAdminPage({super.key, required this.Admin});

  @override
  Widget build(BuildContext context) {
    final currentUser = Admin ?? FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Color(0xFFE9F4FF),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 235, 243, 254),
        elevation: 0,
        title: Text(
          ' PROFIL ADMIN ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 150,
              backgroundColor: Colors.lightBlue[100],
              child: Icon(Icons.assignment_ind_rounded, size: 200, color: Colors.lightBlue[300]),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('PENCAPAIAN',
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pesanan Selesai:',
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text('500',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Income:',
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text('Rp. 1.500.000',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // buildInfoRow('ID:', currentUser?.uid ?? 'Admin'),
            buildInfoRow('Nama:', currentUser?.displayName ?? 'Admin'),
            buildInfoRow('Email:', currentUser?.email ?? 'Admin'),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ],
      ),
    );
  }
}
