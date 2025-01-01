import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RoleManager {
  static Future<String?> getUserRole(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference akun = firestore.collection('role profile');
    String? page;

    try {
      // Melakukan query asinkron untuk mencari dokumen yang memiliki UID yang cocok dengan parameter uid
      QuerySnapshot querySnapshot = await akun.where('UID', isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Mendapatkan dokumen pertama yang ditemukan
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Mengecek apakah UID dalam dokumen sama dengan parameter uid
        if (userDoc['UID'] == uid) {
          String role = userDoc['Role'];

          // Menentukan halaman yang akan dikembalikan berdasarkan role
          if (role == 'customer') {
            page = 'home';
          } else if (role == 'kurir') {
            page = 'kurir';
          } else if (role == 'admin') {
            page = 'admin';
          } else {
            page = ''; // Jika role tidak ditemukan
          }
        } else {
          if (kDebugMode) {
            print('UID mismatch: Firestore UID does not match the provided UID.');
          }
          return ''; // UID tidak cocok
        }
      } else {
        if (kDebugMode) {
          print('No user found with the provided UID.');
        }
        return ''; // Tidak ada data yang ditemukan
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching role: $e');
      }
      return ''; // Kembalikan nilai default jika terjadi error
    }

    return page;
  }
}
