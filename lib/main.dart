import 'package:aplikasi_omah/admin/dashboard.dart';
import 'package:aplikasi_omah/kurir/kurir_home.dart';
import 'package:aplikasi_omah/model/splash_screen.dart';
import 'package:aplikasi_omah/pages/iklan.dart';
import 'package:aplikasi_omah/pages/login.dart';
import 'package:aplikasi_omah/pages/register.dart';
import 'package:aplikasi_omah/util/firebase_options.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MainApp(),)
    );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // darkTheme: ThemeData.dark(useMaterial3: true),
      title: 'Omah Laundry APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: 'splash_screen',
        routes: {
          'splash_screen' : (context) => SplashScreen(),
          'iklan_screen' : (context) => Iklan(),
          'login_screen' : (context) => Login(),
          'register_screen' : (context) => Register(),
          // 'home_screen' : (context) => Home(),
          // 'admin_screen' : (context) => Dashboard(),
          // 'kurir_screen' : (context) => KurirHome(),
        },
    );
  }
}
